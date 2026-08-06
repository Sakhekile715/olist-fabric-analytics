WITH sellers AS (
    SELECT * FROM {{ ref('stg_sellers') }}
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['seller_id']) }} AS seller_key,
        seller_id,
        zip_code,
        city,
        state
    FROM sellers
)

SELECT * FROM final