{{ config(
    materialized='table'
) }}

SELECT
    EXTRACT(YEAR FROM sh.admission_date) AS year,
    EXTRACT(MONTH FROM sh.admission_date) AS month,
    p.medical_condition,
    COUNT(*) AS total_admissions,
    COUNT(DISTINCT sh.patient_name) AS unique_patients
FROM {{ ref('fact_healthcare') }} sh
LEFT JOIN {{ ref('dim_patient') }} p
    ON sh.patient_name = p.patient_name
GROUP BY year,month, p.gender, p.medical_condition
ORDER BY year,month, p.gender, p.medical_condition
