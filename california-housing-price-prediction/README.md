# 소득과 입지, 주거 구조로 캘리포니아 주택가격을 예측할 수 있는가

**작성자:** bolly0809-coder &nbsp;&nbsp;|&nbsp;&nbsp; **작성일:** 2026-09-02

![Python](https://img.shields.io/badge/Python-3.13.9-3776AB?logo=python&logoColor=white) ![pandas](https://img.shields.io/badge/pandas-150458?logo=pandas&logoColor=white) ![scikit-learn](https://img.shields.io/badge/scikit--learn-F7931E?logo=scikitlearn&logoColor=white) ![CatBoost](https://img.shields.io/badge/CatBoost-FFCC00) ![SHAP](https://img.shields.io/badge/SHAP-Explainable_AI-8957E5)

## 요약 (Executive Summary)

- **데이터:** [California Housing Prices](https://www.kaggle.com/datasets/camnugent/california-housing-prices)
- **규모:** 원본 20,640개 관측치 × 10개 변수 → 결측치 제거 후 20,433개 관측치
- **문제 유형:** 예측(회귀)

> 캘리포니아 인구조사 구역의 주택 중위가격(`median_house_value`)을 소득·입지·주거 구조 변수로 예측했다.
> 데이터 품질 점검과 EDA를 거쳐 비율형·공간 파생변수를 만들고, 로그 변환과 전처리 후 11개 회귀모형을 비교했다.
> 튜닝 후 **CatBoost를 선택하고, 중요도 기준으로 입력 변수를 9개에서 7개로 줄여 재학습**했다.
> 최종 평가 R²는 약 **0.785**, RMSE는 **0.2659**, 5-Fold CV RMSE는 **0.2651 ± 0.0016**이었다. RMSE는 로그 가격 척도이며 달러 단위가 아니다.
> SHAP 상위 변수는 **소득 대리변수(`income_per_person`), 해안권 구분(`ocean_area`), 위치 군집(`special_cluster`)**이었다.
> 소득과 입지가 모델 예측을 설명하는 주요 정보로 나타났지만, 훈련–CV 오차 격차 **15.66%**의 과대적합 경고가 남아 일반화 성능을 함께 점검해야 한다.

**상세 분석 노트북:** [California Housing 주택가격 예측 — 전체 분석과 실행 결과](california-housing-price-prediction.ipynb)

## 핵심 결과

| 항목 | 내용 |
|---|---|
| 최종 모형 | CatBoost 회귀모형 — 중요도 기준으로 선택한 7개 변수 사용 |
| 예측 성능 | 평가 R² ≈ 0.785 / RMSE = 0.2659 / MAE ≈ 0.194 — 로그 가격 척도에서 평가 |
| 검증 구성 | 훈련 16,346행 / 평가 4,087행, `random_state=3217` / 5-Fold CV RMSE = 0.2651 ± 0.0016 |
| 최종 입력 변수 | `income_per_person`, `ocean_area`, `special_cluster`, `housing_median_age`, `bedrooms_per_room`, `rooms_per_person`, `rooms_per_household` |
| 주요 설명 변수 | mean\|SHAP\| 기준: 소득 대리변수 0.2283 · 해안권 구분 0.1820 · 위치 군집 0.1292 — 200행 설명 표본 |
| 일반화 진단 | 훈련 RMSE = 0.2236 / 훈련–CV 격차 15.66% — 도우미 함수의 경험적 15% 기준에서 과대적합 경고 |
| 이번에 연습한 기법 | 단변량·이변량·다변량 EDA, 비율형·공간 파생변수, 로그 변환, VIF, 회귀모형 비교, GridSearchCV, 중요도 기반 변수 선택, 학습곡선, SHAP |

## 참고자료

### 데이터 출처

- 공개 데이터셋: [California Housing Prices — Kaggle](https://www.kaggle.com/datasets/camnugent/california-housing-prices)
- 데이터 배경: 1990년 미국 인구조사 기반의 캘리포니아 지역 자료. 관측 단위는 **인구조사 구역**이며 개별 주택이 아니다.
- 실제 로딩 경로: `jussam.load_data()`의 `california_housing` 및 전처리 단계별 데이터셋.
- 모델링·최종 평가 단계는 `california_housing_feature_log_labelled`를 불러온다. **전처리 단계에서 저장한 엑셀을 모델링 단계가 자동으로 이어 읽는 방식은 아니다.**
- 전체 데이터 엑셀과 모델 바이너리는 저장소에 포함하지 않는다.

### 분석 자료와 실행 환경

- 공개 파일: 이 README와 단일 분석 노트북. 코드·표·그래프·해석은 노트북에 함께 수록한다.
- 데이터 품질 점검 → EDA → 전처리 → 모델링 → 최종 진단·해석 순서로 구성했다.
- 각 단계에서 실행·저장한 결과를 통합했으며, 코드와 출력은 보존했다. 실행 번호는 단계별 기록이며 통합 파일의 전체 재실행 기록은 아니다.
- 저장된 결과의 열람에는 별도 파일이 필요하지 않다. **재실행에는 Python 3.13, 별도로 보유한 `helpers`, `jussam` 및 관련 분석 패키지가 필요하다.** 이 저장소만으로 실행 환경이 완결되지는 않는다.
- `helpers`, 별도 그래프 파일, 전체 데이터, 학습 모델, 환경 파일은 공개 프로젝트에 포함하지 않는다.

## 회고

- **이번 분석에서 정리한 기법:** 방·침실·인구·가구 수의 총량을 비율형 변수로 바꾸어 규모와 주거 구조를 구분하고, 예측 성능뿐 아니라 학습곡선·변수 중요도·SHAP을 함께 확인했다. 중요도 기준으로 9개 변수 중 7개를 남겼지만, 변수 축소가 큰 성능 향상을 만들었다고 해석하지 않았다.
- **점검한 지점과 해석 방법:**
  - ① 로그 가격의 RMSE를 달러 단위 오차로 읽지 않도록 평가 척도를 명시했다. 원본 가격 단위의 오차는 이번 결과만으로 제시하지 않는다.
  - ② 최종 재학습 결과에 맞춰 선택 변수와 SHAP 설명을 대조했다. `rooms_per_person`은 포함되고 `population_per_household`는 제외되었다.
  - ③ mean\|SHAP\|은 예측에 대한 평균 절대 기여도다. 이를 지수화해 대칭적인 가격 상승·하락률로 바꾸거나, 변수 중요도를 인과효과로 해석하지 않았다.
- **다음 분석에서 보완할 점:**
  - 훈련–CV 격차 15.66%는 과적합 점검 신호다. 여러 모형의 평가셋 비교와 별개로 독립적인 최종 홀드아웃 및 공간 분할 검증이 필요하다.
  - 공간분석에서 사용한 `EPSG:5186`은 한국용 좌표계이므로 캘리포니아 적용을 재검토해야 한다. Queen/Rook의 이웃 정의도 검증하기 전에는 해당 Moran's I 결과를 확정적 근거로 삼지 않는다.
  - 실루엣 최댓값은 `k=2`지만 후속 분석에서는 `k=5`를 사용했다. 군집 수 선택 근거를 보완해야 한다.
  - SHAP은 200행 표본에 대한 설명이고 자료는 1990년의 구역 집계 데이터다. 현재의 개별 주택 감정가격이나 정책 개입 효과로 일반화하지 않는다.
