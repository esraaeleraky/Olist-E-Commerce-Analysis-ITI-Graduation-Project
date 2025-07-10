--1 retrieves customers from customers_table who are located in a specific Brazilian state
CREATE PROCEDURE p_GetCustomersByState 
    @StateCode VARCHAR(5)
AS
BEGIN
    BEGIN TRY
        SELECT 
            c.Customer_id,
            c.Customer_Unique_id,
            g.geolocation_city AS Customer_City,
            g.geolocation_state AS Customer_State,
            c.Gender
        FROM 
            Customers c
        JOIN 
            Geolocation g ON c.Customer_zip_code_prefix = g.geolocation_zip_code_prefix
        WHERE 
            g.geolocation_state = UPPER(@StateCode)
        ORDER BY 
            g.geolocation_city, c.Customer_Unique_id;
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred: ' + ERROR_MESSAGE();
    END CATCH
END

--Execution result of the procedure
EXEC p_GetCustomersByState @StateCode = 'SP';

--2 returns the total number of orders made by a specific customer
CREATE PROCEDURE CountOrdersByCustomer  @CustomerUniqueID NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        SELECT COUNT(*) AS OrderCount 
        FROM Orders o
        JOIN Customers c ON o.Customer_id = c.Customer_id
        WHERE c.Customer_Unique_id = @CustomerUniqueID;
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred: ' + ERROR_MESSAGE();
    END CATCH
END
--Execution result of the procedure
EXEC CountOrdersByCustomer @CustomerUniqueID = '248ffe10d632bebe4f7267f1f44844c9';


-- 3 calculates the average delivery time (in days) for all completed orders.
CREATE PROCEDURE GetAverageDeliveryTime
AS
BEGIN
    BEGIN TRY
        SELECT 
            COUNT(*) AS TotalDeliveredOrders,
            AVG(DATEDIFF(DAY, Order_Purchase_Timestamp, Order_delivered_customer_date)) AS AvgDeliveryDays,
            MIN(DATEDIFF(DAY, Order_Purchase_Timestamp, Order_delivered_customer_date)) AS MinDeliveryDays,
            MAX(DATEDIFF(DAY, Order_Purchase_Timestamp, Order_delivered_customer_date)) AS MaxDeliveryDays
        FROM 
            Orders
        WHERE 
            Order_Status = 'delivered'
            AND Order_delivered_customer_date IS NOT NULL
            AND Order_Purchase_Timestamp IS NOT NULL;
    END TRY
    BEGIN CATCH
  
        SELECT 
            'An error occurred while calculating delivery times: ' 
            + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
--Execution result of the procedure
EXEC GetAverageDeliveryTime;
---------------------------------------------------------------------------------------------------------------
-- 1) the 4 procedures of Geolocation table
-- 1) Procedure to Add New Location
CREATE PROCEDURE sp_AddGeolocation 
    @zip_code INT,
    @lat FLOAT,
    @lng FLOAT,
    @city NVARCHAR(50),
    @state VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Geolocation (
            geolocation_zip_code_prefix,
            geolocation_lat,
            geolocation_lng,
            geolocation_city,
            geolocation_state
        )
        VALUES (
            @zip_code,
            @lat,
            @lng,
            @city,
            @state
        );
        SELECT 'Location added successfully.' AS Message;
    END TRY
    BEGIN CATCH
        SELECT 
            'Error occurred while adding location: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
-- Execution
EXEC sp_AddGeolocation 12345, -23.55, -46.63, 'São Paulo', 'SP'

--2) Procedure to Get Location by State

CREATE PROCEDURE sp_GetLocationsByState 
    @state VARCHAR(50)
AS
BEGIN
    IF @state IS NULL OR LTRIM(RTRIM(@state)) = ''
    BEGIN
        SELECT 'State code is required.' AS ErrorMessage;
        RETURN;
    END
    BEGIN TRY
        SELECT 
            geolocation_zip_code_prefix AS zip_code,
            geolocation_city AS city
        FROM 
            Geolocation
        WHERE 
            UPPER(geolocation_state) = UPPER(@state)
        ORDER BY 
            geolocation_city;
    END TRY
    BEGIN CATCH
        SELECT 
            'Error occurred while retrieving locations: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
--Execution
EXEC sp_GetLocationsByState 'SP'

-- 3) Procedure to Update City Name
CREATE PROCEDURE sp_UpdateCityName 
    @zip_code INT,
    @new_city_name NVARCHAR(50)
