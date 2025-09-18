{{ config(
    materialized='table'
) }}

SELECT
    EXTRACT(YEAR FROM sh.admission_date) AS year,
    EXTRACT(MONTH FROM sh.admission_date) AS month,
    sh.insurance_provider,
    COUNT(*)                       AS insurance_count,
    COUNT(sh.patient_name) AS total_patients,
    SUM(billing_amount) AS total_billing,
    AVG(billing_amount) AS AVG_billing
FROM {{ ref('fact_healthcare') }} sh
LEFT JOIN {{ ref('dim_patient') }} p
    ON sh.patient_name = p.patient_name
GROUP BY year, month, insurance_provider
ORDER BY year, month, insurance_provider
