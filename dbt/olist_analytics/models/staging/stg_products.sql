WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_products') }}
),

renamed AS (
    SELECT
        product_id,
        product_category_name                  AS category_name_pt, ---flags that it's Portuguese and needs the translation table
        cast(product_weight_g AS int)          AS weight_g,
        cast(product_length_cm AS int)         AS length_cm,
        cast(product_height_cm AS int)         AS height_cm,
        cast(product_width_cm AS int)          AS width_cm,
        cast(product_photos_qty AS int)        AS photo_count
    FROM source
)

SELECT * FROM renamed