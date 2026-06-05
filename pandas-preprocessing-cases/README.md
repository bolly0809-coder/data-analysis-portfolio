# Pandas Preprocessing Cases

이 폴더는 데이터 분석가 지원 과정에서 Python/pandas 기반 전처리 역량을 보여주기 위해 구성한 Skill Evidence입니다.

단순 pandas 문법 예제가 아니라, 실제 프로젝트 데이터의 **전처리 설계 → 처리 → 분석 단위 분리 → 품질 검증 → 해석상 한계 정리** 흐름을 보여주는 자료입니다.

## 1. Why this exists

데이터 분석에서 전처리는 결측치 제거만을 의미하지 않습니다.  
원본 데이터를 분석 질문에 맞는 기준 단위로 재구성하고, JOIN·중복·결측·텍스트 매핑 과정에서 지표가 왜곡되지 않았는지 검증하는 과정입니다.

이 자료는 다음 역량을 보여줍니다.

- 크롤링/수집 데이터의 숫자형·문자열 정제
- 상품명 기반 `product_key` 생성과 중복 후보 관리
- 랭킹 화면 기준 데이터와 고유 상품 기준 데이터 분리
- 다중 테이블의 grain 파악과 JOIN 위험 검증
- 주문 단위 / 상품 단위 base table 설계
- 실제 기업 리뷰 원문의 텍스트 정제와 카테고리 매핑
- 전처리 결과의 PASS / CHECK / LIMITATION 기준 검증

## 2. Folder Structure

```text
pandas-preprocessing-cases/
├─ README.md
├─ data/
│  ├─ 01_product/
│  ├─ 02_olist/
│  └─ 03_review/
├─ notebooks/
│  ├─ 01_product_data_cleaning_actual.ipynb
│  ├─ 02_olist_base_table_design.ipynb
│  ├─ 03_review_text_preprocessing.ipynb
│  └─ 04_preprocessing_validation_summary.ipynb
├─ outputs/
│  ├─ 01_product/
│  ├─ 02_olist/
│  ├─ 03_review/
│  └─ 04_validation/
└─ notes/
```

## 3. Notebook Summary

| Notebook | Topic | Main Evidence |
|---|---|---|
| `01_product_data_cleaning_actual.ipynb` | 이커머스 랭킹 상품 데이터 정제 | 실제 상품 랭킹 CSV 기반, raw → cleaned → ranking_view → unique_product 흐름 |
| `02_olist_base_table_design.ipynb` | Olist base table 설계 | 실제 Olist DB 기반, table grain·naive JOIN 위험·주문/상품 base table 검증 |
| `03_review_text_preprocessing.ipynb` | 기업 리뷰 텍스트 전처리 | 실제 잡플래닛 리뷰 원문과 실제 사전 3종 기반, long format·표준화·카테고리 매핑 |
| `04_preprocessing_validation_summary.ipynb` | 통합 전처리 검증 | 01~03 결과를 PASS / CHECK / LIMITATION 기준으로 통합 검증 |

## 4. Case 01 — Product Data Cleaning

실제 이커머스 랭킹 상품 분석 프로젝트의 CSV 산출물을 사용했습니다.

사용 데이터:

- `raw_integrated_ecommerce_ranking.csv`
- `cleaned_ecommerce_ranking.csv`
- `ranking_view_ecommerce.csv`
- `unique_product_ecommerce.csv`
- `preprocessing_step2_quality_check.csv`
- `preprocessing_step2_summary.csv`

보여주는 역량:

- 가격, 원래가격, 할인율, 리뷰 수, 평점의 숫자형 변환
- `product_key` 기반 상품명 정규화와 중복 후보 관리
- 랭킹 기준별 행 수, 순위 범위, 결측, 중복 여부 검증
- 랭킹 화면 기준 데이터와 고유 상품 기준 데이터 분리

## 5. Case 02 — Olist Base Table Design

실제 `olist_ecommerce.db`를 사용해 Olist 프로젝트의 다중 테이블 구조를 검증했습니다.

보여주는 역량:

