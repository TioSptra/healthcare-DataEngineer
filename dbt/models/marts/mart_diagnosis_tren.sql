{{ config(materialized='table') }}

SELECT
    EXTRACT(YEAR FROM admission_date) as year,
    EXTRACT(MONTH FROM admission_date) as month,
    diagnosa,
    COUNT(*) as total_cases
FROM {{ ref('fact_healthcare') }} 
GROUP BY year, month, diagnosa
ORDER BY year, month, diagnosa