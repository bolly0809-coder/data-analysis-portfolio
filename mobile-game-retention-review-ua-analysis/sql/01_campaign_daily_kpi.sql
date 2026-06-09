SELECT
    s.date,
    s.campaign_id,
    s.channel,
    s.country,
    s.creative_type,
    s.spend,
    s.impressions,
    s.clicks,
    p.installs,
    ROUND(CAST(s.clicks AS REAL) / NULLIF(s.impressions, 0), 4) AS ctr,
    ROUND(CAST(p.installs AS REAL) / NULLIF(s.clicks, 0), 4) AS cvr,
    ROUND(CAST(s.spend AS REAL) / NULLIF(p.installs, 0), 4) AS cpi,
    p.tutorial_completion_rate,
    p.d1_retention,
    p.d7_retention,
    p.d7_revenue,
    ROUND(CAST(p.d7_revenue AS REAL) / NULLIF(s.spend, 0), 4) AS d7_roas
FROM campaign_spend s
JOIN campaign_performance p
    ON s.date = p.date
   AND s.campaign_id = p.campaign_id;