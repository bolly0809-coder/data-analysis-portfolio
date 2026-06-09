# 모바일 게임 리텐션·리뷰·UA 성과 분석

> Cookie Cats A/B 테스트, Google Play 게임 리뷰 수집, 보조 캠페인 데이터를 활용해  
> 모바일 게임의 리텐션, 유저 경험 신호, UA 성과 판단 구조를 분석한 포트폴리오 프로젝트

---

## 1. Project Overview

이 프로젝트는 모바일 게임 데이터 분석 / 게임 마케팅 데이터 분석 / UA(User Acquisition) 성과 분석 직무 지원을 위해 수행한 개인 포트폴리오 프로젝트입니다.

모바일 게임 성과는 단순히 설치 수나 CPI만으로 판단하기 어렵습니다.  
유입된 유저가 게임에 남는지, 광고 경험에 불만을 느끼는지, 캠페인별 유저 품질과 수익성이 어떻게 다른지를 함께 확인해야 합니다.

본 프로젝트는 이 관점에서 아래 세 가지 분석을 독립적으로 수행했습니다.

1. **Cookie Cats A/B 테스트 리텐션 분석**
   - 공개 모바일 게임 A/B 테스트 데이터 기반
   - gate 위치 변경이 D1/D7 Retention에 미친 영향 검정

2. **Google Play 게임 리뷰 신호 분석**
   - Google Play 게임 앱 메타데이터와 리뷰 직접 수집
   - 광고 불만, 오류, 반복성, 과금, 재미/긍정 등 리뷰 신호 분석

3. **보조 캠페인 데이터 기반 UA KPI·ROAS·ML 분석**
   - 모바일 게임 UA 성과 분석 구조를 재현하기 위한 보조 캠페인 데이터 구성
   - CTR, CVR, CPI, D7 Retention, D7 ROAS, Campaign Performance Score 분석
   - 초기 KPI 기반 D7 ROAS 예측 모델과 예측 오차 분석

서로 다른 출처와 기준 단위를 가진 데이터를 무리하게 결합하지 않고, 각 분석을 독립적으로 수행한 뒤 최종 인사이트에서만 모바일 게임 UA 성과 판단에 필요한 시사점으로 연결했습니다.

---

## 2. Key Questions

1. 게임 내 gate 위치 변경은 단기/중기 리텐션에 어떤 영향을 주는가?
2. Google Play 리뷰에서 광고 불만, 오류, 반복성 같은 유저 경험 리스크는 어떻게 나타나는가?
3. 광고 불만 리뷰는 리뷰 점수 하락과 연결되는가?
4. UA 캠페인은 CPI만으로 판단해도 되는가?
5. 초기 KPI를 활용해 D7 ROAS를 어느 정도 예측할 수 있는가?
6. 예측 오차가 큰 채널, 국가, 소재 유형은 어디인가?

---

## 3. Data

### 3-1. Cookie Cats A/B Test Data

- Source: Kaggle Cookie Cats A/B Testing Dataset
- Unit: User
- Main columns:
  - `userid`
  - `version`
  - `sum_gamerounds`
  - `retention_1`
  - `retention_7`

분석 목적은 `gate_30`과 `gate_40` 그룹의 D1/D7 Retention 차이를 검정하는 것입니다.

### 3-2. Google Play App & Review Data

- Source: Google Play
- Collection method: `google-play-scraper`
- Collected apps: 100
- Collected reviews: 9,761
- Review language/country: English / US 기준

주요 수집 정보:

- App metadata: app id, title, developer, genre, score, ratings count, installs, contains ads, in-app purchase 여부
- Review data: review text, review score, review date, thumbs up count, app id / title

### 3-3. Campaign Support Data

이 파트는 실제 기업 광고 데이터가 아니라, 모바일 게임 UA 성과 분석 구조를 재현하기 위해 구성한 보조 데이터입니다.

