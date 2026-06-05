# Data Analysis Portfolio

데이터 분석가 지원을 위한 프로젝트 포트폴리오 저장소입니다.

현재는 데이터 분석 부트캠프 과정에서 수행한 프로젝트와 지원 직무에 맞춘 미니 프로젝트를 중심으로, **데이터 수집·전처리·지표 설계·텍스트 분석·시각화·리포팅** 역량을 보여줄 수 있도록 정리하고 있습니다.

---

## Portfolio Direction

| 구분     | 내용                                                        |
| ------ | --------------------------------------------------------- |
| 지원 직무  | 데이터 분석가                                                   |
| 관심 도메인 | 콘텐츠/커머스/플랫폼/서비스 분석, 광고·마케팅 성과 분석, 에듀테크, 공공데이터 분석          |
| 핵심 역량  | SQL, Python, pandas, 텍스트마이닝, 공공데이터 분석, 지표 설계, 시각화, 보고서 작성 |

---

## Projects

### 1. Job Review & Posting Analysis

기업 리뷰 텍스트를 전처리·분석·점수화하고, 채용공고 데이터와 결합하여 구직자의 지원 판단을 돕는 데이터 기반 취업 지원 서비스 프로젝트입니다.

**보여주는 역량**

* 비정형 텍스트 데이터를 분석 가능한 정량 지표로 변환

* 사용자 반응 데이터를 카테고리별 신호로 구조화

* 추천·진단 서비스에 활용 가능한 분석 테이블 설계

* Repository: [`job-review-analysis`](./job-review-analysis)

---

### 2. Seoul Isolation Risk Analysis

서울시 행정동 단위 공공데이터와 서울 빅데이터캠퍼스의 생활인구·생활이동 데이터를 결합하여 생애주기별 사회적 고립 위험지역을 분석한 프로젝트입니다.

**보여주는 역량**

* 여러 출처의 데이터를 행정동 단위로 결합

* 추상적인 사회문제를 분석 가능한 복합지표로 구조화

* 분석 결과를 지도 시각화, 정책 카드, 보고서로 연결

* Repository: [`seoul-isolation-risk-analysis`](./seoul-isolation-risk-analysis)

---

### 3. Ecommerce Ranking Analysis

쿠팡·네이버쇼핑 건강식품 랭킹 상품 데이터를 수집해 가격, 리뷰 수, 평점, 상품명 소구 키워드, 랭킹 기준별 상품 구성 차이를 분석한 미니 프로젝트입니다.

**보여주는 역량**

* 이커머스 상품 데이터를 분석 가능한 테이블로 구조화

* 가격·리뷰 수·평점·상품명 키워드를 함께 해석

* 플랫폼별 랭킹 기준 차이를 데이터로 비교

* 광고/커머스 성과 분석 관점의 보조 인사이트 도출

* Repository: [`ecommerce-ranking-analysis`](./ecommerce-ranking-analysis)

---

### 4. Olist Ecommerce Analysis

Olist 공개 이커머스 주문·결제·배송·리뷰 데이터를 SQLite에 적재하고, SQL 기반으로 월별 KPI, 카테고리별 매출 기여도, 고객 지역별 배송 지연율, 배송 지연 구간별 리뷰 점수 차이를 분석한 미니 프로젝트입니다.

**보여주는 역량**

* SQLite 기반 다중 테이블 JOIN, GROUP BY, CTE, Window Function 활용

* 주문 단위와 상품 단위 base table 분리

* 결제·리뷰 중복 집계 방지를 위한 사전 집계 처리

* 배송 지연율과 리뷰 점수의 관계를 고객 경험 관점에서 해석

* 클릭·장바구니 로그가 없는 거래 데이터의 한계를 명시하고 분석 범위 제한

* Repository: [`olist-ecommerce-analysis`](./olist-ecommerce-analysis)

---

### 5. Supply Chain Delay Risk Scoring

공급망·물류 데이터에서 배송 지연 가능성을 사전에 점검하기 위한 미니 프로젝트입니다. 주문/배송 관련 변수의 결측·이상치를 점검하고, 배송 리드타임과 지연 여부를 기준으로 리스크 스코어링 로직을 구성했습니다.

**보여주는 역량**

* 배송 리드타임과 지연 여부를 기준으로 리스크 지표 설계

* 결측·이상치 점검 후 분석 가능한 데이터셋 구성

* 지연 위험을 해석 가능한 점수와 구간으로 변환

* 단순 예측보다 의사결정에 활용 가능한 리스크 스코어링 구조 설계

* Repository: [`supply-chain-delay-risk-scoring`](./supply-chain-delay-risk-scoring)

---

## Skill Evidence

### SQL Practice

데이터 분석가 직무에서 요구되는 SQL 기반 데이터 추출·집계 역량을 보여주기 위해 별도로 구성한 보강 자료입니다. Olist 이커머스 데이터로 JOIN, GROUP BY, CTE, Window Function, 월별 KPI, 카테고리 매출 비중, 배송 지연·리뷰 점수 분석을 수행했고, Product Analytics용 synthetic dataset으로 퍼널 전환율, 코호트 리텐션, 세그먼트 분석, A/B 테스트 결과 집계 SQL을 정리했습니다.

* Repository: [`sql-practice`](./sql-practice)

---

### Pandas Preprocessing Cases

실제 프로젝트 데이터 기반으로 Python/pandas 전처리 역량을 보여주는 보강 자료입니다. 이커머스 랭킹 상품 데이터의 정제와 분석 단위 분리, Olist 다중 테이블 base table 설계, 잡플래닛 리뷰 텍스트의 사전 기반 카테고리 매핑, 전처리 결과 통합 검증 과정을 정리했습니다.

* Repository: [`pandas-preprocessing-cases`](./pandas-preprocessing-cases)

---

## Repository Structure

```text
.
├── README.md
├── job-review-analysis/
├── seoul-isolation-risk-analysis/
├── ecommerce-ranking-analysis/
├── olist-ecommerce-analysis/
├── supply-chain-delay-risk-scoring/
├── sql-practice/
└── pandas-preprocessing-cases/
```

---

## Notes on Data Disclosure

일부 원본 데이터는 크롤링 데이터, 기업 리뷰 원문, 서울 빅데이터캠퍼스 반출 데이터, 대용량 DB 파일 등을 포함할 수 있어 공개하지 않습니다.

본 저장소에는 공개 가능한 범위의 분석 흐름, 코드 구조, 결과 요약, 시각화 자료, 포트폴리오 상세 페이지 링크를 중심으로 정리했습니다.

특히 기업 리뷰 원문, 대용량 SQLite DB, 비공개 원천 데이터는 제외하고, 공개 가능한 요약 산출물과 재현 가능한 분석 구조를 중심으로 정리했습니다.
