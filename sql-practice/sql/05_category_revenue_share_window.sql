-- Business Question:
-- 매출 상위 카테고리의 개별 매출 비중과 누적 매출 비중은 얼마인가?
--
-- Tables Used:
-- order_item_base_delivered
--
-- Skills:
-- Window Function, SUM() OVER(), 누적 비중 계산
--
-- Interpretation:
-- 상위 카테고리에 매출이 얼마나 집중되어 있는지 확인한다.
--
-- Limitation:
-- 상품 매출 기준이며, 결제금액·배송비·쿠폰·환불 등은 반영하지 않는다.


WITH category_revenue AS (
    SELECT
        COALESCE(product_category, 'unknown') AS product_category,
        ROUND(SUM(price), 2) AS product_revenue
    FROM order_item_base_delivered
    GROUP BY COALESCE(product_category, 'unknown')
),
ranked AS (
    SELECT
        product_category,
        product_revenue,
        RANK() OVER (ORDER BY product_revenue DESC) AS revenue_rank,
        SUM(product_revenue) OVER () AS total_revenue,
        SUM(product_revenue) OVER (
            ORDER BY product_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue
    FROM category_revenue
)
SELECT
    revenue_rank,
    product_category,
    product_revenue,
    ROUND(100.0 * product_revenue / total_revenue, 2) AS revenue_share_pct,
    ROUND(100.0 * cumulative_revenue / total_revenue, 2) AS cumulative_revenue_share_pct
FROM ranked
ORDER BY revenue_rank
LIMIT 20;
