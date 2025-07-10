-- Aggregate Revenue by Brand
Select b.brand,sum(f.revenue) as Revenue
from brands as b
join finance as f
ON b.product_id = f.product_id
group by b.brand;

-- Calculating Revenue Share
WITH my_ca AS (
    SELECT b.brand, SUM(f.revenue) AS totalrevenue
    FROM brands AS b
    JOIN finance AS f ON b.product_id = f.product_id
    GROUP BY b.brand
),
total_sum AS (
    SELECT SUM(totalrevenue) AS total FROM my_ca
)
SELECT ca.brand, (ca.totalrevenue / ts.total) * 100 AS revenueshare
FROM my_ca as ca,total_sum as ts;

-- Adidas with 0% Discount and Its Revenue
Select  SUM(f.revenue) AS TotalRevenue
from brands as b
join finance as f
ON b.product_id = f.product_id
where f.discount=0 and b.brand='Adidas';

-- Adidas with 0.5 % Discount and Its Revenue
Select  SUM(f.revenue) AS TotalRevenue
from brands as b
join finance as f
ON b.product_id = f.product_id
where f.discount=0.5 and b.brand='Adidas';

-- Nikes Revenue by its Discount Strategy (Single)
Select  SUM(f.revenue) AS TotalRevenue
from brands as b
join finance as f
ON b.product_id = f.product_id
where  b.brand='Nike';

-- Average discount by brands
SELECT b.brand,AVG(f.discount) * 100 AS AverageDiscountPercentage
FROM finance as f
JOIN brands as b 
ON f.product_id = b.product_id
GROUP BY b.brand;

-- distribution of the listing_price and the count for each price
SELECT 
    b.brand, 
    f.listing_price AS price, 
    COUNT(*) AS count
FROM finance AS f
INNER JOIN brands AS b ON f.product_id = b.product_id
WHERE f.listing_price > 0
GROUP BY b.brand, f.listing_price
ORDER BY f.listing_price DESC;

-- labeling price ranges
SELECT  b.brand, COUNT(*), SUM(f.revenue) as total_revenue,
CASE WHEN f.listing_price < 42 THEN 'Low'
     WHEN f.listing_price >= 42 AND f.listing_price < 74 THEN 'Medium'
     WHEN f.listing_price >= 74 AND f.listing_price < 129 THEN 'High'
     ELSE 'Very High' END AS category
FROM finance as f
JOIN brands as b 
ON f.product_id = b.product_id
GROUP BY b.brand, category
ORDER BY total_revenue DESC;

-- corelation (revenue and reviews)
SELECT
    (
        SUM(f.revenue * r.reviews) - COUNT(*) * AVG(f.revenue) * AVG(r.reviews)
    ) /
    (
        SQRT(
            (SUM(f.revenue * f.revenue) - COUNT(*) * POW(AVG(f.revenue), 2)) *
            (SUM(r.reviews * r.reviews) - COUNT(*) * POW(AVG(r.reviews), 2))
        )
    ) AS review_revenue_corr
FROM finance AS f
JOIN reviews AS r ON f.product_id = r.product_id
WHERE f.revenue IS NOT NULL AND r.reviews IS NOT NULL;

--  Ratings and reviews by product description length
SELECT 
    FLOOR(CHAR_LENGTH(description) / 100) * 100 AS description_length,
    ROUND(AVG(r.rating), 1) AS average_rating
FROM info AS i
JOIN reviews AS r 
    ON i.product_id = r.product_id
WHERE description IS NOT NULL
GROUP BY description_length
ORDER BY description_length;

-- No. of reviews by month and brand
SELECT 
    b.brand, 
    MONTH(t.last_visited) AS month,
    COUNT(*) AS numofreviews
FROM brands AS b
JOIN traffic AS t ON b.product_id = t.product_id
JOIN reviews AS r ON r.product_id = t.product_id
WHERE b.brand IS NOT NULL
  AND t.last_visited IS NOT NULL
GROUP BY b.brand, MONTH(t.last_visited)
ORDER BY b.brand, month;

 -- Top Revenue Generated Products with Brands

WITH highest_revenue_product AS
(  
   SELECT i.product_name,
          b.brand,
          revenue
   FROM finance f
   JOIN info i
   ON f.product_id = i.product_id
   JOIN brands b
   ON b.product_id = i.product_id
   WHERE product_name IS NOT NULL 
     AND revenue IS NOT NULL 
     AND brand IS NOT NULL
)
SELECT product_name,
       brand,
       revenue,
        RANK() OVER (ORDER BY revenue DESC) AS product_rank
FROM highest_revenue_product
LIMIT 10;

-- To Count footwear-related products and compute the median revenue 
WITH footwear AS (
    SELECT f.revenue
    FROM info i
    JOIN finance f 
    ON i.product_id = f.product_id
    WHERE (
        LOWER(i.description) LIKE '%shoe%' 
        OR LOWER(i.description) LIKE '%trainer%' 
        OR LOWER(i.description) LIKE '%foot%'
    )
    AND i.description IS NOT NULL
),
ranked AS (
    SELECT 
        revenue, 
        ROW_NUMBER() OVER (ORDER BY revenue) AS rn,
        COUNT(*) OVER () AS total
    FROM footwear
),
median_rows AS (
    SELECT * 
    FROM ranked
    WHERE rn = FLOOR((total + 1) / 2) 
       OR rn = CEIL((total + 1) / 2)
)
SELECT 
    (SELECT COUNT(*) FROM footwear) AS num_footwear_products,
    CASE 
        WHEN COUNT(*) = 2 THEN ROUND(AVG(revenue), 2)
        ELSE MAX(revenue)
    END AS median_footwear_revenue
FROM median_rows;


-- To Count clothing-related products and compute the median revenue 

WITH footwear AS (
    SELECT i.product_id
    FROM info i
    WHERE i.description IS NOT NULL AND (
        LOWER(i.description) LIKE '%shoe%' 
        OR LOWER(i.description) LIKE '%trainer%' 
        OR LOWER(i.description) LIKE '%foot%'
    )
),
clothing AS (
    SELECT f.revenue
    FROM info i
    JOIN finance f ON i.product_id = f.product_id
    WHERE i.product_id NOT IN (SELECT product_id FROM footwear)
      AND i.description IS NOT NULL
),
ranked_revenue AS (
    SELECT 
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue) AS rn,
        COUNT(*) OVER () AS total_count
    FROM clothing
),
median_calc AS (
    SELECT * FROM ranked_revenue
    WHERE rn = FLOOR((total_count + 1) / 2) 
       OR rn = CEIL((total_count + 1) / 2)
)
SELECT 
    MAX(total_count) AS num_clothing_products,
    CASE 
        WHEN COUNT(*) = 2 THEN ROUND(AVG(revenue), 2)
        ELSE MAX(revenue)
    END AS median_clothing_revenue
FROM median_calc;
