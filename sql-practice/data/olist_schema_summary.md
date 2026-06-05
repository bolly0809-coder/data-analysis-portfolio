# Olist Schema Summary
이 문서는 `olist_ecommerce.db`의 주요 테이블과 분석 단위를 요약한 문서입니다.

## category_translation
| column | type |
|---|---|
| `product_category_name` | TEXT |
| `product_category_name_english` | TEXT |

## customers
| column | type |
|---|---|
| `customer_id` | TEXT |
| `customer_unique_id` | TEXT |
| `customer_zip_code_prefix` | INTEGER |
| `customer_city` | TEXT |
| `customer_state` | TEXT |

## geolocation
| column | type |
|---|---|
| `geolocation_zip_code_prefix` | INTEGER |
| `geolocation_lat` | REAL |
| `geolocation_lng` | REAL |
| `geolocation_city` | TEXT |
| `geolocation_state` | TEXT |

## order_base_delivered
| column | type |
|---|---|
| `order_id` | TEXT |
| `customer_id` | TEXT |
| `customer_unique_id` | TEXT |
| `customer_city` | TEXT |
| `customer_state` | TEXT |
| `order_status` | TEXT |
| `order_purchase_timestamp` | NUM |
| `purchase_date` | NUM |
| `purchase_year` | INT |
| `purchase_month` | TEXT |
| `purchase_dayofweek` | TEXT |
| `order_approved_at` | NUM |
| `order_delivered_carrier_date` | NUM |
| `order_delivered_customer_date` | NUM |
| `order_estimated_delivery_date` | NUM |
| `delivery_days` | REAL |
| `delay_days` | REAL |
| `is_delayed` | INT |
| `payment_value` | - |
| `payment_row_count` | - |
| `review_score` | - |
| `review_row_count` | - |

## order_item_base_delivered
| column | type |
|---|---|
| `order_id` | TEXT |
| `customer_id` | TEXT |
| `customer_unique_id` | TEXT |
| `customer_city` | TEXT |
| `customer_state` | TEXT |
| `purchase_year` | INT |
| `purchase_month` | TEXT |
| `delivery_days` | REAL |
| `delay_days` | REAL |
| `is_delayed` | INT |
| `order_item_id` | INT |
| `product_id` | TEXT |
| `seller_id` | TEXT |
| `price` | REAL |
| `freight_value` | REAL |
| `product_category` | - |
| `seller_city` | TEXT |
| `seller_state` | TEXT |
| `review_score` | - |

## order_items
| column | type |
|---|---|
| `order_id` | TEXT |
| `order_item_id` | INTEGER |
| `product_id` | TEXT |
| `seller_id` | TEXT |
| `shipping_limit_date` | TIMESTAMP |
| `price` | REAL |
| `freight_value` | REAL |

## order_payments
| column | type |
|---|---|
| `order_id` | TEXT |
| `payment_sequential` | INTEGER |
| `payment_type` | TEXT |
| `payment_installments` | INTEGER |
| `payment_value` | REAL |

## order_reviews
| column | type |
|---|---|
| `review_id` | TEXT |
| `order_id` | TEXT |
| `review_score` | INTEGER |
| `review_comment_title` | TEXT |
| `review_comment_message` | TEXT |
| `review_creation_date` | TIMESTAMP |
| `review_answer_timestamp` | TIMESTAMP |

## orders
| column | type |
|---|---|
| `order_id` | TEXT |
| `customer_id` | TEXT |
| `order_status` | TEXT |
| `order_purchase_timestamp` | TIMESTAMP |
| `order_approved_at` | TIMESTAMP |
| `order_delivered_carrier_date` | TIMESTAMP |
| `order_delivered_customer_date` | TIMESTAMP |
| `order_estimated_delivery_date` | TIMESTAMP |

## orders_enriched
| column | type |
|---|---|
| `order_id` | TEXT |
| `customer_id` | TEXT |
| `order_status` | TEXT |
| `order_purchase_timestamp` | TIMESTAMP |
| `order_approved_at` | TIMESTAMP |
| `order_delivered_carrier_date` | TIMESTAMP |
| `order_delivered_customer_date` | TIMESTAMP |
| `order_estimated_delivery_date` | TIMESTAMP |
| `purchase_date` | DATE |
| `purchase_year` | INTEGER |
| `purchase_month` | TEXT |
| `purchase_dayofweek` | TEXT |
| `delivery_days` | REAL |
| `delay_days` | REAL |
| `is_delayed` | INTEGER |

## payment_by_order
| column | type |
|---|---|
| `order_id` | TEXT |
| `payment_value` | - |
| `payment_row_count` | - |
| `payment_type_count` | - |

## products
| column | type |
|---|---|
| `product_id` | TEXT |
| `product_category_name` | TEXT |
| `product_name_lenght` | REAL |
| `product_description_lenght` | REAL |
| `product_photos_qty` | REAL |
| `product_weight_g` | REAL |
| `product_length_cm` | REAL |
| `product_height_cm` | REAL |
| `product_width_cm` | REAL |

## review_by_order
| column | type |
|---|---|
| `order_id` | TEXT |
| `review_score` | - |
| `review_row_count` | - |

## sellers
| column | type |
|---|---|
| `seller_id` | TEXT |
| `seller_zip_code_prefix` | INTEGER |
| `seller_city` | TEXT |
| `seller_state` | TEXT |