- Period: 60 days
- Campaigns: 40
- Rows: 2,400
- Channels: Meta, Google Ads, TikTok, Unity Ads, AppLovin
- Countries: US, KR, JP, BR, IN
- Creative types: video, playable, static

주요 지표:

- spend
- impressions
- clicks
- installs
- CTR
- CVR
- CPI
- tutorial completion rate
- D1 Retention
- D7 Retention
- ARPU D1
- ARPU D7
- D7 Revenue
- D7 ROAS

---

## 4. Project Structure

```text
mobile-game-retention-review-ua-analysis/
├─ README.md
├─ requirements.txt
├─ data/
│  ├─ raw/
│  ├─ collected/
│  └─ processed/
├─ notebooks/
│  ├─ 01_cookie_cats_ab_test_analysis.ipynb
│  ├─ 02_google_play_app_review_collection.ipynb
│  ├─ 03_google_play_review_signal_analysis.ipynb
│  ├─ 04_campaign_kpi_roas_ml_analysis.ipynb
│  └─ 05_final_insight_summary.ipynb
├─ sql/
│  ├─ 01_campaign_daily_kpi.sql
│  ├─ 02_channel_cpi_cvr.sql
│  ├─ 03_campaign_roas_d7.sql
│  ├─ 04_campaign_score_base_table.sql
│  └─ 05_modeling_base_table.sql
├─ outputs/
│  ├─ tables/
│  └─ figures/
└─ docs/
   ├─ ab_test_interpretation.md
   ├─ google_play_review_signal_analysis.md
   ├─ review_signal_dictionary.md
   ├─ campaign_score_logic.md
   ├─ prediction_error_analysis.md
   ├─ campaign_support_data_analysis.md
   └─ final_insights.md
```

---

## 5. Analysis Process

## Part 1. Cookie Cats A/B Test Retention Analysis

### Purpose

Cookie Cats 게임의 gate 위치를 level 30에서 level 40으로 변경했을 때, 유저 리텐션이 개선되는지 확인했습니다.

### Process

1. 데이터 로드 및 구조 확인
2. 실험군/대조군 유저 수 확인
3. D1 Retention, D7 Retention 계산
4. proportion z-test 수행
5. bootstrap 기반 retention difference 분포 확인
6. 결과 해석 및 문서화

### Key Result

| Metric | gate_30 | gate_40 | Difference | p-value | Interpretation |
|---|---:|---:|---:|---:|---|
| D1 Retention | 44.82% | 44.23% | -0.59%p | 0.074 | 5% 유의수준에서 명확한 차이 없음 |
| D7 Retention | 19.02% | 18.20% | -0.82%p | 0.0016 | gate_40의 D7 Retention이 유의하게 낮음 |

### Interpretation

gate 위치를 level 30에서 level 40으로 늦춘 실험안은 D1 Retention에서는 명확한 개선을 보이지 않았고, D7 Retention에서는 오히려 유의하게 낮은 결과를 보였습니다.

따라서 해당 실험안은 단기 지표만으로 적용 여부를 판단하기 어렵고, D7 Retention 기준으로는 적용에 신중해야 한다고 해석했습니다.

---

## Part 2. Google Play Review Signal Analysis

### Purpose

Google Play 게임 앱 리뷰에서 광고 불만, 오류, 반복성, 과금, 난이도, 보상, 재미/긍정 신호를 추출하고, 각 신호가 리뷰 점수와 어떤 관계를 보이는지 분석했습니다.

### Review Signal Categories

| Signal Category | Meaning |
|---|---|
| ad_complaint | 광고 불만 |
| reward | 보상/리워드 |
| difficulty | 난이도 |
| repetition_boredom | 반복성/지루함 |
| bug_performance | 오류/성능 |
| payment_iap | 과금/IAP |
| positive_fun | 재미/긍정 |

### Key Result

| Item | Result |
|---|---:|
| Collected apps | 100 |
| Collected reviews | 9,761 |
| Reviews with ad complaint | 896 |
| Ad complaint review rate | 9.18% |
| Avg score of ad complaint reviews | 2.58 |
| Avg score of non-ad complaint reviews | 4.21 |
| Reviews with at least one risk signal | 18.82% |

