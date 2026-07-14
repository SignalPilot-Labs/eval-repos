SELECT
    InvoiceNo AS invoice_id,
    InvoiceDate AS datetime_id,
    {{ dbt_utils.generate_surrogate_key(['StockCode', 'Description', 'UnitPrice']) }} AS product_id,
    {{ dbt_utils.generate_surrogate_key(['CustomerID', 'Country']) }} AS customer_id,
    Quantity AS quantity,
    Quantity * UnitPrice AS total
FROM {{ source('retail', 'raw_invoices') }}
WHERE CustomerID IS NOT NULL
AND StockCode IS NOT NULL
AND UnitPrice > 0
AND Quantity > 0
