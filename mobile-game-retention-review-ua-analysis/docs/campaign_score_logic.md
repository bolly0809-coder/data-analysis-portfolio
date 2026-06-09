
# Campaign Performance Score Logic

## 목적
보조 캠페인 데이터에서 CPI, CVR, D7 Retention, D7 ROAS, Tutorial Completion Rate를 함께 고려해 캠페인별 예산 운영 우선순위를 산출했다.

## 점수 구성
- CPI Score: CPI가 낮을수록 높은 점수
- CVR Score: 클릭 대비 설치 전환율
- D7 Retention Score: 설치 후 7일 잔존율
- D7 ROAS Score: 광고비 대비 7일 수익성
- Tutorial Completion Score: 초기 온보딩 완료율

## 산식
Campaign Performance Score =
0.25 × CPI Score
+ 0.20 × CVR Score
+ 0.25 × D7 Retention Score
+ 0.25 × D7 ROAS Score
+ 0.05 × Tutorial Completion Score

## 해석
이 점수는 실제 광고 네트워크 최적화 알고리즘이 아니라, 캠페인 성과를 비교하기 위한 규칙 기반 스코어다.
다만 여러 초기 성과 지표를 표준화하고 가중합으로 결합하는 과정은 향후 D7 ROAS 또는 LTV 예측 모델의 Feature Engineering으로 확장 가능하다.

## 예산 액션 기준
- Scale: 75점 이상
- Maintain: 55점 이상 75점 미만
- Review: 35점 이상 55점 미만
- Reduce: 35점 미만
