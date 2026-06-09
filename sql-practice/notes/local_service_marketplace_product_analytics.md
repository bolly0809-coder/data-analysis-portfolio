# Local Service Marketplace Product Analytics SQL Case

이 문서는 지역 기반 생활서비스 중개 플랫폼을 가정해, 고객의 서비스 탐색부터 요청서 작성, 전문가 견적 수신, 거래 성사, 리뷰 작성까지 이어지는 과정을 SQL로 분석하는 Product Analytics 연습 케이스입니다.

실제 회사 데이터가 아닌 synthetic dataset을 기반으로 하며, 목적은 실제 성과를 주장하는 것이 아니라 Product Data Analyst 직무에서 요구되는 퍼널 정의, 전환율 계산, 카테고리별 성과 비교, 응답시간별 거래율 분석, 코호트 리텐션 분석 구조를 SQL로 보여주는 것입니다.

---

## 1. Case Overview

지역 기반 생활서비스 중개 플랫폼은 고객과 전문가가 만나는 양면시장 구조를 갖습니다.

고객은 서비스를 탐색하고 요청서를 작성하며, 전문가는 요청에 견적을 보내고, 고객은 견적과 전문가 정보를 비교한 뒤 거래를 결정합니다. 따라서 단순 방문자 수보다 다음 흐름의 전환 구조를 보는 것이 중요합니다.

```text
Visit -> Search -> Provider Detail View -> Request Created -> Quote Received -> Transaction Completed -> Review Written
```

이 케이스는 위 흐름을 기준으로 사용자의 이탈 구간, 카테고리별 매칭 품질, 전문가 응답속도와 거래 성사율, 견적 미수신 요청, 전문가 공급 품질을 SQL로 분석하는 구조를 정리합니다.

---

## 2. Why This Case Matters

Product Data Analyst 관점에서 중요한 질문은 다음과 같습니다.

1. 사용자는 어느 단계에서 가장 많이 이탈하는가?
2. 요청을 남긴 고객은 실제 견적을 충분히 받고 있는가?
3. 견적을 받은 고객은 거래까지 이어지는가?
4. 카테고리별로 요청 -> 견적 -> 거래 전환율은 어떻게 다른가?
5. 전문가 첫 응답시간은 거래 성사율과 어떤 관계를 갖는가?
6. 유입 채널, 디바이스, 지역별 전환 차이는 어디서 발생하는가?
7. 신규 사용자는 가입 후 몇 개월까지 재방문 또는 재이용하는가?

이 질문들은 단순히 SQL 문법을 확인하기 위한 것이 아니라, 서비스 개선 우선순위를 정하기 위한 분석 질문입니다.

---

## 3. Assumed Service Flow

| step | meaning | example metric |
|---|---|---|
| Visit | 서비스 방문 | 방문자 수 |
| Search | 서비스 또는 전문가 탐색 | 검색 전환율 |
| Provider Detail View | 전문가 상세 페이지 확인 | 상세조회 전환율 |
| Request Created | 고객 요청서 작성 | 요청 전환율 |
| Quote Received | 전문가 견적 수신 | 견적 수신율 |
| Transaction Completed | 거래 성사 | 거래 전환율 |
| Review Written | 거래 후 리뷰 작성 | 리뷰 작성률 |

---

## 4. Assumed Data Model

| table | grain | description |
|---|---|---|
| `users` | user 1 row | 가입일, 지역, 유입 채널, 디바이스 |
| `service_events` | event 1 row | 방문, 검색, 상세조회, 요청, 견적확인, 거래, 리뷰 이벤트 |
| `requests` | request 1 row | 고객이 작성한 서비스 요청서 |
| `quotes` | quote 1 row | 전문가가 보낸 견적 |
| `transactions` | transaction 1 row | 실제 거래 성사 정보 |
| `reviews` | review 1 row | 거래 후 리뷰 |
| `categories` | category 1 row | 서비스 카테고리 |
| `providers` | provider 1 row | 전문가 정보 |