AS
BEGIN
    IF @zip_code IS NULL OR @new_city_name IS NULL OR LTRIM(RTRIM(@new_city_name)) = ''
    BEGIN
        SELECT 'Both zip code and new city name are required.' AS ErrorMessage;
        RETURN;
    END
    BEGIN TRY
        UPDATE Geolocation
        SET geolocation_city = @new_city_name
        WHERE geolocation_zip_code_prefix = @zip_code;
        IF @@ROWCOUNT = 0
        BEGIN
            SELECT 'No record found with the given zip code.' AS Message;
        END
        ELSE
        BEGIN
            SELECT 'City name updated successfully.' AS Message;
        END
    END TRY
    BEGIN CATCH
        SELECT 
            'Error occurred while updating city name: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
--execution
EXEC sp_UpdateCityName 1001, 'Port said'
EXEC sp_UpdateCityName 1002, 'Port fouad'

--4) Procedure to Delete Location
CREATE PROCEDURE DeleteLocation @zip_code INT
AS
BEGIN
    IF @zip_code IS NULL
    BEGIN
        SELECT 'Zip code is required.' AS ErrorMessage;
        RETURN;
    END
    BEGIN TRY 
        IF EXISTS (SELECT 1 FROM Customers WHERE Customer_zip_code_prefix = @zip_code)
        BEGIN
            SELECT 'Cannot delete location: there are customers linked to this zip code.' AS Message;
            RETURN;
        END   
        DELETE FROM Geolocation
        WHERE geolocation_zip_code_prefix = @zip_code;   
        IF @@ROWCOUNT = 0
        BEGIN
            SELECT 'No location found with the given zip code.' AS Message;
        END
        ELSE
        BEGIN
            SELECT 'Location deleted successfully.' AS Message;
        END
    END TRY
    BEGIN CATCH
        SELECT 'Error occurred while deleting location: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
--execution
DECLARE @result INT
EXEC @result = DeleteLocation @zip_code = 1003
IF @result = 1
    PRINT 'Deleted successfully'
ELSE
    PRINT 'Cannot delete - ZIP code is in use'
--------------------------------------------------------------------------------------------------------------
-- 2) the 4 procedures of Brand table
--1) Procedure to Get Brands by Country
CREATE PROCEDURE GetBrandsByCountry  @p_country VARCHAR(50)
AS
BEGIN 
    IF @p_country IS NULL OR LTRIM(RTRIM(@p_country)) = ''
    BEGIN
        SELECT 'Country name is required.' AS ErrorMessage;
        RETURN;
    END
    BEGIN TRY
        SELECT 
            brand_id, 
            brand_name, 
            brand_status
        FROM 
            Brand
        WHERE 
            UPPER(brand_country) = UPPER(@p_country)
        ORDER BY 
            brand_name;
    END TRY
    BEGIN CATCH
        SELECT 
            'Error occurred while retrieving brands: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC GetBrandsByCountry @p_country = 'Leading technology manufacturer';

--2) Procedure to Add a New Brand
CREATE OR ALTER PROCEDURE AddBrandd 
    @p_brand_id INT,  
    @p_brand_name VARCHAR(20),  
    @p_brand_description VARCHAR(100),  
    @p_brand_country VARCHAR(50),
    @p_brand_foundation_year INT,  
    @p_brand_website VARCHAR(50),  
    @p_brand_status VARCHAR(10),  
    @p_brand_tier VARCHAR(10)
AS
BEGIN
    IF @p_brand_id IS NULL OR @p_brand_name IS NULL OR LTRIM(RTRIM(@p_brand_name)) = ''
    BEGIN
        SELECT 'Brand ID and Name are required.' AS Message;
        RETURN;
    END
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Brand WHERE brand_id = @p_brand_id)
        BEGIN
            SELECT 'Brand ID already exists.' AS Message;
            RETURN;
        END
        IF EXISTS (SELECT 1 FROM Brand WHERE brand_name = @p_brand_name)
        BEGIN
            SELECT 'Brand name already exists.' AS Message;
            RETURN;
        END
        INSERT INTO Brand (
            brand_id, 
            brand_name, 
            brand_description, 
            brand_country, 
            brand_foundation_year, 
            brand_website, 
            brand_status, 
            brand_tier)
        VALUES (
            @p_brand_id, 
            @p_brand_name, 
            @p_brand_description, 
            @p_brand_country, 
            @p_brand_foundation_year, 
            @p_brand_website, 
            @p_brand_status, 
            @p_brand_tier);
        SELECT 'Brand added successfully.' AS Message;
    END TRY
    BEGIN CATCH
        SELECT 'Error occurred while adding the brand: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
-- Find the next available ID , so we won't use existing id**
DECLARE @next_id INT;
SELECT @next_id = ISNULL(MAX(brand_id), 0) + 1 FROM Brand;
EXEC AddBrandd
    @p_brand_id = @next_id,
    @p_brand_name = 'okhtein',
    @p_brand_description = 'Egyptian bags brand',
    @p_brand_country = 'Egypt',
    @p_brand_foundation_year = 2020,
    @p_brand_website = 'www.okhtein.com',
    @p_brand_status = 'Active',
    @p_brand_tier = 'standard';

