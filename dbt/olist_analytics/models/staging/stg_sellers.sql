WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_sellers') }}
),

renamed AS (
    SELECT
        seller_id,
        CAST(seller_zip_code_prefix AS VARCHAR(10)) AS zip_code,
        seller_city                                 AS city,
        UPPER(TRIM(seller_state))                   AS state
    FROM source
)

SELECT * FROM renamed
