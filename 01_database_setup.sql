-- E-Commerce Sales & Customer Analysis
-- MySQL 8.0+ | Run this entire file to create a fresh practice database.
-- This script resets only the four project tables in ecommerce_sql_portfolio.

CREATE DATABASE IF NOT EXISTS ecommerce_sql_portfolio;
USE ecommerce_sql_portfolio;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120),
    phone VARCHAR(30),
    city VARCHAR(80),
    state_region VARCHAR(80),
    country VARCHAR(80) NOT NULL DEFAULT 'India',
    signup_date DATE NOT NULL,
    customer_segment VARCHAR(30)
) ENGINE = InnoDB;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(80),
    subcategory VARCHAR(80),
    unit_price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2),
    supplier_name VARCHAR(120),
    active_flag CHAR(1) NOT NULL DEFAULT 'Y'
) ENGINE = InnoDB;

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    payment_method VARCHAR(40),
    shipping_city VARCHAR(80),
    shipping_state VARCHAR(80),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) ENGINE = InnoDB;

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2),
    discount_rate DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE = InnoDB;

INSERT INTO customers
    (customer_id, first_name, last_name, email, phone, city, state_region, country, signup_date, customer_segment)
VALUES
    (1, 'Aarav', 'Sharma', 'aarav.sharma@example.com', '9876543210', 'Mumbai', 'Maharashtra', 'India', '2023-02-14', 'Consumer'),
    (2, 'Diya', 'Patel', 'diya.patel@example.com', '9825012345', 'Ahmedabad', 'Gujarat', 'India', '2023-04-02', 'Consumer'),
    (3, 'Vihaan', 'Reddy', 'vihaan.reddy@example.com', '9848012345', 'Hyderabad', 'Telangana', 'India', '2023-05-18', 'Consumer'),
    (4, 'Ananya', 'Iyer', 'ananya.iyer@example.com', '9884012345', 'Chennai', 'Tamil Nadu', 'India', '2023-06-09', 'Consumer'),
    (5, 'Kabir', 'Singh', 'kabir.singh@example.com', '9810012345', 'New Delhi', 'Delhi', 'India', '2023-08-21', 'Small Business'),
    (6, 'Meera', 'Nair', 'meera.nair@example.com', NULL, 'Kochi', 'Kerala', 'India', '2023-09-11', 'Consumer'),
    (7, 'Arjun', 'Das', 'arjun.das@example.com', '9831012345', 'Kolkata', 'West Bengal', 'India', '2023-10-03', 'Consumer'),
    (8, 'Isha', 'Gupta', 'isha.gupta@example.com', '9891012345', 'Noida', 'Uttar Pradesh', 'India', '2023-11-17', 'Consumer'),
    (9, 'Rohan', 'Kulkarni', 'rohan.k@example.com', '9822012345', 'Pune', 'Maharashtra', 'India', '2024-01-05', 'Small Business'),
    (10, 'Saanvi', 'Jain', 'saanvi.jain@example.com', '9987012345', 'Mumbai', 'Maharashtra', 'India', '2024-01-26', 'Consumer'),
    (11, 'Aditya', 'Verma', 'aditya.verma@example.com', NULL, 'Bengaluru', 'Karnataka', 'India', '2024-02-08', 'Consumer'),
    (12, 'Kavya', 'Menon', 'kavya.menon@example.com', '9995012345', 'Thiruvananthapuram', 'Kerala', 'India', '2024-02-19', 'Consumer'),
    (13, 'Reyansh', 'Kapoor', 'reyansh.kapoor@example.com', '9818012345', 'Gurugram', 'Haryana', 'India', '2024-03-01', 'Small Business'),
    (14, 'Myra', 'Bose', 'myra.bose@example.com', '9903012345', 'Kolkata', 'West Bengal', 'India', '2024-03-16', 'Consumer'),
    (15, 'Ishaan', 'Joshi', 'ishaan.joshi@example.com', '9764012345', 'Pune', 'Maharashtra', 'India', '2024-04-04', 'Consumer'),
    (16, 'Aditi', 'Rao', 'aditi.rao@example.com', '9849012345', NULL, 'Telangana', 'India', '2024-04-22', 'Consumer'),
    (17, 'Neil', 'Chawla', 'neil.chawla@example.com', '9873012345', 'New Delhi', 'Delhi', 'India', '2024-05-13', 'Small Business'),
    (18, 'Tara', 'Saxena', 'tara.saxena@example.com', '9839012345', 'Lucknow', 'Uttar Pradesh', 'India', '2024-05-30', 'Consumer'),
    (19, 'Dev', 'Malhotra', 'dev.malhotra@example.com', '9876543001', 'Jaipur', 'Rajasthan', 'India', '2024-06-12', 'Consumer'),
    (20, 'Riya', 'Mukherjee', 'riya.m@example.com', '9830012345', 'Kolkata', 'West Bengal', 'India', '2024-07-08', 'Consumer'),
    (21, 'Yash', 'Bhatia', 'yash.bhatia@example.com', NULL, 'Chandigarh', 'Chandigarh', 'India', '2024-07-29', 'Small Business'),
    (22, 'Nisha', 'Pillai', 'nisha.pillai@example.com', '9895012345', 'Kochi', 'Kerala', 'India', '2024-08-14', 'Consumer'),
    (23, 'Karan', 'Mehta', 'karan.mehta@example.com', '9825012300', 'Ahmedabad', 'Gujarat', 'India', '2024-09-02', 'Consumer'),
    (24, 'Priya', 'Sethi', 'priya.sethi@example.com', '9999012345', 'New Delhi', 'Delhi', 'India', '2024-09-18', 'Consumer'),
    (25, 'Rahul', 'Khanna', 'rahul.khanna@example.com', '9811012345', 'Gurugram', 'Haryana', 'India', '2024-10-06', 'Small Business'),
    (26, 'Simran', 'Kaur', 'simran.kaur@example.com', '9872012345', 'Ludhiana', 'Punjab', 'India', '2024-10-25', 'Consumer'),
    (27, 'Manav', 'Mishra', 'manav.mishra@example.com', '9935012345', 'Varanasi', 'Uttar Pradesh', 'India', '2024-11-09', 'Consumer'),
    (28, 'Zoya', 'Ali', 'zoya.ali@example.com', '9874512345', 'Bengaluru', 'Karnataka', 'India', '2024-11-28', 'Consumer'),
    (29, 'Harsh', 'Vora', 'harsh.vora@example.com', '9825011111', 'Ahmedabad', 'Gujarat', 'India', '2025-01-12', 'Consumer'),
    (30, 'Pooja', 'Desai', 'pooja.desai@example.com', '9898012345', NULL, 'Gujarat', 'India', '2025-02-03', 'Consumer'),
    (31, 'Siddharth', 'Roy', 'siddharth.roy@example.com', '9831012222', 'Kolkata', 'West Bengal', 'India', '2025-02-25', 'Small Business'),
    (32, 'Leela', 'Krishnan', 'leela.krishnan@example.com', '9884012222', 'Chennai', 'Tamil Nadu', 'India', '2025-03-14', 'Consumer'),
    (33, 'Aman', 'Gupta', 'aman.gupta@example.com', '9891019999', 'Noida', 'Uttar Pradesh', 'India', '2025-04-01', 'Consumer'),
    (34, 'Aman', 'Gupta', 'aman.gupta@example.com', NULL, 'Noida', 'UP', 'India', '2025-04-04', 'Consumer');

