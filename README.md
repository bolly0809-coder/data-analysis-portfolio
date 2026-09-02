# Data Analysis Portfolio

데이터 분석가 포트폴리오 저장소입니다.

SQL, Python/pandas, 텍스트 분석, 공공데이터 결합, 지표 설계, 시각화, 리포팅 프로젝트를 중심으로 정리했습니다. 각 프로젝트는 문제 정의, 사용 데이터, 분석 과정, 주요 결과, 한계 및 개선 방향을 확인할 수 있도록 구성했습니다.

---

## Portfolio Direction

| 구분 | 내용 |
|---|---|
| 지원 직무 | 데이터 분석가, 비즈니스 데이터 분석, 서비스/Product 데이터 분석, 자사몰/마케팅 데이터 분석 |
| 관심 도메인 | 커머스, 플랫폼 서비스, 광고·마케팅 성과 분석, 에듀테크, 공공데이터 분석 |
| 핵심 역량 | SQL, Python, pandas, 지표 설계, 퍼널/코호트 분석, 텍스트마이닝, 시각화, 리포팅 |

---

## Projects

### 1. Self-mall Funnel Conversion Analysis

패션/스니커즈 자사몰을 가정한 샘플 행동 로그 데이터를 생성하고, 고객 여정 퍼널·마케팅 채널 성과·재구매/LTV·A/B 테스트·UX 개선 우선순위를 분석한 프로젝트입니다.

- GA4식 이벤트 구조를 참고해 session, event, order, campaign 테이블 설계
- 방문 → 상품조회 → 장바구니 → 결제시작 → 구매 단계별 전환율과 이탈률 분석
- 채널별 CTR, CVR, ROAS, CPA 비교 및 예산 확대/점검 후보 도출
- 사이즈 가이드, 포토리뷰, 모바일 결제, ACC 동반구매 기반 UX/CRM 액션 제안
- Repository: [`selfmall-funnel-conversion-analysis`](./selfmall-funnel-conversion-analysis)

---

### 2. Job Review & Posting Analysis

기업 리뷰 텍스트를 전처리·분석·점수화하고, 채용공고 데이터와 결합해 구직자의 지원 판단을 돕는 데이터 기반 취업 지원 서비스 프로젝트입니다.

- 비정형 리뷰 텍스트를 카테고리별 정량 지표로 변환
- 채용공고 점수와 리뷰 점수를 결합한 통합 분석 테이블 구축
- 추천·진단 서비스에 활용 가능한 데이터 구조 설계
- Repository: [`job-review-analysis`](./job-review-analysis)

---

### 3. Seoul Isolation Risk Analysis

서울시 행정동 단위 공공데이터와 서울 빅데이터캠퍼스의 생활인구·생활이동 데이터를 결합해 생애주기별 사회적 고립 위험지역을 분석한 프로젝트입니다.

- 여러 출처의 데이터를 행정동 단위로 정합화
- 청년·중장년·노년별 복합위험지수 설계
- 분석 결과를 지도 시각화, 정책 카드, 보고서로 연결
- Repository: [`seoul-isolation-risk-analysis`](./seoul-isolation-risk-analysis)

---

### 4. Ecommerce Ranking Analysis

쿠팡·네이버쇼핑 건강식품 랭킹 상품 데이터를 수집해 가격, 리뷰 수, 평점, 상품명 소구 키워드, 랭킹 기준별 상품 구성 차이를 분석한 프로젝트입니다.

- 이커머스 상품 데이터를 분석 가능한 테이블로 구조화
- 가격·리뷰 수·평점·상품명 키워드 비교
- 플랫폼별 랭킹 기준과 상품 소구 방식 차이 해석
- Repository: [`ecommerce-ranking-analysis`](./ecommerce-ranking-analysis)

---

### 5. Olist Ecommerce Analysis

Olist 공개 이커머스 주문·결제·배송·리뷰 데이터를 SQLite에 적재하고, SQL 기반으로 월별 KPI, 카테고리별 매출 기여도, 배송 지연율과 리뷰 점수 차이를 분석한 프로젝트입니다.

- SQLite 기반 다중 테이블 JOIN, GROUP BY, CTE, Window Function 활용
- 주문 단위와 상품 단위 base table 분리
- 배송 지연율과 리뷰 점수의 관계를 고객 경험 관점에서 해석
- Repository: [`olist-ecommerce-analysis`](./olist-ecommerce-analysis)

---

### 6. Supply Chain Delay Risk Scoring

공급망 주문 데이터를 활용해 배송 지연 가능성을 예측하고, 주문별 리스크 스코어를 산출한 프로젝트입니다.

- 배송 완료 후에야 알 수 있는 누수 변수를 제거하고 모델링
- Logistic Regression과 XGBoost 성능 비교
- 예측 확률을 0~100점 리스크 스코어로 변환
- Streamlit 대시보드로 고위험 주문 점검 화면 구성
- Repository: [`supply-chain-delay-risk-scoring`](./supply-chain-delay-risk-scoring)

