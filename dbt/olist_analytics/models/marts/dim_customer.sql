WITH customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

orders as (
    SELECT * FROM {{ ref('stg_orders') }}
),

customer_orders AS (
    SELECT
        c.customer_id,
        c.zip_code,
        c.city,
        c.state,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id
            ORDER BY o.purchased_at DESC
        ) AS recency_rank
    FROM customers c
    INNER JOIN orders o
        ON c.customer_order_key = o.customer_order_key
),

latest AS (
    SELECT * FROM customer_orders WHERE recency_rank = 1
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} AS customer_key,
        customer_id,
        zip_code,
        city,
        state
    FROM latest
)

SELECT * FROM final
