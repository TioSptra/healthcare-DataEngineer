{{ config(materialized='table') }}

SELECT
    EXTRACT(YEAR FROM admission_date) AS year,
    EXTRACT(MONTH FROM admission_date) AS month,
    doctor,
    outcome,
    COUNT(*) AS total_cases,
    SUM(doctor_rating) AS total_rating,
FROM {{ ref('fact_doctor_rating') }}
GROUP BY year, month, doctor, outcome
ORDER BY year, month, doctor, outcome