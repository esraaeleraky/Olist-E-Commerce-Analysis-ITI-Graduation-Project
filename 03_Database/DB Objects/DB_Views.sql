--This view hides sensitive customer details like full ZIP codes
--showing only non-sensitive parts. It helps protect customer privacy while allowing general analysis.
CREATE VIEW view_customer_data AS
SELECT  c.Customer_id, c.Customer_Unique_id, LEFT(CAST(c.Customer_zip_code_prefix AS VARCHAR), 3) + '**' AS ZIP_Code,
    g.geolocation_city AS City, g.geolocation_state AS State, c.Gender, FLOOR(c.Age/10)*10 AS Age_Group,  
    (SELECT COUNT(*) FROM Orders o WHERE o.Customer_id = c.Customer_id) AS Orders_Count
FROM 
    Customers c
JOIN 
    Geolocation g ON c.Customer_zip_code_prefix = g.geolocation_zip_code_prefix;
--execute
SELECT * FROM view_customer_data;

------------------------------------------------------------------------------------------------------------------------

--Only shows completed (delivered) orders. Useful for reporting and limits users from seeing canceled/refunded ones.
CREATE VIEW view_completed_orders AS
SELECT  o.Order_id, o.Order_Purchase_Timestamp AS Order_Date, c.Customer_id, SUM(oi.Price) AS Total_Amount
FROM 
    Orders o
JOIN 
    Customers c ON o.Customer_id = c.Customer_id
JOIN 
    Order_Items oi ON o.Order_id = oi.Order_id
WHERE 
    o.Order_Status = 'delivered'
GROUP BY 
    o.Order_id,
    o.Order_Purchase_Timestamp,
    c.Customer_id;
--execute
SELECT * FROM view_completed_orders;