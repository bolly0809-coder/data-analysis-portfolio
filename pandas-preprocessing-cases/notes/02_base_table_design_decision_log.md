# 02 Base Table Design Decision Log

## 결정 1. naive JOIN을 실제 분석에 사용하지 않음

- 문제: orders, order_items, order_payments, order_reviews를 한 번에 JOIN하면 주문 1건이 상품 수와 결제 행 수만큼 늘어날 수 있음
- 처리: naive JOIN은 위험을 보여주는 검증 예시로만 사용
- 이유: 주문 단위 KPI에서 결제금액이나 리뷰 점수가 중복 집계될 수 있기 때문

## 결정 2. 결제 테이블 사전 집계

- 문제: order_payments는 주문 1건에 여러 결제 행이 존재할 수 있음
- 처리: `payment_by_order`를 생성해 주문별 결제금액을 먼저 합산
- 이유: 월별 매출, 객단가 분석은 주문 단위 결제금액을 기준으로 해야 함

## 결정 3. 리뷰 테이블 사전 집계

- 문제: order_reviews는 주문별 리뷰 결측 또는 중복 가능성이 있음
- 처리: `review_by_order`를 생성해 주문별 평균 리뷰 점수를 먼저 집계
- 이유: 배송 지연과 리뷰 점수 관계를 주문 단위로 분석하기 위함

## 결정 4. 주문 단위 base table 생성

- 문제: 월별 KPI, 배송 지연율, 리뷰 점수 분석은 주문 1건 기준으로 계산해야 함
- 처리: `order_base_delivered`를 사용
- 이유: 배송 완료 주문 기준으로 주문 수, 결제금액, 배송 지연, 리뷰 점수를 안정적으로 집계하기 위함

## 결정 5. 상품 단위 base table 생성

- 문제: 카테고리 매출과 상품 가격 분석은 상품 행 기준이 필요함
- 처리: `order_item_base_delivered`를 사용
- 이유: product_category, price, seller_id는 주문상품 행 단위에서 분석해야 함