### Interpretation

Google Play 리뷰 9,761건을 분석한 결과, 광고 불만 키워드가 포함된 리뷰는 전체의 9.18%였고 평균 점수는 2.58점이었습니다. 광고 불만이 없는 리뷰 평균 점수는 4.21점이었습니다.

이는 광고 수익형 게임에서 광고 노출 방식이 유저 경험 리스크로 이어질 수 있음을 시사합니다.

단, 이 리뷰 데이터는 앱마켓 리뷰 데이터이므로 특정 UA 캠페인과 직접 연결하지 않았습니다. 앱 단위에서 관찰 가능한 유저 경험 리스크 신호로 제한해 해석했습니다.

---

## Part 3. Campaign KPI / ROAS / ML Analysis

### Purpose

보조 캠페인 데이터를 활용해 모바일 게임 UA 성과 분석 구조를 재현했습니다.  
CPI, CVR, D7 Retention, D7 ROAS를 함께 분석하고, Campaign Performance Score와 D7 ROAS 예측 모델을 구성했습니다.

### SQL KPI Analysis

작성한 SQL 파일:

| SQL File | Purpose |
|---|---|
| `01_campaign_daily_kpi.sql` | 일자·캠페인별 CTR, CVR, CPI, D7 ROAS 계산 |
| `02_channel_cpi_cvr.sql` | 채널별 CPI, CVR, D7 ROAS 비교 |
| `03_campaign_roas_d7.sql` | 캠페인별 D7 ROAS 집계 |
| `04_campaign_score_base_table.sql` | Campaign Score 산출용 base table 생성 |
| `05_modeling_base_table.sql` | D7 ROAS 예측 모델용 데이터셋 생성 |

### Channel Result

| Channel | D7 ROAS | D7 Retention | Interpretation |
|---|---:|---:|---|
| Unity Ads | 0.0646 | 0.1772 | 고품질 유저 확보 채널 |
| Google Ads | 0.0573 | 0.1583 | 안정적 성과 |
| AppLovin | 0.0546 | 0.1567 | 준수한 성과 |
| Meta | 0.0492 | 0.1479 | 평균권 |
| TikTok | 0.0355 | 0.1147 | 저렴한 유입 대비 품질 낮음 |

### Campaign Performance Score

Campaign Performance Score는 아래 지표를 표준화한 뒤 가중합으로 산출했습니다.

| Component | Weight | Meaning |
|---|---:|---|
| CPI Score | 0.25 | CPI가 낮을수록 높은 점수 |
| CVR Score | 0.20 | 클릭 대비 설치 전환율 |
| D7 Retention Score | 0.25 | 7일 잔존율 |
| D7 ROAS Score | 0.25 | 광고비 대비 7일 수익성 |
| Tutorial Completion Score | 0.05 | 초기 온보딩 완료율 |

예산 액션 기준:

| Score Range | Action |
|---|---|
| 75 이상 | Scale |
| 55 이상 75 미만 | Maintain |
| 35 이상 55 미만 | Review |
| 35 미만 | Reduce |

### Budget Action Result

| Action | Campaign Count | Avg Score | Avg D7 ROAS |
|---|---:|---:|---:|
| Scale | 3 | 80.4 | 0.0757 |
| Maintain | 12 | 66.5 | 0.0637 |
| Review | 15 | 46.1 | 0.0488 |
| Reduce | 10 | 29.5 | 0.0369 |

### D7 ROAS Prediction Model

초기 캠페인 KPI를 활용해 D7 ROAS 예측 모델을 구성했습니다.

사용 피처:

- channel
- country
- creative_type
- spend
- impressions
- clicks
- installs
- CTR
- CVR
- CPI
- tutorial completion rate
- D1 Retention
- ARPU D1
- D1 Revenue

제외한 피처:

