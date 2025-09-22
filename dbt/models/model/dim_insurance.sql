{{ config(materialized='table') }}

SELECT DISTINCT
    insurance_provider
FROM {{ ref('stg_healthcare') }}
