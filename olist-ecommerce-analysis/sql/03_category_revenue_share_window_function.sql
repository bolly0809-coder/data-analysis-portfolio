
/*
분석 질문:
카테고리별 매출 비중과 누적 매출 비중은 어떻게 나타나는가?

활용 SQL:
- SUM() OVER()
- SUM() OVER(ORDER BY ...)
- Window Function

포트폴리오 포인트:
단순 GROUP BY뿐 아니라 Window Function으로 전체 대비 비중과 누적 비중을 계산했다.
*/

WITH category_sales AS (
    SELECT
        product_category,
        COUNT(DISTINCT order_id) AS order_count,
        COUNT(*) AS item_count,
        SUM(price) AS revenue
    FROM order_item_base_delivered
    GROUP BY product_category
),

category_share AS (
    SELECT
        product_category,
        order_count,
        item_count,
        revenue,
        revenue / SUM(revenue) OVER() AS revenue_share,
        SUM(revenue) OVER(
            ORDER BY revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) / SUM(revenue) OVER() AS cumulative_revenue_share,
        RANK() OVER(ORDER BY revenue DESC) AS revenue_rank
    FROM category_sales
)

SELECT
    revenue_rank,
    product_category,
    order_count,
    item_count,
    ROUND(revenue, 2) AS revenue,
    ROUND(revenue_share * 100, 2) AS revenue_share_pct,
    ROUND(cumulative_revenue_share * 100, 2) AS cumulative_revenue_share_pct
FROM category_share
ORDER BY revenue_rank
LIMIT 20;