- 주문·상품·결제·리뷰 테이블의 grain 파악
- 원본 테이블 naive JOIN 시 중복 집계 위험 확인
- 결제/리뷰의 주문 단위 사전 집계 필요성 설명
- `order_base_delivered`와 `order_item_base_delivered` 분리 검증
- 분석 질문별 적절한 base table 선택 기준 정리

## 6. Case 03 — Review Text Preprocessing

실제 잡플래닛 리뷰 원문 일부와 실제 사전 파일을 사용했습니다.

사용 데이터:

- 잡플래닛 리뷰 원문 xlsx
- 복합명사 사전
- 카테고리 사전
- 표준화 사전

보여주는 역량:

- 리뷰제목 / 장점 / 단점 / 경영진에 바라는 점을 long format으로 변환
- 장점 = positive context, 단점 = negative context, 경영진 의견 = improvement context로 분리
- 표준화 사전 기반 표현 통일
- 카테고리 사전 기반 복수 카테고리 매핑
- 기업 단위 카테고리 신호 요약
- 카테고리 매칭률과 미매칭 샘플을 통한 한계 검증

## 7. Case 04 — Validation Summary

01~03 결과물을 통합해 전처리 결과가 포트폴리오에서 사용 가능한 상태인지 검증했습니다.

검증 기준:

- `PASS`: 바로 설명 가능한 상태
- `CHECK`: 해석 시 추가 확인이 필요한 상태
- `LIMITATION`: 한계로 명시해야 하는 상태

## 8. Public Data Disclosure

For public GitHub upload, large/local or raw scraped files are excluded.

- `data/02_olist/olist_ecommerce.db` is excluded due to file size.
- The original JobPlanet review Excel file is excluded because it contains scraped review text.
- Review-text-level output CSV files containing raw/processed review text are excluded.

The notebooks document the preprocessing logic, and executed summary outputs are included under `outputs/`. To re-run all notebooks locally, place the excluded local files back into the paths described in `data/02_olist/README.md` and `data/03_review/README.md`.

## 9. How to Run

노트북은 아래 순서대로 실행합니다.

```text
1. notebooks/01_product_data_cleaning_actual.ipynb
2. notebooks/02_olist_base_table_design.ipynb
3. notebooks/03_review_text_preprocessing.ipynb
4. notebooks/04_preprocessing_validation_summary.ipynb
```

04번은 01~03번의 outputs를 읽어 통합 검증을 수행하므로 반드시 마지막에 실행합니다.

## 10. Important Limitations

- `product_key`는 완전한 상품 식별자가 아니라 상품명 기반 중복 완화 기준입니다.
- Olist의 주문 단위 KPI와 상품 단위 카테고리 분석은 서로 다른 base table을 사용해야 합니다.
- 리뷰 텍스트 카테고리 매핑은 사전 기반 방식이므로, 비꼼·문맥 반전·사전에 없는 표현을 완벽히 처리하지 못합니다.
- 따라서 리뷰 텍스트 결과는 자동 판정 지표가 아니라 추천/진단 판단을 보조하는 신호로 해석해야 합니다.

## 11. Resume Sentence

```text
Python/pandas 기반으로 이커머스 상품 데이터 정제, Olist 주문/상품 단위 base table 설계, 잡플래닛 리뷰 텍스트 사전 매핑, 전처리 결과 검증 케이스를 정리했습니다. 이를 통해 원본 데이터를 분석 목적에 맞는 구조로 변환하고, 중복 집계 위험과 데이터 해석 범위를 관리하는 역량을 보여주었습니다.
```

## 12. Interview Talking Point

```text
전처리는 결측치 처리만이 아니라 분석 목적에 맞는 기준 단위를 설계하는 과정이라고 생각합니다. 상품 랭킹 데이터에서는 ranking view와 unique product를 분리했고, Olist에서는 주문 단위 KPI와 상품 단위 카테고리 분석을 위해 base table을 나눴습니다. 리뷰 텍스트는 실제 잡플래닛 리뷰와 사전을 사용해 카테고리 신호로 구조화하되, 사전 기반 방식의 한계를 함께 검증했습니다.
```
