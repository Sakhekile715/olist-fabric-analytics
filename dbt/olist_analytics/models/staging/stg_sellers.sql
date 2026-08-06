WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_sellers') }}
),

renamed AS (
    SELECT
        seller_id,
        cast(seller_zip_code_prefix AS varchar(10)) AS zip_code,
        seller_city                                 AS city,
        upper(trim(seller_state))                   AS state
    FROM source
)

SELECT * FROM renamed