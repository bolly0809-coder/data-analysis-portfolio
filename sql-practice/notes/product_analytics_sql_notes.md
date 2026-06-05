# Product Analytics SQL Notes

## 1. Why synthetic service data is used

Olist 데이터는 주문·결제·배송·리뷰 중심의 거래 데이터입니다.

Product Data Analyst 공고에서 자주 요구되는 클릭, 검색, 상세조회, 요청, 견적, 거래, 리뷰 작성 같은 이벤트 로그는 포함되어 있지 않습니다.

따라서 Olist 데이터로 실제 퍼널 분석을 수행했다고 표현하면 과장입니다.

이를 보완하기 위해 Product Analytics SQL 구조를 보여주는 synthetic service dataset을 별도로 구성했습니다.

## 2. Difference between transaction data and event log data

### Transaction data

거래 데이터는 이미 발생한 주문, 결제, 배송, 리뷰 결과를 보여줍니다.

적합한 분석:

- 주문 수
- 매출
- 객단가
- 배송 지연율
- 리뷰 점수
- 카테고리별 매출

### Event log data

이벤트 로그 데이터는 사용자가 서비스 안에서 어떤 행동을 거쳤는지 보여줍니다.

적합한 분석:

- 방문
- 검색
- 상세 조회
- 요청
- 견적 수신
- 거래 성사
- 리뷰 작성
- 퍼널 전환율
- 리텐션
- 세그먼트별 행동 차이

## 3. Funnel analysis structure

서비스 퍼널은 다음처럼 정의했습니다.

방문 → 검색 → 상세조회 → 요청 → 견적 수신 → 거래 성사 → 리뷰 작성

각 단계에서 `COUNT(DISTINCT user_id)`를 기준으로 유저 수를 집계하고, 이전 단계 대비 전환율과 첫 방문 대비 전환율을 함께 계산했습니다.

## 4. Retention analysis structure

리텐션 분석은 가입 월을 cohort month로 두고, 이후 이벤트 발생 월을 active month로 계산했습니다.

이를 통해 M0, M1, M2, M3 기준 활성 유저 비율을 집계했습니다.

## 5. Segment analysis structure

세그먼트 분석은 유입 채널, 디바이스, 서비스 카테고리, 지역 등을 기준으로 요청 전환율과 거래 전환율을 비교합니다.

이 분석은 특정 그룹의 병목 지점을 찾고, 제품 개선 또는 마케팅 액션 후보를 정하는 데 활용할 수 있습니다.

## 6. Important limitations

- synthetic dataset은 실제 서비스 데이터가 아닙니다.
- 퍼널 구조와 SQL 작성 방식을 보여주기 위한 샘플입니다.
- 실제 서비스 분석에서는 이벤트 정의, 중복 이벤트 처리, 봇/비정상 로그 제거, 실험군 배정 방식 검증이 추가로 필요합니다.
