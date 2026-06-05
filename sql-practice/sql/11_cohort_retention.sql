-- Business Question:
-- 가입 월별 유저의 M0~M3 리텐션은 어떻게 달라지는가?
--
-- Dataset:
-- Synthetic Service Analytics Dataset
--
-- Skills:
-- 날짜 기준 집계, CTE, Cohort, COUNT DISTINCT, 리텐션 계산
--
-- Interpretation:
-- 가입 월별 유지율을 비교해 특정 유입 시기의 잔존 품질을 확인한다.
--
-- Limitation:
-- 월 차이는 SQLite 날짜 계산 기반의 단순화된 예시이며, 실무에서는 정확한 calendar month diff 로직을 별도 정의해야 한다.


WITH first_month AS (
    SELECT
        user_id,
        DATE(signup_date, 'start of month') AS cohort_month
    FROM users
),
active_month AS (
    SELECT DISTINCT
        user_id,
        DATE(event_time, 'start of month') AS active_month
    FROM events
),
cohort_activity AS (
    SELECT
        f.cohort_month,
        CAST((JULIANDAY(a.active_month) - JULIANDAY(f.cohort_month)) / 30 AS INTEGER) AS month_number,
        COUNT(DISTINCT f.user_id) AS active_users
    FROM first_month f
    JOIN active_month a
        ON f.user_id = a.user_id
       AND a.active_month >= f.cohort_month
    GROUP BY f.cohort_month, month_number
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT user_id) AS cohort_users
    FROM first_month
    GROUP BY cohort_month
)
SELECT
    ca.cohort_month,
    ca.month_number,
    cs.cohort_users,
    ca.active_users,
    ROUND(100.0 * ca.active_users / cs.cohort_users, 2) AS retention_rate_pct
FROM cohort_activity ca
JOIN cohort_size cs
    ON ca.cohort_month = cs.cohort_month
WHERE ca.month_number BETWEEN 0 AND 3
ORDER BY ca.cohort_month, ca.month_number;
