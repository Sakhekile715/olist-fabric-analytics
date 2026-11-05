WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_order_payments') }}
),

renamed AS (
    SELECT
        order_id,
        payment_sequential                     AS payment_sequence,
        LOWER(TRIM(payment_type))              AS payment_type,
        CAST(payment_installments AS INT)      AS installments,
        CAST(payment_value AS DECIMAL(10,2))   AS payment_value
    FROM source
)

SELECT * FROM renamed
