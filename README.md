# Data Analysis Portfolio

데이터 분석가 지원을 위한 프로젝트 포트폴리오 저장소입니다.

현재는 데이터 분석 부트캠프 과정에서 수행한 프로젝트와 지원 직무에 맞춘 미니 프로젝트를 중심으로, **데이터 수집·전처리·지표 설계·텍스트 분석·시각화·리포팅** 역량을 보여줄 수 있도록 정리하고 있습니다.

---

## Portfolio Direction

| 구분 | 내용 |
|---|---|
| 지원 직무 | 데이터 분석가 |
| 관심 도메인 | 콘텐츠/커머스/플랫폼/서비스 분석, 광고·마케팅 성과 분석, 에듀테크, 공공데이터 분석 |
| 핵심 역량 | SQL, Python, pandas, 텍스트마이닝, 공공데이터 분석, 지표 설계, 시각화, 보고서 작성 |

---

## Projects

### 1. Job Review & Posting Analysis

기업 리뷰 텍스트를 전처리·분석·점수화하고, 채용공고 데이터와 결합하여 구직자의 지원 판단을 돕는 데이터 기반 취업 지원 서비스 프로젝트입니다.

**보여주는 역량**

- 비정형 텍스트 데이터를 분석 가능한 정량 지표로 변환
- 사용자 반응 데이터를 카테고리별 신호로 구조화
- 추천·진단 서비스에 활용 가능한 분석 테이블 설계

- Repository: [`job-review-analysis`](./job-review-analysis)

---

### 2. Seoul Isolation Risk Analysis

서울시 행정동 단위 공공데이터와 서울 빅데이터캠퍼스의 생활인구·생활이동 데이터를 결합하여 생애주기별 사회적 고립 위험지역을 분석한 프로젝트입니다.

**보여주는 역량**

- 여러 출처의 데이터를 행정동 단위로 결합
- 추상적인 사회문제를 분석 가능한 복합지표로 구조화
- 분석 결과를 지도 시각화, 정책 카드, 보고서로 연결

- Repository: [`seoul-isolation-risk-analysis`](./seoul-isolation-risk-analysis)

---

### 3. Ecommerce Ranking Analysis

쿠팡·네이버쇼핑 건강식품 랭킹 상품 데이터를 수집해 가격, 리뷰 수, 평점, 상품명 소구 키워드, 랭킹 기준별 상품 구성 차이를 분석한 미니 프로젝트입니다.

**보여주는 역량**

- 이커머스 상품 데이터를 분석 가능한 테이블로 구조화
- 가격·리뷰 수·평점·상품명 키워드를 함께 해석
- 플랫폼별 랭킹 기준 차이를 데이터로 비교
- 광고/커머스 성과 분석 관점의 보조 인사이트 도출

- Repository: [`ecommerce-ranking-analysis`](./ecommerce-ranking-analysis)

---

## Repository Structure

```text
.
├── README.md
├── job-review-analysis/
│   └── README.md
├── seoul-isolation-risk-analysis/
│   └── README.md
└── ecommerce-ranking-analysis/
    ├── README.md
    ├── data/
    ├── images/
    └── scripts/
```

---

## Notes on Data Disclosure

일부 원본 데이터는 크롤링 데이터, 기업 리뷰 원문, 서울 빅데이터캠퍼스 반출 데이터 등을 포함할 수 있어 공개하지 않습니다.

본 저장소에는 공개 가능한 범위의 분석 흐름, 코드 구조, 결과 요약, 시각화 자료, 포트폴리오 상세 페이지 링크를 중심으로 정리했습니다.
