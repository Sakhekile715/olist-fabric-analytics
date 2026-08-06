WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

item_totals AS (
    SELECT
        order_id,
        COUNT(*)              AS item_count,
        SUM(item_price)       AS gross_item_value,
        SUM(freight_value)    AS total_freight
    FROM {{ ref('stg_order_items') }}
    GROUP BY order_id
),

payment_totals AS (
    SELECT
        order_id,
        SUM(payment_value)        AS total_paid,
        MAX(installments)         AS max_installments,
        COUNT(*)                  AS payment_count
    FROM {{ ref('stg_order_payments') }}
    GROUP BY order_id
),

reviews_ranked AS (
    SELECT
        order_id,
        review_score,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY created_at DESC
        ) AS review_rank
    FROM {{ ref('stg_order_reviews') }}
),

reviews AS (
    SELECT order_id, review_score
    FROM reviews_ranked
    WHERE review_rank = 1
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['o.order_id']) }} AS order_key,
        o.order_id,
        {{ dbt_utils.generate_surrogate_key(['c.customer_id']) }} AS customer_key,
        {{ dbt_utils.generate_surrogate_key(['CAST(o.purchased_at AS DATE)']) }} AS purchase_date_key,
        o.order_status,
        o.purchased_at,
        o.delivered_at,
        o.estimated_delivery_at,
        DATEDIFF(DAY, o.purchased_at, o.delivered_at)            AS days_to_deliver,
        DATEDIFF(DAY, o.purchased_at, o.estimated_delivery_at)   AS days_estimated,
        DATEDIFF(DAY, o.estimated_delivery_at, o.delivered_at)   AS delivery_variance_days,
        CASE
            WHEN o.delivered_at > o.estimated_delivery_at THEN 1
            WHEN o.delivered_at IS NULL THEN NULL
            ELSE 0
        END                                                      AS is_late,
        COALESCE(i.item_count, 0)        AS item_count,
        COALESCE(i.gross_item_value, 0)  AS gross_item_value,
        COALESCE(i.total_freight, 0)     AS total_freight,
        COALESCE(i.gross_item_value, 0) + COALESCE(i.total_freight, 0) AS order_value,
        p.total_paid,
        p.max_installments,
        r.review_score
    FROM orders o
    INNER JOIN customers c
        ON o.customer_order_key = c.customer_order_key
    LEFT JOIN item_totals i    ON o.order_id = i.order_id
    LEFT JOIN payment_totals p ON o.order_id = p.order_id
    LEFT JOIN reviews r        ON o.order_id = r.order_id
)

SELECT * FROM final