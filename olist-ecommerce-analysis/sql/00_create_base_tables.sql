
/*
2단계 목적:
- order_payments, order_reviews처럼 order_id 기준 중복 가능성이 있는 테이블을 먼저 주문 단위로 집계한다.
- delivered 주문 기준 주문 단위 base table과 상품 단위 base table을 분리한다.
- 이후 월별 KPI, 카테고리 매출, 배송 지연, 리뷰 점수 분석에 활용한다.
*/

DROP TABLE IF EXISTS payment_by_order;
DROP TABLE IF EXISTS review_by_order;
DROP TABLE IF EXISTS order_base_delivered;
DROP TABLE IF EXISTS order_item_base_delivered;

/*
1. 주문 단위 결제금액 테이블

주의:
order_payments는 한 order_id에 여러 결제 row가 존재할 수 있다.
따라서 매출 분석 전 order_id 기준으로 payment_value를 합산한다.
*/
CREATE TABLE payment_by_order AS
SELECT
    order_id,
    SUM(payment_value) AS payment_value,
    COUNT(*) AS payment_row_count,
    COUNT(DISTINCT payment_type) AS payment_type_count
FROM order_payments
GROUP BY order_id;

/*
2. 주문 단위 리뷰점수 테이블

주의:
order_reviews도 order_id 기준으로 여러 row가 존재할 수 있다.
본 프로젝트에서는 주문 단위 평균 리뷰 점수를 사용한다.
*/
CREATE TABLE review_by_order AS
SELECT
    order_id,
    AVG(review_score) AS review_score,
    COUNT(*) AS review_row_count
FROM order_reviews
GROUP BY order_id;

/*
3. delivered 주문 기준 주문 단위 base table

분석 단위:
- 1행 = 배송 완료 주문 1건

활용:
- 월별 주문 수
- 월별 매출
- 객단가
- 배송 지연율
- 고객 지역별 배송 지연율
- 배송 지연과 리뷰 점수 관계
*/
CREATE TABLE order_base_delivered AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    o.purchase_date,
    o.purchase_year,
    o.purchase_month,
    o.purchase_dayofweek,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    o.delivery_days,
    o.delay_days,
    o.is_delayed,
    p.payment_value,
    p.payment_row_count,
    r.review_score,
    r.review_row_count
FROM orders_enriched o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN payment_by_order p
    ON o.order_id = p.order_id
LEFT JOIN review_by_order r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';

/*
4. delivered 주문 기준 상품 단위 base table

분석 단위:
- 1행 = 배송 완료 주문에 포함된 상품 row 1건

활용:
- 카테고리별 매출
- 카테고리별 주문 수
- 카테고리별 배송 지연율
- 판매자 지역 분석

주의:
order_items는 주문 1건에 여러 상품이 있을 수 있다.
따라서 이 테이블에서는 order_id가 중복되는 것이 정상이다.
*/
CREATE TABLE order_item_base_delivered AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.purchase_year,
    o.purchase_month,
    o.delivery_days,
    o.delay_days,
    o.is_delayed,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    COALESCE(
        t.product_category_name_english,
        pr.product_category_name,
        'unknown'
    ) AS product_category,
    s.seller_city,
    s.seller_state,
    r.review_score
FROM orders_enriched o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN products pr
    ON oi.product_id = pr.product_id
LEFT JOIN category_translation t
    ON pr.product_category_name = t.product_category_name
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
LEFT JOIN review_by_order r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';
