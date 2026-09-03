WITH source AS (

    SELECT * FROM {{ source('bronze', 'bronze_order_items') }}

),

renamed AS (

    SELECT
        order_id,
        order_item_id                        AS item_sequence,
        product_id,
        seller_id,
        CAST(shipping_limit_date AS DATETIME2(6)) AS shipping_limit_at,
        CAST(price AS decimal(10,2))              AS item_price,
        CAST(freight_value AS decimal(10,2))      AS freight_value

    FROM source

)

SELECT * FROM renamed