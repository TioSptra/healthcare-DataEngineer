{{ config(
    materialized='table'
) }}

SELECT
    EXTRACT(YEAR FROM sh.admission_date) AS year,
    EXTRACT(MONTH FROM sh.admission_date) AS month,
    CASE
        WHEN p.age < 5 THEN 'toddler'
        WHEN p.age BETWEEN 5 AND 9 THEN 'child'
        WHEN p.age BETWEEN 10 AND 18 THEN 'teenager'
        WHEN p.age BETWEEN 19 AND 60 THEN 'adult'
        ELSE 'elderly'
    END AS age_group,
    p.gender,
    COUNT(DISTINCT sh.patient_name) AS unique_patients,
    COUNT(*) AS total_admissions
FROM {{ ref('fact_healthcare') }} sh
LEFT JOIN {{ ref('dim_patient') }} p
    ON sh.patient_name = p.patient_name
GROUP BY year, month, age_group, p.gender
ORDER BY year, month, age_group, p.gender
