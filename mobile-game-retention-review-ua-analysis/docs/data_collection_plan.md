
# Google Play 게임 앱/리뷰 데이터 수집 요약

## 수집 목적
모바일 게임 앱마켓에서 관찰 가능한 유저 경험 신호를 분석하기 위해 Google Play의 게임 앱 메타데이터와 최신 리뷰를 수집했다.

## 수집 기준
- 국가: us
- 언어: en
- 목표 앱 수: 100
- 앱별 목표 리뷰 수: 100

## 수집 결과
- 수집 앱 ID 수: 100
- 유효 앱 수: 100
- 수집 리뷰 수: 9761
- 리뷰가 수집된 앱 수: 99

## 수집 컬럼

### 앱 메타데이터
- app_id
- title
- developer
- genre
- score
- ratings_count
- reviews_count
- installs
- free
- contains_ads
- in_app_purchase
- updated
- content_rating

### 리뷰 데이터
- app_id
- title
- review_id
- review_text
- review_score
- review_date
- thumbs_up_count
- review_created_version

## 해석 범위
이 데이터는 앱마켓에서 관찰 가능한 리뷰와 메타데이터 기반 유저 경험 신호를 분석하기 위한 데이터다.
개별 리뷰를 특정 UA 캠페인, 광고 채널, 유저 획득 비용과 직접 연결하지 않는다.
캠페인 KPI/ROAS 분석과는 독립 파트로 해석하며, 최종 종합 인사이트에서만 논리적으로 연결한다.
