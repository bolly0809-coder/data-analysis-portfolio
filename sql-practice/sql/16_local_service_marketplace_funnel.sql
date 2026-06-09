-- 16_local_service_marketplace_funnel.sql
-- Case: Local Service Marketplace Product Analytics
-- Business Question:
--   In a local service marketplace, where do users drop off across the funnel?
--   Visit -> Search -> Provider Detail View -> Request -> Quote Received -> Transaction -> Review.
--
-- Product Decision:
--   Use the largest conversion drop to prioritize product questions around search quality,
--   provider profile information, request form UX, quote receiving experience, and transaction conversion.
--
-- Data Assumption:
--   synthetic event log table `service_events`
--   Grain: one row per user event
--   This query is for SQL structure practice, not actual company performance reporting.

WITH user_funnel AS (
    SELECT
        user_id,
        MAX(CASE WHEN event_name = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_name = 'search' THEN 1 ELSE 0 END) AS searched,
        MAX(CASE WHEN event_name = 'provider_detail_view' THEN 1 ELSE 0 END) AS viewed_provider,
        MAX(CASE WHEN event_name = 'request_created' THEN 1 ELSE 0 END) AS requested,
        MAX(CASE WHEN event_name = 'quote_received' THEN 1 ELSE 0 END) AS quote_received,
        MAX(CASE WHEN event_name = 'transaction_completed' THEN 1 ELSE 0 END) AS transacted,
        MAX(CASE WHEN event_name = 'review_written' THEN 1 ELSE 0 END) AS reviewed
    FROM service_events
    GROUP BY user_id
),
funnel_counts AS (
    SELECT '01_visit' AS step, COUNT(DISTINCT CASE WHEN visited = 1 THEN user_id END) AS users FROM user_funnel
    UNION ALL
    SELECT '02_search', COUNT(DISTINCT CASE WHEN searched = 1 THEN user_id END) FROM user_funnel
    UNION ALL
    SELECT '03_provider_detail_view', COUNT(DISTINCT CASE WHEN viewed_provider = 1 THEN user_id END) FROM user_funnel
    UNION ALL
    SELECT '04_request_created', COUNT(DISTINCT CASE WHEN requested = 1 THEN user_id END) FROM user_funnel
    UNION ALL
    SELECT '05_quote_received', COUNT(DISTINCT CASE WHEN quote_received = 1 THEN user_id END) FROM user_funnel
    UNION ALL
    SELECT '06_transaction_completed', COUNT(DISTINCT CASE WHEN transacted = 1 THEN user_id END) FROM user_funnel
    UNION ALL
    SELECT '07_review_written', COUNT(DISTINCT CASE WHEN reviewed = 1 THEN user_id END) FROM user_funnel
),
funnel_with_prev AS (
    SELECT
        step,
        users,
        LAG(users) OVER (ORDER BY step) AS prev_step_users,
        FIRST_VALUE(users) OVER (ORDER BY step) AS first_step_users
    FROM funnel_counts
)
SELECT
    step,
    users,
    prev_step_users,
    ROUND(100.0 * users / NULLIF(prev_step_users, 0), 2) AS step_conversion_rate,
    ROUND(100.0 * users / NULLIF(first_step_users, 0), 2) AS total_conversion_rate
FROM funnel_with_prev
ORDER BY step;

-- Interpretation Guide:
-- 1. A low detail_view -> request_created rate may indicate issues in provider profile information, expected price, reviews, or request form UX.
-- 2. A low request_created -> quote_received rate may indicate provider supply shortage, local matching issues, or low request quality.
-- 3. A low quote_received -> transaction_completed rate may indicate price mismatch, weak quote quality, provider trust issues, or follow-up friction.
-- 4. Funnel conversion is only the starting point; category, region, and acquisition channel segments should be checked before deciding product actions.
