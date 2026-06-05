-- Business Question:
-- 방문 → 검색 → 상세조회 → 요청 → 견적 → 거래 → 리뷰 작성 퍼널의 단계별 전환율은 어떻게 나타나는가?
--
-- Dataset:
-- Synthetic Service Analytics Dataset
--
-- Skills:
-- CTE, UNION ALL, Window Function, COUNT DISTINCT, 단계별 전환율 계산
--
-- Interpretation:
-- Product DA는 전체 방문자 수보다 단계별 전환율과 이탈 지점을 함께 확인해야 한다.
--
-- Limitation:
-- 이 데이터는 실제 서비스 데이터가 아니라 SQL 분석 구조를 보여주기 위한 synthetic dataset이다.


WITH funnel AS (
    SELECT '01_visit' AS step, COUNT(DISTINCT user_id) AS users FROM events WHERE event_name = 'visit'
    UNION ALL
    SELECT '02_search', COUNT(DISTINCT user_id) FROM events WHERE event_name = 'search'
    UNION ALL
    SELECT '03_view_provider', COUNT(DISTINCT user_id) FROM events WHERE event_name = 'view_provider'
    UNION ALL
    SELECT '04_submit_request', COUNT(DISTINCT user_id) FROM events WHERE event_name = 'submit_request'
    UNION ALL
    SELECT '05_view_quote', COUNT(DISTINCT user_id) FROM events WHERE event_name = 'view_quote'
    UNION ALL
    SELECT '06_complete_transaction', COUNT(DISTINCT user_id) FROM events WHERE event_name = 'complete_transaction'
    UNION ALL
    SELECT '07_write_review', COUNT(DISTINCT user_id) FROM events WHERE event_name = 'write_review'
),
with_base AS (
    SELECT
        step,
        users,
        FIRST_VALUE(users) OVER (ORDER BY step) AS visit_users,
        LAG(users) OVER (ORDER BY step) AS prev_step_users
    FROM funnel
)
SELECT
    step,
    users,
    ROUND(100.0 * users / visit_users, 2) AS conversion_from_visit_pct,
    CASE
        WHEN prev_step_users IS NULL THEN NULL
        ELSE ROUND(100.0 * users / prev_step_users, 2)
    END AS conversion_from_previous_step_pct
FROM with_base
ORDER BY step;
