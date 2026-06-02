# Olist 이커머스 주문·배송·리뷰 데이터 기반 고객 경험 분석

## 1. 프로젝트 개요

본 프로젝트는 Kaggle의 **Brazilian E-Commerce Public Dataset by Olist**를 활용해 이커머스 주문, 결제, 배송, 리뷰 데이터를 분석한 미니 프로젝트입니다.

Olist 데이터셋은 클릭, 장바구니, 페이지뷰와 같은 웹 행동 로그가 아니라 **주문·결제·배송·리뷰 중심의 거래 데이터**입니다. 따라서 본 프로젝트는 퍼널 분석이나 전환율 분석이 아니라, 주문 성과와 배송 경험, 리뷰 만족도 간의 관계를 탐색하는 **이커머스 고객 경험 분석**으로 범위를 제한했습니다.

주요 목적은 다음과 같습니다.

- SQLite 기반 다중 테이블 JOIN, GROUP BY, Window Function 활용
- Python/pandas 기반 전처리 및 시각화
- 월별 주문 수, 매출, 객단가 등 이커머스 기본 KPI 분석
- 카테고리별 매출 기여도 분석
- 배송 지연율과 고객 리뷰 점수 간의 관계 분석
- 주문·배송·리뷰 데이터 기반 고객 경험 인사이트 도출

---

## 2. 사용 데이터

- 데이터셋: Kaggle - Brazilian E-Commerce Public Dataset by Olist
- 원본 출처: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
- 분석 도구: Python, pandas, SQLite, matplotlib
- 분석 기간: 2016-09 ~ 2018-10
- 주요 분석 기간: 2017-01 ~ 2018-08

### 사용 테이블

| 파일명 | 설명 |
|---|---|
| `olist_orders_dataset.csv` | 주문 상태, 주문 시각, 배송 시각, 예상 배송일 |
| `olist_order_items_dataset.csv` | 주문별 상품, 판매자, 상품 가격, 배송비 |
| `olist_order_payments_dataset.csv` | 주문별 결제 수단 및 결제 금액 |
| `olist_order_reviews_dataset.csv` | 주문별 리뷰 점수 및 리뷰 작성 시각 |
| `olist_customers_dataset.csv` | 고객 ID, 고객 도시, 고객 주 |
| `olist_sellers_dataset.csv` | 판매자 ID, 판매자 도시, 판매자 주 |
| `olist_products_dataset.csv` | 상품 ID, 상품 카테고리, 상품 속성 |
| `olist_geolocation_dataset.csv` | 우편번호 prefix 기준 위치 정보 |
| `product_category_name_translation.csv` | 포르투갈어 상품 카테고리의 영어 번역 |

---

## 3. 데이터 구조와 분석 단위

원본 9개 CSV를 SQLite DB에 적재한 뒤, 분석 목적에 맞게 주문 단위와 상품 단위 base table을 분리했습니다.

```text
customers → orders → order_items → products
orders → order_payments
orders → order_reviews
order_items → sellers
products → product_category_name_translation
```

| 테이블명 | 분석 단위 | 용도 |
|---|---|---|
| `payment_by_order` | 주문 1건 | 주문별 결제금액 합산 |
| `review_by_order` | 주문 1건 | 주문별 평균 리뷰 점수 |
| `order_base_delivered` | 배송 완료 주문 1건 | 월별 KPI, 배송 지연율, 리뷰 점수 분석 |
| `order_item_base_delivered` | 배송 완료 주문의 상품 row 1건 | 카테고리별 매출, 상품 가격, 판매자 분석 |

`order_payments`, `order_reviews`, `order_items`는 `order_id` 기준으로 여러 행이 존재할 수 있으므로, 매출과 리뷰 점수의 중복 집계를 방지하기 위해 주문 단위로 먼저 집계한 뒤 분석에 활용했습니다.

---

## 4. 분석 질문

1. 월별 주문 수, 매출, 객단가는 어떻게 변화했는가?
2. 어떤 상품 카테고리가 매출에 크게 기여했는가?
3. 고객 지역별 배송 지연율은 어떻게 다른가?
4. 배송 지연 정도에 따라 리뷰 점수는 어떻게 달라지는가?

---

## 5. 주요 SQL 분석

### 5-1. 월별 주문 수·매출·객단가 분석

```sql
SELECT
    purchase_month,
    COUNT(DISTINCT order_id) AS order_count,
    COUNT(DISTINCT customer_unique_id) AS customer_count,
    ROUND(SUM(payment_value), 2) AS revenue,
    ROUND(SUM(payment_value) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(is_delayed) * 100, 2) AS delayed_order_rate_pct,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_base_delivered
GROUP BY purchase_month
ORDER BY purchase_month;
```

### 5-2. Window Function 기반 카테고리별 매출 비중 분석

```sql
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
```

---

## 6. 주요 결과

### 6-1. 월별 주문 수와 매출 추이

![월별 주문 수와 매출 추이](images/01_monthly_orders_revenue.svg)

그래프의 매출 축은 백만 단위로 표시했습니다. 2017년 이후 주문 수와 매출이 함께 증가했으며, 2017년 11월 이후 높은 수준의 주문량과 매출을 유지했습니다.

### 6-2. 카테고리별 상품 매출 TOP10

![카테고리별 상품 매출 TOP10](images/02_top_categories_revenue.svg)

상품 매출 기준 상위 카테고리는 `health_beauty`, `watches_gifts`, `bed_bath_table`, `sports_leisure`, `computers_accessories` 순으로 나타났습니다. 그래프의 상품 매출 값은 백만 단위로 표시했습니다.

### 6-3. 카테고리별 매출 비중 TOP20

