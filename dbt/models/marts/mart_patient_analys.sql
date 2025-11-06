{{ config(materialized='table') }}

SELECT
    EXTRACT(YEAR FROM admission_date) AS year,
    EXTRACT(MONTH FROM admission_date) AS month,
    admission_type,
    diagnosa,
    COUNTIF(outcome = 'recovered') AS recovered_patients,
    COUNTIF(outcome = 'referred') AS refered_patients,
    COUNTIF(outcome = 'deceased') AS deceased_patients,
    ROUND(AVG(length_of_stay), 2) AS avg_length_of_stay,
    COUNT(patient_id) AS total_patients,
    SUM(billing_amount) as total_billing,
    SUM(rating_service) as total_rating,
    ROUND(AVG(rating_service), 2) AS avg_rating
FROM {{ ref('fact_healthcare') }}
GROUP BY year, month, admission_type, diagnosa
ORDER BY year, month, admission_type, diagnosa