---

### 7. Mobile Game Retention Review UA Analysis

Cookie Cats A/B 테스트, Google Play 리뷰, 보조 UA 캠페인 데이터를 활용해 모바일 게임의 리텐션 변화, UX 신호, UA 성과 판단 구조를 분석한 프로젝트입니다.

- A/B 테스트 기반 D1·D7 Retention 차이 검정
- Google Play 리뷰 수집 및 UX 리스크 신호 분류
- 캠페인 KPI, D7 ROAS, 예측 오차 분석
- Repository: [`mobile-game-retention-review-ua-analysis`](./mobile-game-retention-review-ua-analysis)

---

### 8. AI Agent Response Evaluation

한국어 AI 에이전트 응답 90건을 평가해 지시 준수, 근거성, 맥락 이해, 안전성 오류를 라벨링하고 실패 패턴을 분석한 프로젝트입니다.

- 한국어 AI 응답 평가용 프롬프트 설계
- 오류 유형 라벨링 및 대표 사례 분석
- 환불·책임·AI 추천·데이터 해석 맥락의 위험 표현 개선
- Repository: [`ai-agent-response-evaluation`](./ai-agent-response-evaluation)

---

### 9. Pocari Consumer Reaction Analysis

포카리스웨트 관련 네이버 블로그 공개 검색 데이터와 일부 상세 본문을 수집해 사용 맥락, 제품 반응, CX/마케팅 신호를 분류한 프로젝트입니다.

- Selenium·BeautifulSoup 기반 공개 검색 데이터 수집
- 검색결과 카드 566건과 상세 본문 샘플 150건 수집
- 제품 타입 재분류 및 사전 기반 다중 라벨링
- Repository: [`pocari-consumer-reaction-analysis`](./pocari-consumer-reaction-analysis)

---

### 10. 소득과 입지, 주거 구조로 캘리포니아 주택가격을 예측할 수 있는가

캘리포니아 인구조사 구역의 주택 중위가격을 대상으로 데이터 품질 점검, EDA, 파생변수 설계, 11개 회귀모형 비교, 최종 CatBoost 평가와 SHAP 해석을 수행했습니다.

- 데이터 품질 → EDA → 전처리 → 모델링 → 해석을 실행 결과가 포함된 단일 노트북으로 구성
- 최종 평가 R² 약 0.785, RMSE 0.2659(로그 척도)
- 소득·입지·주거 구조 변수의 예측 기여도와 과적합·공간분석 한계 정리
- 분석 요약 · 핵심 결과 · 참고자료 · 회고: [`california-housing-price-prediction`](./california-housing-price-prediction)

---

## Skill Evidence

### SQL Practice

SQL 기반 데이터 추출·집계 역량을 보여주기 위해 구성한 보강 자료입니다. Olist 이커머스 데이터로 JOIN, GROUP BY, CTE, Window Function, KPI 집계를 수행했고, synthetic dataset으로 퍼널 전환율, 코호트 리텐션, 세그먼트 분석, A/B 테스트 결과 집계 SQL을 정리했습니다.

- Repository: [`sql-practice`](./sql-practice)

---

### Pandas Preprocessing Cases

실제 프로젝트 데이터 기반으로 Python/pandas 전처리 흐름을 정리한 보강 자료입니다. 이커머스 랭킹 상품 데이터 정제, Olist base table 설계, 리뷰 텍스트 사전 매핑, 전처리 결과 검증 과정을 포함합니다.

- Repository: [`pandas-preprocessing-cases`](./pandas-preprocessing-cases)

---

## Repository Structure

```text
.
├── README.md
├── selfmall-funnel-conversion-analysis/
├── job-review-analysis/
├── seoul-isolation-risk-analysis/
├── ecommerce-ranking-analysis/
├── olist-ecommerce-analysis/
├── supply-chain-delay-risk-scoring/
├── mobile-game-retention-review-ua-analysis/
├── ai-agent-response-evaluation/
├── pocari-consumer-reaction-analysis/
├── california-housing-price-prediction/
├── sql-practice/
└── pandas-preprocessing-cases/
```

---

## Data Disclosure

본 저장소에는 공개 가능한 범위의 분석 코드, 요약 산출물, 시각화 자료, README 문서를 중심으로 정리했습니다.

다음 자료는 공개 저장소에 포함하지 않는 것을 원칙으로 합니다.

- 크롤링 원문 데이터
- 기업 리뷰 원문 및 원문이 포함된 중간 산출물
- 서울 빅데이터캠퍼스 반출 원본 데이터
- 대용량 SQLite DB 및 원본 Kaggle CSV
- 모델 바이너리와 로컬 환경 파일

공개 데이터셋을 활용한 프로젝트도 원본 전체 파일 대신 분석 흐름과 요약 결과를 중심으로 관리합니다.
