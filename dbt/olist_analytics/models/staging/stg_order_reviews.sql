WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_order_reviews') }}
),

renamed AS (
    SELECT
        review_id,
        order_id,
        cast(review_score AS int)                     AS review_score,
        cast(review_creation_date AS datetime2)       AS created_at,
        cast(review_answer_timestamp AS datetime2)    AS answered_at
    FROM source
)

SELECT * FROM renamed