이 케이스에서 중요한 점은 이벤트 로그, 요청서, 견적, 거래 테이블의 기준 단위가 다르다는 점입니다. 단순 JOIN을 하면 요청 수, 견적 수, 거래 수가 중복 집계될 수 있으므로, 분석 질문에 따라 user 단위, request 단위, quote 단위, provider 단위를 구분해 집계해야 합니다.

---

## 5. Key Metrics

### 5-1. Funnel Metrics

- Visit -> Search Conversion Rate
- Search -> Detail View Conversion Rate
- Detail View -> Request Creation Rate
- Request -> Quote Received Rate
- Quote -> Transaction Conversion Rate
- Transaction -> Review Written Rate

### 5-2. Marketplace Matching Metrics

- Request Count
- Quoted Request Count
- Quote Receive Rate
- Average Quotes per Request
- Transaction Count
- Request-to-Transaction Conversion Rate
- Quote-to-Transaction Conversion Rate

### 5-3. Response / Supply Metrics

- First Response Time
- Response Time Bucket
- Transaction Rate by Response Time Bucket
- No Quote Rate
- Provider Quote Count
- Provider Quote-to-Transaction Rate

### 5-4. Retention / Segment Metrics

- Signup Cohort Retention
- M0~M3 Active Rate
- Conversion Rate by Acquisition Channel
- Conversion Rate by Device
- Conversion Rate by Region

---

## 6. SQL Analysis Files

| file | business question | main skills |
|---|---|---|
| `16_local_service_marketplace_funnel.sql` | 방문 -> 검색 -> 상세조회 -> 요청 -> 견적 -> 거래 -> 리뷰 단계별 전환율은? | CTE, COUNT DISTINCT, Window Function |
| `17_request_quote_transaction_conversion.sql` | 카테고리별 요청 -> 견적 -> 거래 전환율은? | 사전 집계, JOIN, GROUP BY |
| `18_response_time_transaction_rate.sql` | 전문가 첫 응답시간별 거래 성사율은? | 시간 차이 계산, CASE WHEN |
| `19_no_quote_request_analysis.sql` | 견적을 받지 못한 요청은 어떤 카테고리·지역·시간대에 집중되는가? | LEFT JOIN, 조건부 집계, 세그먼트 분석 |
| `20_provider_supply_response_quality.sql` | 전문가별 응답속도와 거래 전환율은 어떻게 다른가? | 공급자 세그먼트, 전환율, 리뷰 점수 결합 |

---

## 7. Analysis Questions & Interpretation

### 7-1. Funnel Drop-off

전체 퍼널 전환율은 사용자가 어느 단계에서 가장 많이 이탈하는지 확인하기 위한 출발점입니다.

- 상세조회에서 요청서 작성으로 이어지지 않는다면 전문가 프로필 정보, 예상 가격, 리뷰 노출, 요청서 작성 UX를 점검합니다.
- 요청서 작성 이후 견적 수신율이 낮다면 전문가 공급 부족, 지역 매칭, 요청서 품질 문제를 점검합니다.
- 견적 수신 이후 거래율이 낮다면 가격 기대치, 견적 품질, 전문가 신뢰 정보, 후속 커뮤니케이션 문제를 점검합니다.

### 7-2. Category Matching Quality

카테고리별 요청 수만 보면 수요 규모는 알 수 있지만, 실제 매칭 품질은 알기 어렵습니다. 요청 -> 견적 -> 거래 전환율을 분리하면 문제 위치를 더 명확히 볼 수 있습니다.

- 요청은 많지만 견적 수신율이 낮은 카테고리: 공급 부족 또는 매칭 커버리지 문제
- 견적은 많이 받지만 거래 전환율이 낮은 카테고리: 가격 기대치, 신뢰 정보, 견적 품질 문제
- 요청당 평균 견적 수는 높지만 거래율이 낮은 카테고리: 견적 수보다 견적 품질 또는 전문가 정보 개선 필요

