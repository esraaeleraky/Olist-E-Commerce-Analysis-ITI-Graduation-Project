CREATE DATABASE Olist_Ecommerce;
go
use  Olist_Ecommerce;

-- 1. Geolocation Table
CREATE TABLE Geolocation (
    geolocation_zip_code_prefix INT PRIMARY KEY CHECK (geolocation_zip_code_prefix > 0),
    geolocation_lat FLOAT CHECK (geolocation_lat BETWEEN -30 AND 28),
    geolocation_lng FLOAT CHECK (geolocation_lng BETWEEN -80 AND -15),
    geolocation_city NVARCHAR(50) NOT NULL,
    geolocation_state VARCHAR(50) NOT NULL 
);

-- 2. Brand Table
CREATE TABLE Brand (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR(20) NOT NULL UNIQUE,
    brand_description VARCHAR(100),
    brand_country VARCHAR(50) NOT NULL,
    brand_foundation_year INT CHECK (brand_foundation_year BETWEEN 1800 AND 2025),
    brand_website VARCHAR(50),
    brand_status VARCHAR(10) CHECK (brand_status IN ('Active', 'Inactive')),
    brand_tier VARCHAR(10) CHECK (brand_tier IN ('Premium', 'Standard'))
)

-- 3. Logistics_Companies Table
CREATE TABLE Logistics_Companies (
    logistics_company_id INT PRIMARY KEY,
    logistics_company_name VARCHAR(20) NOT NULL,
    logistics_contact_number VARCHAR(20) NOT NULL,
    logistics_email VARCHAR(50),
    logistics_website VARCHAR(50)
)

-- 4. Customers Table

CREATE TABLE Customers (
    Customer_id NVARCHAR(50) PRIMARY KEY,
	Customer_Unique_id NVARCHAR(50),
    Customer_zip_code_prefix INT,
    Gender VARCHAR(10),
	Customer_Login_type VARCHAR(50),
    Age INT CHECK (Age>=18),
    FOREIGN KEY (Customer_zip_code_prefix) REFERENCES Geolocation(geolocation_zip_code_prefix)
)

-- 5. Sellers Table
CREATE TABLE Sellers (
    Seller_id VARCHAR(50) PRIMARY KEY,
    Seller_zip_code_prefix INT,
    Seller_name VARCHAR(50),
    FOREIGN KEY (Seller_zip_code_prefix) REFERENCES Geolocation(geolocation_zip_code_prefix)
)

-- 6. Products Table
CREATE TABLE Products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name NVARCHAR(100) NOT NULL,
    product_category_English_name VARCHAR(100),
    product_name_length INT CHECK (product_name_length > 0),
    product_description_length INT CHECK (product_description_length > 0),
    product_photos_qty INT CHECK (product_photos_qty >= 0),
    product_weight_g INT CHECK (product_weight_g > 0),
    product_length_cm INT CHECK (product_length_cm > 0),
    product_height_cm INT CHECK (product_height_cm > 0),
    product_width_cm INT CHECK (product_width_cm > 0), 
	product_name NVARCHAR(100) NOT NULL,
    brand_id INT,
    FOREIGN KEY (brand_id) REFERENCES Brand(brand_id)
);

-- 7. Orders Table
CREATE TABLE Orders (
    Order_id NVARCHAR(50) PRIMARY KEY,
    Customer_id NVARCHAR(50),
    Device_Type VARCHAR(10),
    Order_Status VARCHAR(20),
   Order_Purchase_Timestamp DATETIME DEFAULT GETDATE(),
    Order_Approved_at DATETIME,
    Order_delivered_carrier_date DATETIME,
    Order_delivered_customer_date DATETIME,
    Order_estimated_delivery_date DATETIME,
	logistics_company_id INT,
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id),
    FOREIGN KEY (logistics_company_id) REFERENCES Logistics_Companies(logistics_company_id)
)

-- 8.  Order_Items Table
CREATE TABLE Order_Items (
    Order_id NVARCHAR(50),
    Order_item_id INT,
    Product_id VARCHAR(50),
    Seller_id VARCHAR(50),
    Shipping_limit_date DATETIME,
    Price FLOAT CHECK(Price>=0),
    freight_value FLOAT CHECK (freight_value >= 0),
    PRIMARY KEY (Order_id, Order_item_id),
    FOREIGN KEY (Order_id) REFERENCES Orders(Order_id),
    FOREIGN KEY (Product_id) REFERENCES Products(product_id),
    FOREIGN KEY (Seller_id) REFERENCES Sellers(Seller_id)
)

-- 9. Order_Payments Table
CREATE TABLE Order_Payments (
    order_id NVARCHAR(50),
    payment_sequential INT CHECK (payment_sequential >= 1),
    payment_type VARCHAR(20) NOT NULL,
    payment_installments INT CHECK (payment_installments BETWEEN 1 AND 24),
    payment_value FLOAT NOT NULL CHECK (payment_value > 0),
    bank_name NVARCHAR(50),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES Orders(Order_id)
)

-- 10. Order_Reviews Table
CREATE TABLE Order_Reviews (
    review_id NVARCHAR(50) PRIMARY KEY,
    Order_id NVARCHAR(50) NOT NULL,
    review_score INT CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title NVARCHAR(100),
    review_comment_title_English VARCHAR(100),
    review_comment_message NVARCHAR(500),
    review_comment_message_English VARCHAR(500),
    review_creation_date DateTime,
    review_answer_timestamp DateTime,
    review_status VARCHAR(50) CHECK (review_status IN ('positive','negative')),
    FOREIGN KEY (Order_id) REFERENCES Orders(Order_id)
)
