
/*
분석 질문:
배송 지연 정도에 따라 평균 리뷰 점수는 어떻게 달라지는가?

분석 단위:
- 1행 = 배송 완료 주문 1건

지연 구간 정의:
- early_7plus_days: 예상일보다 7일 이상 빨리 도착
- early_1_to_6_days: 예상일보다 1~6일 빨리 도착
- on_time: 예상일 당일 도착
- delayed_1_to_3_days: 1~3일 지연
- delayed_4_to_7_days: 4~7일 지연
- delayed_8plus_days: 8일 이상 지연

핵심 해석:
배송 지연이 커질수록 리뷰 점수가 낮아지는지 확인한다.
*/

WITH delay_grouped AS (
    SELECT
        order_id,
        review_score,
        delay_days,
        CASE
            WHEN delay_days <= -7 THEN 'early_7plus_days'
            WHEN delay_days < 0 THEN 'early_1_to_6_days'
            WHEN delay_days = 0 THEN 'on_time'
            WHEN delay_days BETWEEN 0.000001 AND 3 THEN 'delayed_1_to_3_days'
            WHEN delay_days > 3 AND delay_days <= 7 THEN 'delayed_4_to_7_days'
            WHEN delay_days > 7 THEN 'delayed_8plus_days'
            ELSE 'unknown'
        END AS delay_group,
        CASE
            WHEN delay_days <= -7 THEN 1
            WHEN delay_days < 0 THEN 2
            WHEN delay_days = 0 THEN 3
            WHEN delay_days BETWEEN 0.000001 AND 3 THEN 4
            WHEN delay_days > 3 AND delay_days <= 7 THEN 5
            WHEN delay_days > 7 THEN 6
            ELSE 99
        END AS delay_group_order
    FROM order_base_delivered
    WHERE review_score IS NOT NULL
      AND delay_days IS NOT NULL
)

SELECT
    delay_group_order,
    delay_group,
    COUNT(*) AS order_count,
    ROUND(AVG(delay_days), 2) AS avg_delay_days,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS low_score_rate_pct,
    ROUND(SUM(CASE WHEN review_score = 5 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS five_star_rate_pct
FROM delay_grouped
GROUP BY delay_group_order, delay_group
ORDER BY delay_group_order;
