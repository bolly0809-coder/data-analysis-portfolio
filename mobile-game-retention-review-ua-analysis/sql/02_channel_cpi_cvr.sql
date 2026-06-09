WITH channel_base AS (
    SELECT
        s.channel,
        SUM(s.spend) AS spend,
        SUM(s.impressions) AS impressions,
        SUM(s.clicks) AS clicks,
        SUM(p.installs) AS installs,
        SUM(p.d7_revenue) AS d7_revenue
    FROM campaign_spend s
    JOIN campaign_performance p
        ON s.date = p.date
       AND s.campaign_id = p.campaign_id
    GROUP BY s.channel
)
SELECT
    channel,
    spend,
    impressions,
    clicks,
    installs,
    ROUND(CAST(clicks AS REAL) / NULLIF(impressions, 0), 4) AS ctr,
    ROUND(CAST(installs AS REAL) / NULLIF(clicks, 0), 4) AS cvr,
    ROUND(CAST(spend AS REAL) / NULLIF(installs, 0), 4) AS cpi,
    ROUND(CAST(d7_revenue AS REAL) / NULLIF(spend, 0), 4) AS d7_roas
FROM channel_base
ORDER BY d7_roas DESC;