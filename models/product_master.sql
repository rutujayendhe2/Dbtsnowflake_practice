WITH product_data AS (
    SELECT
        p.product_id,
        t.product_name,
        p.product_pricing,
        p.product_margin,
        p.prod_date,
        CASE
            WHEN p.category_code = 'CAT-A' THEN 'Snacks'
            WHEN p.category_code = 'CAT-B' THEN 'Cereal'
            WHEN p.category_code = 'CAT-C' THEN 'Dairy'
            WHEN p.category_code = 'CAT-D' THEN 'Beverages'
            ELSE 'Other'
        END AS product_category
    FROM
        {{ source('stage', 'prod_mstr_pna1') }} AS p
    JOIN
        {{ source('stage', 'prod_mstr_tpna1') }} AS t
    ON p.product_id = t.product_id
)
SELECT * FROM product_data