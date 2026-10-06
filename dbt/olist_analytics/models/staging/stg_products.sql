WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_products') }}
),

renamed AS (
    SELECT
        product_id,
        product_category_name                  AS category_name_pt, ---flags that it's Portuguese and needs the translation table
        CAST(product_weight_g AS INT)          AS weight_g,
        CAST(product_length_cm AS INT)         AS length_cm,
        CAST(product_height_cm AS INT)         AS height_cm,
        CAST(product_width_cm AS INT)          AS width_cm,
        CAST(product_photos_qty AS INT)        AS photo_count
    FROM source
)

SELECT * FROM renamed
