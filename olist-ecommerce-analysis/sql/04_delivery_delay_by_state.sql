
/*
분석 질문:
고객 지역별 배송 지연율은 어떻게 다른가?

분석 단위:
- 1행 = 배송 완료 주문 1건

해석 주의:
주문 수가 너무 적은 지역은 지연율이 왜곡될 수 있으므로,
주문 수 100건 이상인 주만 비교한다.
*/

SELECT
    customer_state,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(delay_days), 2) AS avg_delay_days,
    SUM(is_delayed) AS delayed_order_count,
    ROUND(AVG(is_delayed) * 100, 2) AS delayed_order_rate_pct,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_base_delivered
GROUP BY customer_state
HAVING COUNT(DISTINCT order_id) >= 100
ORDER BY delayed_order_rate_pct DESC;
