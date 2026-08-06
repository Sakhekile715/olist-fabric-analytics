WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_order_payments') }}
),

renamed AS (
    SELECT
        order_id,
        payment_sequential                     AS payment_sequence,
        lower(trim(payment_type))              AS payment_type,
        cast(payment_installments AS int)      AS installments,
        cast(payment_value AS decimal(10,2))   AS payment_value
    FROM source
)

SELECT * FROM renamed