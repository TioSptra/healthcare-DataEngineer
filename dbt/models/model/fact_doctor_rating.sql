{{ config(
    materialized='table',
    partition_by={
        "field": "admission_date",
        "data_type": "date",
        "granularity": "year"
    }
) }}

SELECT
    patient_id,
    admission_date,
    doctor,
    outcome,
        CASE
    WHEN outcome = 'recovered' THEN 5
    WHEN outcome = 'referred' THEN 3
    WHEN outcome = 'deceased' THEN 1
    ELSE NULL
    END AS doctor_rating
FROM {{ ref('stg_healthcare') }} 
