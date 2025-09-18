{{ config(materialized='table') }}

SELECT DISTINCT
    patient_name,
    room_number,
    hospital,
    admission_type,
    medication,
    length_of_stay
FROM {{ ref('stg_healthcare') }}

