-- Missing Values:

-- Count of Product IDs without a Brand Name
SELECT COUNT(*) as MissingBrand
FROM brands
WHERE brand IS NULL OR brand = '';

-- Count of Products by Brand
SELECT brand, COUNT(DISTINCT product_id) as ProductCount
FROM brands
WHERE brand IN ('Adidas', 'Nike')
GROUP BY brand;

-- Identifying Products with Missing  Details in Finance table
SELECT product_id
FROM finance
WHERE listing_price IS NULL AND sale_price IS NULL AND discount IS NULL AND revenue IS NULL;

-- Count of Products not having Last Visited Date
SELECT COUNT(*) AS MissingLastVisitedCount
FROM traffic
WHERE last_visited IS NULL;

-- Removing unimportant values
CREATE TEMPORARY TABLE temp_product_ids (
    product_id VARCHAR(255)
);

-- Step 2: Insert product IDs with missing brand
INSERT INTO temp_product_ids (product_id)
SELECT product_id
FROM brands
WHERE brand IS NULL OR brand = '';

-- Step 3: Delete from related tables using the temp table
DELETE FROM brands
WHERE product_id IN (SELECT product_id FROM temp_product_ids);

DELETE FROM finance
WHERE product_id IN (SELECT product_id FROM temp_product_ids);

DELETE FROM info
WHERE product_id IN (SELECT product_id FROM temp_product_ids);

DELETE FROM reviews
WHERE product_id IN (SELECT product_id FROM temp_product_ids);

DELETE FROM traffic
WHERE product_id IN (SELECT product_id FROM temp_product_ids);

