Create Database sports;

CREATE TABLE info
(
    product_name VARCHAR(100),
    product_id VARCHAR(11) PRIMARY KEY,
    description VARCHAR(700)
);
CREATE TABLE finance
(
    product_id VARCHAR(11) PRIMARY KEY,
    listing_price FLOAT,
    sale_price FLOAT,
    discount FLOAT,
    revenue FLOAT
);
DROP TABLE brands;

CREATE TABLE brands
(
    product_id VARCHAR(11) PRIMARY KEY,
    brand VARCHAR(7)
);
CREATE TABLE traffic
(
    product_id VARCHAR(11) PRIMARY KEY,
    last_visited TIMESTAMP
);
CREATE TABLE reviews
(
    product_id VARCHAR(11) PRIMARY KEY,
    rating FLOAT,
    reviews FLOAT
);