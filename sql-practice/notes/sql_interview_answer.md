# SQL Interview Answer

## 1. My SQL level

SQLD 범위의 기본 문법을 학습했고, 포트폴리오에서는 SQLite 기반으로 다중 테이블 JOIN, GROUP BY, CTE, Window Function을 활용한 분석을 수행했습니다.

## 2. Olist SQL project explanation

Olist 공개 이커머스 데이터 9개 테이블을 SQLite에 적재하고, 주문·결제·배송·리뷰 데이터를 활용해 월별 KPI, 카테고리별 매출 기여도, 배송 지연율, 배송 지연 구간별 리뷰 점수 차이를 분석했습니다.

## 3. How I handle join and aggregation risk

분석용 데이터셋을 만들 때 먼저 기준 단위를 정합니다.

Olist 프로젝트에서는 주문 단위 KPI와 상품 단위 카테고리 매출 분석의 기준 단위가 달랐기 때문에 주문 단위 base table과 상품 단위 base table을 분리했습니다.

또한 결제와 리뷰 테이블은 주문 1건에 여러 행이 연결될 수 있어 `order_id` 기준으로 사전 집계한 뒤 주문 테이블과 결합했습니다.

## 4. Product Analytics SQL practice

Olist에는 실제 클릭, 검색, 상세조회, 요청 같은 이벤트 로그가 없기 때문에 Product Analytics형 SQL은 synthetic service dataset을 별도로 만들어 연습했습니다.

이를 통해 퍼널 전환율, 코호트 리텐션, 응답 속도와 거래 성사율, 리뷰 점수와 재이용률, A/B 테스트 결과 집계, 세그먼트별 전환율 분석 SQL을 작성했습니다.

## 5. One-minute answer

SQL은 단순 조회 도구가 아니라 분석 질문을 데이터셋과 지표로 바꾸는 도구라고 생각합니다. Olist 프로젝트에서는 주문·결제·배송·리뷰 데이터를 SQLite에 적재하고, JOIN, GROUP BY, CTE, Window Function을 활용해 월별 KPI와 카테고리 매출, 배송 지연과 리뷰 점수 차이를 분석했습니다. 특히 주문 단위와 상품 단위의 기준이 달라 base table을 분리했고, 결제와 리뷰는 주문 단위로 사전 집계해 중복 집계 위험을 줄였습니다. 또한 Product Analytics 공고를 대비해 synthetic service dataset으로 퍼널 전환율, 코호트 리텐션, 세그먼트 분석 SQL을 별도로 정리했습니다.
