
/*
분석 질문:
어떤 상품 카테고리가 매출에 가장 크게 기여했는가?

분석 단위:
- 1행 = 배송 완료 주문의 상품 row 1건

주요 지표:
- revenue: 상품 가격 합계
- freight_value: 배송비 합계
- order_count: 해당 카테고리를 포함한 주문 수
- item_count: 판매 상품 row 수
- avg_item_price: 평균 상품 가격

해석 주의:
이 분석의 revenue는 order_items.price 기준 상품 매출이다.
order_payments.payment_value 기준 결제금액과는 쿠폰, 배송비, 결제 구조 때문에 차이가 날 수 있다.
*/

SELECT
    product_category,
    COUNT(DISTINCT order_id) AS order_count,
    COUNT(*) AS item_count,
    ROUND(SUM(price), 2) AS revenue,
    ROUND(SUM(freight_value), 2) AS freight_revenue,
    ROUND(AVG(price), 2) AS avg_item_price,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_item_base_delivered
GROUP BY product_category
ORDER BY revenue DESC
LIMIT 10;
