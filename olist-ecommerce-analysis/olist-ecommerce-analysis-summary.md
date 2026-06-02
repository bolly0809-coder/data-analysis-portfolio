# Olist Ecommerce Analysis Summary

## Project

Olist ecommerce order, delivery, and review data analysis.

## Purpose

This mini project uses the public Olist Brazilian E-Commerce dataset to demonstrate SQL joins, aggregation, window functions, pandas preprocessing, and portfolio-ready visualization.

The dataset is transaction-oriented. It does not include clickstream, cart, impression, or pageview logs, so the analysis is limited to order, payment, delivery, and review data.

## Data

- orders
- order items
- payments
- reviews
- customers
- sellers
- products
- geolocation
- product category translation

Total orders: 99,441.
Delivered orders: 96,478.
Delivered orders were used as the main analysis scope for delivery and review analysis.

## Key Tables

- payment_by_order: order-level payment aggregation
- review_by_order: order-level review score aggregation
- order_base_delivered: delivered order-level base table
- order_item_base_delivered: delivered item-level base table

## Key Results

- Monthly order count and revenue increased after 2017 and stayed at a relatively high level after late 2017.
- Top revenue categories included health_beauty, watches_gifts, bed_bath_table, sports_leisure, and computers_accessories.
- Top 20 categories accounted for about 84.06 percent of product revenue.
- Some customer states showed higher delivery delay rates, but this should be interpreted as an operational review signal rather than a single-cause regional issue.
- Average review score decreased as delivery delay became longer.

## Review Score by Delivery Delay

| Delivery group | Avg review score | Low score rate | 5-star rate |
|---|---:|---:|---:|
| Early 7+ days | 4.32 | 8.94% | 63.58% |
| Early 1-6 days | 4.20 | 10.21% | 57.43% |
| Delayed 1-3 days | 3.77 | 19.08% | 43.13% |
| Delayed 4-7 days | 2.32 | 61.25% | 18.10% |
| Delayed 8+ days | 1.73 | 78.32% | 7.47% |

## Limitations

- No clickstream, cart, impression, or pageview logs.
- No funnel or conversion-rate analysis.
- Delivery delay and review score differences should not be interpreted as causal proof.
- Review score may also be affected by product quality, seller response, price, and customer expectation.
- Product category revenue is based on order_items.price.
- Repeat purchase rate was about 3 percent, so cohort retention analysis was excluded from the main analysis.

## Resume Bullet

Olist ecommerce order, delivery, and review data analysis | Personal mini project
- Loaded 9 public Olist ecommerce tables into SQLite and used SQL JOIN, GROUP BY, CTE, and Window Functions to analyze monthly orders, revenue, average order value, and category revenue contribution.
- Created delivery days, delay days, and delay flag variables to compare delivery delay rates by customer state and review-score differences by delivery-delay group.
- Explicitly limited the analysis to order, delivery, and review data because the dataset does not contain clickstream or cart logs.
