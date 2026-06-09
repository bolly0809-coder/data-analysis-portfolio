-- 17_request_quote_transaction_conversion.sql
-- Purpose: 카테고리별 요청 → 견적 수신 → 거래 성사 전환율 계산
-- Assumption: synthetic tables `requests`, `quotes`, `transactions`, `categories`
-- Grain:
--   requests: one row per customer request
--   quotes: one row per provider quote
--   transactions: one row per completed transaction

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

-- Interpretation guide:
-- 1. request_to_quote_rate가 낮은 카테고리는 전문가 공급 부족 또는 요청서 품질 문제를 의심할 수 있다.
-- 2. request_to_quote_rate는 높지만 quote_to_transaction_rate가 낮은 카테고리는 가격·신뢰·경쟁 견적 품질을 점검해야 한다.
-- 3. avg_quotes_per_request가 높아도 거래율이 낮다면 견적 수 자체보다 견적 품질 또는 고객 기대치가 문제일 수 있다.
