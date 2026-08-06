WITH geo AS (
    SELECT *
    FROM {{ ref('stg_geolocation') }}
    WHERE latitude  BETWEEN -34 AND 6
      AND longitude BETWEEN -74 AND -34
),

city_ranked AS (
    SELECT
        zip_code,
        city,
        state,
        ROW_NUMBER() OVER (
            PARTITION BY zip_code
            ORDER BY COUNT(*) DESC, city ASC
        ) AS city_rank
    FROM geo
    GROUP BY zip_code, city, state
),

dominant_city AS (
    SELECT zip_code, city, state
    FROM city_ranked
    WHERE city_rank = 1
),

centroid AS (
    SELECT
        zip_code,
        CAST(AVG(latitude)  AS DECIMAL(10,6)) AS latitude,
        CAST(AVG(longitude) AS DECIMAL(10,6)) AS longitude,
        COUNT(*)                              AS address_count
    FROM geo
    GROUP BY zip_code
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['c.zip_code']) }} AS geography_key,
        c.zip_code,
        d.city,
        d.state,
        c.latitude,
        c.longitude,
        c.address_count
    FROM centroid c
    INNER JOIN dominant_city d
        ON c.zip_code = d.zip_code
)

SELECT * FROM final