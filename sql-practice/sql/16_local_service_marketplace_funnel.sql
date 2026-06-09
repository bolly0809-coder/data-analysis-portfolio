-- 16_local_service_marketplace_funnel.sql
-- Purpose: 라이프서비스 중개 플랫폼의 핵심 퍼널 전환율 계산
-- Assumption: synthetic event log table `service_events`
-- Grain: one row per user event

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

-- Interpretation guide:
-- 1. step_conversion_rate가 급락하는 구간은 제품 경험상 가장 큰 이탈 구간이다.
-- 2. request_created 전 이탈은 검색 결과 품질, 전문가 상세정보, 가격 기대치 문제일 수 있다.
-- 3. quote_received 이후 이탈은 견적 가격, 응답 속도, 전문가 신뢰정보, 리뷰 노출 문제일 수 있다.
