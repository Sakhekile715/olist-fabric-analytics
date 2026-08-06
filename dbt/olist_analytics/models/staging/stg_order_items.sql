WITH source AS (

    SELECT * FROM {{ source('bronze', 'bronze_order_items') }}

),

renamed AS (

    SELECT
        order_id,
        order_item_id                        AS item_sequence,
        product_id,
        seller_id,
        cast(shipping_limit_date AS datetime2) AS shipping_limit_at,
        cast(price AS decimal(10,2))           AS item_price,
        cast(freight_value AS decimal(10,2))   AS freight_value

    FROM source

)

SELECT * FROM renamed