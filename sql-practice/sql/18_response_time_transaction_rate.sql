-- 18_response_time_transaction_rate.sql
-- Purpose: 전문가 첫 응답 시간대별 거래 성사율 계산
-- Assumption: synthetic tables `requests`, `quotes`, `transactions`
-- SQLite syntax 기준

WITH first_quote AS (
    SELECT
        request_id,
        MIN(created_at) AS first_quote_at
    FROM quotes
    GROUP BY request_id
),
request_response AS (
    SELECT
        r.request_id,
        r.user_id,
        r.category_id,
        r.created_at AS request_created_at,
        f.first_quote_at,
        ROUND((JULIANDAY(f.first_quote_at) - JULIANDAY(r.created_at)) * 24 * 60, 1) AS first_response_minutes,
        CASE WHEN t.transaction_id IS NOT NULL THEN 1 ELSE 0 END AS has_transaction
    FROM requests r
    LEFT JOIN first_quote f
        ON r.request_id = f.request_id
    LEFT JOIN transactions t
        ON r.request_id = t.request_id
),
response_bucket AS (
    SELECT
        request_id,
        user_id,
        category_id,
        first_response_minutes,
        has_transaction,
        CASE
            WHEN first_response_minutes IS NULL THEN 'no_quote'
            WHEN first_response_minutes <= 10 THEN '01_0_10min'
            WHEN first_response_minutes <= 30 THEN '02_10_30min'
            WHEN first_response_minutes <= 60 THEN '03_30_60min'
            WHEN first_response_minutes <= 180 THEN '04_1_3h'
            WHEN first_response_minutes <= 720 THEN '05_3_12h'
            ELSE '06_12h_plus'
        END AS response_time_bucket
    FROM request_response
)
SELECT
    response_time_bucket,
    COUNT(DISTINCT request_id) AS request_count,
    COUNT(DISTINCT CASE WHEN has_transaction = 1 THEN request_id END) AS transaction_count,
    ROUND(AVG(first_response_minutes), 1) AS avg_first_response_minutes,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN has_transaction = 1 THEN request_id END)
        / NULLIF(COUNT(DISTINCT request_id), 0), 2) AS transaction_rate
FROM response_bucket
GROUP BY response_time_bucket
ORDER BY response_time_bucket;

-- Interpretation guide:
-- 1. 빠른 응답 구간의 거래율이 높다면, 전문가 첫 응답 속도 개선 실험을 설계할 수 있다.
-- 2. 단, 응답 시간과 거래 성사율의 관계는 인과로 단정하지 않는다.
-- 3. 카테고리, 가격, 지역, 전문가 평점, 고객 예산을 함께 통제하는 추가 분석이 필요하다.
