WITH source AS (

    SELECT * FROM {{ source('bronze', 'bronze_orders') }}

),

renamed AS (

    SELECT
        order_id,
        customer_id                          AS customer_order_key,
        lower(trim(order_status))            AS order_status,
        cast(order_purchase_timestamp AS datetime2)      AS purchased_at,
        cast(order_approved_at AS datetime2)             AS approved_at,
        cast(order_delivered_carrier_date AS datetime2)  AS shipped_at,
        cast(order_delivered_customer_date AS datetime2) AS delivered_at,
        cast(order_estimated_delivery_date AS datetime2) AS estimated_delivery_at

    FROM source

)

SELECT * FROM renamed