-- 3) Procedure to Update Brand Status
CREATE OR ALTER PROCEDURE UpdateBrandStatus
    @p_brand_id INT,
    @p_new_status VARCHAR(10)
AS
BEGIN  
    IF @p_brand_id IS NULL
    BEGIN
        SELECT 'Brand ID is required.' AS Message;
        RETURN;
    END
    IF @p_new_status IS NULL OR LTRIM(RTRIM(@p_new_status)) = ''
    BEGIN
        SELECT 'New status is required.' AS Message;
        RETURN;
    END
    BEGIN TRY       
        IF NOT EXISTS (SELECT 1 FROM Brand WHERE brand_id = @p_brand_id)
        BEGIN
            SELECT 'Brand not found.' AS Message;
            RETURN;
        END 
        UPDATE Brand 
        SET brand_status = @p_new_status 
        WHERE brand_id = @p_brand_id;
        SELECT 'Brand status updated successfully.' AS Message;
    END TRY
    BEGIN CATCH
        SELECT 'Error occurred while updating brand status: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC UpdateBrandStatus 
    @p_brand_id = 1, 
    @p_new_status = 'Inactive';

-- 4) Procedure to Get Brand Details by ID
CREATE OR ALTER PROCEDURE GetBrandDetails
    @p_brand_id INT
AS
BEGIN  
    IF @p_brand_id IS NULL
    BEGIN
        SELECT 'Brand ID is required.' AS Message;
        RETURN;
    END
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Brand WHERE brand_id = @p_brand_id)
        BEGIN
            SELECT 'Brand not found.' AS Message;
            RETURN;
        END
        SELECT 
            brand_name, 
            brand_description, 
            brand_country, 
            brand_foundation_year, 
            brand_website, 
            brand_status, 
            brand_tier
        FROM 
            Brand
        WHERE 
            brand_id = @p_brand_id;
    END TRY
    BEGIN CATCH
        SELECT 'Error occurred while retrieving brand details: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC GetBrandDetails @p_brand_id = 1;
----------------------------------------------------------------------------------------------------------------
-- 3) the 4 procedures of logistics companies table
-- 1) Search Companies by Name
CREATE OR ALTER PROCEDURE SearchLogisticsCompanies
    @search_term VARCHAR(20)
AS
BEGIN
    IF @search_term IS NULL OR LTRIM(RTRIM(@search_term)) = ''
    BEGIN
        SELECT 'Search term is required.' AS Message;
        RETURN;
    END
    BEGIN TRY
        SELECT 
            logistics_company_id,
            logistics_company_name,
            logistics_contact_number,
            logistics_email,
            logistics_website
        FROM 
            Logistics_Companies
        WHERE 
            logistics_company_name COLLATE SQL_Latin1_General_CP1_CI_AS LIKE '%' + @search_term + '%';
    END TRY
    BEGIN CATCH
        SELECT 'Error occurred while searching logistics companies: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC SearchLogisticsCompanies @search_term = 'FedEx';

-- 2) Procedure to Add a New company
CREATE OR ALTER PROCEDURE AddLogisticsCompany
    @company_id INT,
    @company_name VARCHAR(20),
    @contact_number VARCHAR(20),
    @email VARCHAR(50) = NULL,
    @website VARCHAR(50) = NULL
AS
BEGIN  
    IF @company_name IS NULL OR LTRIM(RTRIM(@company_name)) = ''
    BEGIN
        PRINT 'Company name is required.';
        RETURN;
    END
    IF @contact_number IS NULL OR LTRIM(RTRIM(@contact_number)) = ''
    BEGIN
        PRINT 'Contact number is required.';
        RETURN;
    END
    BEGIN TRY 
        IF EXISTS (SELECT 1 FROM Logistics_Companies WHERE logistics_company_name = @company_name)
        BEGIN
            PRINT 'A company with this name already exists.';
            RETURN;
        END
        INSERT INTO Logistics_Companies (logistics_company_id,
            logistics_company_name,
            logistics_contact_number,
            logistics_email,
            logistics_website)
        VALUES (
            @company_id,
            @company_name,
            @contact_number,
            @email,
            @website);
        PRINT 'Logistics company added successfully.';
    END TRY
    BEGIN CATCH
        SELECT 'Error occurred while adding logistics company: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

--execution
-- Get the next available ID
DECLARE @next_id INT;
SELECT @next_id = ISNULL(MAX(logistics_company_id), 0) + 1 FROM Logistics_Companies;
-- Add new company with the generated ID
EXEC AddLogisticsCompany 
    @company_id = @next_id,
    @company_name = 'FastShip',
    @contact_number = '+208635551234',
    @email = 'contact@fastship.com',
    @website = 'www.fastship.com';