INSERT INTO products
    (product_id, product_name, category, subcategory, unit_price, cost_price, supplier_name, active_flag)
VALUES
    (1001, 'Wireless Mouse', 'Electronics', 'Computer Accessories', 799.00, 430.00, 'TechSource India', 'Y'),
    (1002, 'Mechanical Keyboard', 'Electronics', 'Computer Accessories', 2499.00, 1540.00, 'TechSource India', 'Y'),
    (1003, 'USB-C Hub', 'electronics', 'Computer Accessories', 1499.00, 820.00, 'ConnectPro', 'Y'),
    (1004, 'Noise Cancelling Headphones', 'Electronics ', 'Audio', 5999.00, 3600.00, 'SoundSphere', 'Y'),
    (1005, 'Bluetooth Speaker Mini', 'electronics', 'Audio', 1899.00, 980.00, 'SoundSphere', 'Y'),
    (1006, 'Smartwatch Lite', 'Electronics', 'Wearables', 3499.00, NULL, 'Pulse Retail', 'Y'),
    (1007, 'Laptop Stand', 'Home & Office', 'Office Accessories', 1299.00, 650.00, 'WorkWell', 'Y'),
    (1008, 'Desk Organizer', 'Home and Office', 'Office Accessories', 699.00, 300.00, 'WorkWell', 'Y'),
    (1009, 'LED Desk Lamp', 'Home & Office', 'Lighting', 1599.00, 850.00, 'Bright Nest', 'Y'),
    (1010, 'Ceramic Coffee Mug', 'Home & Kitchen', 'Drinkware', 499.00, 180.00, 'Bright Nest', 'Y'),
    (1011, 'Insulated Water Bottle', 'Home & Kitchen', 'Drinkware', 899.00, 430.00, 'Hydrate Co', 'Y'),
    (1012, 'Cotton Bedsheet Set', 'Home & Kitchen', 'Bedding', 1799.00, 950.00, 'Loom & Leaf', 'Y'),
    (1013, 'Microfiber Towel Set', 'Home & Kitchen', 'Bath', 649.00, 290.00, 'Loom & Leaf', 'Y'),
    (1014, 'Yoga Mat', 'Sports & Fitness', 'Fitness', 1199.00, 600.00, 'Active Life', 'Y'),
    (1015, 'Resistance Band Set', 'Sports and Fitness', 'Fitness', 799.00, 350.00, 'Active Life', 'Y'),
    (1016, 'Stainless Steel Lunch Box', 'Home & Kitchen', 'Kitchen Storage', 999.00, 520.00, 'KitchenCraft', 'Y'),
    (1017, 'Non-Stick Frying Pan', 'Home & Kitchen', 'Cookware', 1399.00, 780.00, 'KitchenCraft', 'Y'),
    (1018, 'Organic Green Tea', 'Grocery', 'Beverages', 399.00, 180.00, 'Daily Basket', 'Y'),
    (1019, 'Almonds 500g', 'Grocery', 'Snacks', 649.00, 460.00, 'Daily Basket', 'Y'),
    (1020, 'Notebook Pack', 'Stationery', 'Paper Products', 299.00, 110.00, 'PaperTrail', 'Y'),
    (1021, 'Gel Pen Set', 'Stationary', 'Writing', 249.00, 95.00, 'PaperTrail', 'Y'),
    (1022, 'Running Shoes', 'Fashion', 'Footwear', 2799.00, 1600.00, 'Stride India', 'Y'),
    (1023, 'Canvas Backpack', 'Fashion', 'Bags', 1599.00, 790.00, 'Urban Carry', 'Y'),
    (1024, 'Classic T-Shirt', 'Fashion', 'Apparel', 699.00, 280.00, 'Urban Carry', 'Y'),
    (1025, 'Denim Jeans', 'Fashion ', 'Apparel', 1899.00, 900.00, 'Urban Carry', 'Y'),
    (1026, 'Sunscreen SPF 50', 'Beauty', 'Skin Care', 549.00, 260.00, 'Glow Goods', 'Y'),
    (1027, 'Face Wash', 'Beauty', 'Skin Care', 349.00, NULL, 'Glow Goods', 'Y'),
    (1028, 'Hair Dryer', 'Beauty', 'Personal Care', 2199.00, 1350.00, 'Glow Goods', 'Y'),
    (1029, 'Phone Case', 'Electronics', 'Mobile Accessories', 399.00, 140.00, 'ConnectPro', 'Y'),
    (1030, 'Power Bank 10000mAh', 'Electronics', 'Mobile Accessories', 1799.00, 1020.00, 'ConnectPro', 'Y'),
    (1031, 'Portable Blender', 'Home & Kitchen', 'Appliances', 2299.00, 1280.00, NULL, 'Y'),
    (1032, 'Scented Candle', 'Home & Decor', 'Decor', 449.00, 170.00, 'Bright Nest', 'Y'),
    (1033, 'Wall Clock', 'Home and Decor', 'Decor', 1099.00, 520.00, 'Bright Nest', 'Y'),
    (1034, 'Travel Pillow', NULL, 'Travel Accessories', 699.00, 310.00, 'Urban Carry', 'Y'),
    (1035, 'Wireless Mouse', 'Electronics', 'Computer Accessories', 799.00, 430.00, 'TechSource India', 'Y'),
    (1036, 'Festival Gift Box', 'Gifts', 'Seasonal', 1299.00, NULL, 'Seasonal Supplies', 'N');

