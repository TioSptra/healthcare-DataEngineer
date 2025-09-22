{{ config(
    materialized='table',
    partition_by={
        "field": "admission_date",
        "data_type": "date",
        "granularity": "month"
    }
) }}

SELECT
    patient_id,
    admission_date,
    doctor,
    rating_service,
    outcome,
    amount AS billing_amount
FROM {{ ref('stg_healthcare') }} 