-- 3) Procedure to Delete Inactive company
CREATE OR ALTER PROCEDURE DeleteLogisticsCompanies @company_id INT
AS
BEGIN
    BEGIN TRY     
        IF NOT EXISTS (SELECT 1 FROM Logistics_Companies WHERE logistics_company_id = @company_id)
        BEGIN
            RAISERROR('Company not found.', 16, 1);
            RETURN;
        END
        IF EXISTS (SELECT 1 FROM Orders WHERE logistics_company_id = @company_id)
        BEGIN
            RAISERROR('Cannot delete: Company is linked to existing orders.', 16, 1);
            RETURN;
        END  
        DELETE FROM Logistics_Companies
        WHERE logistics_company_id = @company_id;
        PRINT 'Company deleted successfully.';
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC DeleteLogisticsCompanies @company_id = 6;

-- 4) Update Contact Information
CREATE OR ALTER PROCEDURE UpdateLogisticsContact
    @company_id INT,
    @new_contact_number VARCHAR(20),
    @new_email VARCHAR(50) = NULL
AS
BEGIN
    BEGIN TRY 
        IF NOT EXISTS (
            SELECT 1 FROM Logistics_Companies WHERE logistics_company_id = @company_id)
        BEGIN
            RAISERROR('Company not found.', 16, 1);
            RETURN;
        END
        IF @new_contact_number IS NULL OR LTRIM(RTRIM(@new_contact_number)) = ''
        BEGIN
            RAISERROR('Contact number is required.', 16, 1);
            RETURN;
        END
        UPDATE Logistics_Companies
        SET 
            logistics_contact_number = @new_contact_number,
            logistics_email = @new_email
        WHERE 
            logistics_company_id = @company_id;
        PRINT 'Contact information updated successfully.';
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC UpdateLogisticsContact
    @company_id = 1,
    @new_contact_number = '+205553575678',
    @new_email = 'dhl@dhl.com';
----------------------------------------------------------------------------------------------------------------
-- 4) the 4 procedures of customers table
-- 1) Procedure to Add a New Customer
CREATE PROCEDURE p_AddCustomer @Customer_id NVARCHAR(50), @Customer_Unique_id NVARCHAR(50), @Customer_zip_code_prefix INT, @Gender VARCHAR(10),
    @Customer_Login_type VARCHAR(50),@Age INT
AS 
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @Customer_id)
        BEGIN
            RAISERROR('Customer ID already exists.', 16, 1);
            RETURN;
        END
        IF NOT EXISTS (
            SELECT 1 FROM Geolocation WHERE geolocation_zip_code_prefix = @Customer_zip_code_prefix)
        BEGIN
            RAISERROR('Zip code does not exist in Geolocation table.', 16, 1);
            RETURN;
        END
        INSERT INTO Customers ( Customer_id, Customer_Unique_id, Customer_zip_code_prefix, Gender, Customer_Login_type, Age) 
        VALUES ( @Customer_id, @Customer_Unique_id, @Customer_zip_code_prefix, @Gender, @Customer_Login_type, @Age);
        PRINT 'Customer added successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
--execution
EXEC p_AddCustomer 
    @Customer_id = 'CUST12345',
    @Customer_Unique_id = 'UNIQ67890',
    @Customer_zip_code_prefix = 1001,
    @Gender = 'Male',
    @Customer_Login_type = 'First SignUp',
    @Age = 30;

--2) Procedure to Update Customer Information
CREATE PROCEDURE UpdateCustomer  @Customer_id NVARCHAR(50),  @New_Zip_Code INT,  @New_Gender VARCHAR(10),  @New_Login_Type VARCHAR(50),  @New_Age INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Geolocation WHERE geolocation_zip_code_prefix = @New_Zip_Code)
    BEGIN
        RAISERROR('The entered zip code does not exist in Geolocation.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (
        SELECT 1 FROM Customers WHERE Customer_id = @Customer_id)
    BEGIN
        RAISERROR('Customer ID not found.', 16, 1);
        RETURN;
    END
    UPDATE Customers
    SET  Customer_zip_code_prefix = @New_Zip_Code, 
        Gender = @New_Gender, 
        Customer_Login_type = @New_Login_Type,  
        Age = @New_Age
    WHERE Customer_id = @Customer_id;    
    PRINT 'Customer information updated successfully.';
END;
--execution
EXEC UpdateCustomer @Customer_id = '000161a058600d5901f007fab4c27140', @New_Zip_Code = 6273, @New_Gender = 'Female', @New_Login_Type = 'Standard', @New_Age = 31;

