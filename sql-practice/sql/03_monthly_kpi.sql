-- Business Question:
-- 월별 주문 수, 매출, 객단가, 평균 리뷰 점수, 배송 지연율은 어떻게 변화했는가?
--
-- Tables Used:
-- order_base_delivered
--
-- Skills:
-- 날짜 기준 집계, GROUP BY, HAVING, KPI 계산
--
-- Interpretation:
-- 배송 완료 주문 기준으로 월별 KPI 흐름을 확인한다.
--
-- Limitation:
-- Olist 데이터의 초기 월은 주문 수가 적어 2017-01 이후를 중심으로 해석한다.


SELECT
    purchase_month,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(SUM(payment_value), 2) AS revenue,
    ROUND(SUM(payment_value) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(100.0 * SUM(is_delayed) / COUNT(*), 2) AS delay_rate_pct
FROM order_base_delivered
WHERE purchase_month BETWEEN '2017-01' AND '2018-08'
GROUP BY purchase_month
HAVING COUNT(DISTINCT order_id) >= 100
ORDER BY purchase_month;
