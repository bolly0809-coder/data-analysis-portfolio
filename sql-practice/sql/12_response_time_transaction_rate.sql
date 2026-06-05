-- Business Question:
-- 견적 응답 속도 구간별 거래 성사율은 어떻게 다른가?
--
-- Dataset:
-- Synthetic Service Analytics Dataset
--
-- Skills:
-- CASE WHEN, JOIN, GROUP BY, 전환율 계산
--
-- Interpretation:
-- 응답 속도는 서비스 운영 품질 지표이며 거래 성사율과 함께 확인할 수 있다.
--
-- Limitation:
-- synthetic dataset의 경향이며 실제 인과관계나 운영 성과로 해석하지 않는다.


WITH response_group AS (
    SELECT
        sr.request_id,
        sr.service_category,
        q.response_minutes,
        CASE
            WHEN q.response_minutes <= 30 THEN '01_under_30m'
            WHEN q.response_minutes <= 60 THEN '02_31_to_60m'
            WHEN q.response_minutes <= 180 THEN '03_61_to_180m'
            ELSE '04_over_180m'
        END AS response_time_group,
        CASE WHEN t.transaction_id IS NOT NULL THEN 1 ELSE 0 END AS is_transaction
    FROM service_requests sr
    JOIN quotes q
        ON sr.request_id = q.request_id
    LEFT JOIN transactions t
        ON sr.request_id = t.request_id
)
SELECT
    response_time_group,
    COUNT(*) AS quote_count,
    ROUND(AVG(response_minutes), 2) AS avg_response_minutes,
    SUM(is_transaction) AS transaction_count,
    ROUND(100.0 * SUM(is_transaction) / COUNT(*), 2) AS transaction_rate_pct
FROM response_group
GROUP BY response_time_group
ORDER BY response_time_group;
