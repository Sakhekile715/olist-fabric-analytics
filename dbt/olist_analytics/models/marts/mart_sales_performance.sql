WITH monthly AS (
    SELECT
        d.year,
        d.month,
        d.month_name,
        p.category,
        COUNT(DISTINCT f.order_id)              AS order_count,
        SUM(f.item_price)                       AS revenue,
        SUM(f.freight_value)                    AS freight,
        CAST(AVG(f.item_price) AS DECIMAL(10,2)) AS avg_item_price
    FROM {{ ref('fct_order_items') }} f
    INNER JOIN {{ ref('dim_date') }} d
        ON f.purchase_date_key = d.date_key
    INNER JOIN {{ ref('dim_product') }} p
        ON f.product_key = p.product_key
    WHERE f.order_status = 'delivered'
    GROUP BY d.year, d.month, d.month_name, p.category
),

ranked AS (
    SELECT
        *,
        SUM(revenue) OVER (
            PARTITION BY category
            ORDER BY year, month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_revenue,

        LAG(revenue) OVER (
            PARTITION BY category
            ORDER BY year, month
        ) AS prev_month_revenue,

        RANK() OVER (
            PARTITION BY year, month
            ORDER BY revenue DESC
        ) AS category_rank_in_month,

        CAST(100.0 * revenue / SUM(revenue) OVER (PARTITION BY year, month)
             AS DECIMAL(5,2)) AS pct_of_month_revenue
    FROM monthly
),

final AS (
    SELECT
        year,
        month,
        month_name,
        category,
        order_count,
        revenue,
        freight,
        avg_item_price,
        running_revenue,
        prev_month_revenue,
        CASE
            WHEN prev_month_revenue IS NULL OR prev_month_revenue = 0 THEN NULL
            ELSE CAST(100.0 * (revenue - prev_month_revenue) / prev_month_revenue
                      AS DECIMAL(8,2))
        END AS mom_growth_pct,
        category_rank_in_month,
        pct_of_month_revenue
    FROM ranked
)

SELECT * FROM final