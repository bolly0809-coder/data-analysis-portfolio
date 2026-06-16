# Self-mall Funnel Conversion Analysis

패션/스니커즈 자사몰을 가정한 샘플 행동 로그 데이터를 생성하고, 고객 여정 퍼널·마케팅 채널 성과·재구매/LTV·A/B 테스트·UX 개선 우선순위를 분석한 프로젝트입니다.

> 본 프로젝트는 실제 기업 자사몰 내부 데이터가 아니라, 자사몰 행동 로그 구조를 재현한 **샘플 데이터 기반 분석**입니다. 특정 브랜드의 실제 성과를 설명하는 목적이 아니라, 자사몰 퍼널 분석에 필요한 이벤트 설계, KPI 계산, 이탈 원인 해석, 개선안 도출 과정을 보여주는 데 목적이 있습니다.

---

## 1. Project Objective

자사몰에서 방문자는 발생하지만 상품 탐색 이후 구매까지 이어지는 비율이 낮다는 상황을 가정했습니다. 분석 목표는 다음과 같습니다.

1. 방문 → 상품조회 → 장바구니 → 결제시작 → 구매 단계 중 가장 큰 이탈 구간을 찾습니다.
2. 유입 채널별 CTR, CVR, ROAS를 비교해 예산 확대/점검 후보를 구분합니다.
3. 모바일 결제, 사이즈 가이드, 포토리뷰, 리뷰 상단 노출 등 UX 개선 후보를 지표로 검토합니다.
4. 재구매, 코호트 리텐션, RFM, ACC 동반구매를 통해 CRM·객단가 개선 액션을 도출합니다.

---

## 2. Data Design

| Table | Rows | Description |
|---|---:|---|
| users | 12,000 | 고객 ID, 가입일, 고객 세그먼트 |
| products | 100 | 상품 카테고리, 라인, 가격, 리뷰/사이즈 정보 |
| campaigns | 900 | 일자·캠페인 기준 광고비, 노출, 클릭 |
| sessions | 30,000 | 방문 세션, 유입 채널, 디바이스, 캠페인 |
| events | 168,129 | session_start, view_item, add_to_cart, begin_checkout, purchase 등 행동 로그 |
| orders | 2,195 | 주문, 매출, 할인, 배송비, 결제수단 |
| order_items | 2,564 | 주문별 상품 상세 |
| ab_test_exposures | 22,107 | PDP 리뷰 노출 위치 A/B 테스트 샘플 |

주요 이벤트는 GA4식 이벤트 구조를 참고해 설계했습니다.

- `session_start`
- `view_promotion`
- `select_promotion`
- `view_item_list`
- `view_item`
- `view_size_guide`
- `add_to_wishlist`
- `add_to_cart`
- `begin_checkout`
- `apply_coupon`
- `payment_attempt`
- `purchase`

---

## 3. Analysis Process

1. **Data generation**
   - 패션/스니커즈 자사몰을 가정한 고객, 상품, 세션, 이벤트, 주문, 캠페인 데이터 생성
   - 채널·디바이스·상품군별 전환 차이가 나타나도록 샘플 데이터 시나리오 설계

2. **Data validation**
   - 세션-이벤트-주문-상품 테이블 간 키 정합성 확인
   - 주문 금액과 주문 상품 합계 일치 여부 확인
   - 구매 이벤트 세션 수와 주문 세션 수 일치 여부 확인

3. **Funnel analysis**
   - 방문 → 상품조회 → 장바구니 → 결제시작 → 구매 단계별 전환율과 이탈률 계산

4. **Channel performance analysis**
   - 채널별 CTR, CVR, 매출, 광고비, ROAS, CPA 비교
   - Paid Social, Paid Search, Retargeting 등 채널별 역할 구분

5. **UX signal analysis**
   - 모바일/데스크톱 결제 전환율 비교
   - 사이즈 가이드 조회 여부와 장바구니율 비교
   - 포토리뷰 규모와 상품 전환율 비교

6. **Customer and cross-sell analysis**
   - 재구매율, 코호트 리텐션, RFM 세그먼트 분석
   - 신발 단독 주문과 신발+ACC 동반구매 주문의 객단가 비교

