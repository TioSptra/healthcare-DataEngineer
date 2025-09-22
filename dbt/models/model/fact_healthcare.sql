{{ config(
    materialized='table',
    partition_by={
    "field": "admission_date",
    "data_type": "date",
    "granularity": "year"
    }
) }}

SELECT
    p.patient_id,
    sh.admission_type,
    sh.admission_date,
    sh.discharge_date,
    sh.length_of_stay,
    m.diagnosa,
    m.doctor,
    i.insurance_provider,
    sh.amount AS billing_amount,
    sh.outcome,
    sh.rating_service
FROM {{ ref('stg_healthcare') }} sh
LEFT JOIN {{ ref('dim_patient') }} p
    ON sh.patient_id = p.patient_id
LEFT JOIN {{ ref('dim_insurance') }} i
    ON sh.insurance_provider = i.insurance_provider
LEFT JOIN {{ ref('dim_medic') }} m
    ON sh.doctor = m.doctor
