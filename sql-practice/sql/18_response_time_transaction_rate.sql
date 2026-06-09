-- 18_response_time_transaction_rate.sql
-- Case: Local Service Marketplace Product Analytics
-- Business Question:
--   Are requests with faster first provider response associated with higher transaction rates?
--
-- Product Decision:
--   If faster response buckets show higher transaction rates, product teams can design hypotheses around
--   provider notifications, request prioritization, faster quote nudges, or supply activation.
--
-- Caution:
--   This query shows association, not causality.
--   Category, region, price range, provider rating, request time, and customer intent should be checked before making decisions.
--
-- Data Assumption:
--   synthetic tables: requests, quotes, transactions
--   SQLite syntax

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
            WHEN first_response_minutes IS NULL THEN '00_no_quote'
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

-- Interpretation Guide:
-- 1. Compare transaction_rate across response_time_bucket values.
-- 2. A high no_quote share may indicate provider supply shortage or poor request matching.
-- 3. Faster response buckets with higher transaction rates can support an experiment hypothesis, not a causal conclusion.
-- 4. Follow-up analysis should segment by category, region, request hour, provider rating, and expected budget.
