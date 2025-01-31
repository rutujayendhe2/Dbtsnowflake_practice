
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
        SUM(total_quantity) AS total_quantity,  -- Summing total quantities
        SUM(total_value) AS total_value,  -- Summing total values
        SUM(total_margin) AS total_margin,  -- Summing total margins
        SUM(total_order) AS total_order  -- Summing total orders
    FROM SNOWFLAKE_CASE_STUDY.STAGE.day_invoice  -- Using the existing day_invoice data
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