![카테고리별 매출 비중 TOP20](images/03_category_revenue_share_top20.svg)

TOP20 카테고리가 전체 상품 매출의 약 84.06%를 차지해, 매출 기여도가 일부 주요 카테고리에 집중되어 있음을 확인했습니다.

### 6-4. 고객 주별 배송 지연율 TOP10

![고객 주별 배송 지연율 TOP10](images/04_delay_rate_by_state.svg)

고객 주별 배송 지연율을 비교한 결과, AL, MA, PI, CE, SE 등의 주에서 배송 지연율이 높게 확인되었습니다. 다만 지역별 지연율 차이는 판매자 위치, 물류 거리, 상품 구성, 주문량 차이의 영향을 함께 받을 수 있으므로 운영 점검 후보로 해석했습니다.

### 6-5. 배송 지연 구간별 평균 리뷰 점수

![배송 지연 구간별 평균 리뷰 점수](images/05_review_score_by_delay_group.svg)

배송이 예상일보다 빨리 도착한 주문은 평균 리뷰 점수가 4점대였지만, 배송 지연이 길어질수록 평균 리뷰 점수가 낮아졌습니다.

| 배송 구간 | 평균 리뷰 점수 |
|---|---:|
| 7일 이상 조기 도착 | 4.32 |
| 1~6일 조기 도착 | 4.20 |
| 1~3일 지연 | 3.77 |
| 4~7일 지연 | 2.32 |
| 8일 이상 지연 | 1.73 |

### 6-6. 배송 지연 구간별 낮은 점수 비율과 5점 비율

![배송 지연 구간별 낮은 점수 비율과 5점 비율](images/06_review_score_distribution_by_delay.svg)

배송이 빨리 도착한 주문에서는 5점 리뷰 비율이 높았지만, 배송 지연이 길어질수록 1~2점 리뷰 비율이 증가하고 5점 리뷰 비율은 감소했습니다.

---

## 7. 핵심 인사이트

1. 2017년 이후 월별 주문 수와 매출은 유사한 흐름으로 증가했다.
2. `health_beauty`, `watches_gifts`, `bed_bath_table` 등 상위 카테고리가 높은 매출 기여도를 보였고, TOP20 카테고리가 전체 상품 매출의 약 84.06%를 차지했다.
3. 일부 고객 지역에서 배송 지연율이 상대적으로 높게 나타났지만, 원인을 지역 자체로 단정하지 않고 운영 점검 후보로 해석했다.
4. 배송 지연이 길어질수록 평균 리뷰 점수와 5점 리뷰 비율은 낮아지고, 1~2점 리뷰 비율은 증가했다.

---

## 8. 한계 및 해석 주의점

- 클릭, 장바구니, 페이지뷰, 노출, 이탈 데이터가 없어 퍼널 분석이나 전환율 분석은 수행할 수 없다.
- 배송 지연과 리뷰 점수 간 관계를 확인했지만, 인과관계로 단정할 수는 없다.
- 리뷰 점수에는 배송뿐 아니라 상품 품질, 가격, 판매자 응대, 고객 기대치 등 다양한 요인이 영향을 줄 수 있다.
- 카테고리 매출은 `order_items.price` 기준 상품 매출이며, 결제금액 기준 매출과는 다를 수 있다.
- 고객 지역별 배송 지연율은 판매자 위치, 물류 거리, 주문량, 상품 구성의 영향을 함께 받을 수 있다.
- `customer_unique_id` 기준 반복 구매 고객 비율이 약 3% 수준으로 낮아, 코호트 리텐션 분석은 메인 분석에서 제외했다.

---

## 9. 프로젝트에서 보여준 역량

- SQLite 기반 데이터 적재 및 SQL 분석 환경 구성
- 다중 테이블 JOIN을 통한 분석용 base table 생성
- 주문 단위와 상품 단위 분석 테이블 분리
- GROUP BY, CTE, Window Function을 활용한 SQL 분석
- 결제·리뷰 중복 집계 방지를 위한 사전 집계 처리
- 배송 소요일, 배송 지연일, 지연 여부 등 파생변수 생성
- 이커머스 KPI 분석 및 시각화
- 배송 운영 지표와 고객 리뷰 만족도의 관계 해석
- 데이터 한계를 고려한 분석 범위 설정

---

## 10. 폴더 구조

```text
olist-ecommerce-analysis/
├─ README.md
├─ data/
│  └─ README.md
├─ notebooks/
│  └─ README.md
├─ outputs/
│  ├─ monthly_kpi.csv
│  ├─ category_revenue_top10.csv
│  ├─ category_revenue_share.csv
│  ├─ delivery_delay_by_state.csv
│  └─ review_score_by_delay_group.csv
├─ sql/
│  ├─ 00_create_base_tables.sql
│  ├─ 01_monthly_kpi.sql
│  ├─ 02_category_revenue_top10.sql
│  ├─ 03_category_revenue_share_window_function.sql
│  ├─ 04_delivery_delay_by_state.sql
│  └─ 05_review_score_by_delay_group.sql
└─ images/
   ├─ 01_monthly_orders_revenue.svg
   ├─ 02_top_categories_revenue.svg
   ├─ 03_category_revenue_share_top20.svg
   ├─ 04_delay_rate_by_state.svg
   ├─ 05_review_score_by_delay_group.svg
   └─ 06_review_score_distribution_by_delay.svg
```

> 원본 CSV와 SQLite DB 파일은 용량 및 데이터 출처 관리를 위해 GitHub에 포함하지 않습니다. 프로젝트를 재현하려면 Kaggle에서 원본 CSV를 다운로드한 뒤, 노트북을 순서대로 실행해 DB와 분석 결과물을 생성해야 합니다.
