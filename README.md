# Data Analysis Portfolio

데이터 분석가 지원을 위한 프로젝트 포트폴리오 저장소입니다.

현재는 데이터 분석 부트캠프 과정에서 수행한 프로젝트를 중심으로, **데이터 수집·전처리·지표 설계·시각화·리포팅** 역량을 보여줄 수 있도록 정리하고 있습니다.

- **Notion Portfolio:** https://www.notion.so/36eb1b26b8cc81e69a2ed576a6333f6d
- **Email:** bolly0809@gmail.com

---

## Portfolio Direction

| 구분 | 내용 |
|---|---|
| 지원 직무 | 데이터 분석가 |
| 관심 도메인 | 콘텐츠/커머스/플랫폼/서비스 분석, 광고·마케팅 성과 분석, 에듀테크, 공공데이터 분석 |
| 핵심 역량 | SQL, Python, pandas, 텍스트마이닝, 감성분석, 공공데이터 분석, 지표 설계, 시각화, 보고서 작성 |

---

## Projects

### 1. Job Review & Posting Analysis

기업 리뷰 텍스트를 전처리·분석·점수화하고, 채용공고 데이터와 결합하여 구직자의 지원 판단을 돕는 데이터 기반 취업 지원 서비스 프로젝트입니다.

**핵심 역할**

- 기업 리뷰 데이터 전처리
- 복합명사/표준화/카테고리/불용어 사전 구축
- 형태소 분석 및 감성분석
- 리뷰 카테고리별 긍정·부정 신호 추출
- 기업별 리뷰 점수화 로직 설계
- 채용공고 점수와 리뷰 점수를 결합한 통합 분석 테이블 구축

**보여주는 역량**

- 비정형 텍스트 데이터를 분석 가능한 정량 지표로 변환
- 사용자 반응 데이터를 카테고리별 신호로 구조화
- 추천·진단 서비스에 활용 가능한 분석 테이블 설계

- Repository: [`job-review-analysis`](./job-review-analysis)
- Notion Detail: https://www.notion.so/36fb1b26b8cc816faebefb7c73f2cbd6

---

### 2. Seoul Isolation Risk Analysis

서울시 행정동 단위 공공데이터와 서울 빅데이터캠퍼스의 생활인구·생활이동 데이터를 결합하여 생애주기별 사회적 고립 위험지역을 분석한 프로젝트입니다.

**핵심 역할**

- 서울시 빅데이터캠퍼스 데이터와 외부 공공데이터 수집
- 행정동 단위 데이터 병합 및 정합화
- 청년층·중장년층·노년층별 위험지표 설계
- 복합위험지수 산출
- 고위험 행정동 도출 및 시각화
- 정책 우선순위와 정책 패키지 제안

**보여주는 역량**

- 여러 출처의 데이터를 행정동 단위로 결합
- 추상적인 사회문제를 분석 가능한 복합지표로 구조화
- 분석 결과를 지도 시각화, 정책 카드, 보고서로 연결

- Repository: [`seoul-isolation-risk-analysis`](./seoul-isolation-risk-analysis)
- Notion Detail: https://www.notion.so/36fb1b26b8cc81949e4ffc4b2ce37e80

---

## Repository Structure

```text
.
├── README.md
├── job-review-analysis/
│   └── README.md
└── seoul-isolation-risk-analysis/
    └── README.md
```

---

## Notes on Data Disclosure

일부 원본 데이터는 크롤링 데이터, 기업 리뷰 원문, 서울 빅데이터캠퍼스 반출 데이터 등을 포함할 수 있어 공개하지 않습니다.

본 저장소에는 공개 가능한 범위의 분석 흐름, 코드 구조, 결과 요약, 시각화 자료, Notion 상세 페이지 링크를 중심으로 정리했습니다.

---

## Contact

- Email: bolly0809@gmail.com
- Notion Portfolio: https://www.notion.so/36eb1b26b8cc81e69a2ed576a6333f6d
