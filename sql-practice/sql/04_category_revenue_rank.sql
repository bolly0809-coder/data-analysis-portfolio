-- Business Question:
-- 배송 완료 주문상품 기준 매출 상위 카테고리는 무엇인가?
--
-- Tables Used:
-- order_item_base_delivered
--
-- Skills:
-- GROUP BY, RANK, ORDER BY, 카테고리별 KPI 집계
--
-- Interpretation:
-- 카테고리별 상품 매출 기여도를 순위로 비교한다.
--
-- Limitation:
-- 여기서 매출은 order_items.price 기준 상품 매출이며, 결제금액 기준 총액과 다를 수 있다.


WITH category_revenue AS (
    SELECT
        COALESCE(product_category, 'unknown') AS product_category,
        COUNT(DISTINCT order_id) AS order_count,
        COUNT(*) AS order_item_count,
        ROUND(SUM(price), 2) AS product_revenue,
        ROUND(AVG(price), 2) AS avg_item_price
    FROM order_item_base_delivered
    GROUP BY COALESCE(product_category, 'unknown')
)
SELECT
    RANK() OVER (ORDER BY product_revenue DESC) AS revenue_rank,
    product_category,
    order_count,
    order_item_count,
    product_revenue,
    avg_item_price
FROM category_revenue
ORDER BY revenue_rank
LIMIT 20;
