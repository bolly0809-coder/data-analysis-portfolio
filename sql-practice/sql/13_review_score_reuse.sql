-- Business Question:
-- 첫 거래 리뷰 점수 구간별 재이용률은 어떻게 다른가?
--
-- Dataset:
-- Synthetic Service Analytics Dataset
--
-- Skills:
-- ROW_NUMBER, Window Function, 이후 행동 추적, CASE WHEN, GROUP BY
--
-- Interpretation:
-- 첫 거래 만족도와 이후 재이용 행동의 관계를 탐색한다.
--
-- Limitation:
-- 리뷰 점수와 재이용의 관계는 관찰적 경향이며 인과관계로 단정하지 않는다.


WITH user_transactions AS (
    SELECT
        t.user_id,
        t.transaction_id,
        t.transaction_time,
        r.review_score,
        ROW_NUMBER() OVER (
            PARTITION BY t.user_id
            ORDER BY t.transaction_time
        ) AS transaction_seq
    FROM transactions t
    LEFT JOIN reviews r
        ON t.transaction_id = r.transaction_id
),
first_transaction AS (
    SELECT
        user_id,
        transaction_id AS first_transaction_id,
        transaction_time AS first_transaction_time,
        review_score AS first_review_score
    FROM user_transactions
    WHERE transaction_seq = 1
),
reuse_flag AS (
    SELECT
        f.user_id,
        f.first_review_score,
        CASE
            WHEN COUNT(t.transaction_id) > 0 THEN 1
            ELSE 0
        END AS reused_after_first_transaction
    FROM first_transaction f
    LEFT JOIN transactions t
        ON f.user_id = t.user_id
       AND t.transaction_time > f.first_transaction_time
    WHERE f.first_review_score IS NOT NULL
    GROUP BY f.user_id, f.first_review_score
)
SELECT
    CASE
        WHEN first_review_score <= 2 THEN '01_low_1_2'
        WHEN first_review_score = 3 THEN '02_mid_3'
        WHEN first_review_score = 4 THEN '03_high_4'
        WHEN first_review_score = 5 THEN '04_highest_5'
    END AS first_review_group,
    COUNT(*) AS user_count,
    SUM(reused_after_first_transaction) AS reused_user_count,
    ROUND(100.0 * SUM(reused_after_first_transaction) / COUNT(*), 2) AS reuse_rate_pct
FROM reuse_flag
GROUP BY first_review_group
ORDER BY first_review_group;
