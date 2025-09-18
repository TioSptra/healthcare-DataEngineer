{{ config(
    materialized='table',
    unique_key='patient_name') }}

SELECT DISTINCT
    patient_name,
    age,
    gender,
    blood_type,
    medical_condition
FROM {{ ref('stg_healthcare') }}