7. **A/B test analysis**
   - PDP 리뷰 상단 노출 variant와 control의 장바구니율·구매율 차이 검정

---

## 4. Key Findings

### Finding 1. 가장 큰 이탈 구간은 상품 상세 조회 → 장바구니 추가 단계였습니다.

| Step | Sessions | Conversion from previous | Drop-off from previous |
|---|---:|---:|---:|
| session_start | 30,000 | - | - |
| view_item | 22,107 | 73.7% | 26.3% |
| add_to_cart | 4,055 | 18.3% | 81.7% |
| begin_checkout | 3,041 | 75.0% | 25.0% |
| purchase | 2,195 | 72.2% | 27.8% |

상품 관심은 발생하지만 장바구니 전환에서 큰 이탈이 발생했습니다. 신발 자사몰 특성상 사이즈, 착용감, 포토리뷰, 혜택 정보가 장바구니 결정을 충분히 밀어주지 못하는 상황으로 해석했습니다.

### Finding 2. Paid Social은 CTR은 높지만 구매 전환과 ROAS가 낮았습니다.

| Channel | Sessions | CVR | Event-based CTR | ROAS |
|---|---:|---:|---:|---:|
| Retargeting | 3,319 | 16.2% | 16.4% | 2.87 |
| Paid Search | 4,261 | 9.5% | 11.7% | 1.42 |
| Paid Social | 5,302 | 3.3% | 18.0% | 0.12 |
| Display | 2,500 | 1.8% | 4.2% | 0.38 |

Paid Social은 클릭을 만드는 능력은 높지만 구매 전환과 ROAS가 낮았습니다. 광고 소재가 관심을 끌더라도 랜딩 상품, 혜택, 가격 메시지와 기대가 맞지 않으면 전환으로 이어지지 않을 수 있습니다.

### Finding 3. 모바일 결제 전환율이 데스크톱보다 낮았습니다.

| Device | Checkout sessions | Purchases | Checkout → purchase rate |
|---|---:|---:|---:|
| desktop | 717 | 588 | 82.0% |
| mobile | 2,104 | 1,445 | 68.7% |
| tablet | 220 | 162 | 73.6% |

모바일 결제 단계에서 배송비, 쿠폰, 결제수단, 총 결제금액 노출 방식이 이탈에 영향을 줄 수 있다고 해석했습니다.

### Finding 4. 사이즈 가이드 조회와 포토리뷰는 장바구니 전환에 긍정적인 신호로 나타났습니다.

| Signal | Group | View-to-cart rate | Purchase rate |
|---|---|---:|---:|
| Size guide | not viewed | 11.2% | 6.1% |
| Size guide | viewed | 20.3% | 10.8% |
| Photo reviews | low | 7.2% | 3.7% |
| Photo reviews | high | 11.4% | 6.2% |

신발 상품에서는 사이즈와 착용감 불확실성을 줄이는 정보가 전환에 중요하다는 점을 확인했습니다.

### Finding 5. 리뷰 상단 노출 A/B 테스트는 장바구니율과 구매율 모두 개선되었습니다.

| Variant | Exposures | Add-to-cart rate | Purchase rate | p-value |
|---|---:|---:|---:|---:|
| control | 11,090 | 16.8% | 8.9% | - |
| review_top | 11,017 | 19.9% | 11.0% | 9.1e-10 |

리뷰 신뢰 요소를 PDP 상단에 노출하는 구성은 장바구니 전환 개선 후보로 볼 수 있습니다.

### Finding 6. 신발+ACC 동반구매 주문은 신발 단독 주문보다 객단가가 높았습니다.

| Purchase mix | Orders | Average net revenue |
|---|---:|---:|
| SHOES only | 1,700 | 80,351원 |
| SHOES+ACC | 369 | 95,385원 |

신발 주문 중 ACC 동반구매율은 17.8%였고, 신발+ACC 주문의 객단가는 신발 단독 주문보다 18.7% 높았습니다. PDP, 장바구니, 결제 직전 단계에서 ACC 추천 모듈과 묶음 혜택을 테스트할 수 있습니다.

---

## 5. Recommended Actions

