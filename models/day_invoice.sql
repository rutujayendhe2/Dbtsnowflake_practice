WITH invoice AS (
    SELECT 
        DATE(transaction_timestamp) AS transaction_date,
        cust_number AS customer_id,
        region,
        zone,
        ir.product_id,
        SUM(quantity) AS total_quantity,  
        SUM(quantity * pm.product_pricing) AS total_value,  
        COUNT(*) AS total_order 
    FROM {{ source('stage', 'invoice_raw') }} ir  
    LEFT JOIN {{ ref('product_master') }} pm  
        ON ir.product_id = pm.product_id
    GROUP BY 1, 2, 3, 4, 5
),
customer AS (
    SELECT 
        cust_number,
        cust_name,
        cust_location,
        cust_country_code
    FROM {{ ref('customer_master') }}  
),
product AS (
    SELECT 
        product_id,
        product_name,
        product_category,
        product_margin
    FROM {{ ref('product_master') }} 
)
SELECT 
    i.transaction_date,
    c.cust_country_code AS customer_country_code,
    i.region,
    i.zone,
    c.cust_number,
    c.cust_name,
    c.cust_location,
    p.product_name,
    i.product_id,
    p.product_category,
    i.total_quantity,
    i.total_value,
    (i.total_value * p.product_margin) / 100 AS total_margin,  
    i.total_order
FROM invoice i
LEFT JOIN customer c ON i.customer_id = c.cust_number
LEFT JOIN product p ON i.product_id = p.product_id