-- 3) Procedure to Delete a Customer
CREATE OR ALTER PROCEDURE sp_DeleteCustomer @Customer_id NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (
            SELECT 1 FROM Customers WHERE Customer_id = @Customer_id)
        BEGIN
            PRINT 'Customer not found.';
            RETURN 0; 
        END  
        DELETE FROM Customers
        WHERE Customer_id = @Customer_id;
        PRINT 'Customer deleted successfully.';
        RETURN 1; 
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
        RETURN -1;
    END CATCH
END;
--execution
EXEC sp_DeleteCustomer @Customer_id = 'CUST12345';

-- 4)Procedure to Get Customer Details by ID
CREATE OR ALTER PROCEDURE sp_GetCustomerByID  @Customer_id NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (
            SELECT 1 FROM Customers WHERE Customer_id = @Customer_id)
        BEGIN
            SELECT 'Customer not found.' AS Message;
            RETURN;
        END
        SELECT 
            Customer_id, 
            Customer_Unique_id, 
            Customer_zip_code_prefix, 
            Gender, 
            Customer_Login_type, 
            Age
        FROM 
            Customers
        WHERE 
            Customer_id = @Customer_id;
    END TRY
    BEGIN CATCH
        SELECT 
            'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC sp_GetCustomerByID @Customer_id = '000f17e290c26b28549908a04cfe36c1';
-----------------------------------------------------------------------------------------------------------------
-- 5) the 4 procedures of sellers table
-- 1) Search Sellers by Name Pattern
CREATE OR ALTER PROCEDURE sp_SearchSellersByName @NamePattern VARCHAR(50)
AS
BEGIN  
    IF @NamePattern IS NULL OR LTRIM(RTRIM(@NamePattern)) = ''
    BEGIN
        SELECT 'Search term is required.' AS Message;
        RETURN;
    END
    BEGIN TRY
        SELECT  Seller_id,  Seller_zip_code_prefix,  Seller_name
        FROM  Sellers
        WHERE 
            Seller_name LIKE '%' + @NamePattern + '%'
        ORDER BY 
            Seller_name;
    END TRY
    BEGIN CATCH
        SELECT 
            'An error occurred while searching sellers: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC sp_SearchSellersByName @NamePattern = 'Ramirez, Garza and Callahan';

-- 2) add new seller
CREATE OR ALTER PROCEDURE p_AddSeller @Seller_id VARCHAR(50), @Seller_zip_code_prefix INT, @Seller_name VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Sellers WHERE Seller_id = @Seller_id)
        BEGIN
            SELECT 'Error: Seller ID already exists.' AS Message;
            RETURN;
        END
        IF NOT EXISTS (SELECT 1 FROM Geolocation WHERE geolocation_zip_code_prefix = @Seller_zip_code_prefix)
        BEGIN
            SELECT 'Error: The zip code does not exist in the Geolocation table.' AS Message;
            RETURN;
        END
        INSERT INTO Sellers (Seller_id, Seller_zip_code_prefix, Seller_name)
        VALUES (@Seller_id, @Seller_zip_code_prefix, @Seller_name);
        SELECT 'Seller added successfully.' AS Message;
    END TRY
    BEGIN CATCH
        SELECT 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC p_AddSeller @Seller_id = 'SEL12345', @Seller_zip_code_prefix = 12345, @Seller_name = 'kenzy osama';

-- 3) Get sellers by zip code
CREATE OR ALTER PROCEDURE sp_GetSellersByZipCode  @Zip_Code_Prefix INT
AS
BEGIN
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1  FROM Geolocation 
            WHERE geolocation_zip_code_prefix = @Zip_Code_Prefix)
        BEGIN
            SELECT 'Error: Zip code does not exist in Geolocation.' AS Message;
            RETURN;
        END
        SELECT 
            Seller_id, 
            Seller_name
        FROM 
            Sellers
        WHERE 
            Seller_zip_code_prefix = @Zip_Code_Prefix
        ORDER BY 
            Seller_name;
    END TRY
    BEGIN CATCH
        SELECT 
            'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC sp_GetSellersByZipCode @Zip_Code_Prefix = 9080;

-- 4) Count Sellers by Zip Code
CREATE OR ALTER PROCEDURE DeleteLocations 
    @zip_code INT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Customers WHERE Customer_zip_code_prefix = @zip_code)
           OR EXISTS (SELECT 1 FROM Sellers WHERE Seller_zip_code_prefix = @zip_code)
        BEGIN
            SELECT 'Cannot delete. ZIP code is used by Customers or Sellers.' AS Result;
            RETURN;
        END 
        DELETE FROM Geolocation
        WHERE geolocation_zip_code_prefix = @zip_code; 
        IF @@ROWCOUNT > 0
            SELECT 'Location deleted successfully.' AS Result;
        ELSE
            SELECT 'ZIP code not found in Geolocation table.' AS Result;
    END TRY
    BEGIN CATCH
        SELECT 'Error occurred: ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC DeleteLocation 1003
