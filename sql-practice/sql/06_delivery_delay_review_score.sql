-- Business Question:
-- 배송 지연 구간별 평균 리뷰 점수와 저평점/5점 리뷰 비율은 어떻게 달라지는가?
--
-- Tables Used:
-- order_base_delivered
--
-- Skills:
-- CASE WHEN, GROUP BY, AVG, 조건부 비율 계산
--
-- Interpretation:
-- 배송 지연이라는 운영 지표와 리뷰 만족도 지표의 관계를 탐색한다.
--
-- Limitation:
-- 배송 지연과 리뷰 점수의 관계는 경향으로만 해석하며 인과관계로 단정하지 않는다.


WITH delay_grouped AS (
    SELECT
        order_id,
        review_score,
        CASE
            WHEN delay_days <= -7 THEN 'early_7_days_or_more'
            WHEN delay_days BETWEEN -6 AND -1 THEN 'early_1_to_6_days'
            WHEN delay_days <= 0 THEN 'on_time'
            WHEN delay_days BETWEEN 1 AND 3 THEN 'delay_1_to_3_days'
            WHEN delay_days BETWEEN 4 AND 7 THEN 'delay_4_to_7_days'
            ELSE 'delay_8_days_or_more'
        END AS delivery_group
    FROM order_base_delivered
    WHERE review_score IS NOT NULL
)
SELECT
    delivery_group,
    COUNT(*) AS order_count,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(100.0 * SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) / COUNT(*), 2) AS low_review_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN review_score = 5 THEN 1 ELSE 0 END) / COUNT(*), 2) AS five_star_rate_pct
FROM delay_grouped
GROUP BY delivery_group
ORDER BY
    CASE delivery_group
        WHEN 'early_7_days_or_more' THEN 1
        WHEN 'early_1_to_6_days' THEN 2
        WHEN 'on_time' THEN 3
        WHEN 'delay_1_to_3_days' THEN 4
        WHEN 'delay_4_to_7_days' THEN 5
        WHEN 'delay_8_days_or_more' THEN 6
    END;
