-- 19_no_quote_request_analysis.sql
-- Case: Local Service Marketplace Product Analytics
-- Business Question:
--   Which categories, regions, or request time buckets have many requests that receive no provider quote?
--
-- Product Decision:
--   A high no_quote_rate can point to provider supply shortage, local matching gaps,
--   low request quality, unrealistic customer budget, or timing issues.
--
-- Data Assumption:
--   synthetic tables: requests, quotes, categories
--   requests grain: one row per customer request
--   quotes grain: one row per provider quote
--
-- Join Caution:
--   Use LEFT JOIN from requests to quote_by_request to keep requests with no quotes.

WITH quote_by_request AS (
    SELECT
        request_id,
        COUNT(DISTINCT quote_id) AS quote_count,
        MIN(created_at) AS first_quote_at
    FROM quotes
    GROUP BY request_id
),
request_base AS (
    SELECT
        r.request_id,
        r.user_id,
        r.category_id,
        c.category_name,
        r.region,
        r.created_at AS request_created_at,
        CAST(STRFTIME('%H', r.created_at) AS INTEGER) AS request_hour,
        r.expected_budget,
        COALESCE(q.quote_count, 0) AS quote_count,
        CASE WHEN q.quote_count IS NULL OR q.quote_count = 0 THEN 1 ELSE 0 END AS is_no_quote
    FROM requests r
    LEFT JOIN quote_by_request q
        ON r.request_id = q.request_id
    LEFT JOIN categories c
        ON r.category_id = c.category_id
),
request_segment AS (
    SELECT
        request_id,
        user_id,
        category_id,
        category_name,
        region,
        expected_budget,
        quote_count,
        is_no_quote,
        CASE
            WHEN request_hour BETWEEN 0 AND 5 THEN '01_late_night'
            WHEN request_hour BETWEEN 6 AND 11 THEN '02_morning'
            WHEN request_hour BETWEEN 12 AND 17 THEN '03_afternoon'
            ELSE '04_evening'
        END AS request_time_bucket
    FROM request_base
)
SELECT
    category_name,
    region,
    request_time_bucket,
    COUNT(DISTINCT request_id) AS request_count,
    COUNT(DISTINCT CASE WHEN is_no_quote = 1 THEN request_id END) AS no_quote_request_count,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_no_quote = 1 THEN request_id END)
        / NULLIF(COUNT(DISTINCT request_id), 0), 2) AS no_quote_rate,
    ROUND(AVG(expected_budget), 0) AS avg_expected_budget,
    ROUND(AVG(quote_count), 2) AS avg_quotes_per_request
FROM request_segment
GROUP BY category_name, region, request_time_bucket
HAVING COUNT(DISTINCT request_id) >= 20
ORDER BY no_quote_rate DESC, request_count DESC;

-- Interpretation Guide:
-- 1. High no_quote_rate by category and region may indicate supply shortage or local matching coverage issues.
-- 2. High no_quote_rate in a specific time bucket may indicate provider availability issues.
-- 3. If expected budget is low and no_quote_rate is high, price expectation mismatch may be a possible hypothesis.
-- 4. This query helps separate demand generation issues from supply matching issues.