| Priority | Finding | Recommended action | Test or metric |
|---:|---|---|---|
| 1 | 상품 상세 조회 후 장바구니 전환율이 18.3%로 낮음 | PDP 상단에 포토리뷰, 사이즈 가이드, 배송/쿠폰 혜택, 착용컷 강화 | view_item → add_to_cart rate |
| 2 | 모바일 결제 전환율이 데스크톱보다 낮음 | 모바일 결제 페이지에서 총 결제금액, 쿠폰, 배송비, 간편결제 버튼 사전 노출 | begin_checkout → purchase rate |
| 3 | Paid Social은 CTR은 높지만 CVR/ROAS 낮음 | 광고 소재 문구와 랜딩 PDP의 가격/혜택/스타일 메시지 일치 | campaign funnel CVR |
| 4 | Retargeting과 Paid Search의 유료 채널 성과가 상대적으로 양호 | 예산 유지/확대 후보로 두되 한계 ROAS 모니터링 | ROAS, CPA, marginal ROAS |
| 5 | 사이즈 가이드 조회 세션의 장바구니율이 높음 | 사이즈 가이드 버튼을 PDP 상단/사이즈 선택 영역에 고정 배치 | size guide CTA click rate |
| 6 | 리뷰 상단 노출 variant가 유의하게 우수 | 포토리뷰/착용후기 영역 상단 노출 A/B 테스트 | add_to_cart rate, purchase rate |
| 7 | 신발+ACC 주문 객단가가 18.7% 높음 | 신발 라인별 ACC 추천 모듈과 묶음 혜택 테스트 | ACC attach rate, AOV |

---

## 6. Repository Contents

```text
selfmall-funnel-conversion-analysis/
├── README.md
└── data/
    ├── 00_data_quality_checks.csv
    ├── 01_funnel_analysis.csv
    ├── 02_channel_performance_analysis.csv
    ├── 03_device_checkout_analysis.csv
    ├── 05_size_photo_review_analysis.csv
    ├── 09_ab_test_ztest_analysis.csv
    ├── 10_action_item_priority.csv
    ├── 12_acc_attach_overall_metrics.csv
    ├── 13_acc_purchase_mix_summary.csv
    ├── 14_acc_attach_by_channel.csv
    └── 15_acc_attach_by_product_line.csv
```

---

## 7. Tech Stack

- Python
- pandas
- NumPy
- matplotlib
- SQLite
- funnel analysis
- marketing KPI analysis
- A/B test z-test
- RFM / cohort / LTV basic analysis
- GA4-style event design

---

## 8. Limitations

- 본 프로젝트는 실제 기업 자사몰 내부 데이터가 아니라 샘플 데이터 기반 분석입니다.
- 광고비, 전환율, ROAS, 재구매율 등 수치는 특정 브랜드의 실제 성과가 아닙니다.
- 데이터 생성 단계에서 분석 목적에 맞는 패턴을 의도적으로 삽입했으므로, 결과값 자체보다 지표 정의와 분석 흐름을 중심으로 해석해야 합니다.
- 실제 자사몰에서는 GA4, 광고 매체, 주문 DB, CRM, 재고 데이터가 연결되어야 더 정확한 원인 분석이 가능합니다.
- 본 프로젝트는 전환 개선 가설과 테스트 후보를 제시하는 수준이며, 실제 개선 효과는 운영 데이터 기반 실험으로 검증해야 합니다.

---

## 9. Portfolio Relevance

이 프로젝트는 자사몰 데이터 분석, 마케팅 성과 분석, UX/UI 개선안 도출 직무에 맞춰 구성했습니다.

특히 다음 역량을 보여주는 포트폴리오로 활용할 수 있습니다.

- 자사몰 고객 여정과 퍼널 지표 설계
- CTR, CVR, ROAS, CPA 등 마케팅 KPI 해석
- GA4식 이벤트 구조와 UTM/채널 데이터 이해
- 상세페이지, 리뷰, 사이즈 가이드, 모바일 결제 UX 개선안 도출
- A/B 테스트 설계 및 통계 검정
- 재구매, LTV, RFM, ACC 동반구매 기반 CRM/객단가 개선 액션 제안
