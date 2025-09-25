{{ config(materialized='table') }}

SELECT
    EXTRACT(YEAR FROM admission_date) AS year,
    EXTRACT(MONTH FROM admission_date) AS month,
    admission_type,
    COUNT(patient_id) AS total_patients,
    ROUND(AVG(length_of_stay), 2) AS avg_length_of_stay,
    SUM(billing_amount) AS total_billing,
    ROUND(AVG(rating_service), 2) AS avg_rating,
    COUNTIF(outcome = 'recovered') AS recovered_patients,
    COUNTIF(outcome = 'deceased') AS deceased_patients
FROM {{ ref('fact_healthcare') }}
GROUP BY year, month, admission_type, diagnosa, insurance_provider
ORDER BY year, month, admission_type, diagnosa
