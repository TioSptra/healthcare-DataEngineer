{{ config(
    materialized='table',
    partition_by={
    "field": "admission_date",
    "data_type": "date",
    "granularity": "year"
    }
) }}

SELECT DISTINCT
    p.patient_name,
    r.admission_type,
    st.doctor,
    st.insurance_provider,
    st.billing_amount,
    st.date_of_admission as admission_date,
    st.discharge_date,
    st.test_results
FROM {{ ref('stg_healthcare') }} st
LEFT JOIN{{ ref('dim_patient') }} p 
    ON st.patient_name = p.patient_name
LEFT JOIN{{ ref('dim_medic') }} r 
    ON st.admission_type = r.admission_type
