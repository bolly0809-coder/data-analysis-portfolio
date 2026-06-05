-- Business Question:
-- 주문 단위 KPI 분석과 상품 단위 카테고리 매출 분석에 같은 base table을 사용해도 되는가?
--
-- Tables Used:
-- orders_enriched, customers, payment_by_order, review_by_order, order_items, products, category_translation, sellers
--
-- Skills:
-- 분석용 base table 설계, JOIN, 데이터 grain 관리, 중복 집계 위험 방지
--
-- Interpretation:
-- 주문 단위 분석과 상품 단위 분석은 기준 단위가 다르므로 base table을 분리해야 한다.
--
-- Limitation:
-- 아래 쿼리는 이미 생성된 base table 구조를 재현하기 위한 예시다. 실제 실행 전 기존 테이블명 충돌 여부를 확인해야 한다.

-- 1) 주문 단위 base table
DROP TABLE IF EXISTS order_base_delivered_example;

CREATE TABLE order_base_delivered_example AS
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

-- 2) 상품 단위 base table
DROP TABLE IF EXISTS order_item_base_delivered_example;

CREATE TABLE order_item_base_delivered_example AS
SELECT
    ob.order_id,
    ob.customer_id,
    ob.customer_unique_id,
    ob.customer_city,
    ob.customer_state,
    ob.purchase_year,
    ob.purchase_month,
    ob.delivery_days,
    ob.delay_days,
    ob.is_delayed,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    COALESCE(ct.product_category_name_english, p.product_category_name) AS product_category,
    s.seller_city,
    s.seller_state,
    ob.review_score
FROM order_base_delivered ob
JOIN order_items oi
    ON ob.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id;
