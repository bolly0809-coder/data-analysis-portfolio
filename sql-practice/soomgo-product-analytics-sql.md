# Soomgo Product Analytics SQL Practice

> 숨고(Product Data Analyst) 지원을 위해 라이프서비스 중개 플랫폼의 핵심 퍼널과 전환 지표를 SQL로 정의·집계하는 연습 자료입니다.

## 1. Purpose

숨고와 같은 라이프서비스 중개 플랫폼에서는 사용자가 서비스를 탐색한 뒤 요청서를 작성하고, 전문가의 견적을 받은 후 실제 거래로 이어지는 과정의 전환율을 이해하는 것이 중요합니다.

이 문서는 실제 숨고 내부 데이터가 아니라, Product Data Analyst 직무에서 요구되는 이벤트 로그 기반 분석 구조를 보여주기 위한 synthetic dataset SQL 연습입니다.

기존 `sql-practice`의 Product Analytics SQL을 숨고 지원 관점에 맞춰 다음 질문 중심으로 재정리했습니다.

- 방문자는 어느 단계에서 가장 많이 이탈하는가?
- 요청서를 작성한 사용자 중 실제 거래까지 이어지는 비율은 얼마인가?
- 카테고리별 요청→견적→거래 전환율은 어떻게 다른가?
- 전문가 응답 시간이 거래 성사율과 어떤 관계를 갖는가?
- 유입 채널·디바이스·지역별 전환율 차이는 어디서 나타나는가?
- 신규 사용자는 가입 후 몇 개월까지 다시 서비스를 이용하는가?

---

## 2. Assumed Data Structure

실제 회사 데이터가 아닌 연습용 구조입니다.

| table | grain | purpose |
|---|---|---|
| `users` | user 1 row | 가입일, 지역, 유입 채널, 디바이스 정보 |
| `service_events` | event 1 row | 방문, 검색, 상세조회, 요청작성, 견적확인, 거래, 리뷰작성 이벤트 로그 |
| `requests` | request 1 row | 고객이 남긴 서비스 요청서 |
| `quotes` | quote 1 row | 전문가가 요청서에 보낸 견적 |
| `transactions` | transaction 1 row | 실제 거래 성사 내역 |
| `reviews` | review 1 row | 거래 후 리뷰 작성 내역 |
| `categories` | category 1 row | 서비스 카테고리 정보 |

---

## 3. Key SQL Files

| file | analysis question | product analytics meaning |
|---|---|---|
| `16_local_service_marketplace_funnel.sql` | 방문→검색→상세조회→요청→견적확인→거래→리뷰작성 단계별 전환율은? | 전체 서비스 퍼널에서 가장 큰 이탈 구간 파악 |
| `17_request_quote_transaction_conversion.sql` | 카테고리별 요청→견적→거래 전환율은? | 카테고리별 수요·공급 매칭 품질 비교 |
| `18_response_time_transaction_rate.sql` | 전문가 첫 응답 시간이 거래 성사율과 어떤 관계가 있는가? | 공급자 응답 속도 개선이 거래 전환에 미치는 영향 가설 확인 |
| `09_service_funnel_conversion.sql` | 서비스 퍼널 단계별 전환율은? | Product Analytics 기본 퍼널 구조 |
| `10_category_conversion.sql` | 카테고리별 요청→거래 전환율은? | 서비스 카테고리별 성과 비교 |
| `11_cohort_retention.sql` | 가입 월별 M0~M3 리텐션은? | 신규 사용자의 재방문·재이용 구조 확인 |
| `14_ab_test_result_aggregation.sql` | A/B 그룹별 전환율은? | 실험 결과 집계 구조 연습 |
| `15_user_segment_analysis.sql` | 유입 채널·디바이스별 전환율은? | 세그먼트별 성과 차이 확인 |

---

## 4. Core Metrics

### Funnel Metrics

- Visit → Search Conversion Rate
- Search → Provider Detail View Conversion Rate
- Detail View → Request Creation Conversion Rate
- Request → Quote Received Conversion Rate
- Quote Received → Transaction Conversion Rate
- Transaction → Review Written Conversion Rate

### Marketplace Matching Metrics

- Request Count
- Quoted Request Count
- Quote Receive Rate
- Average Quotes per Request
- Transaction Count
- Request-to-Transaction Conversion Rate
- Quote-to-Transaction Conversion Rate

### Provider Response Metrics

- First Response Time
- Response Time Bucket
- Transaction Rate by Response Time Bucket
- Average Quotes per Request by Response Time Bucket

### Retention / Segment Metrics

- Signup Cohort Retention
- M0~M3 Active Rate
- Conversion Rate by Acquisition Channel
- Conversion Rate by Device
- Conversion Rate by Region

---

## 5. Example Interpretation

분석 결과는 단순 수치 나열이 아니라 제품 개선 질문으로 연결합니다.

- 요청서 작성 전 이탈이 크다면, 검색 결과 품질·전문가 상세 페이지 정보·가격 기대치 문제를 확인해야 합니다.
- 요청 후 견적 수신율이 낮다면, 해당 카테고리의 전문가 공급 부족 또는 요청서 품질 문제를 검토해야 합니다.
- 견적은 받지만 거래 전환율이 낮다면, 가격·응답 속도·전문가 신뢰 정보·리뷰 노출 방식이 원인일 수 있습니다.
- 응답 시간이 짧은 요청의 거래율이 높다면, 전문가 첫 응답 속도를 높이는 알림·추천·노출 정책을 실험할 수 있습니다.
- 특정 유입 채널의 요청 전환율은 높지만 거래 전환율이 낮다면, 유입 품질이나 기대치 불일치를 점검해야 합니다.

---

## 6. Limitations

- 실제 숨고 내부 데이터가 아니라 synthetic dataset을 가정한 SQL 구조입니다.
- 전환율 차이를 확인하더라도 인과관계로 단정하지 않습니다.
- 응답 시간이 거래 성사에 영향을 줄 가능성은 있지만, 가격, 전문가 평점, 카테고리 특성, 지역 수급, 고객 예산 등 다른 요인의 영향을 함께 고려해야 합니다.
- A/B 테스트 SQL은 결과 집계 구조를 보여주는 예시이며, 통계적 유의성 검정은 별도 분석이 필요합니다.

---

## 7. Resume Bullet

```text
Product Analytics SQL Practice | 개인 SQL 보강 자료 | 2026.06
- 라이프서비스 중개 플랫폼을 가정한 synthetic dataset으로 방문→검색→상세조회→요청→견적→거래→리뷰 작성 퍼널 전환율을 SQL로 집계
- 카테고리별 요청→견적→거래 전환율과 전문가 첫 응답 시간대별 거래 성사율을 분석하는 쿼리 작성
- Product Data Analyst 직무에서 요구되는 퍼널, 전환율, 코호트 리텐션, 세그먼트 분석 구조를 SQL로 정리
```

---

## 8. Cover Letter Sentence

```text
숨고와 같은 라이프서비스 플랫폼에서는 사용자가 서비스를 탐색하고 요청서를 작성한 뒤 실제 거래로 이어지는 과정의 전환율을 이해하는 것이 중요하다고 생각했습니다. 이를 보완하기 위해 synthetic dataset을 활용해 방문→검색→상세조회→요청→견적→거래 단계별 퍼널 전환율, 카테고리별 요청→거래 전환율, 전문가 응답시간별 거래 성사율을 SQL로 분석하는 연습 자료를 별도로 정리했습니다.
```
