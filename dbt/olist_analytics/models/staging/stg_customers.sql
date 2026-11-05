WITH source AS (

    SELECT * FROM {{ source('bronze', 'bronze_customers') }}

),

renamed AS (

    SELECT
        customer_id                                   AS customer_order_key,
        customer_unique_id                            AS customer_id,
        CAST(customer_zip_code_prefix AS VARCHAR(10)) AS zip_code,
        customer_city                                 AS city,
        UPPER(TRIM(customer_state))                   AS state

    FROM source

)

SELECT *
FROM renamed
