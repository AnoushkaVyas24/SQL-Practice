-- Drop and create schema
DROP SCHEMA IF EXISTS online_retail_app CASCADE;
CREATE SCHEMA IF NOT EXISTS online_retail_app;

-- USER LOGIN TABLE
DROP TABLE IF EXISTS online_retail_app.user_login;
CREATE TABLE IF NOT EXISTS online_retail_app.user_login (
    user_id TEXT PRIMARY KEY,
    password TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT,
    sign_up_on DATE DEFAULT CURRENT_DATE,
    email_id TEXT UNIQUE NOT NULL
);

-- CUSTOMERS TABLE
DROP TABLE IF EXISTS online_retail_app.customers;
CREATE TABLE IF NOT EXISTS online_retail_app.customers (
    customer_id TEXT PRIMARY KEY,
    password TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT,
    sign_up_on DATE DEFAULT CURRENT_DATE,
    email_id TEXT UNIQUE NOT NULL,
    contact TEXT UNIQUE NOT NULL,
    last_login TIMESTAMP
);

-- EMPLOYMENT TYPE TABLE
DROP TABLE IF EXISTS online_retail_app.employment_type;
CREATE TABLE IF NOT EXISTS online_retail_app.employment_type (
    employment_type_id TEXT PRIMARY KEY,
    employment_type TEXT NOT NULL,
    internal_employee BOOLEAN DEFAULT TRUE,
    vendor_name TEXT
);

-- EMPLOYEES TABLE
DROP TABLE IF EXISTS online_retail_app.employees;
CREATE TABLE IF NOT EXISTS online_retail_app.employees (
    employee_id TEXT PRIMARY KEY,
    employee_type TEXT NOT NULL REFERENCES online_retail_app.employment_type (employment_type_id),
    first_name TEXT NOT NULL,
    last_name TEXT,
    registered_on DATE DEFAULT CURRENT_DATE,
    email_id TEXT UNIQUE NOT NULL,
    contact TEXT UNIQUE NOT NULL,
    contract_expiry DATE
);

-- PAYMENT TABLE
DROP TABLE IF EXISTS online_retail_app.payment;
CREATE TABLE IF NOT EXISTS online_retail_app.payment (
    payment_id TEXT PRIMARY KEY,
    total_amount FLOAT NOT NULL,
    payment_mode TEXT NOT NULL,
    paid_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_success BOOLEAN DEFAULT TRUE
);

-- ORDERS TABLE
DROP TABLE IF EXISTS online_retail_app.orders;
CREATE TABLE IF NOT EXISTS online_retail_app.orders (
    order_id TEXT PRIMARY KEY,
    ordered_by TEXT NOT NULL REFERENCES online_retail_app.customers (customer_id),
    payment_id TEXT NOT NULL REFERENCES online_retail_app.payment (payment_id),
    is_delivered BOOLEAN DEFAULT FALSE,
    delivery_date DATE,
    delivered_by TEXT REFERENCES online_retail_app.employees (employee_id)
);

-- PRODUCT ITEMS TABLE
DROP TABLE IF EXISTS online_retail_app.product_items;
CREATE TABLE IF NOT EXISTS online_retail_app.product_items (
    item_id TEXT PRIMARY KEY,
    item_code TEXT UNIQUE NOT NULL,
    item_name TEXT NOT NULL,
    item_type TEXT,
    item_description TEXT,
    item_image JSON,
    sold_by TEXT,
    amount FLOAT NOT NULL,
    discount FLOAT DEFAULT 0.0,
    stock_count INT DEFAULT 0
);

-- ORDER ITEMS TABLE
DROP TABLE IF EXISTS online_retail_app.order_items;
CREATE TABLE IF NOT EXISTS online_retail_app.order_items (
    order_item_id SERIAL PRIMARY KEY,
    item_id TEXT NOT NULL REFERENCES online_retail_app.product_items (item_id),
    order_id TEXT NOT NULL REFERENCES online_retail_app.orders (order_id)
);

-- ORDER DELIVERY STAGES
DROP TABLE IF EXISTS online_retail_app.order_delivery;
CREATE TABLE IF NOT EXISTS online_retail_app.order_delivery (
    row_id SERIAL PRIMARY KEY,
    order_id TEXT NOT NULL REFERENCES online_retail_app.orders (order_id),
    delivery_stage TEXT NOT NULL
);

-- Indexes for performance
CREATE INDEX idx_order_customer ON online_retail_app.orders (ordered_by);
CREATE INDEX idx_order_items_item ON online_retail_app.order_items (item_id);
CREATE INDEX idx_order_items_order ON online_retail_app.order_items (order_id);

-- Sample Data Inserts
-- Customers
INSERT INTO online_retail_app.customers (customer_id, password, first_name, last_name, email_id, contact)
VALUES 
('cust001', 'pass123', 'Alice', 'Smith', 'alice@example.com', '9876543210'),
('cust002', 'pass456', 'Bob', 'Johnson', 'bob@example.com', '8765432109');

-- Employment Type
INSERT INTO online_retail_app.employment_type (employment_type_id, employment_type, internal_employee)
VALUES 
('emp_type1', 'Full-Time', TRUE),
('emp_type2', 'Contractor', FALSE);

-- Employees
INSERT INTO online_retail_app.employees (employee_id, employee_type, first_name, email_id, contact)
VALUES 
('emp001', 'emp_type1', 'John', 'john@retail.com', '9988776655'),
('emp002', 'emp_type2', 'Mary', 'mary@retail.com', '8877665544');

-- Product Items
INSERT INTO online_retail_app.product_items (item_id, item_code, item_name, amount, stock_count)
VALUES 
('item001', 'P1001', 'Laptop', 60000, 10),
('item002', 'P1002', 'Smartphone', 30000, 20);

-- Payments
INSERT INTO online_retail_app.payment (payment_id, total_amount, payment_mode)
VALUES 
('pay001', 60000, 'UPI'),
('pay002', 30000, 'Credit Card');

-- Orders
INSERT INTO online_retail_app.orders (order_id, ordered_by, payment_id, is_delivered, delivered_by)
VALUES 
('ord001', 'cust001', 'pay001', TRUE, 'emp001'),
('ord002', 'cust002', 'pay002', FALSE, NULL);

-- Order Items
INSERT INTO online_retail_app.order_items (item_id, order_id)
VALUES 
('item001', 'ord001'),
('item002', 'ord002');

-- Order Delivery Stages
INSERT INTO online_retail_app.order_delivery (order_id, delivery_stage)
VALUES 
('ord001', 'Delivered'),
('ord002', 'Dispatched');
