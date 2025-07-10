use Olist_Ecommerce

-- 1. Geolocation Table
BULK INSERT Geolocation
FROM 'D:\Desktop\marwa\marwa\ITI\Grad. Project\02_Enhanced Data\Data Files\geolocation.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	CODEPAGE = '65001'
);

-- 2. Brand Table
BULK INSERT Brand
FROM 'D:\Desktop\marwa\marwa\ITI\Grad. Project\02_Enhanced Data\Data Files\brand.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- 3. Logistics_Companies Table
BULK INSERT Logistics_Companies
FROM 'D:\Desktop\marwa\marwa\ITI\Grad. Project\02_Enhanced Data\Data Files\logistics_companies.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- 4. Customers Table
BULK INSERT Customers
FROM 'D:\Desktop\marwa\marwa\ITI\Grad. Project\02_Enhanced Data\Data Files\Customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- 5. Sellers Table
BULK INSERT Sellers
FROM 'D:\Desktop\marwa\marwa\ITI\Grad. Project\02_Enhanced Data\Data Files\sellers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- 6. Products Table
BULK INSERT Products 
FROM 'D:\Desktop\marwa\marwa\ITI\Grad. Project\02_Enhanced Data\Data Files\products.txt'
WITH (
  FIRSTROW = 2,
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);


-- 7. Orders Table
BULK INSERT Orders
FROM 'D:\Desktop\marwa\marwa\ITI\Grad. Project\02_Enhanced Data\Data Files\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- 8.  Order_Items Table
BULK INSERT Order_Items
FROM 'D:\Desktop\marwa\marwa\ITI\Grad. Project\02_Enhanced Data\Data Files\order_items.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
-- 9. Order_Payments Table
BULK INSERT Order_Payments
FROM 'D:\Desktop\marwa\marwa\ITI\Grad. Project\02_Enhanced Data\Data Files\order_payments.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
-- 10. Order_Reviews Table
BULK INSERT Order_Reviews
FROM 'D:\Desktop\marwa\marwa\ITI\Grad. Project\02_Enhanced Data\Data Files\order_reviews.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);