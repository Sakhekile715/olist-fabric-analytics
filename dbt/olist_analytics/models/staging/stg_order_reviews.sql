WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_order_reviews') }}
),

renamed AS (
    SELECT
        review_id,
        order_id,
        CAST(review_score AS INT)                     AS review_score,
        CAST(review_creation_date AS DATETIME2)       AS created_at,
        CAST(review_answer_timestamp AS DATETIME2)    AS answered_at
    FROM source
)

SELECT * FROM renamed