DROP PROCEDURE IF EXISTS seed_orders;

DELIMITER $$

CREATE PROCEDURE seed_orders()
BEGIN
    DECLARE v_order_number INT DEFAULT 1;
    DECLARE v_line_number INT;
    DECLARE v_product_id INT;
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_order_id INT;

    WHILE v_order_number <= 150 DO
        INSERT INTO orders
            (customer_id, order_date, order_status, payment_method, shipping_city, shipping_state)
        VALUES
            (
                1 + MOD(v_order_number * 5, 34),
                DATE_ADD('2024-01-03', INTERVAL MOD(v_order_number * 29, 730) DAY),
                CASE
                    WHEN MOD(v_order_number, 23) = 0 THEN 'Cancelled'
                    WHEN MOD(v_order_number, 19) = 0 THEN 'cancelled '
                    WHEN MOD(v_order_number, 13) = 0 THEN 'Returned'
                    WHEN MOD(v_order_number, 7) = 0 THEN 'shipped'
                    WHEN MOD(v_order_number, 5) = 0 THEN 'Processing'
                    ELSE 'Delivered'
                END,
                CASE
                    WHEN MOD(v_order_number, 11) = 0 THEN 'Credit Card'
                    WHEN MOD(v_order_number, 7) = 0 THEN 'UPI '
                    WHEN MOD(v_order_number, 5) = 0 THEN 'Cash on delivery'
                    ELSE 'UPI'
                END,
                CASE WHEN MOD(v_order_number, 29) = 0 THEN NULL ELSE ELT(1 + MOD(v_order_number, 8), 'Mumbai', 'Bengaluru', 'New Delhi', 'Kolkata', 'Chennai', 'Pune', 'Ahmedabad', 'Hyderabad') END,
                CASE WHEN MOD(v_order_number, 29) = 0 THEN NULL ELSE ELT(1 + MOD(v_order_number, 8), 'Maharashtra', 'Karnataka', 'Delhi', 'West Bengal', 'Tamil Nadu', 'Maharashtra', 'Gujarat', 'Telangana') END
            );

        SET v_order_id = LAST_INSERT_ID();
        SET v_line_number = 1;

        WHILE v_line_number <= 3 DO
            SET v_product_id = 1001 + MOD((v_order_number * 7) + (v_line_number * 11), 36);
            SELECT unit_price INTO v_price FROM products WHERE product_id = v_product_id;

            INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_rate)
            VALUES
                (
                    v_order_id,
                    v_product_id,
                    CASE WHEN v_order_number = 77 AND v_line_number = 1 THEN 0 ELSE 1 + MOD(v_order_number + v_line_number, 4) END,
                    CASE WHEN MOD(v_order_number, 31) = 0 AND v_line_number = 3 THEN NULL ELSE v_price END,
                    CASE
                        WHEN MOD(v_order_number, 47) = 0 AND v_line_number = 2 THEN 1.20
                        WHEN MOD(v_order_number + v_line_number, 10) = 0 THEN 0.15
                        WHEN MOD(v_order_number + v_line_number, 6) = 0 THEN 0.05
                        ELSE 0.00
                    END
                );

            SET v_line_number = v_line_number + 1;
        END WHILE;

        SET v_order_number = v_order_number + 1;
    END WHILE;
END$$

DELIMITER ;

CALL seed_orders();
DROP PROCEDURE seed_orders;

-- Deliberate duplicate line: retained by the surrogate key for data-cleaning practice.
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_rate)
SELECT order_id, product_id, quantity, unit_price, discount_rate
FROM order_items
WHERE order_item_id = 10;

-- Setup verification: expected counts are 34 customers, 36 products, 150 orders, 451 order items.
SELECT 'customers' AS table_name, COUNT(*) AS record_count FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;
