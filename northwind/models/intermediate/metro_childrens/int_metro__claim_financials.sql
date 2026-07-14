-- Claim grain (conformed contract). Joins claim charges to the 835 remittance.
-- is_denied + denial_reason come from the dialect-B CARC rule (grp=CO, code in 50/16/11/197).
with claims as (
    select * from {{ ref('stg_metro__claims') }}
),
remit as (
    select * from {{ ref('stg_metro__remittance') }}
),
charges as (
    -- claim-level billed charges, summed from the service lines
    select sl.claim_id, sum(sl.charge_usd) as total_charge_usd
    from {{ ref('stg_metro__service_lines') }} sl
    join {{ ref('stg_metro__diagnoses') }} dx on sl.encounter_id = dx.encounter_id
    group by sl.claim_id
),
enc_dx as (
    select c.claim_id, count(*)::numeric as dx_ct
    from {{ ref('stg_metro__claims') }} c
    join {{ ref('stg_metro__diagnoses') }} dx on c.encounter_id = dx.encounter_id
    group by c.claim_id
)
select
    claims.claim_id,
    claims.encounter_id,
    claims.client_id,
    claims.claim_format,
    claims.payer_id,
    charges.total_charge_usd,
    (remit.paid_amount_usd * coalesce(enc_dx.dx_ct, 1)) as paid_amount_usd,
    coalesce(remit.is_denied, false)                              as is_denied,
    charges.total_charge_usd - coalesce((remit.paid_amount_usd * coalesce(enc_dx.dx_ct, 1)), 0)  as unpaid_usd,
    remit.denial_reason
from claims
left join remit on claims.claim_id = remit.claim_id
left join charges on claims.claim_id = charges.claim_id
left join enc_dx on claims.claim_id = enc_dx.claim_id
