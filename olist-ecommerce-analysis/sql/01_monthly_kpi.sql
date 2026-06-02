SELECT
    purchase_month,
    COUNT(DISTINCT order_id) AS order_count,
    COUNT(DISTINCT customer_unique_id) AS customer_count,
    ROUND(SUM(payment_value), 2) AS revenue,
    ROUND(SUM(payment_value) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(is_delayed) * 100, 2) AS delayed_order_rate_pct,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_base_delivered
GROUP BY purchase_month
ORDER BY purchase_month;
