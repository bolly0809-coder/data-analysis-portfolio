# Data Analysis Portfolio

데이터 분석가 지원을 위한 프로젝트 포트폴리오 저장소입니다.

현재는 아이티윌 데이터 분석 부트캠프 과정에서 수행한 팀 프로젝트를 중심으로 정리하고 있으며, 이후 개인 미니 프로젝트를 추가할 예정입니다.

## Portfolio Direction

- 지원 직무: 데이터 분석가
- 관심 도메인: 콘텐츠/커머스/플랫폼/서비스 분석, 광고/마케팅 성과 분석, 에듀테크/추천·진단 서비스, 공공데이터/정책 데이터 분석
- 핵심 역량: SQL, Python, pandas, 텍스트마이닝, 감성분석, 공공데이터 분석, 시각화, 보고서 작성

## Projects

### 1. Job Review & Posting Analysis

기업 리뷰 텍스트를 전처리·분석·점수화하고, 채용공고 데이터와 결합하여 구직자의 지원 판단을 돕는 취업 지원 서비스 프로젝트입니다.

- 기업 리뷰 데이터 전처리
- 복합명사/표준화/카테고리/불용어 사전 구축
- 형태소 분석 및 감성분석
- 리뷰 카테고리별 긍정·부정 신호 추출
- 기업별 리뷰 점수화 로직 설계
- 채용공고 점수와 리뷰 점수를 결합한 통합 분석 테이블 구축

자세한 내용은 [`job-review-analysis`](./job-review-analysis)를 참고하세요.

### 2. Seoul Isolation Risk Analysis

서울시 행정동 단위 공공데이터와 서울 빅데이터 캠퍼스의 생활인구·생활이동 데이터를 결합하여 생애주기별 사회적 고립 위험지역을 분석한 프로젝트입니다.

- 서울 빅데이터 캠퍼스 생활인구/생활이동 데이터 활용
- 외부 공공데이터 수집 및 행정동 단위 병합
- 청년층·중장년층·노년층별 위험지표 설계
- 복합위험지수 산출
- 고위험 행정동 도출 및 시각화
- 정책 개입 방향 제안

자세한 내용은 [`seoul-isolation-risk-analysis`](./seoul-isolation-risk-analysis)를 참고하세요.

## Planned Projects

### Commerce / Content / Ad Performance Analysis

커머스 또는 콘텐츠 데이터를 활용해 상품/콘텐츠 성과 지표를 정의하고, 카테고리·리뷰·가격·반응 데이터 기반의 성과 차이를 분석할 예정입니다.

### Game / App User Behavior Analysis

앱 또는 게임 유저 행동 로그 데이터를 활용해 퍼널, 리텐션, 이탈 구간, 핵심 이벤트를 분석하고 서비스 개선 가설과 A/B 테스트 아이디어를 제안할 예정입니다.

## Repository Structure

```text
.
├── README.md
├── job-review-analysis/
│   ├── README.md
│   ├── notebooks/
│   ├── images/
│   └── docs/
├── seoul-isolation-risk-analysis/
│   ├── README.md
│   ├── notebooks/
│   ├── images/
│   └── docs/
├── commerce-content-performance-analysis/
│   └── README.md
└── game-user-behavior-analysis/
    └── README.md
```

## Notes on Data Disclosure

일부 원본 데이터는 크롤링 데이터, 기업 리뷰 원문, 서울 빅데이터 캠퍼스 반출 데이터 등을 포함할 수 있어 공개하지 않습니다. 본 저장소에는 공개 가능한 범위의 코드, 샘플 데이터, 분석 흐름, 결과 이미지, 보고서 중심으로 정리할 예정입니다.

## Contact

- Email: bolly0809@gmail.com
- Notion Portfolio: 준비 중
