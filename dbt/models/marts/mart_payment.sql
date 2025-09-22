{{ config(
    materialized='table'
) }}

SELECT  
    EXTRACT(YEAR FROM admission_date) as year,
    EXTRACT(MONTH FROM admission_date) as month,
    insurance_provider,
    COUNT(*)                       AS insurance_count,
    COUNT(patient_id) as total_patients,
    SUM(billing_amount) as total_payment,
    AVG(billing_amount) as AVG_payment
FROM {{ ref('fact_payment') }}
GROUP BY year,month, insurance_provider
ORDER BY year,month, insurance_provider