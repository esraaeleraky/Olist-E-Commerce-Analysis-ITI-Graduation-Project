CREATE DATABASE Olist_DWH
 
GO

USE Olist_DWH
GO


--Object:  Table [dbo].[Geolocation_Dim]   
CREATE TABLE [dbo].[Geolocation_Dim](
	[geolocation_zip_code_prefix_SK] int IDENTITY(1,1) NOT NULL,
	[geolocation_zip_code_prefix_BK] int NOT NULL,
	[geolocation_lat] float NULL,
	[geolocation_lng] float NULL,
	[geolocation_city] nvarchar(50) NOT NULL,
	[geolocation_state] varchar(50) NOT NULL,
 CONSTRAINT [PK_Geolocation_Dim] PRIMARY KEY CLUSTERED 
(
	[geolocation_zip_code_prefix_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Object:  Table [dbo].[Customer_Dim]   
CREATE TABLE [dbo].[Customer_Dim](
	[Customer_Dim_SK] INT IDENTITY(1,1) NOT NULL,
	[Customer_BK] nvarchar(50) NOT NULL,
	[Customer_unique_id] nvarchar(50) NULL,
	[Gender] varchar(10) NULL,
	[Customer_Login_type] varchar(50) NULL,
	[Age] int NULL,
 CONSTRAINT [PK_Customer_Dim] PRIMARY KEY CLUSTERED 
(
	[Customer_Dim_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Object:  Table [dbo].[Logistics_Companies_Dim] 
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Logistics_Companies_Dim](
	[logistics_company_SK] INT IDENTITY(1,1) NOT NULL,
	[logistics_company_BK] INT NOT NULL,
	[logistics_company_name] varchar(20) NOT NULL,
	[logistics_contact_number] varchar(20) NOT NULL,
	[logistics_email] varchar(50) NULL,
	[logistics_website] varchar(50) NULL,
 CONSTRAINT [PK_Logistics_Companies_Dim] PRIMARY KEY CLUSTERED 
(
	[logistics_company_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--  Table [dbo].[Order_Reviews_Dim] 
CREATE TABLE [dbo].[Order_Reviews_Dim](
	[review_SK] INT IDENTITY(1,1) NOT NULL,
	[review_BK] nvarchar(50) NOT NULL,
	[review_score] int NULL,
	[review_comment_title] nvarchar(100) NULL,
	[review_comment_title_English] varchar(100) NULL,
	[review_comment_message] nvarchar(500) NULL,
	[review_comment_message_English] varchar(500) NULL,
	[review_status] varchar(50) NULL,
 CONSTRAINT [PK_Order_Reviews_Dim] PRIMARY KEY CLUSTERED 
(
	[review_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Object:  Table [dbo].[Payment_Dim]  

CREATE TABLE [dbo].[Payment_Dim](
	[Payment_SK] INT IDENTITY(1,1) NOT NULL,
	[order_id_BK] nvarchar(50) NOT NULL,
	[payment_sequential_BK] int NOT NULL,
	[payment_type] varchar(20) NULL,
	[payment_installments] int NULL,
	[bank_name] nvarchar(50) NULL,
 CONSTRAINT [PK_Payment_Dim] PRIMARY KEY CLUSTERED 
(
	[Payment_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Object:  Table [dbo].[Product_Dim]
CREATE TABLE [dbo].[Product_Dim](
	[Product_Dim_SK] INT IDENTITY(1,1) NOT NULL,
	[product_BK] varchar(50) NOT NULL,
	[product_category_name] nvarchar(100) NOT NULL,
	[product_category_English_name] varchar(100) NULL,
	[product_name_length] int NULL,
	[product_description_length] int NULL,
	[product_photos_qty] int NULL,
	[product_weight_g] INT NULL,
	[product_length_cm] INT NULL,
	[product_height_cm] INT NULL,
	[product_width_cm] INT NULL,
	[product_name] nvarchar(100) NOT NULL,
	[brand_BK] INT NOT NULL,
	[brand_name] varchar(20) NOT NULL,
	[brand_description] varchar(100) NULL,
	[brand_country] varchar(50) NOT NULL,
	[brand_foundation_year] int NULL,
	[brand_website] varchar(50) NULL,
	[brand_status] varchar(10) NULL,
	[brand_tier] varchar(10) NULL,
 CONSTRAINT [PK_Product_Dim] PRIMARY KEY CLUSTERED 
(
	[Product_Dim_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Object:  Table [dbo].[Seller_Dim]  
CREATE TABLE [dbo].[Seller_Dim](
	[seller_SK] INT IDENTITY(1,1) NOT NULL,
	[seller_BK] varchar(50) NOT NULL,
	[seller_name] varchar(50) NULL,
 CONSTRAINT [PK_Seller_Dim] PRIMARY KEY CLUSTERED 
(
	[seller_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Object:  Table [dbo].[Date_Dim] 
CREATE TABLE dbo.Date_Dim (
    Date_SK INT PRIMARY KEY,            -- Format: YYYYMMDD
    [Date] DATE NOT NULL,
    Day INT,
    Month INT,
    Month_Name VARCHAR(20),
    Year INT,
    Quarter INT,
    Week INT,
    Day_Name VARCHAR(20),
    Is_Weekend BIT,
    Is_Holiday BIT DEFAULT 0
)
GO
-- Object:  Table [dbo].[Time_Dim] 
CREATE TABLE dbo.Time_Dim (
    Time_SK INT PRIMARY KEY,         -- Format: HHMM 
    [Hour] INT NOT NULL,
    [Minute] INT NOT NULL,
    [AM_PM] VARCHAR(2) NOT NULL,     
    [Time_Label] VARCHAR(10) NOT NULL, 
    [Time_Period] VARCHAR(20) NOT NULL 
)

-- Object:  Table [dbo].[Order_Fact]  
CREATE TABLE dbo.Order_Fact (
    FT_PK_SK int IDENTITY(1,1) NOT NULL,
    order_id_BK  nvarchar(50) NOT NULL,
    order_item_BK int NOT NULL,
    Payment_FK int NULL,
    customer_Dim_FK int NULL,
    review_Dim_FK int NULL,
    product_Dim_FK int NULL,
    seller_Dim_FK int NULL,
    customer_zip_code_prefix_Geolocatoin_Dim_FK int NULL,
    seller_zip_code_prefix_Geolocatoin_Dim_FK int NULL,
    logistics_company_Dim_FK int NULL,
    order_purchase_date_FK INT NULL,
    order_approved_at_date_FK INT NULL,
    order_delivered_carrier_date_FK INT NULL,
    order_delivered_customer_date_FK INT NULL,
    order_estimated_delivery_date_FK INT NULL,
    shipping_limit_date_FK INT NULL,
    review_creation_date_FK INT NULL,
    review_answer_date_FK INT NULL,
	order_purchase_time_FK INT NULL,
    order_approved_time_FK INT NULL,
    order_delivered_carrier_time_FK INT NULL,
    order_delivered_customer_time_FK INT NULL,
    order_estimated_delivery_time_FK INT NULL,
    shipping_limit_time_FK INT NULL,
    review_creation_time_FK INT NULL,
    review_answer_time_FK INT NULL,

    -- Measures
    price float NULL,
    freight_value float NULL,
    payment_value float NULL,

    -- Degenerate Dimensions
    [Device_Type(DD)] varchar(50) NULL,
    [order_status(DD)] varchar(20) NULL,

    -- Primary Key
    CONSTRAINT PK_Order_Fact PRIMARY KEY CLUSTERED (FT_PK_SK),

    -- Foreign Key Constraints
    CONSTRAINT FK_Order_Fact_Customer_Dim 
        FOREIGN KEY (customer_Dim_FK) 
        REFERENCES dbo.Customer_Dim (Customer_Dim_SK),

    CONSTRAINT FK_Order_Fact_Order_Reviews_Dim 
        FOREIGN KEY (review_Dim_FK) 
        REFERENCES dbo.Order_Reviews_Dim (review_SK),

    CONSTRAINT FK_Order_Fact_Payment_Dim 
        FOREIGN KEY (Payment_FK) 
        REFERENCES dbo.Payment_Dim (Payment_SK),

    CONSTRAINT FK_Order_Fact_Product_Dim 
        FOREIGN KEY (product_Dim_FK) 
        REFERENCES dbo.Product_Dim (Product_Dim_SK),

    CONSTRAINT FK_Order_Fact_Seller_Dim 
        FOREIGN KEY (seller_Dim_FK) 
        REFERENCES dbo.Seller_Dim (seller_SK),

    CONSTRAINT FK_Order_Fact_Geolocation_Dim_Customer 
        FOREIGN KEY (customer_zip_code_prefix_Geolocatoin_Dim_FK) 
        REFERENCES dbo.Geolocation_Dim (geolocation_zip_code_prefix_SK),

    CONSTRAINT FK_Order_Fact_Geolocation_Dim_Seller 
        FOREIGN KEY (seller_zip_code_prefix_Geolocatoin_Dim_FK) 
        REFERENCES dbo.Geolocation_Dim (geolocation_zip_code_prefix_SK),

    CONSTRAINT FK_Order_Fact_Logistics_Companies_Dim 
        FOREIGN KEY (logistics_company_Dim_FK) 
        REFERENCES dbo.Logistics_Companies_Dim (logistics_company_SK),

	-- Date Foreign Keys
    CONSTRAINT FK_Order_Purchase_Date 
        FOREIGN KEY (order_purchase_date_FK) 
        REFERENCES dbo.Date_Dim (Date_SK),

    CONSTRAINT FK_Order_Approved_Date 
        FOREIGN KEY (order_approved_at_date_FK) 
        REFERENCES dbo.Date_Dim (Date_SK),

    CONSTRAINT FK_Carrier_Delivery_Date 
        FOREIGN KEY (order_delivered_carrier_date_FK) 
        REFERENCES dbo.Date_Dim (Date_SK),

    CONSTRAINT FK_Customer_Delivery_Date 
        FOREIGN KEY (order_delivered_customer_date_FK) 
        REFERENCES dbo.Date_Dim (Date_SK),

    CONSTRAINT FK_Estimated_Delivery_Date 
        FOREIGN KEY (order_estimated_delivery_date_FK) 
        REFERENCES dbo.Date_Dim (Date_SK),

    CONSTRAINT FK_Shipping_Limit_Date 
        FOREIGN KEY (shipping_limit_date_FK) 
        REFERENCES dbo.Date_Dim (Date_SK),

    CONSTRAINT FK_Review_Creation_Date 
        FOREIGN KEY (review_creation_date_FK) 
        REFERENCES dbo.Date_Dim (Date_SK),

    CONSTRAINT FK_Review_Answer_Timestamp 
        FOREIGN KEY (review_answer_date_FK) 
        REFERENCES dbo.Date_Dim (Date_SK),
	-- Time Foreign Keys
    CONSTRAINT FK_Order_Purchase_Time
        FOREIGN KEY (order_purchase_time_FK)
        REFERENCES dbo.Time_Dim (Time_SK),

    CONSTRAINT FK_Order_Approved_Time
        FOREIGN KEY (order_approved_time_FK)
        REFERENCES dbo.Time_Dim (Time_SK),

    CONSTRAINT FK_Carrier_Delivery_Time
        FOREIGN KEY (order_delivered_carrier_time_FK)
        REFERENCES dbo.Time_Dim (Time_SK),

    CONSTRAINT FK_Customer_Delivery_Time
        FOREIGN KEY (order_delivered_customer_time_FK)
        REFERENCES dbo.Time_Dim (Time_SK),

    CONSTRAINT FK_Estimated_Delivery_Time
        FOREIGN KEY (order_estimated_delivery_time_FK)
        REFERENCES dbo.Time_Dim (Time_SK),

    CONSTRAINT FK_Shipping_Limit_Time
        FOREIGN KEY (shipping_limit_time_FK)
        REFERENCES dbo.Time_Dim (Time_SK),

    CONSTRAINT FK_Review_Creation_Time
        FOREIGN KEY (review_creation_time_FK)
        REFERENCES dbo.Time_Dim (Time_SK),

    CONSTRAINT FK_Review_Answer_Time
        FOREIGN KEY (review_answer_time_FK)
        REFERENCES dbo.Time_Dim (Time_SK),
);






