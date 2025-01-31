WITH aggregated_invoice AS (
    SELECT
        DATE_TRUNC('MONTH', transaction_date) AS transaction_month, 
        customer_country_code,
        region,
        zone,
        cust_number,
        cust_name,
        cust_location,
        product_name,
        product_id,
        product_category,
        SUM(total_quantity) AS total_quantity,
        SUM(total_value) AS total_value,  
        SUM(total_margin) AS total_margin,  
        SUM(total_order) AS total_order 
    FROM {{ ref('day_invoice') }}  
    GROUP BY
        transaction_month,
        customer_country_code,
        region,
        zone,
        cust_number,
        cust_name,
        cust_location,
        product_name,
        product_id,
        product_category
)
SELECT
    transaction_month,
    customer_country_code,
    region,
    zone,
    cust_number,
    cust_name,
    cust_location,
    product_name,
    product_id,
    product_category,
    total_quantity,
    total_value,
    total_margin,
    total_order
FROM aggregated_invoice
