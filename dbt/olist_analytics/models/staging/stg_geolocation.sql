WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_geolocation') }}
),

renamed AS (
    SELECT
        CAST(geolocation_zip_code_prefix AS VARCHAR(10)) AS zip_code,
        CAST(geolocation_lat AS DECIMAL(10,6))           AS latitude,
        CAST(geolocation_lng AS DECIMAL(10,6))           AS longitude,
        geolocation_city                                 AS city,
        UPPER(TRIM(geolocation_state))                   AS state
    FROM source
)

SELECT * FROM renamed
