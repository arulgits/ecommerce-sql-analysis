USE ecommerce_sql_portfolio;
SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products;


-- TODO 1: Profile NULL values in each table and decide which fields need handling.
-- Task 1: Find customers with missing phone numbers.

SELECT customer_id, phone
FROM customers
WHERE phone IS NULL;

-- Task 2: Find customers whose city information is missing.

SELECT customer_id, city
FROM customers
WHERE city IS NULL;

-- Task 3: Profile Missing Values Across Customer Fields.
-- Business Question:
-- How many missing (NULL) values are present in email, phone, city, and state_region in the customers table?

SELECT 'phone' AS field,
COUNT( CASE WHEN phone IS NULL THEN 1 END ) AS missing_count
FROM customers
UNION ALL
SELECT 'email' AS field,
COUNT( CASE WHEN email IS NULL THEN 1 END ) AS missing_count
FROM customers
UNION ALL
SELECT 'city' AS field,
COUNT( CASE WHEN city IS NULL THEN 1 END ) AS missing_count
FROM customers
UNION ALL
SELECT 'state_region' AS field,
COUNT( CASE WHEN state_region IS NULL THEN 1 END ) AS missing_count
FROM customers;

-- Task 4: Products: Identify Missing Values
-- Business question:
-- Before using the product data for analysis, identify products with missing cost_price.

SELECT product_id, product_name, cost_price 
FROM products
WHERE cost_price IS NULL;

-- Task 5: Products: Missing Supplier Information
-- Business question:
-- Which products are missing supplier information?

SELECT product_id, product_name, supplier_name 
FROM products
WHERE supplier_name IS NULL;

-- Task 6: Orders: Profile Missing Shipping Information
-- Business question:
-- How many orders have missing shipping_city and how many have missing shipping_state?

SELECT 'shipping_city' AS ORDERS,
COUNT( CASE WHEN shipping_city IS NULL THEN 1 END) AS missing_count
FROM orders
UNION ALL
SELECT 'shipping_state' AS ORDERS,
COUNT( CASE WHEN shipping_state IS NULL THEN 1 END) AS missing_count
FROM orders;

-- Task 7:  Order Items: Missing Item Price
-- Business question:
-- Which order items have a missing (NULL) unit_price?

SELECT order_item_id, order_id, product_id, unit_price
FROM order_items
WHERE unit_price IS NULL;


-- TODO 2: STANDARDIZE INCONSISTENT CATEGORY, CUSTOMER STATE/REGION, PAYMENT METHOD,
-- AND ORDER STATUS VALUES. CONSIDER TRIM(), LOWER()/UPPER(), CASE, OR MAPPING TABLES.
-- Task 8: Inspect Product Categories
-- Before cleaning anything, we need to see exactly which category values exist.
-- Business question:
-- What are all the unique category values currently stored in the products table?

SELECT DISTINCT category
FROM products;

-- Task 9: Identify Product Categories With Extra Spaces
-- Business Question:
-- Which product categories contain leading or trailing spaces that need to be cleaned?

SELECT category
FROM products
WHERE category <> TRIM(category);

-- Task 10: Standardize Product Category Capitalization
-- Busianess Question:
-- How can we make all product category values use the same capitalization format?

SELECT CASE 
WHEN TRIM(category) = 'Home and Office' THEN 'HOME & OFFICE'
WHEN TRIM(category) = 'Home and Decor' THEN 'HOME & DECOR'
WHEN TRIM(category) = 'Sports and Fitness' THEN 'SPORTS & FITNESS'
WHEN TRIM(category) = 'Stationary' THEN 'STATIONERY'
ELSE UPPER(TRIM(category)) END AS Category
FROM products;

-- Task 11: Inspect Order Status Values
-- Business Question:
-- What unique order_status values currently exist in the orders table?

SELECT DISTINCT order_status
 FROM orders;

-- Task 12: Identify Order Status Formatting Issues
-- Business Question:
-- Which order status values contain extra spaces or inconsistent formatting that can be detected using TRIM()?

SELECT order_status 
FROM orders
WHERE order_status <> TRIM(order_status);

-- Task 13: Standardize Payment Methods
-- Business Question:
-- Create a cleaned payment_method column where extra spaces are removed and capitalization is made consistent.

SELECT UPPER(TRIM(payment_method)) AS payment_method
FROM orders;

-- Task 14: Standardize Customer State/Region
-- Business Question:
-- Identify the different state_region values in the customers table so we can determine which ones represent the same state but are written differently.

SELECT DISTINCT CASE 
WHEN state_region = 'UP' THEN 'Uttar Pradesh'
ELSE state_region END AS State_Region
FROM customers;

-- TODO 3: IDENTIFY & HANDLE DUPLICATES
-- Task 15: To decide how to handle the duplicate customer profiles.
-- Business question:
-- For duplicate emails, how can we compare their customer_id, first_name, last_name, city, and state_region?

SELECT customer_id, first_name, last_name, city, state_region
FROM customers
WHERE email IN (
SELECT email
FROM customers
GROUP BY email
HAVING count(email) > 1);

-- Task 16: Inspect Duplicate Product Names
-- Business Question:
-- We identified that some products have the same product_name. Which product names are duplicated, and how many times does each appear?

SELECT product_name, COUNT(*) AS count
FROM products
GROUP BY product_name
HAVING COUNT(*) > 1;

-- Task 17: Inspect Duplicate Order-Item Records
-- Business Question:
-- We already identified that some order_items lines are duplicated. Now we want to see the complete records of those duplicates.