-----------------------------------------------------------------------------------------------------------------
-- 6) the 4 procedures of products table
-- 1) Add new product
CREATE PROCEDURE AddProducts @product_id VARCHAR(50),@product_category_name NVARCHAR(100),@product_category_English_name VARCHAR(100) = NULL,
    @product_name_length INT,@product_description_length INT,@product_photos_qty INT,@product_weight_g INT,@product_length_cm INT,@product_height_cm INT, 
    @product_width_cm INT,@product_name NVARCHAR(100),@brand_id INT = NULL
AS
BEGIN
    BEGIN TRY
        INSERT INTO Products (product_id,product_category_name,product_category_English_name,product_name_length,product_description_length, 
            product_photos_qty,product_weight_g,product_length_cm,product_height_cm, product_width_cm,product_name,brand_id)
        VALUES (@product_id,@product_category_name,@product_category_English_name,@product_name_length,@product_description_length,@product_photos_qty,
            @product_weight_g,@product_length_cm,@product_height_cm,@product_width_cm,@product_name,@brand_id);      
        PRINT 'Product added successfully.';
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution 
EXEC AddProducts 
    @product_id = 'P12345',
    @product_category_name = 'skin care',
    @product_name_length = 15,
    @product_description_length = 100,
    @product_photos_qty = 3,
    @product_weight_g = 500,
    @product_length_cm = 20,
    @product_height_cm = 10,
    @product_width_cm = 15,
    @product_name = 'Moistrizer';

--2) Update product
CREATE PROCEDURE UpdateProducts
    @product_id VARCHAR(50), 
    @product_name NVARCHAR(100), 
    @product_weight_g INT, 
    @product_photos_qty INT
AS
BEGIN
    BEGIN TRY
        UPDATE Products
        SET 
            product_name = @product_name, 
            product_weight_g = @product_weight_g, 
            product_photos_qty = @product_photos_qty
        WHERE product_id = @product_id;       
        IF @@ROWCOUNT = 0
            PRINT 'No product found with ID: ' + @product_id;
        ELSE
            PRINT 'Product updated successfully.';
    END TRY
    BEGIN CATCH
	    print 'ErrorNumber' + ERROR_NUMBER();
        PRINT 'Error updating product: ' + ERROR_MESSAGE();
        PRINT 'Error occurred in procedure: ' + COALESCE(ERROR_PROCEDURE(), 'sp_UpdateProduct');
    END CATCH
END;
--execution
EXEC UpdateProducts
    @product_id = '001c5d71ac6ad696d22315953758fa04',
    @product_name = 'Premium Wireless Headphones',
    @product_weight_g = 550,
	@product_photos_qty=4;

-- 3) Delete product
CREATE PROCEDURE Delete_Product  @product_id VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Products WHERE product_id = @product_id)
        BEGIN
            PRINT 'Product does not exist.';
            RETURN;
        END
        DELETE FROM Products 
        WHERE product_id = @product_id;
        IF @@ROWCOUNT = 0
            PRINT 'No product was deleted.';
        ELSE
            PRINT 'Product deleted successfully.';
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 547
            PRINT 'Cannot delete product - it is referenced in other tables (likely has existing orders).';
        ELSE
		    print 'ErrorNumber' + ERROR_NUMBER();
            PRINT 'Error deleting product: ' + ERROR_MESSAGE();
    END CATCH
END;
--execution
EXEC Delete_Product @product_id = '001c5d71ac6ad696d22315953758fa04';

-- 4) Get products by category
CREATE PROCEDURE p_GetProductsByCategory  @product_category_name NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        SELECT  
            product_id, 
            product_name, 
            product_weight_g, 
            product_length_cm, 
            product_height_cm, 
            product_width_cm
        FROM Products
        WHERE product_category_name = @product_category_name
        ORDER BY product_name;
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 547
            PRINT 'Foreign key constraint violation occurred.';
        ELSE
		    print 'ErrorNumber' + ERROR_NUMBER();
            PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
--execution
EXEC p_GetProductsByCategory @product_category_name = 'skin care';
-------------------------------------------------------------------------------------------------------------
-- 7) the 4 procedures of orders table
-- 1) add new order
CREATE OR ALTER PROCEDURE CreateOrder @Order_id NVARCHAR(50), @Customer_id NVARCHAR(50), @Device_Type VARCHAR(10), @Order_Status VARCHAR(20),
    @logistics_company_id INT = NULL
