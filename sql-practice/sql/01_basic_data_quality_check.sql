-- Business Question:
-- 주문 상태 분포와 리뷰 결측 비율은 어떻게 나타나는가?
--
-- Tables Used:
-- orders, review_by_order
--
-- Skills:
-- SELECT, LEFT JOIN, GROUP BY, CASE WHEN, Window Function, 비율 계산
--
-- Interpretation:
-- 분석 전에 주문 상태와 리뷰 결측을 확인해 이후 KPI 분석 범위를 정한다.
--
-- Limitation:
-- 리뷰 결측은 리뷰 미작성 또는 데이터 누락을 모두 포함할 수 있으므로 원인을 단정하지 않는다.


WITH order_status_summary AS (
    SELECT
        order_status,
        COUNT(*) AS order_count,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS order_share_pct
    FROM orders
    GROUP BY order_status
),
review_missing_summary AS (
    SELECT
        COUNT(*) AS total_orders,
        SUM(CASE WHEN r.order_id IS NULL THEN 1 ELSE 0 END) AS orders_without_review,
        ROUND(100.0 * SUM(CASE WHEN r.order_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS orders_without_review_pct
    FROM orders o
    LEFT JOIN review_by_order r
        ON o.order_id = r.order_id
)
SELECT
    'order_status' AS check_type,
    order_status AS category,
    order_count AS count_value,
    order_share_pct AS pct_value
FROM order_status_summary
UNION ALL
SELECT
    'review_missing' AS check_type,
    'orders_without_review' AS category,
    orders_without_review AS count_value,
    orders_without_review_pct AS pct_value
FROM review_missing_summary
ORDER BY check_type, count_value DESC;
