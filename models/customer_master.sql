WITH kna1 AS (
    SELECT 
        CUSTOMERNUMBER AS cust_number,
        LOCATION AS cust_location,
        COUNTRY AS cust_country,
        ROW_NUMBER() OVER (PARTITION BY CUSTOMERNUMBER ORDER BY LOCATION DESC) AS row_num
    FROM snowflake_case_study.stage.cust_mstr_kna1
),
tkna1 AS (
    SELECT 
        CUST_NUMBER AS cust_number,
        FIRST_NAME || ' ' || LAST_NAME AS cust_name
    FROM snowflake_case_study.stage.cust_mstr_tkna1
),
country_ref AS (
    SELECT 
        Country,
        DialingCode
    FROM SNOWFLAKE_CASE_STUDY.STAGE.country_code
)

SELECT 
    k.cust_number,
    t.cust_name,
    k.cust_location,
    k.cust_country,
    r.DialingCode AS cust_country_code
FROM kna1 k
LEFT JOIN tkna1 t ON k.cust_number = t.cust_number
LEFT JOIN country_ref r ON k.cust_country = r.Country
WHERE row_num = 1  
AND r.DialingCode NOT IN ('7', '92')  -- Exclude Russia and Pakistan
