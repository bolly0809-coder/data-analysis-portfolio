# Synthetic Service Analytics Dataset Schema

이 데이터셋은 Product Data Analyst 공고에서 요구되는 퍼널, 전환율, 리텐션, 이벤트 로그 분석 SQL 구조를 보여주기 위해 만든 연습용 가상 데이터셋입니다.

실제 회사 데이터가 아니며, SQL 분석 구조를 보여주기 위한 synthetic dataset입니다.

## Tables

### users

| column | description |
|---|---|
| user_id | 사용자 ID |
| signup_date | 가입일 |
| region | 사용자 지역 |
| acquisition_channel | 유입 채널 |
| user_type | 사용자 유형 |

### events

| column | description |
|---|---|
| event_id | 이벤트 ID |
| user_id | 사용자 ID |
| event_time | 이벤트 발생 시각 |
| event_name | 이벤트명 |
| service_category | 서비스 카테고리 |
| provider_id | 고수/공급자 ID |
| session_id | 세션 ID |
| device | 접속 디바이스 |
| ab_group | A/B 테스트 그룹 |

### service_requests

| column | description |
|---|---|
| request_id | 요청 ID |
| user_id | 사용자 ID |
| provider_id | 고수/공급자 ID |
| service_category | 서비스 카테고리 |
| request_time | 요청 시각 |
| region | 요청 지역 |
| request_status | 요청 상태 |

### quotes

| column | description |
|---|---|
| quote_id | 견적 ID |
| request_id | 요청 ID |
| provider_id | 고수/공급자 ID |
| quote_time | 견적 발송 시각 |
| quote_price | 견적 금액 |
| response_minutes | 요청 후 견적 응답까지 걸린 시간 |

### transactions

| column | description |
|---|---|
| transaction_id | 거래 ID |
| request_id | 요청 ID |
| user_id | 사용자 ID |
| provider_id | 고수/공급자 ID |
| transaction_time | 거래 성사 시각 |
| transaction_amount | 거래금액 |
| transaction_status | 거래 상태 |

### reviews

| column | description |
|---|---|
| review_id | 리뷰 ID |
| transaction_id | 거래 ID |
| user_id | 사용자 ID |
| provider_id | 고수/공급자 ID |
| review_score | 리뷰 점수 |
| review_time | 리뷰 작성 시각 |
