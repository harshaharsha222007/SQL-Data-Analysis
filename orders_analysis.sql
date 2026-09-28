CREATE TABLE orders (
    OrderID VARCHAR(50) PRIMARY KEY,
    Date DATE,
    CustomerID VARCHAR(50),
    Product VARCHAR(100),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    ShippingAddress VARCHAR(255),
    PaymentMethod VARCHAR(50),
    OrderStatus VARCHAR(50),
    TrackingNumber VARCHAR(50),
    ItemsInCart INT,
    CouponCode VARCHAR(50),
    ReferralSource VARCHAR(100),
    TotalPrice DECIMAL(10,2)
);

-- 1. Basic Insights

-- A. Total Revenue and Order Count
SELECT 
    COUNT(OrderID) AS Total_Orders,
    SUM(TotalPrice) AS Gross_Revenue,
    AVG(TotalPrice) AS Average_Order_Value
FROM orders;

-- B. Unique Customers
SELECT COUNT(DISTINCT CustomerID) AS Unique_Customers
FROM orders;

-- 2. Intermediate Insights

-- A. Top Performing Products
SELECT 
    Product,
    SUM(Quantity) AS Total_Units_Sold,
    SUM(TotalPrice) AS Total_Revenue
FROM orders
GROUP BY Product
ORDER BY Total_Revenue DESC;

-- B. Referral Source Performance
SELECT 
    ReferralSource,
    COUNT(OrderID) AS Order_Volume,
    SUM(TotalPrice) AS Revenue_Generated
FROM orders
WHERE ReferralSource IS NOT NULL AND ReferralSource <> ''
GROUP BY ReferralSource
ORDER BY Revenue_Generated DESC;

-- C. Order Status Distribution
SELECT 
    OrderStatus,
    COUNT(OrderID) AS Status_Count,
    ROUND((COUNT(OrderID) * 100.0 / (SELECT COUNT(*) FROM orders)), 2) AS Percentage
FROM orders
GROUP BY OrderStatus
ORDER BY Status_Count DESC;

-- 3. Advanced Insights

-- A. Monthly Revenue Trends
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS Order_Month,
    COUNT(OrderID) AS Monthly_Orders,
    SUM(TotalPrice) AS Monthly_Revenue
FROM orders
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY Order_Month ASC;

-- B. High-Value Repeat Customers
SELECT 
    CustomerID,
    COUNT(OrderID) AS Total_Purchases,
    SUM(TotalPrice) AS Lifetime_Value
FROM orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 1
ORDER BY Lifetime_Value DESC;

-- C. Coupon Usage Impact Analysis
SELECT 
    CASE 
        WHEN CouponCode IS NULL OR CouponCode = '' THEN 'No Coupon'
        ELSE CouponCode
    END AS Coupon_Type,
    COUNT(OrderID) AS Uses_Count,
    SUM(Quantity) AS Units_Moved,
    AVG(TotalPrice) AS Avg_Order_Value
FROM orders
GROUP BY Coupon_Type
ORDER BY Uses_Count DESC;
