{{ config(
    materialized='table',
    partition_by={
    "field": "admission_date",
    "data_type": "date",
    "granularity": "year"
    }
) }}

SELECT DISTINCT
    SAFE_CAST(patient_id AS STRING) AS patient_id,
    SAFE_CAST(age AS INTEGER) AS age,
    LOWER(SAFE_CAST(gender AS STRING)) AS gender,
    LOWER(SAFE_CAST(blood_type AS STRING)) AS blood_type,
    LOWER(SAFE_CAST(diagnosa AS STRING)) AS diagnosa,
    LOWER(SAFE_CAST(doctor AS STRING)) AS doctor,
    LOWER(SAFE_CAST(room AS STRING)) AS room,
    SAFE_CAST(admission_date AS DATE) AS admission_date,
    SAFE_CAST(discharge_date AS DATE) AS discharge_date,
    SAFE_CAST(length_of_stay AS INTEGER) AS length_of_stay,
    LOWER(SAFE_CAST(admission_type AS STRING)) AS admission_type,   
    LOWER(SAFE_CAST(insurance_provider AS STRING)) AS insurance_provider,
    SAFE_CAST(amount AS FLOAT64) AS amount,
    LOWER(SAFE_CAST(outcome AS STRING)) AS outcome,
    SAFE_CAST(rating AS INTEGER) AS rating_service
FROM `purwadika.jcdeol005_finalproject_Tio_raw.raw_healthcare`
