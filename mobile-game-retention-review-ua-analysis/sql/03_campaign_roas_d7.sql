SELECT
    campaign_id,
    channel,
    country,
    creative_type,
    SUM(spend) AS spend,
    SUM(installs) AS installs,
    ROUND(SUM(spend) / NULLIF(SUM(installs), 0), 4) AS cpi,
    ROUND(AVG(d1_retention), 4) AS avg_d1_retention,
    ROUND(AVG(d7_retention), 4) AS avg_d7_retention,
    SUM(d7_revenue) AS d7_revenue,
    ROUND(SUM(d7_revenue) / NULLIF(SUM(spend), 0), 4) AS d7_roas
FROM campaign_modeling_table
GROUP BY campaign_id, channel, country, creative_type
ORDER BY d7_roas DESC;