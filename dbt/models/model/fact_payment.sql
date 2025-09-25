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
    insurance_provider,
    amount AS billing_amount
FROM {{ ref('stg_healthcare') }} 
