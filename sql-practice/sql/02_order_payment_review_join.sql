-- Business Question:
-- 주문·결제·리뷰 데이터를 주문 단위로 결합하려면 어떤 사전 집계가 필요한가?
--
-- Tables Used:
-- orders, order_payments, order_reviews
--
-- Skills:
-- CTE, LEFT JOIN, GROUP BY, 1:N 관계 사전 집계
--
-- Interpretation:
-- 결제와 리뷰는 주문 1건에 여러 행이 연결될 수 있으므로 주문 단위로 먼저 집계한 뒤 결합한다.
--
-- Limitation:
-- LIMIT 100은 샘플 확인용이며, 실제 분석에서는 이 쿼리를 base table 생성 로직으로 확장한다.


WITH payment_agg AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_value,
        COUNT(*) AS payment_row_count,
        COUNT(DISTINCT payment_type) AS payment_type_count
    FROM order_payments
    GROUP BY order_id
),
review_agg AS (
    SELECT
        order_id,
        AVG(review_score) AS review_score,
        COUNT(*) AS review_row_count
    FROM order_reviews
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    DATE(o.order_purchase_timestamp) AS purchase_date,
    p.payment_value,
    p.payment_row_count,
    p.payment_type_count,
    r.review_score,
    r.review_row_count
FROM orders o
LEFT JOIN payment_agg p
    ON o.order_id = p.order_id
LEFT JOIN review_agg r
    ON o.order_id = r.order_id
LIMIT 100;