AS
BEGIN
    BEGIN TRY
        INSERT INTO Orders (Order_id, Customer_id, Device_Type,  Order_Status, logistics_company_id)
        VALUES ( @Order_id, @Customer_id, @Device_Type, @Order_Status, @logistics_company_id);        
        PRINT 'Order created successfully.';
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 547
            PRINT 'Error: Invalid Customer ID or Logistics Company ID';
        ELSE
		    print 'ErrorNumber' + ERROR_NUMBER();
            PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
--execution
EXEC CreateOrder  @Order_id = 'ORD12345', @Customer_id = 'CUST67890', @Device_Type = 'Mobile', @Order_Status = 'Pending', @logistics_company_id = 5;

-- 2) Get order details
CREATE PROCEDURE p_GetOrderById @Order_id NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        SELECT * FROM Orders WHERE Order_id = @Order_id;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution 
EXEC p_GetOrderById @Order_id = '00024acbcdf0a6daa1e931b038114c75';

--3) Update order status
CREATE PROCEDURE p_UpdateOrderStatus  @Order_id NVARCHAR(50), @New_Status VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;       
        UPDATE Orders
        SET Order_Status = @New_Status
        WHERE Order_id = @Order_id;
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'No orders were updated. Order ID might not exist.';
        END
        ELSE
        BEGIN
            PRINT 'Order status updated successfully.';
        END        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;            
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    END CATCH
END;
--execution
EXEC p_UpdateOrderStatus  @Order_id = 'ORD12345', @New_Status = 'Shipped';

--4) Get customer's order history
CREATE PROCEDURE p_GetCustomerOrders  @Customer_id NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        SELECT  
		    Order_id, 
            Order_Status, 
            Order_Purchase_Timestamp, 
            Order_estimated_delivery_date
        FROM Orders
        WHERE Customer_id = @Customer_id
        ORDER BY Order_Purchase_Timestamp DESC;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC p_GetCustomerOrders @Customer_id = '5d178120c29c61748ea95bac23cb8f25';
----------------------------------------------------------------------------------------------------------------
-- 8) the 4 procedures of order items table
-- 1) Add Order Item
CREATE OR ALTER PROCEDURE AddOrderItems @Order_id NVARCHAR(50), @Order_item_id INT, @Product_id VARCHAR(50), @Seller_id VARCHAR(50),
    @Shipping_limit_date DATETIME, @Price FLOAT, @freight_value FLOAT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Order_Items (Order_id, Order_item_id, Product_id, Seller_id, Shipping_limit_date, Price, freight_value)
        VALUES (@Order_id, @Order_item_id, @Product_id, @Seller_id, @Shipping_limit_date, @Price, @freight_value);        
        PRINT 'Order item added successfully.';
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 547
            PRINT 'Error: Invalid Order, Product, or Seller ID';
        ELSE
            PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
--execution
EXEC AddOrderItems  @Order_id = 'ORD12345', @Order_item_id = 1, @Product_id = 'PROD1001', @Seller_id = 'SALLER001', @Shipping_limit_date = '2023-12-31',
    @Price = 99.99, @freight_value = 9.99;

-- 2) Get order items
CREATE PROCEDURE p_GetOrderItems @Order_id NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        SELECT  
            Order_item_id, 
            Product_id, 
            Seller_id, 
            Shipping_limit_date, 
            Price, 
            freight_value
        FROM Order_Items
        WHERE Order_id = @Order_id
        ORDER BY Order_item_id;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
--execution
EXEC p_GetOrderItems @Order_id = '000c3e6612759851cc3cbb4b83257986';

-- 3) Update item price
CREATE PROCEDURE p_UpdateOrderItemPrice @Order_id NVARCHAR(50), @Order_item_id INT, @New_Price FLOAT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;        
        UPDATE Order_Items
        SET Price = @New_Price
        WHERE Order_id = @Order_id AND Order_item_id = @Order_item_id;        
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'No rows were updated. The specified order item may not exist.';
        END
        ELSE
        BEGIN
            PRINT 'Order item price updated successfully.';
        END       
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;            
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
		 print 'ErrorNumber' + ERROR_NUMBER();
    END CATCH
END;
--execution
EXEC p_UpdateOrderItemPrice  @Order_id = 'ORD12345', @Order_item_id = 1, @New_Price = 89.99;

-- 4) Delete order item
CREATE PROCEDURE p_DeleteOrderItem  @Order_id NVARCHAR(50), @Order_item_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;    
        DELETE FROM Order_Items
        WHERE Order_id = @Order_id AND Order_item_id = @Order_item_id;           
        IF @@ROWCOUNT > 0
            PRINT 'Order item deleted successfully.';
        ELSE
            PRINT 'Order item not found.';        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;           
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
		print 'ErrorNumber' + ERROR_NUMBER();
    END CATCH
