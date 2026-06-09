-- 17_request_quote_transaction_conversion.sql
-- Case: Local Service Marketplace Product Analytics
-- Business Question:
--   Which service categories convert customer requests into provider quotes and completed transactions?
--
-- Product Decision:
--   Separate request-to-quote conversion from quote-to-transaction conversion.
--   A category with low quote receive rate may have supply or matching issues.
--   A category with high quote receive rate but low transaction rate may have price, trust, or quote quality issues.
--
-- Data Assumption:
--   synthetic tables: requests, quotes, transactions, categories
--   requests grain: one row per customer request
--   quotes grain: one row per provider quote
--   transactions grain: one row per completed transaction
--
-- Join Caution:
--   quotes can be 1:N by request_id, so quotes must be pre-aggregated before joining to requests.

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
        r.created_at AS request_created_at,
        COALESCE(q.quote_count, 0) AS quote_count,
        CASE WHEN q.quote_count > 0 THEN 1 ELSE 0 END AS has_quote,
        CASE WHEN t.transaction_id IS NOT NULL THEN 1 ELSE 0 END AS has_transaction
    FROM requests r
    LEFT JOIN quote_by_request q
        ON r.request_id = q.request_id
    LEFT JOIN transactions t
        ON r.request_id = t.request_id
    LEFT JOIN categories c
        ON r.category_id = c.category_id
)
SELECT
    category_id,
    category_name,
    COUNT(DISTINCT request_id) AS request_count,
    COUNT(DISTINCT CASE WHEN has_quote = 1 THEN request_id END) AS quoted_request_count,
    COUNT(DISTINCT CASE WHEN has_transaction = 1 THEN request_id END) AS transaction_count,
    ROUND(AVG(quote_count), 2) AS avg_quotes_per_request,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN has_quote = 1 THEN request_id END)
        / NULLIF(COUNT(DISTINCT request_id), 0), 2) AS request_to_quote_rate,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN has_transaction = 1 THEN request_id END)
        / NULLIF(COUNT(DISTINCT request_id), 0), 2) AS request_to_transaction_rate,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN has_transaction = 1 THEN request_id END)
        / NULLIF(COUNT(DISTINCT CASE WHEN has_quote = 1 THEN request_id END), 0), 2) AS quote_to_transaction_rate
FROM request_base
GROUP BY category_id, category_name
HAVING COUNT(DISTINCT request_id) >= 30
ORDER BY request_to_transaction_rate DESC;

-- Interpretation Guide:
-- 1. Low request_to_quote_rate: check provider supply, local matching coverage, request form quality, or category demand spikes.
-- 2. High request_to_quote_rate but low quote_to_transaction_rate: check price expectation, provider trust signals, quote quality, or customer follow-up friction.
-- 3. High avg_quotes_per_request but low transaction rate: more quotes may not be enough; quote relevance and provider information may matter more.
-- 4. The HAVING threshold reduces noise from categories with too few requests.
