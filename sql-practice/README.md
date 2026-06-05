# SQL Practice for Data Analyst Portfolio

이 폴더는 데이터 분석가 지원 과정에서 SQL 기반 데이터 추출·집계·분석용 데이터셋 구성 역량을 보여주기 위해 만든 SQL 포트폴리오 보강 자료입니다.

SQLD 문법 학습 수준을 넘어, 실제 분석 질문을 SQL 쿼리로 바꾸고 원본 테이블을 분석 목적에 맞게 결합·집계하는 과정을 보여주는 데 목적이 있습니다.

## 1. Data Used

### 1-1. Olist Ecommerce Dataset

Kaggle Olist 공개 이커머스 데이터셋을 SQLite에 적재한 `olist_ecommerce.db`를 활용했습니다.

주요 분석 대상은 주문, 결제, 배송, 리뷰, 상품, 고객, 판매자 데이터입니다.

이 데이터셋에는 클릭, 노출, 장바구니, 페이지뷰 로그가 없으므로 실제 퍼널 분석이나 전환율 분석으로 해석하지 않습니다. Olist 기반 SQL은 주문·결제·배송·리뷰 중심의 거래 데이터 분석으로 범위를 제한했습니다.

### 1-2. Synthetic Service Analytics Dataset

Product Data Analyst 공고에서 자주 요구되는 퍼널, 전환율, 리텐션, 이벤트 로그 분석 SQL을 보여주기 위해 만든 연습용 가상 데이터셋입니다.

실제 회사 데이터가 아니며, SQL 분석 구조를 보여주기 위한 synthetic dataset입니다.

## 2. Skills Demonstrated

- SELECT / WHERE / GROUP BY / HAVING
- JOIN
- CASE WHEN
- Subquery / CTE
- Window Function
- 날짜 기준 집계
- KPI 계산
- 퍼널 전환율
- 코호트 리텐션
- 세그먼트 분석
- 랭킹 분석
- A/B 테스트 결과 집계 기초
- 분석용 base table 설계
- 중복 집계 위험 관리

## 3. Repository Structure

```text
sql-practice/
├─ README.md
├─ data/
├─ sql/
├─ outputs/
└─ notes/
```

## 4. SQL Analysis List

### Part A. Olist Ecommerce SQL

| file | business question | main skills |
|---|---|---|
| `01_basic_data_quality_check.sql` | 주문 상태 분포와 리뷰 결측 비율은? | GROUP BY, CASE WHEN, Window |
| `02_order_payment_review_join.sql` | 주문·결제·리뷰는 어떤 단위로 결합해야 하는가? | CTE, JOIN, 사전 집계 |
| `03_monthly_kpi.sql` | 월별 주문 수, 매출, 객단가는? | 날짜 집계, KPI |
| `04_category_revenue_rank.sql` | 매출 상위 카테고리는? | GROUP BY, RANK |
| `05_category_revenue_share_window.sql` | 카테고리별 누적 매출 비중은? | Window Function |
| `06_delivery_delay_review_score.sql` | 배송 지연 구간별 리뷰 점수는? | CASE WHEN, 조건부 비율 |
| `07_customer_state_delay_rate.sql` | 고객 지역별 배송 지연율은? | 세그먼트 분석, HAVING |
| `08_base_table_design.sql` | 주문 단위/상품 단위 base table을 왜 분리하는가? | 데이터 grain 설계 |

### Part B. Product Analytics SQL

| file | business question | main skills |
|---|---|---|
| `09_service_funnel_conversion.sql` | 서비스 퍼널 단계별 전환율은? | CTE, COUNT DISTINCT, Window |
| `10_category_conversion.sql` | 카테고리별 요청→거래 전환율은? | JOIN, GROUP BY |
| `11_cohort_retention.sql` | 가입 월별 M0~M3 리텐션은? | Cohort, 날짜 계산 |
| `12_response_time_transaction_rate.sql` | 응답 속도와 거래 성사율은? | CASE WHEN, 전환율 |
| `13_review_score_reuse.sql` | 첫 거래 리뷰 점수와 재이용률은? | ROW_NUMBER, 이후 행동 추적 |
| `14_ab_test_result_aggregation.sql` | A/B 그룹별 전환율은? | 실험 결과 집계 |
| `15_user_segment_analysis.sql` | 유입 채널·디바이스별 전환율은? | 세그먼트 분석 |

