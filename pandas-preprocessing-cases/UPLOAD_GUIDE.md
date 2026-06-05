# Upload Guide

## 1. Local placement

압축을 풀면 `pandas-preprocessing-cases/` 폴더가 생성됩니다.  
이 폴더를 GitHub 포트폴리오 저장소 루트에 그대로 복사합니다.

```text
data-analysis-portfolio/
└─ pandas-preprocessing-cases/
```

## 2. Run notebooks

VS Code 또는 Jupyter에서 아래 순서로 실행합니다.

```text
notebooks/01_product_data_cleaning_actual.ipynb
notebooks/02_olist_base_table_design.ipynb
notebooks/03_review_text_preprocessing.ipynb
notebooks/04_preprocessing_validation_summary.ipynb
```

04번은 01~03번의 outputs를 기반으로 통합 검증을 수행하므로 마지막에 실행해야 합니다.

## 3. GitHub main README section

포트폴리오 메인 README의 Skill Evidence 섹션에 아래 문장을 추가합니다.

```markdown
### Pandas Preprocessing Cases

실제 프로젝트 데이터 기반으로 Python/pandas 전처리 역량을 보여주는 보강 자료입니다. 이커머스 랭킹 상품 데이터의 정제와 분석 단위 분리, Olist 다중 테이블 base table 설계, 잡플래닛 리뷰 텍스트의 사전 기반 카테고리 매핑, 전처리 결과 통합 검증 과정을 정리했습니다.

Folder: [`pandas-preprocessing-cases`](./pandas-preprocessing-cases)
```

## 4. Notion card

Notion의 `Skills` 아래 `Skill Evidence` 섹션에 아래 카드로 추가합니다.

```text
Pandas Preprocessing Cases
- 실제 프로젝트 데이터 기반 전처리 보강 자료
- 상품 데이터 정제 / Olist base table 설계 / 리뷰 텍스트 카테고리 매핑 / 통합 검증
- 보여주는 역량: 분석 단위 설계, 중복 집계 위험 관리, 텍스트 구조화, 전처리 결과 검증
```

## 5. Resume sentence

```text
Python/pandas 기반으로 이커머스 상품 데이터 정제, Olist 주문/상품 단위 base table 설계, 잡플래닛 리뷰 텍스트 사전 매핑, 전처리 결과 검증 케이스를 정리했습니다. 이를 통해 원본 데이터를 분석 목적에 맞는 구조로 변환하고, 중복 집계 위험과 데이터 해석 범위를 관리하는 역량을 보여주었습니다.
```

## 6. Caution

아래 표현은 피합니다.

```text
리뷰 텍스트를 완벽하게 감성분석했습니다.
상품명을 완전한 고유 상품 ID로 식별했습니다.
Olist 모든 지표를 하나의 테이블에서 계산했습니다.
```

대신 아래처럼 설명합니다.

```text
사전 기반 리뷰 매핑은 설명 가능성이 높지만 문맥 반전과 미등록 표현에는 한계가 있어 보조 지표로 활용했습니다.
product_key는 완전한 상품 식별자가 아니라 상품명 기반 중복 완화 기준으로 사용했습니다.
분석 질문에 따라 주문 단위 base table과 상품 단위 base table을 분리했습니다.
```
