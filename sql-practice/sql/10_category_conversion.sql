-- Business Question:
-- 서비스 카테고리별 요청→견적→거래 전환율은 어떻게 다른가?
--
-- Dataset:
-- Synthetic Service Analytics Dataset
--
-- Skills:
-- LEFT JOIN, GROUP BY, 세그먼트별 전환율 계산
--
-- Interpretation:
-- 요청 수는 많지만 거래 성사율이 낮은 카테고리는 병목 분석 후보가 된다.
--
-- Limitation:
-- synthetic dataset이므로 특정 카테고리의 실제 시장성을 의미하지 않는다.


WITH category_base AS (
    SELECT
        sr.service_category,
        COUNT(DISTINCT sr.request_id) AS request_count,
        COUNT(DISTINCT q.quote_id) AS quote_count,
        COUNT(DISTINCT t.transaction_id) AS transaction_count,
        ROUND(AVG(q.response_minutes), 2) AS avg_response_minutes,
        ROUND(AVG(t.transaction_amount), 2) AS avg_transaction_amount
    FROM service_requests sr
    LEFT JOIN quotes q
        ON sr.request_id = q.request_id
    LEFT JOIN transactions t
        ON sr.request_id = t.request_id
    GROUP BY sr.service_category
)
SELECT
    service_category,
    request_count,
    quote_count,
    transaction_count,
    ROUND(100.0 * quote_count / request_count, 2) AS quote_receive_rate_pct,
    ROUND(100.0 * transaction_count / request_count, 2) AS request_to_transaction_rate_pct,
    avg_response_minutes,
    avg_transaction_amount
FROM category_base
ORDER BY request_to_transaction_rate_pct DESC;
