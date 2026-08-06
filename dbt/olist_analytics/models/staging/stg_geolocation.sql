WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_geolocation') }}
),

renamed AS (
    SELECT
        cast(geolocation_zip_code_prefix AS varchar(10)) AS zip_code,
        cast(geolocation_lat AS decimal(10,6))           AS latitude,
        cast(geolocation_lng AS decimal(10,6))           AS longitude,
        geolocation_city                                 AS city,
        upper(trim(geolocation_state))                   AS state
    FROM source
)

SELECT * FROM renamed