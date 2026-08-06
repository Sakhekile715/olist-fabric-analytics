WITH source AS (

    SELECT * FROM {{ source('bronze', 'bronze_orders') }}

),

renamed AS (

    SELECT
        order_id,
        customer_id                          AS customer_order_key,
        lower(trim(order_status))            AS order_status,
        CAST(order_purchase_timestamp AS DATETIME2(6))      AS purchased_at,
        CAST(order_approved_at AS DATETIME2(6))             AS approved_at,
        CAST(order_delivered_carrier_date AS DATETIME2(6))  AS shipped_at,
        CAST(order_delivered_customer_date AS DATETIME2(6)) AS delivered_at,
        CAST(order_estimated_delivery_date AS DATETIME2(6)) AS estimated_delivery_at

    FROM source

)

SELECT * FROM renamed

