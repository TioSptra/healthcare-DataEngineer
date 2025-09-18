{{ config(
    materialized='table',
    partition_by={
    "field": "date_of_admission",
    "data_type": "date",
    "granularity": "year"
    }
) }}

SELECT DISTINCT
    CASE 
        WHEN LOWER(Gender) = 'male' 
            THEN CONCAT('mr. ', TRIM(REPLACE(LOWER(Name), 'dr.', '')))
        WHEN LOWER(Gender) = 'female' 
            THEN CONCAT('mrs. ', TRIM(REPLACE(LOWER(Name), 'dr.', '')))
        ELSE SAFE_CAST(NAME AS STRING)
    END AS patient_name,

    SAFE_CAST(Age AS INTEGER) AS age,
    LOWER(Gender) AS gender,
    `Blood Type` AS blood_type,
    LOWER(`Medical Condition`) AS medical_condition,
    SAFE_CAST(`Date Of Admission` AS DATE) AS date_of_admission,
    CONCAT('dr. ', LOWER(Doctor)) AS doctor,
    LOWER(Hospital) AS hospital,
    LOWER(`Insurance Provider`) AS insurance_provider,
    SAFE_CAST(`Billing Amount` AS FLOAT64) AS billing_amount,
    SAFE_CAST(`Room Number` AS INTEGER) AS room_number,
    LOWER(`Admission Type`) AS admission_type,
    SAFE_CAST(`Discharge Date` AS DATE) AS discharge_date,
    LOWER(Medication) AS medication,
    LOWER(`Test Results`) AS test_results,
    SAFE_CAST(`Length of stay` AS INTEGER) AS length_of_stay
FROM `purwadika.jcdeol005_finalproject_Tio_raw.raw_healthcare`