SELECT order_id, product_id, quantity, unit_price, discount_rate,
COUNT(*) AS count
FROM order_items
GROUP BY order_id, product_id, quantity, unit_price, discount_rate
HAVING COUNT(*) > 1;

-- Task 18: View the Actual Duplicate Rows
-- Business Question: 
-- How can we retrieve those full rows?

SELECT order_item_id, order_id, product_id, quantity, unit_price, discount_rate
FROM order_items
WHERE order_id = 4
  AND product_id = 1004
  AND quantity = 2
  AND unit_price = 5999.00
  AND discount_rate = 0.00;
  
  -- Task 19: Decide How to Handle Duplicate Order-Item Records
  -- business decision:
  -- These two rows represent the same order item entered twice. What should we do?
  
  -- ANSWER: Duplicate order-item rule: Keep the raw duplicate records unchanged, but flag potential duplicates in the cleaned/analysis layer to avoid counting the same order item twice.
  
  
  -- TODO 4: BUSINESS-RULE VALIDATION
  -- Task 20: Validate Zero-Quantity Order Items
  -- Business Question:
  -- Which order-item records have a quantity of 0, and should they be included in sales calculations?
  
SELECT order_item_id, order_id, product_id, quantity
FROM order_items
WHERE quantity = 0;

-- Task 21: Decide How to Handle Zero Quantity
-- Business Question:
-- If an order item has quantity = 0, should it be counted as a sale?

-- Answer: Rule: Zero-quantity order items should be excluded from sales/revenue calculations and flagged as invalid data.

-- Task 22:  Validate Invalid Discount Rates
-- Business Question:
-- Which order-item records have a discount rate outside the valid 0%–100% range?

SELECT order_item_id, order_id, product_id, discount_rate
FROM order_items
WHERE discount_rate < 0
   OR discount_rate > 1;
   
-- Rule:
-- Discount rate must be between 0% and 100%.
-- If the actual discount is known, use the verified value.
-- If it cannot be verified, flag the record as invalid rather than guessing.
   
-- Task 23: Identify NULL unit_price Records
-- Business Question:
-- Which order-item records have a missing unit_price before we calculate revenue?

SELECT order_item_id, order_id, product_id, unit_price
FROM order_items
WHERE unit_price IS NULL;

-- Task 24: Decide How to Handle NULL unit_price
-- Business Question:
-- If an order item has no unit_price, what should we use before calculating revenue?

-- Answer: If order_items.unit_price is NULL, use the corresponding products.unit_price as a fallback. If that is also unavailable, flag the record rather than guessing.

-- Task 25: Validate the NULL unit_price Fallback
-- Business Question:
-- For order items where unit_price is NULL, can we retrieve the corresponding product price from products?

SELECT order_items.order_item_id,
	   order_items.product_id,
       order_items.unit_price AS item_price,
       products.unit_price AS product_price
FROM order_items
LEFT JOIN products
ON order_items.product_id = products.product_id
WHERE order_items.unit_price IS NULL;

-- Task 26: Investigate Inactive Products
-- Business Question:
-- Which products are currently inactive, and should inactive products
-- be excluded from future sales analysis or simply flagged?

SELECT product_id, product_name, category, unit_price, active_flag
FROM products
WHERE active_flag = 'N';

-- Rule: Inactive products remain in the dataset for historical integrity, but should be excluded from current product/catalog analysis unless they have relevant historical orders.

-- TODO 5: CREATE CLEANED LAYER & VALIDATE.
-- Task 27: Create a Cleaned Item Price
-- Business Question:
-- How can we create a cleaned price column where:
-- If order_items.unit_price exists → use it
-- If it is NULL → use products.unit_price

SELECT 
order_items.order_item_id,
order_items.product_id,
order_items.unit_price AS item_price, 
COALESCE(order_items.unit_price, products.unit_price) AS cleaned_item_price
FROM order_items
LEFT JOIN products
ON order_items.product_id = products.product_id; 
 
-- Task 28: Create a Reusable Cleaned Order Items View
-- Business Question:
-- How can we create a reusable, analysis-ready view of order items
-- that includes a cleaned unit price by using the product price
-- as a fallback when the order item's unit_price is NULL?

CREATE OR REPLACE VIEW cleaned_order_items AS
SELECT 
order_items.order_item_id,
order_items.order_id,
order_items.product_id,
order_items.quantity,
order_items.unit_price,
order_items.discount_rate,
COALESCE(order_items.unit_price, products.unit_price) AS cleaned_unit_price
FROM order_items
LEFT JOIN products
ON order_items.product_id = products.product_id;

SELECT * 
FROM cleaned_order_items;

-- Task 29: Validate Cleaned Unit Prices
-- Business Question:
-- Are any order items still missing a cleaned unit price after applying
-- the product price as the fallback?

SELECT order_item_id, product_id, cleaned_unit_price
FROM cleaned_order_items
WHERE cleaned_unit_price IS NULL;

-- Task 30: Validate Revenue Calculation Inputs
-- Business Question:
-- Which order items have an invalid quantity or a missing/invalid cleaned unit price that could affect revenue calculations?

SELECT order_item_id, order_id, product_id, quantity, cleaned_unit_price
FROM cleaned_order_items
WHERE quantity <= 0
OR cleaned_unit_price IS NULL
OR cleaned_unit_price <= 0;

-- Rule: Order items with zero/negative quantity or missing/invalid cleaned unit prices
-- should be excluded from revenue calculations and flagged for data-quality review.
