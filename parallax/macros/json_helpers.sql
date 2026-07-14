{# =========================================================================
   JSON access helpers for the verbatim raw.client_blob landing table (Postgres/jsonb).

   Every client sends a different shape, so staging models navigate the blob
   with these macros. The col argument accepts any jsonb expression (the blob
   column or an exploded array element).

   Postgres idioms:
     scalar : blob #>> '{a,b}'
     number : nullif(replace(blob #>> '{a}', ',', ''), '')::numeric
     array  : jsonb_array_elements(blob #> '{arr}')  AS t(elem)          (in FROM)
     array+ : jsonb_array_elements(...) WITH ORDINALITY AS t(elem, n)    (1-based index)
   ========================================================================= #}

{# convert a JSONPath like '$.a.b[0].c' into a Postgres path-array literal '{a,b,0,c}' #}
{% macro pgpath(path) -%}
    {%- set cleaned = path.replace('$.', '').replace('[', '.').replace(']', '') -%}
    {%- set parts = [] -%}
    {%- for seg in cleaned.split('.') -%}
        {%- if seg != '' -%}{%- do parts.append(seg) -%}{%- endif -%}
    {%- endfor -%}
    '{ {{- parts | join(',') -}} }'
{%- endmacro %}

{# scalar text at a json path #}
{% macro j(col, path) -%}
    ({{ col }} #>> {{ pgpath(path) }})
{%- endmacro %}

{# numeric at a json path, tolerant of comma-formatted string money #}
{% macro jnum(col, path) -%}
    (nullif(replace({{ col }} #>> {{ pgpath(path) }}, ',', ''), '')::numeric)::double precision
{%- endmacro %}

{# set-returning array expansion — use in FROM:  {{ jarr('blob','$.arr') }} as t(elem) #}
{% macro jarr(col, path) -%}
    jsonb_array_elements({{ col }} #> {{ pgpath(path) }})
{%- endmacro %}

{# array expansion with a 1-based ordinal — use:  {{ jarr_ord('blob','$.arr') }} as t(elem, seq) #}
{% macro jarr_ord(col, path) -%}
    jsonb_array_elements({{ col }} #> {{ pgpath(path) }}) with ordinality
{%- endmacro %}

{# length of a json array at a path #}
{% macro jarr_len(col, path) -%}
    jsonb_array_length({{ col }} #> {{ pgpath(path) }})
{%- endmacro %}

{# parse an ISO-8601 string (optionally trailing 'Z') to a timestamp #}
{% macro ts_iso(expr) -%}
    (replace({{ expr }}, 'Z', ''))::timestamp
{%- endmacro %}

{# parse epoch-milliseconds text to a timestamp #}
{% macro ts_epoch_ms(expr) -%}
    (to_timestamp(({{ expr }})::bigint / 1000.0) at time zone 'UTC')
{%- endmacro %}

{# parse a date-only string ('YYYY-MM-DD') to a timestamp #}
{% macro ts_date(expr) -%}
    ({{ expr }})::timestamp
{%- endmacro %}

{# canonicalize a variant label: bucket letters, numeric cells, or names #}
{% macro variant_canonical(expr) -%}
    case
        when {{ expr }} in ('control', 'A', '0') then 'control'
        when {{ expr }} in ('variant_1', 'B', '1') then 'variant_1'
        when {{ expr }} in ('variant_2', 'C', '2') then 'variant_2'
        else {{ expr }}
    end
{%- endmacro %}
