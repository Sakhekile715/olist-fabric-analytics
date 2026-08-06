WITH digits AS (
    SELECT 0 AS d
    UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
    UNION ALL SELECT 9
),

numbers AS (
    SELECT a.d + b.d * 10 + c.d * 100 + e.d * 1000 AS n
    FROM digits a
    CROSS JOIN digits b
    CROSS JOIN digits c
    CROSS JOIN digits e
),

spine AS (
    SELECT DATEADD(DAY, n, CAST('2016-01-01' AS DATE)) AS date_day
    FROM numbers
    WHERE n <= DATEDIFF(DAY, CAST('2016-01-01' AS DATE), CAST('2018-12-31' AS DATE))
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['date_day']) }} AS date_key,
        date_day                                          AS full_date,
        YEAR(date_day)                                    AS year,
        MONTH(date_day)                                   AS month,
        CAST(DATENAME(MONTH, date_day) AS VARCHAR(20))    AS month_name,
        DATEPART(QUARTER, date_day)                       AS quarter,
        DAY(date_day)                                     AS day_of_month,
        CAST(DATENAME(WEEKDAY, date_day) AS VARCHAR(20))  AS day_name,
        CASE
            WHEN (DATEDIFF(DAY, CAST('1900-01-01' AS DATE), date_day)) % 7 IN (5, 6)
            THEN 1 ELSE 0
        END                                               AS is_weekend
    FROM spine
)

SELECT * FROM final