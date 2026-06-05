-- Synthetic Service Analytics Dataset
-- 실제 회사 데이터가 아니라 Product Analytics SQL 연습용 가상 데이터셋의 DDL입니다.

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id TEXT PRIMARY KEY,
    signup_date DATE,
    region TEXT,
    acquisition_channel TEXT,
    user_type TEXT
);

DROP TABLE IF EXISTS events;
CREATE TABLE events (
    event_id TEXT PRIMARY KEY,
    user_id TEXT,
    event_time TIMESTAMP,
    event_name TEXT,
    service_category TEXT,
    provider_id TEXT,
    session_id TEXT,
    device TEXT,
    ab_group TEXT
);

DROP TABLE IF EXISTS service_requests;
CREATE TABLE service_requests (
    request_id TEXT PRIMARY KEY,
    user_id TEXT,
    provider_id TEXT,
    service_category TEXT,
    request_time TIMESTAMP,
    region TEXT,
    request_status TEXT
);

DROP TABLE IF EXISTS quotes;
CREATE TABLE quotes (
    quote_id TEXT PRIMARY KEY,
    request_id TEXT,
    provider_id TEXT,
    quote_time TIMESTAMP,
    quote_price REAL,
    response_minutes INTEGER
);

DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
    transaction_id TEXT PRIMARY KEY,
    request_id TEXT,
    user_id TEXT,
    provider_id TEXT,
    transaction_time TIMESTAMP,
    transaction_amount REAL,
    transaction_status TEXT
);

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
    review_id TEXT PRIMARY KEY,
    transaction_id TEXT,
    user_id TEXT,
    provider_id TEXT,
    review_score INTEGER,
    review_time TIMESTAMP
);
