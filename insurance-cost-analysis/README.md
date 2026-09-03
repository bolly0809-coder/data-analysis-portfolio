# 의료보험 청구비용은 어떤 특성과 관련되는가

**작성자:** bolly0809-coder &nbsp;&nbsp;|&nbsp;&nbsp; **결과 점검일:** 2026-09-03

![Python](https://img.shields.io/badge/Python-3.13-3776AB?logo=python&logoColor=white) ![pandas](https://img.shields.io/badge/pandas-150458?logo=pandas&logoColor=white) ![statsmodels](https://img.shields.io/badge/statsmodels-4051B5) ![scikit-learn](https://img.shields.io/badge/scikit--learn-F7931E?logo=scikitlearn&logoColor=white)

## 요약 (Executive Summary)

- **데이터:** [Medical Cost Personal Datasets — Kaggle](https://www.kaggle.com/datasets/mirichoi0218/insurance)
- **규모:** 원본 1,338행 × 7열 → 완전 중복 1행 제거 후 1,337행, 결측치 없음
- **문제 유형:** 의료보험 청구비용의 관련 요인 탐색 및 선형회귀 모형 비교

나이·BMI·부양 자녀 수·흡연 여부 등과 청구비용의 관계를 분석했다. 품질 점검과 EDA 후 기준선에 로그변환·IQR 이상치 대체·VIF·표준화를 누적한 다섯 모형을 같은 원본 금액 단위에서 비교했다.

최종 선택은 **0_기준선**이었다. 독립변수 4개로 원본 척도 R² **0.750**, RMSE **6,058.642달러**, MAE **4,181.335달러**를 기록했다. 로그변환은 비용 분포의 비대칭을 완화했지만 달러 단위 오차를 개선하지 못했다. 흡연 여부가 가장 큰 절댓값의 표준화 계수를 보였으며 나이·BMI·자녀 수도 유의했다.

**모든 성능은 적합에 사용한 표본 내 결과다.** 새 고객에 대한 검증 성능이나 인과효과로 해석하지 않는다. `charges`는 납입 보험료가 아니라 의료보험 청구비용이다.

**상세 분석:** [단일 노트북 — 코드·실행 결과·단계별 해석·종합 결론](insurance-cost-analysis.ipynb)

## 핵심 결과

| 항목 | 확인한 결과 |
|---|---|
| 최종 모형 | 기준선 OLS: age + bmi + children + smoker |
| 설명력·오차 | 원본 척도 R² 0.750 / RMSE 6,058.642달러 / MAE 4,181.335달러 |
| 로그 모형 비교 | 모델 척도 R² 0.763이나 원본 척도 R² 0.532, RMSE 약 8,278~8,281달러 |
| 주요 조건부 관계 | smoker +23,810.399달러, age 1세당 +257.773달러, bmi 1단위당 +321.871달러, children 1명당 +472.975달러 |
| 표준화 계수 | smoker 0.794 → age 0.299 → bmi 0.162 → children 0.047 |
| 공선성·유의성 | 최종 모형 VIF 최대 약 1.014, 네 변수 모두 HC3 기준 p<0.05 |
| 가정 진단 | RESET 141.672, 잔차 정규성 검정 0.163, BP F=31.929에서 각각 p<0.001 |
| 독립성 해석 | DW=2.088이지만 횡단면 관측치의 독립성을 이 값만으로 입증하지 않음 |

### 결과를 어떻게 해석했는가

**평균만으로 비용을 대표하기 어렵다.** 비용의 평균은 13,279.121달러, 중앙값은 9,386.161달러로 오른쪽 꼬리가 길었다. 상단 IQR 이상치 139개는 고액 관측치 점검 신호이며 입력 오류나 자동 삭제 대상으로 간주하지 않았다.

**단독 관계와 조건부 관계를 구분했다.** age의 Spearman 상관은 0.533, bmi·children은 각각 0.120·0.132였다. BMI·자녀 수는 단독 상관이 약해도 다른 포함 변수를 고정한 회귀에서는 유의했다. sex는 p≈0.695, region은 Welch ANOVA p≈0.053으로 유의한 차이를 발견하지 못해 분석 절차에 따라 제외했지만, 집단의 동등성이나 변수의 완전한 무관함을 입증한 것은 아니다.

**전처리의 양보다 목적에 맞는 성능을 우선했다.** log(charges)로 왜도가 약 −0.09까지 완화되어도 원본 달러 단위 오차는 기준선보다 컸다. 같은 종속변수 척도가 아닌 R²·AIC를 그대로 비교하지 않고, exp 역변환 후 RMSE·MAE로 선택했다. 로그 예측값에는 별도 재변환 편향 보정을 추가하지 않았다. VIF로 제거된 변수는 없었고 표준화도 같은 OLS 모형의 적합값을 바꾸지 않았다.

**계수는 조건부 관계이며 요율 산정 근거가 아니다.** 흡연 여부의 계수는 다른 포함 변수가 같을 때의 모형상 청구비용 차이다. 이를 금연에 따른 비용 절감 효과나 보험료 할증액으로 바꾸어 해석하지 않는다. 표준화 계수의 비율을 변수 중요도의 보편적인 배수로 표현하지도 않는다.

## 참고자료

### 데이터 출처와 실제 로딩 경로

- 공개 데이터: [Medical Cost Personal Datasets — Kaggle](https://www.kaggle.com/datasets/mirichoi0218/insurance)
- 실제 분석에서는 `jussam.load_data()`의 `insurance`, `insurance_qtcheck`, `insurance_qtcheck_desc`, `insurance_qtcheck_category_desc`, `insurance_checkpoint_0`~`insurance_checkpoint_4`를 사용했다.
- 품질 점검에서 엑셀을 저장하지만 EDA·모델링은 패키지의 데이터·요약표·체크포인트를 다시 읽는다. 로컬에서 저장한 엑셀을 자동으로 이어 읽는 구조는 아니다.

### 분석 자료와 실행 환경

- **포트폴리오 구성:** README와 결과가 포함된 단일 노트북. `helpers`는 로컬 실행용이며 공개 대상이 아니다.
- Python 3.13 및 기존 `jussam`, `helpers`, pandas·NumPy·SciPy, matplotlib·seaborn, statsmodels·scikit-learn·pingouin·statannotations·openpyxl 등을 사용한다.
- 68개 코드 셀의 순차 실행을 확인했으며 오류 출력은 없다. pandas의 `observed` 기본값 변경 관련 FutureWarning은 남아 있다.
- 지역 사후검정의 최소 평균 차이 자동 요약을 `idxmin()`으로 수정하고 같은 데이터로 재확인했다. 최소 차이는 northwest–southwest의 103.903달러다. 검정 수치·기존 그래프·회귀 결과는 보존했다.
- 재실행 시 첫 경로 셀을 본인 환경에 맞추고 커널을 재시작한다. 다른 프로젝트와 같은 커널 상태를 공유하지 않는다.
- 실행 중 저장되는 파일은 `insurance_qtcheck.xlsx`, `insurance_qtcheck_desc.xlsx`다. 표·그래프·회귀 결과는 노트북 안에 저장돼 있다.

## 회고

- **확인한 점:** 로그변환으로 분포가 보기 좋아져도 목적 단위의 오차가 줄어드는 것은 아니다. 여러 전처리를 누적한 결과를 같은 단위로 비교해야 했다. 단독 상관의 약함과 다변량 회귀에서의 유의성도 구분했다.
- **해석상 한계:** HC3는 표준오차를 보정할 뿐 함수 형태·잔차 분포 문제를 해결하지 않는다. RESET 기각은 특정 원인 하나의 증명이 아니며, DW만으로 독립성을 판정할 수 없다. 비용 구간별 오차 분석을 수행하지 않았으므로 특정 구간을 성능 악화의 확정 원인으로 단정하지 않는다.
- **후속 검증 과제:** 같은 표본에서 변수 선택과 모형 비교를 수행했다. 실제 예측 업무로 확장하려면 독립 검증자료, 구간별 오차, 데이터 수집 구조와 함수 형태 등을 별도로 확인해야 한다. 이번 노트북에는 새 분석 방법을 추가하지 않고 이러한 한계를 결과와 함께 명시했다.
