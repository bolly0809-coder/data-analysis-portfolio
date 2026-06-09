
# Cookie Cats A/B 테스트 분석 요약

## 분석 목적
Cookie Cats 공개 모바일 게임 A/B 테스트 데이터를 활용해 gate 위치 변경이 유저 리텐션에 미친 영향을 분석했다.
gate_30은 기존안, gate_40은 gate 위치를 level 40으로 늦춘 실험안이다.

## 핵심 결과
- gate_30 그룹 유저 수는 44,700명, gate_40 그룹 유저 수는 45,489명으로 두 그룹 규모는 유사했다.
- D1 Retention은 gate_30 44.82%, gate_40 44.23%로 gate_40이 약 0.59%p 낮았다.
- D1 Retention 차이는 proportion z-test 기준 p-value가 약 0.074로, 유의수준 5%에서는 명확한 차이라고 보기 어려웠다.
- D7 Retention은 gate_30 19.02%, gate_40 18.20%로 gate_40이 약 0.82%p 낮았다.
- D7 Retention 차이는 proportion z-test 기준 p-value가 약 0.0016으로, 통계적으로 유의한 차이를 보였다.

## 해석
gate를 level 30에서 level 40으로 늦춘 실험안은 D1 Retention에서는 명확한 개선을 만들지 못했고,
D7 Retention에서는 오히려 유의하게 낮은 결과를 보였다.
따라서 실험안 적용 여부를 판단할 때 단기 반응만 볼 것이 아니라,
D7 Retention처럼 더 긴 잔존 지표를 함께 확인해야 한다.

## 포트폴리오 관점의 시사점
이 분석은 모바일 게임에서 A/B 테스트 결과를 단순 평균 차이로 판단하지 않고,
retention uplift, 통계 검정, 신뢰구간을 함께 확인해야 함을 보여준다.
또한 실험 결과가 일부 지표에서 좋아 보이더라도 장기 잔존 지표에서 부정적일 수 있으므로,
실험안 적용 여부는 핵심 KPI 기준으로 신중하게 판단해야 한다.
