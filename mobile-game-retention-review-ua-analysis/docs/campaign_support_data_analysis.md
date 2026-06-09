
# 보조 캠페인 데이터 기반 UA KPI·ROAS·ML 분석 요약

## 데이터 성격
이 파트는 실제 기업 광고 데이터가 아니라, 모바일 게임 UA 성과 분석 구조를 재현하기 위해 구성한 보조 캠페인 데이터다.
실제 데이터 기반 분석 파트인 Cookie Cats A/B 테스트 분석, Google Play 리뷰 신호 분석과 구분해 해석한다.

## 데이터 규모
- 분석 기간: 60일
- 캠페인 수: 40개
- 일자 × 캠페인 행 수: 2,400행
- 채널: Meta, Google Ads, TikTok, Unity Ads, AppLovin
- 국가: US, KR, JP, BR, IN
- 소재 유형: video, playable, static

## 수행 분석
1. SQL 기반 CTR, CVR, CPI, D7 ROAS 산출
2. Campaign Performance Score 산출
3. 예산 확대·유지·점검·축소 후보 분류
4. 초기 KPI 기반 D7 ROAS 예측 모델 구축
5. 예측 오차를 채널·국가·소재 유형별로 분석

## 핵심 포트폴리오 메시지
캠페인 성과는 CPI만으로 판단하기 어렵다.
유저 획득 비용이 낮더라도 D7 Retention과 D7 ROAS가 낮다면 예산 확대 후보로 보기 어렵다.
반대로 CPI가 높더라도 잔존율과 ROAS가 높다면 고품질 유저 확보 채널로 볼 수 있다.