END;
--execution
EXEC p_DeleteOrderItem  @Order_id = '0009c9a17f916a706d71784483a5d643', @Order_item_id = 1;
---------------------------------------------------------------------------------------------------------------
-- 9) the 4 procedures of order payments table
-- 1) Add payment
CREATE OR ALTER PROCEDURE AddOrderPayment  @order_id NVARCHAR(50), @payment_sequential INT, @payment_type VARCHAR(20), @payment_installments INT,
    @payment_value FLOAT, @bank_name NVARCHAR(50) = NULL
AS
BEGIN
    BEGIN TRY
        INSERT INTO Order_Payments (order_id, payment_sequential, payment_type,payment_installments, payment_value, bank_name)
        VALUES (@order_id, @payment_sequential, @payment_type,@payment_installments, @payment_value, @bank_name);        
        PRINT 'Payment added successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error: Could not add payment - ' + ERROR_MESSAGE();
    END CATCH
END;
--execution
EXEC AddOrderPayment @order_id = 'ORD12345', @payment_sequential = 1, @payment_type = 'boleto', @payment_installments = 3,
    @payment_value = 150.75, @bank_name = 'National Bank';

-- 2) Get payments 
CREATE PROCEDURE p_GetOrderPayments @order_id NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        SELECT 
            payment_sequential, 
            payment_type, 
            payment_installments, 
            payment_value, 
            bank_name
        FROM 
            Order_Payments
        WHERE 
            order_id = @order_id
        ORDER BY 
            payment_sequential;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
--execution
EXEC p_GetOrderPayments @order_id = '00125cb692d04887809806618a2a145f';

--3) Update payment
CREATE PROCEDURE p_UpdatePaymentValue @order_id NVARCHAR(50),@payment_sequential INT,@new_payment_value FLOAT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE Order_Payments
        SET payment_value = @new_payment_value
        WHERE order_id = @order_id AND payment_sequential = @payment_sequential; 
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'No rows were updated. Check if the order_id and payment_sequential exist.';
        END
        ELSE
        BEGIN
            PRINT 'Payment value updated successfully.';
        END   
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;        
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
		print 'ErrorNumber' + ERROR_NUMBER();
    END CATCH
END;
--execution
EXEC p_UpdatePaymentValue
    @order_id = 'ORD12345',
    @payment_sequential = 1,
    @new_payment_value = 149.99;

-- 4) Delete payment
CREATE PROCEDURE p_DeleteOrderPayment @order_id NVARCHAR(50), @payment_sequential INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; 
        DELETE FROM Order_Payments
        WHERE order_id = @order_id AND payment_sequential = @payment_sequential;        
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'No payment found with the specified order_id and payment_sequential.';
        END
        ELSE
        BEGIN
            PRINT 'Payment deleted successfully.';
        END   
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;       
        PRINT 'Error occurred while deleting payment: ' + ERROR_MESSAGE();
		print 'ErrorNumber' + ERROR_NUMBER();
    END CATCH
END;
--execution
EXEC p_DeleteOrderPayment @order_id = 'ORD12345', @payment_sequential = 1;
------------------------------------------------------------------------------------------------------------------
-- 10) the 4 procedures of order reviews table
-- 1) Get Review by ID
CREATE PROCEDURE p_GetReview
    @review_id NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        SELECT * FROM Order_Reviews WHERE review_id = @review_id;
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No review found with the specified ID', 16, 1);
        END
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC p_GetReview @review_id = '0010388b006db42c9457d7148035db0e';

-- 2) Update Review Score
CREATE PROCEDURE p_UpdateReviewScore @review_id NVARCHAR(50), @new_score INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE Order_Reviews
        SET review_score = @new_score
        WHERE review_id = @review_id;  
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'No review found with the specified ID.';
        END
        ELSE
        BEGIN
            PRINT 'Review score updated successfully.';
        END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;    
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
--execution
EXEC p_UpdateReviewScore  @review_id = '0010388b006db42c9457d7148035db0e', @new_score = 4;

-- 3) Delete Review
CREATE PROCEDURE p_DeleteReview  @review_id NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE FROM Order_Reviews 
        WHERE review_id = @review_id;   
        IF @@ROWCOUNT > 0
            PRINT 'Review deleted successfully.';
        ELSE
            PRINT 'Review not found - no rows were deleted.';       
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;  
        PRINT 'Error occurred while deleting review: ' + ERROR_MESSAGE();
    END CATCH
END;
--execution
EXEC p_DeleteReview @review_id = '0005949d4c047d64863a6874338139ba';

--4) Count Reviews by Score
CREATE PROCEDURE p_CountReviewsByScore @score INT
AS
BEGIN
    BEGIN TRY
        SELECT COUNT(*) AS review_count
        FROM Order_Reviews
        WHERE review_score = @score;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
--execution
EXEC p_CountReviewsByScore @score = 5;