## 5. Key Analysis Examples

### 5-1. Monthly KPI

`03_monthly_kpi.sql`은 배송 완료 주문 기준 월별 주문 수, 매출, 객단가, 평균 리뷰 점수, 배송 지연율을 집계합니다.

### 5-2. Category Revenue Share

`05_category_revenue_share_window.sql`은 Window Function을 활용해 카테고리별 매출 비중과 누적 매출 비중을 계산합니다.

### 5-3. Delivery Delay and Review Score

`06_delivery_delay_review_score.sql`은 배송 지연 구간별 평균 리뷰 점수, 1~2점 리뷰 비율, 5점 리뷰 비율을 비교합니다.

### 5-4. Service Funnel Conversion

`09_service_funnel_conversion.sql`은 방문 → 검색 → 상세조회 → 요청 → 견적 → 거래 → 리뷰 작성 단계별 유저 수와 전환율을 계산합니다.

### 5-5. Cohort Retention

`11_cohort_retention.sql`은 가입 월 기준 M0~M3 리텐션을 계산합니다.

## 6. Important Limitations

- Olist 데이터에는 클릭, 노출, 장바구니, 페이지뷰 로그가 없으므로 실제 Product Funnel 분석으로 해석하지 않습니다.
- Product Analytics SQL은 synthetic dataset으로 구성했습니다.
- Synthetic dataset은 실제 회사 데이터가 아니며, SQL 분석 구조를 보여주기 위한 샘플 데이터입니다.
- 배송 지연과 리뷰 점수, 리뷰 점수와 재이용률 등은 관찰적 경향으로만 해석하며 인과관계로 단정하지 않습니다.
- A/B 테스트 SQL은 결과 집계 구조를 보여주는 예시이며, 통계적 유의성 검정까지 수행한 분석은 아닙니다.

## 7. How This Supports My Portfolio

이 폴더는 기존 프로젝트에서 설명한 SQL 역량을 채용 담당자가 직접 확인할 수 있도록 만든 보강 자료입니다.

특히 다음 역량을 보여주는 데 목적이 있습니다.

- 분석 질문을 SQL 쿼리로 변환하는 능력
- 원본 테이블의 관계와 분석 단위를 고려해 JOIN하는 능력
- 중복 집계 위험을 관리하기 위해 base table을 설계하는 능력
- KPI, 랭킹, 누적 비중, 전환율, 리텐션, 세그먼트 분석을 SQL로 수행하는 능력
- 거래 데이터와 이벤트 로그 데이터의 차이를 구분하고 분석 범위를 명확히 제한하는 태도

## 8. Interview Talking Points

SQL 역량을 설명할 때는 다음 흐름으로 답변할 수 있습니다.

1. SQLD 범위의 기본 문법을 학습했고, 포트폴리오에서는 Olist 공개 이커머스 데이터 9개 테이블을 SQLite에 적재해 실습했습니다.
2. 주문·결제·리뷰는 1:N 관계가 생길 수 있어 주문 단위로 먼저 집계한 뒤 결합했습니다.
3. 주문 단위 KPI와 상품 단위 카테고리 매출 분석은 기준 단위가 달라 base table을 분리했습니다.
4. JOIN, GROUP BY, CTE, Window Function을 활용해 월별 KPI, 카테고리별 매출 기여도, 누적 매출 비중, 배송 지연과 리뷰 점수 차이를 분석했습니다.
5. Olist에는 실제 제품 로그가 없기 때문에 Product Analytics형 SQL은 synthetic dataset으로 퍼널, 전환율, 리텐션, 세그먼트 분석 구조를 별도로 연습했습니다.