### 7-3. Response Time and Transaction Rate

전문가 첫 응답시간은 고객 경험에 영향을 줄 수 있는 중요한 운영 지표입니다. 빠른 응답 구간의 거래율이 높다면, 전문가 알림, 요청 우선 노출, 빠른 견적 유도 정책을 실험 가설로 검토할 수 있습니다.

다만 응답시간과 거래 성사율의 관계는 인과관계로 단정하지 않습니다. 카테고리, 지역, 가격대, 전문가 평점, 요청 시간대, 고객 의도 등 추가 변수를 함께 확인해야 합니다.

### 7-4. No Quote Requests

요청서를 작성했지만 견적을 받지 못한 고객은 이탈 가능성이 큽니다. 견적 미수신 요청이 특정 카테고리, 지역, 시간대에 집중된다면 공급 부족, 요청 조건, 가격 기대치, 요청 시간대 문제를 구분해 볼 수 있습니다.

### 7-5. Provider Supply Quality

생활서비스 중개 플랫폼은 고객 측 퍼널뿐 아니라 전문가 공급 측면도 함께 봐야 합니다.

- 견적 수와 거래율이 모두 높은 전문가: 우수 공급 파트너 후보
- 견적 수는 많지만 거래율이 낮은 전문가: 견적 품질, 가격, 프로필, 커뮤니케이션 점검 후보
- 견적 수는 적지만 거래율이 높은 전문가: 노출 확대 또는 공급 활성화 후보

---

## 8. Limitations

- 이 케이스는 synthetic dataset 기반 SQL 구조 연습이며, 실제 특정 회사의 내부 데이터를 분석한 결과가 아닙니다.
- 전환율 차이는 관찰적 지표이며, 인과관계로 단정하지 않습니다.
- 응답시간과 거래 성사율의 관계를 해석할 때는 카테고리, 지역, 가격대, 전문가 평점, 요청 시간대 등 추가 변수를 함께 고려해야 합니다.
- A/B 테스트 결과 집계는 SQL 구조 연습이며, 통계적 유의성 검정은 별도 분석이 필요합니다.
- 실제 서비스에서는 이벤트 정의, 중복 이벤트 처리, 봇/비정상 트래픽 제거, 유저 식별 기준, 요청 취소/환불 처리 기준이 추가로 필요합니다.

---

## 9. Portfolio Use

이 케이스는 실제 서비스 성과를 주장하기 위한 프로젝트가 아니라, Product Data Analyst 직무에서 자주 요구되는 서비스 퍼널, 전환율, 세그먼트, 리텐션, 양면시장 매칭 지표를 SQL로 정의하고 집계할 수 있음을 보여주는 보강 자료입니다.

기존 Olist SQL 분석이 주문·배송·리뷰 중심의 거래 데이터 분석이었다면, 이 케이스는 이벤트 로그와 요청·견적·거래 흐름을 가정한 서비스 Product Analytics SQL 구조를 보여줍니다.

---

## 10. Interview Talking Points

1. Olist 데이터에는 클릭·검색·요청 같은 이벤트 로그가 없기 때문에, Product Analytics형 SQL은 synthetic dataset으로 별도 연습했습니다.
2. 생활서비스 중개 플랫폼에서는 방문 수보다 요청서 작성, 견적 수신, 거래 성사로 이어지는 전환 구조가 중요하다고 보았습니다.
3. 요청과 견적은 1:N 관계가 생기므로, 견적을 request 단위로 먼저 집계한 뒤 요청 테이블과 결합해야 중복 집계를 줄일 수 있습니다.
4. 요청 -> 견적 수신율과 견적 -> 거래 전환율을 분리하면 공급 부족 문제와 거래 전환 문제를 구분할 수 있습니다.
5. 전문가 응답시간과 거래율의 관계는 실험 가설로 활용할 수 있지만, 인과관계로 단정하지 않고 카테고리·지역·가격대·전문가 평점 등 추가 변수를 함께 봐야 합니다.
