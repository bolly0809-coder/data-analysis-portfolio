-- Business Question:
-- A/B 그룹별 요청 전환율, 거래 전환율, 평균 거래금액은 어떻게 다른가?
--
-- Dataset:
-- Synthetic Service Analytics Dataset
--
-- Skills:
-- 실험군/대조군 집계, 전환율 계산, 평균값 비교
--
-- Interpretation:
-- 실험 결과를 SQL로 1차 집계해 그룹별 차이를 확인한다.
--
-- Limitation:
-- 이 쿼리는 SQL 집계 예시이며, 통계적 유의성 검정까지 수행한 A/B 테스트 분석은 아니다.


WITH user_group AS (
    SELECT
        user_id,
        MIN(ab_group) AS ab_group
    FROM events
    GROUP BY user_id
),
group_summary AS (
    SELECT
        ug.ab_group,
        COUNT(DISTINCT ug.user_id) AS users,
        COUNT(DISTINCT sr.request_id) AS request_users,
        COUNT(DISTINCT t.transaction_id) AS transaction_count,
        ROUND(AVG(t.transaction_amount), 2) AS avg_transaction_amount
    FROM user_group ug
    LEFT JOIN service_requests sr
        ON ug.user_id = sr.user_id
    LEFT JOIN transactions t
        ON ug.user_id = t.user_id
    GROUP BY ug.ab_group
)
SELECT
    ab_group,
    users,
    request_users,
    transaction_count,
    ROUND(100.0 * request_users / users, 2) AS request_conversion_rate_pct,
    ROUND(100.0 * transaction_count / users, 2) AS transaction_conversion_rate_pct,
    avg_transaction_amount
FROM group_summary
ORDER BY ab_group;
