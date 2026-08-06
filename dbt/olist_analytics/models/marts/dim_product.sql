with products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

translation AS (
    SELECT * FROM {{ ref('stg_category_translation') }}
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['p.product_id']) }} AS product_key,
        p.product_id,
        coalesce(t.category_name_en, 'unknown') AS category,
        p.category_name_pt,
        p.weight_g,
        p.length_cm,
        p.height_cm,
        p.width_cm,
        p.photo_count
    FROM products p
    LEFT JOIN translation t
        ON p.category_name_pt = t.category_name_pt
)

SELECT * FROM final