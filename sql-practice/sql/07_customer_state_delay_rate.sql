-- Business Question:
-- 고객 주(state)별 배송 지연율과 평균 리뷰 점수는 어떻게 다른가?
--
-- Tables Used:
-- order_base_delivered
--
-- Skills:
-- GROUP BY, HAVING, 세그먼트 분석, 비율 계산
--
-- Interpretation:
-- 배송 지연율이 높은 지역을 운영 점검 후보로 도출한다.
--
-- Limitation:
-- 지역별 지연율은 판매자 위치, 물류 거리, 상품 구성, 주문량의 영향을 함께 받을 수 있으므로 지역 자체를 원인으로 단정하지 않는다.


SELECT
    customer_state,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(100.0 * SUM(is_delayed) / COUNT(*), 2) AS delay_rate_pct,
    ROUND(AVG(delay_days), 2) AS avg_delay_days,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_base_delivered
WHERE customer_state IS NOT NULL
GROUP BY customer_state
HAVING COUNT(DISTINCT order_id) >= 100
ORDER BY delay_rate_pct DESC, order_count DESC;