- D7 Retention
- D7 Revenue
- D7 ROAS

해당 변수들은 D7 이후 확인 가능한 사후 정보 또는 타겟과 직접 연결되는 정보이므로 모델 피처에서 제외했습니다.

### Model Result

| Model | MAE | RMSE | R² |
|---|---:|---:|---:|
| Linear Regression | 0.0097 | 0.0135 | 0.538 |
| Random Forest | 0.0102 | 0.0140 | 0.505 |

### Interpretation

초기 KPI 기반으로 D7 ROAS를 어느 정도 예측할 수 있었지만, 모델 성능을 과장하지 않았습니다.  
분석의 초점은 예측 모델 자체보다, 실제값과 예측값의 오차가 큰 채널·국가·소재 유형을 확인해 Feature Engineering 개선 방향을 도출하는 데 두었습니다.

---

## 6. Final Insights

### Insight 1. 모바일 게임 실험은 단기 반응보다 리텐션 기준으로 판단해야 한다.

Cookie Cats A/B 테스트에서 D1 Retention은 명확한 차이를 보이지 않았지만, D7 Retention에서는 실험군이 유의하게 낮았습니다.  
이는 게임 실험의 적용 여부를 판단할 때 D1 같은 단기 지표뿐 아니라 D7 Retention처럼 더 긴 잔존 지표를 함께 확인해야 함을 보여줍니다.

### Insight 2. 광고 경험은 앱마켓 리뷰에서 명확한 불만 신호로 나타날 수 있다.

Google Play 리뷰 분석에서 광고 불만 키워드가 포함된 리뷰는 평균 점수가 낮게 나타났습니다.  
광고 수익형 게임에서는 광고 노출 방식이 유저 경험과 만족도에 영향을 줄 수 있으므로, 광고 수익성과 유저 경험 리스크를 함께 고려해야 합니다.

### Insight 3. UA 캠페인은 CPI만으로 판단하면 안 된다.

보조 캠페인 분석에서는 낮은 CPI가 반드시 높은 D7 ROAS로 이어지지 않았습니다.  
따라서 캠페인 성과는 CPI, CVR, D7 Retention, D7 ROAS를 함께 고려해야 합니다.

### Insight 4. 예측 모델은 성능보다 오차 원인 분석까지 연결해야 한다.

D7 ROAS 예측 모델은 초기 KPI 기반으로 단기 성과를 예측하는 구조를 보여줬습니다.  
그러나 실제 실무에서는 예측 성능 자체보다 예측이 빗나가는 세그먼트를 분석하는 것이 중요합니다.  
채널·국가·소재 유형별 오차 분석은 Feature Engineering 개선과 캠페인 운영 전략으로 이어질 수 있습니다.

---

## 7. Visualizations

주요 시각화는 `outputs/figures/` 폴더에 저장했습니다.

### A/B Test

- `cookie_cats_retention_by_group.png`
- `cookie_cats_gamerounds_distribution.png`
- `cookie_cats_bootstrap_retention_1_diff.png`
- `cookie_cats_bootstrap_retention_7_diff.png`

### Review Signal Analysis

- `google_play_review_signal_count.png`
- `google_play_review_signal_score_diff.png`
- `google_play_ad_complaint_vs_score.png`
- `google_play_top_review_risk_apps.png`

### Campaign Analysis

- `campaign_score_distribution.png`
- `campaign_budget_priority_matrix.png`
- `d7_roas_actual_vs_predicted.png`
- `d7_roas_error_by_channel.png`

---

## 8. Limitations

