-- is_late and delivery_bucket must agree: an order is late exactly when it falls
-- in one of the late bands. Returns the orders where the two disagree.
SELECT
    order_id,
    is_late,
    delivery_variance_days,
    delivery_bucket
FROM {{ ref('fct_orders') }}
WHERE (is_late = 1 AND delivery_bucket NOT IN ('1-4 days late', '5-9 days late', '10+ days late'))
   OR (is_late = 0 AND delivery_bucket IN ('1-4 days late', '5-9 days late', '10+ days late'))
   OR (is_late IS NULL AND delivery_bucket <> 'Not delivered')
