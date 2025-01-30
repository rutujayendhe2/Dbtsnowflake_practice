WITH invoice AS (
    SELECT 
        DATE(transaction_timestamp) AS transaction_date,
        cust_number AS customer_id,
        region,
        zone,
        ir.product_id,
        SUM(quantity) AS total_quantity,  -- Direct sum of quantity
        SUM(quantity * pm.product_pricing) AS total_value,  -- Calculated: total value based on quantity and product_pricing
        COUNT(*) AS total_order  -- Direct count of orders
    FROM SNOWFLAKE_CASE_STUDY.STAGE.invoice_raw ir
    LEFT JOIN SNOWFLAKE_CASE_STUDY.STAGE.product_master pm 
        ON ir.product_id = pm.product_id
    GROUP BY 1, 2, 3, 4, 5
),
customer AS (
    SELECT 
        cust_number,
        cust_name,
        cust_location,
        cust_country_code
    FROM SNOWFLAKE_CASE_STUDY.STAGE.customer_master
),
product AS (
    SELECT 
        product_id,
        product_name,
        product_category,
        product_margin  -- Assuming this represents the margin percentage for the product
    FROM SNOWFLAKE_CASE_STUDY.STAGE.product_master
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
    -- Calculated: total margin = total_value * product_margin / 100
    (i.total_value * p.product_margin) / 100 AS total_margin,  
    i.total_order
FROM invoice i
LEFT JOIN customer c ON i.customer_id = c.cust_number
LEFT JOIN product p ON i.product_id = p.product_id
