{{ config(
    materialized='table',
    unique_key='patient_id') }}

SELECT DISTINCT
    patient_id,
    age,
        CASE
        WHEN age < 5 THEN 'toddler'
        WHEN age BETWEEN 5 AND 9 THEN 'child'
        WHEN age BETWEEN 10 AND 18 THEN 'teenager'
        WHEN age BETWEEN 19 AND 60 THEN 'adult'
        ELSE 'elderly'
    END AS age_group,
    gender,
    blood_type
FROM {{ ref('stg_healthcare') }}    