| Limitation | Explanation | Improvement |
|---|---|---|
| 데이터 간 직접 결합 없음 | A/B 테스트, 리뷰, 캠페인 데이터는 출처와 기준 단위가 달라 JOIN하지 않음 | 실제 게임사 내부 데이터 확보 시 유저·캠페인·리뷰·수익 로그 연결 가능 |
| 리뷰 분석 대표성 한계 | Google Play 최신 리뷰 표본 기반 분석이며 전체 유저를 대표하지 않음 | 기간 확장, 국가별 리뷰 비교, 토픽 모델링/감성분석 고도화 |
| 캠페인 데이터의 보조성 | 실제 광고 데이터가 아니라 UA 분석 구조를 재현하기 위한 보조 데이터 | 실제 광고 집행 데이터 확보 시 ROAS, LTV, Incrementality 분석 가능 |
| ML 모델의 제한 | D7 ROAS 예측은 보조 데이터 기반이며 실제 운영 모델이 아님 | 실제 캠페인 로그 기반 D30 LTV 예측, calibration, 세그먼트별 모델 비교 |
| Incrementality 제한 | Cookie Cats A/B 테스트는 retention 실험이며 광고 채널 incremental lift 실험은 아님 | holdout/geo experiment 기반 광고 기여도 평가로 확장 |

---

## 9. Skills Demonstrated

| Area | Evidence |
|---|---|
| A/B Test Analysis | retention difference, proportion z-test, bootstrap |
| Python / pandas | 데이터 로드, 전처리, 파생변수 생성, 그룹 집계 |
| Review Text Analysis | 사전 기반 키워드 매칭, 리뷰 신호 분류, 앱별 리스크 점수 |
| SQL | CTR, CVR, CPI, D7 ROAS 산출 쿼리 작성 |
| Campaign KPI Analysis | 채널별 CPI, Retention, ROAS 비교 |
| Metric Design | Campaign Performance Score 설계 |
| Machine Learning | D7 ROAS 예측 모델, 예측 오차 분석 |
| Business Interpretation | UA 성과 판단, 예산 액션 후보, Feature Engineering 개선 방향 |

---

## 10. Portfolio Message

이 프로젝트는 실제 기업 내부 광고 데이터를 사용한 프로젝트가 아닙니다.  
대신 실제 공개 A/B 테스트 데이터, 직접 수집한 앱마켓 리뷰 데이터, 보조 캠페인 데이터를 명확히 분리해 분석했습니다.

핵심은 데이터를 억지로 결합하는 것이 아니라, 모바일 게임 성과 판단에서 필요한 리텐션, 유저 경험 신호, UA KPI, ROAS, 예측 오차 분석의 사고 흐름을 보여주는 것입니다.

---

## 11. Resume Bullet

```text
모바일 게임 리텐션·리뷰·UA 성과 분석 | 개인 미니 프로젝트
- Cookie Cats 공개 A/B 테스트 데이터를 활용해 gate 위치 변경에 따른 D1·D7 Retention 차이를 검정하고, D7 Retention에서 실험군이 유의하게 낮아졌음을 확인
- Google Play 게임 앱 100개와 리뷰 9,761건을 수집해 광고 불만, 오류, 반복성, 과금, 재미/긍정 등 리뷰 신호를 사전 기반으로 분류
- 광고 불만 리뷰의 평균 점수가 비광고 불만 리뷰보다 낮게 나타나는 것을 확인해 광고 수익형 게임의 유저 경험 리스크를 분석
- 보조 캠페인 데이터 2,400행을 구성해 SQL/Python 기반으로 CTR, CVR, CPI, D7 Retention, D7 ROAS를 산출하고, Campaign Performance Score로 예산 액션 후보를 분류
- 초기 KPI 기반 D7 ROAS 예측 모델을 구축하고, 예측 오차를 채널·국가·소재 유형별로 분석해 Feature Engineering 개선 방향 제시
```

---

## 12. Notes on Data Disclosure

- Cookie Cats 데이터는 공개 데이터셋입니다.
- Google Play 리뷰 데이터는 수집 시점 기준 공개 앱마켓 리뷰 일부입니다.
- Campaign Support Data는 실제 기업 광고 데이터가 아니라 분석 구조 재현을 위한 보조 데이터입니다.
- 대용량 DB 파일(`*.db`)은 GitHub 업로드 대상에서 제외합니다.
