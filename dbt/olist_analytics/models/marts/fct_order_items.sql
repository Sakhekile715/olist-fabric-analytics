WITH items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['i.order_id', 'i.item_sequence']) }} AS order_item_key,
        i.order_id,
        i.item_sequence,
        {{ dbt_utils.generate_surrogate_key(['c.customer_id']) }}  AS customer_key,
        {{ dbt_utils.generate_surrogate_key(['i.product_id']) }}   AS product_key,
        {{ dbt_utils.generate_surrogate_key(['i.seller_id']) }}    AS seller_key,
        {{ dbt_utils.generate_surrogate_key(['CAST(o.purchased_at AS DATE)']) }} AS purchase_date_key,
        o.order_status,
        i.item_price,
        i.freight_value,
        i.item_price + i.freight_value AS item_total
    FROM items i
    INNER JOIN orders o
        ON i.order_id = o.order_id
    INNER JOIN customers c
        ON o.customer_order_key = c.customer_order_key
)

SELECT * FROM final