WITH Unified AS (
    SELECT 
        Customer_unique_id,
        -- »‰«Œœ «·ﬁÌ„ «·√ﬂÀ—  ﬂ—«—« ·ﬂ· Œ«’Ì…
        MAX(gender) AS unified_gender,
        AVG(age) AS unified_age,
        MAX(Customer_Login_type) AS unified_login_type
    FROM [dbo].[Customers]
    GROUP BY Customer_unique_id
)
UPDATE C
SET 
    C.gender = U.unified_gender,
    C.age = U.unified_age,
    C.Customer_Login_type = U.unified_login_type
FROM [dbo].[Customers] C
JOIN Unified U
    ON C.customer_unique_id = U.Customer_unique_id;