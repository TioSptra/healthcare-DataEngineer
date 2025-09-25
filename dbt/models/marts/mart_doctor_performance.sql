{{ config(materialized='table') }}

SELECT
    EXTRACT(YEAR FROM admission_date) as year,
    EXTRACT(MONTH FROM admission_date) as month,
    doctor,
    ROUND(AVG(doctor_rating), 2) AS avg_doctor_rating,
    COUNT(patient_id) AS total_cases
FROM {{ ref('fact_doctor_rating') }} 
GROUP BY year, month, doctor
ORDER BY year, month, doctor
