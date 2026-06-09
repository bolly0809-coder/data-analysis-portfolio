-- 20_provider_supply_response_quality.sql
-- Case: Local Service Marketplace Product Analytics
-- Business Question:
--   Which providers send many quotes, respond quickly, and convert quotes into transactions?
--
-- Product Decision:
--   Provider-side metrics can support supply quality monitoring, provider activation,
--   exposure policy, and coaching priorities.
--
-- Data Assumption:
--   synthetic tables: quotes, requests, transactions, reviews, providers
--   quotes grain: one row per provider quote
--   transactions grain: one row per completed transaction
--
-- Join Caution:
--   A provider can send many quotes, and one request can receive many quotes.
--   Build provider-level metrics after calculating quote-level and request-level outcomes.

WITH quote_base AS (
    SELECT
        q.quote_id,
        q.request_id,
        q.provider_id,
        r.category_id,
        r.region,
        r.created_at AS request_created_at,
        q.created_at AS quote_created_at,
        ROUND((JULIANDAY(q.created_at) - JULIANDAY(r.created_at)) * 24 * 60, 1) AS response_minutes,
        CASE WHEN t.transaction_id IS NOT NULL THEN 1 ELSE 0 END AS has_transaction
    FROM quotes q
    INNER JOIN requests r
        ON q.request_id = r.request_id
    LEFT JOIN transactions t
        ON q.request_id = t.request_id
        AND q.provider_id = t.provider_id
),
provider_review AS (
    SELECT
        provider_id,
        COUNT(DISTINCT review_id) AS review_count,
        ROUND(AVG(review_score), 2) AS avg_review_score
    FROM reviews
    GROUP BY provider_id
),
provider_metrics AS (
    SELECT
        q.provider_id,
        COUNT(DISTINCT q.quote_id) AS quote_count,
        COUNT(DISTINCT q.request_id) AS quoted_request_count,
        COUNT(DISTINCT CASE WHEN q.has_transaction = 1 THEN q.request_id END) AS transaction_count,
        ROUND(AVG(q.response_minutes), 1) AS avg_response_minutes,
        ROUND(100.0 * COUNT(DISTINCT CASE WHEN q.has_transaction = 1 THEN q.request_id END)
            / NULLIF(COUNT(DISTINCT q.request_id), 0), 2) AS quote_to_transaction_rate
    FROM quote_base q
    GROUP BY q.provider_id
)
SELECT
    p.provider_id,
    p.quote_count,
    p.quoted_request_count,
    p.transaction_count,
    p.quote_to_transaction_rate,
    p.avg_response_minutes,
    COALESCE(r.review_count, 0) AS review_count,
    r.avg_review_score,
    CASE
        WHEN p.quote_count >= 30 AND p.quote_to_transaction_rate >= 30 THEN 'high_volume_high_conversion'
        WHEN p.quote_count >= 30 AND p.quote_to_transaction_rate < 15 THEN 'high_volume_low_conversion'
        WHEN p.quote_count < 10 AND p.quote_to_transaction_rate >= 30 THEN 'low_volume_high_conversion'
        ELSE 'monitor'
    END AS provider_segment
FROM provider_metrics p
LEFT JOIN provider_review r
    ON p.provider_id = r.provider_id
WHERE p.quote_count >= 5
ORDER BY p.quote_to_transaction_rate DESC, p.quote_count DESC;

-- Interpretation Guide:
-- 1. high_volume_high_conversion providers may be strong supply partners.
-- 2. high_volume_low_conversion providers may need quote quality, pricing, profile, or communication review.
-- 3. low_volume_high_conversion providers may be candidates for more exposure if supply quality is stable.
-- 4. Provider segmentation should not be used for final decisions without category and region context.
