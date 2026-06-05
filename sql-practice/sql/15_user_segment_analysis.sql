-- Business Question:
-- 유입 채널과 디바이스 조합별 요청/거래 전환율은 어떻게 다른가?
--
-- Dataset:
-- Synthetic Service Analytics Dataset
--
-- Skills:
-- 세그먼트 분석, LEFT JOIN, GROUP BY, HAVING, 조건부 집계
--
-- Interpretation:
-- 사용자 그룹별 전환 차이를 확인해 마케팅·제품 개선 후보를 찾는다.
--
-- Limitation:
-- synthetic dataset의 세그먼트 결과이며 실제 채널 성과를 의미하지 않는다.


WITH user_level AS (
    SELECT
        u.user_id,
        u.region,
        u.acquisition_channel,
        MAX(e.device) AS main_device,
        COUNT(DISTINCT e.session_id) AS session_count,
        COUNT(DISTINCT sr.request_id) AS request_count,
        COUNT(DISTINCT t.transaction_id) AS transaction_count
    FROM users u
    LEFT JOIN events e
        ON u.user_id = e.user_id
    LEFT JOIN service_requests sr
        ON u.user_id = sr.user_id
    LEFT JOIN transactions t
        ON u.user_id = t.user_id
    GROUP BY u.user_id, u.region, u.acquisition_channel
)
SELECT
    acquisition_channel,
    main_device,
    COUNT(*) AS user_count,
    ROUND(AVG(session_count), 2) AS avg_sessions,
    ROUND(100.0 * SUM(CASE WHEN request_count > 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS request_user_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN transaction_count > 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS transaction_user_rate_pct
FROM user_level
GROUP BY acquisition_channel, main_device
HAVING COUNT(*) >= 10
ORDER BY transaction_user_rate_pct DESC, user_count DESC;
