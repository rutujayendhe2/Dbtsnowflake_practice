{% test validate_country_code(model, column_name, restricted_values) %}

SELECT 
    {{ column_name }} AS invalid_country_code
FROM {{ model }}
WHERE {{ column_name }} IN ({{ restricted_values | join(", ") }}) 

{% endtest %}
