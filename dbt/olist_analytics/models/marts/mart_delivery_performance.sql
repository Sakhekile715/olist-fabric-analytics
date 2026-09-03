WITH delivered AS (
    SELECT *
    FROM {{ ref('fct_orders') }}
    WHERE delivered_at IS NOT NULL
      AND review_score IS NOT NULL
),

aggregated AS (
    SELECT
        delivery_bucket,
        delivery_bucket_sort,
        COUNT(*)                                   AS order_count,
        CAST(AVG(CAST(review_score AS DECIMAL(4,2))) AS DECIMAL(4,2)) AS avg_review_score,
        SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) AS negative_reviews,
        SUM(CASE WHEN review_score  = 5 THEN 1 ELSE 0 END) AS five_star_reviews,
        CAST(AVG(CAST(days_to_deliver AS DECIMAL(6,2))) AS DECIMAL(6,2)) AS avg_days_to_deliver,
        CAST(AVG(order_value) AS DECIMAL(10,2))    AS avg_order_value
    FROM delivered
    GROUP BY delivery_bucket, delivery_bucket_sort
),

final AS (
    SELECT
        delivery_bucket,
        delivery_bucket_sort,
        order_count,
        avg_review_score,
        avg_days_to_deliver,
        avg_order_value,
        CAST(100.0 * negative_reviews  / order_count AS DECIMAL(5,2)) AS pct_negative,
        CAST(100.0 * five_star_reviews / order_count AS DECIMAL(5,2)) AS pct_five_star,
        CAST(100.0 * order_count / SUM(order_count) OVER () AS DECIMAL(5,2)) AS pct_of_orders,
        avg_review_score - FIRST_VALUE(avg_review_score) OVER (
            ORDER BY delivery_bucket_sort
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS score_delta_vs_earliest
    FROM aggregated
)

SELECT * FROM final
