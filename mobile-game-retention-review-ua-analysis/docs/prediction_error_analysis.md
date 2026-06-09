
# D7 ROAS Prediction Error Analysis

## 분석 목적
초기 캠페인 성과 지표를 활용해 D7 ROAS를 예측하고, 실제값과 예측값의 오차가 큰 세그먼트를 확인했다.

## 사용 피처
- channel
- country
- creative_type
- spend
- impressions
- clicks
- installs
- ctr
- cvr
- cpi
- tutorial_completion_rate
- d1_retention
- arpu_d1
- d1_revenue

## 제외한 피처
- d7_retention
- d7_revenue
- d7_roas

위 변수들은 D7 이후 확인 가능한 사후 정보 또는 타겟과 직접 연결되는 정보이므로 모델 피처에서 제외했다.

## 모델 결과
| model             |        mae |      rmse |       r2 |
|:------------------|-----------:|----------:|---------:|
| Linear Regression | 0.00972726 | 0.0135417 | 0.538336 |
| Random Forest     | 0.0102327  | 0.014021  | 0.505077 |

## 해석 원칙
모델 성능 자체를 과장하지 않고, 예측 오차가 큰 채널·국가·소재 유형을 확인하는 데 초점을 두었다.
이 분석은 슈퍼센트 공고에서 요구하는 ML 예측 모델의 오차 원인 분석과 Feature Engineering 사고를 보여주기 위한 보조 분석이다.

## 주의
이 파트는 실제 기업 내부 광고 데이터가 아니라, 모바일 게임 UA 성과 분석 구조를 재현하기 위해 구성한 보조 캠페인 데이터 기반 분석이다.
실제 A/B 테스트 분석 및 Google Play 리뷰 분석 파트와는 데이터 레벨에서 결합하지 않는다.
