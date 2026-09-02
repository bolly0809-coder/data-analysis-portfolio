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

**상세 분석 노트북:** [01. 개요·품질 점검](notebooks/01_프로젝트_개요와_데이터_품질.ipynb) · [02. EDA](notebooks/02_탐색적_데이터_분석.ipynb) · [03. 전처리](notebooks/03_분석용_데이터_전처리.ipynb) · [04. 모델링·튜닝](notebooks/04_회귀모델링과_하이퍼파라미터_튜닝.ipynb) · [05. 진단·해석](notebooks/05_최종모델_평가와_SHAP.ipynb)

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
- 04·05번은 `california_housing_feature_log_labelled`를 불러온다. **03번에서 저장한 엑셀을 04번이 자동으로 이어 읽는 방식은 아니다.**
- 전체 데이터 엑셀과 모델 바이너리는 저장소에 포함하지 않는다.

### 분석 자료와 실행 환경

- 코드·실행 결과·해석: 위의 01~05번 노트북에 순서대로 수록.
- 공통 분석 모듈: [`helpers`](notebooks/helpers/) / 실행 패키지: [`requirements.txt`](requirements.txt)
- 대표 결과: [변수 중요도](assets/feature_importance.png) · [학습곡선](assets/learning_curve.png) · [SHAP 요약](assets/shap_summary.png)
- 동봉 폰트: Noto Sans KR — [SIL Open Font License](notebooks/helpers/fonts/OFL.txt)

<details>
<summary>실행 방법</summary>

Python 3.13 환경에서 프로젝트 폴더를 기준으로 실행한다.

```bash
python -m pip install -r requirements.txt
cd notebooks
jupyter lab
```

01~05번을 순서대로 실행한다. `helpers`는 노트북과 같은 폴더에 있다. 04번은 `ml_models/<실행시각>`와 `<실행시각>_tuned`에 모델을 저장하고, 05번은 최신 튜닝 폴더를 읽어 `<실행시각>_importance`에 최종 모델을 저장한다. CatBoost 튜닝과 학습곡선 계산에는 시간이 걸릴 수 있다.

</details>

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
