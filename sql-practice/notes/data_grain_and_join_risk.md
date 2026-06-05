# Data Grain and Join Risk

## 1. Why data grain matters

SQL 분석에서 가장 먼저 정해야 할 것은 분석 기준 단위입니다.

같은 이커머스 데이터라도 월별 주문 KPI를 볼 때는 주문 1건이 기준이고, 카테고리별 매출을 볼 때는 주문상품 1행이 기준입니다. 기준 단위를 명확히 하지 않으면 JOIN 이후 매출이나 리뷰 점수가 중복 집계될 수 있습니다.

## 2. Order-level vs item-level analysis

### Order-level analysis

주문 단위 분석은 `order_id` 1건을 기준으로 합니다.

적합한 지표는 다음과 같습니다.

- 주문 수
- 결제금액
- 평균 리뷰 점수
- 배송 지연 여부
- 배송 소요일
- 고객 지역별 배송 지연율

### Item-level analysis

상품 단위 분석은 `order_id + order_item_id` 1행을 기준으로 합니다.

적합한 지표는 다음과 같습니다.

- 상품 카테고리별 매출
- 상품 가격
- 판매자별 상품 매출
- 카테고리별 주문상품 수

## 3. Join risk in payment and review tables

`order_payments`와 `order_reviews`는 하나의 주문에 여러 행이 연결될 수 있습니다.

따라서 두 테이블을 원본 그대로 주문 테이블과 JOIN하면 한 주문의 결제금액이나 리뷰 점수가 중복될 수 있습니다.

이를 방지하기 위해 다음 순서로 처리합니다.

1. 결제 테이블을 `order_id` 기준으로 먼저 집계한다.
2. 리뷰 테이블을 `order_id` 기준으로 먼저 집계한다.
3. 주문 테이블에 집계된 결제/리뷰 테이블을 LEFT JOIN한다.

## 4. Base table design

Olist 프로젝트에서는 분석 목적에 따라 두 개의 base table을 분리했습니다.

### `order_base_delivered`

배송 완료 주문 1건을 기준으로 만든 테이블입니다.

사용 목적:

- 월별 KPI
- 배송 지연율
- 평균 리뷰 점수
- 고객 지역별 배송 지연율

### `order_item_base_delivered`

배송 완료 주문상품 1행을 기준으로 만든 테이블입니다.

사용 목적:

- 카테고리별 매출
- 카테고리별 매출 비중
- 판매자/상품 단위 분석

## 5. Interview answer summary

분석용 데이터셋을 만들 때는 먼저 기준 단위를 정합니다. Olist 프로젝트에서는 주문 단위 KPI와 상품 단위 매출 분석의 기준이 달랐기 때문에 `order_base_delivered`와 `order_item_base_delivered`를 분리했습니다. 또한 결제와 리뷰 테이블은 주문 1건에 여러 행이 연결될 수 있어 `order_id` 기준으로 사전 집계한 뒤 JOIN했습니다. 이를 통해 매출과 리뷰 점수의 중복 집계 가능성을 줄였습니다.
