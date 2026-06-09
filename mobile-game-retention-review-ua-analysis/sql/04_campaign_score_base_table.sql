SELECT
    campaign_id,
    channel,
    country,
    creative_type,
    SUM(spend) AS spend,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(installs) AS installs,
    ROUND(SUM(clicks) * 1.0 / NULLIF(SUM(impressions), 0), 4) AS ctr,
    ROUND(SUM(installs) * 1.0 / NULLIF(SUM(clicks), 0), 4) AS cvr,
    ROUND(SUM(spend) * 1.0 / NULLIF(SUM(installs), 0), 4) AS cpi,
    ROUND(AVG(tutorial_completion_rate), 4) AS tutorial_completion_rate,
    ROUND(AVG(d1_retention), 4) AS d1_retention,
    ROUND(AVG(d7_retention), 4) AS d7_retention,
    ROUND(SUM(d7_revenue) * 1.0 / NULLIF(SUM(spend), 0), 4) AS d7_roas
FROM campaign_modeling_table
GROUP BY campaign_id, channel, country, creative_type;