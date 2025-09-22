{{ config(materialized='table') }}

SELECT
    EXTRACT(YEAR FROM admission_date) as year,
    EXTRACT(MONTH FROM admission_date) as month,
    doctor,
    outcome,
    COUNT(outcome) AS total_outcome
FROM {{ ref('fact_doctor_rating') }} 
GROUP BY year, month, doctor, outcome
ORDER BY year, month, doctor, outcome
