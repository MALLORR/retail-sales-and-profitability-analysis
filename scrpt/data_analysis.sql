/*
PROJECT: SUPERSTORE SALES ANALYSIS

PHASE 2: EXPLORATORY DATA ANALYSIS

SECTION 1: OVERALL BUSINESS PERFORMANCE

OBJECTIVE:
To understand the overall performance of the
business using key sales and profitability metrics.
*/

USE `sales.superstore_orders`;


-Overall Business Performance
SELECT
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    SUM(Quantity) AS Total_Quantity_Sold

FROM superstore_cleaned; 


/*
 SALES TREND ANALYSIS

YEARLY SALES PERFORMANCE
*/

SELECT
    YEAR(Order_Date) AS Sales_Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders

FROM superstore_cleaned

GROUP BY YEAR(Order_Date)

ORDER BY Sales_Year;


/*
 MONTHLY SALES PERFORMANCE

OBJECTIVE:
To examine monthly sales and profit performance
and identify high-performing months.
*/

SELECT
    MONTH(Order_Date) AS Sales_Month,
    MONTHNAME(Order_Date) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders

FROM superstore_cleaned

GROUP BY
    MONTH(Order_Date),
    MONTHNAME(Order_Date)

ORDER BY Sales_Month;

/*
 BEST-PERFORMING MONTHS

OBJECTIVE:
Rank months according to total sales revenue.
*/

SELECT
    MONTHNAME(Order_Date) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit

FROM superstore_cleaned

GROUP BY
    MONTH(Order_Date),
    MONTHNAME(Order_Date)

ORDER BY Total_Sales DESC;

/*
MONTHLY SALES GROWTH ANALYSIS

OBJECTIVE:
Calculate month-over-month sales growth
to identify periods of increasing or declining revenue.
*/

WITH Monthly_Sales AS (
    SELECT
        YEAR(Order_Date) AS Sales_Year,
        MONTH(Order_Date) AS Sales_Month,
        MONTHNAME(Order_Date) AS Month_Name,
        SUM(Sales) AS Total_Sales

    FROM superstore_cleaned

    GROUP BY
        YEAR(Order_Date),
        MONTH(Order_Date),
        MONTHNAME(Order_Date)
),

Sales_Growth AS (
    SELECT
        Sales_Year,
        Sales_Month,
        Month_Name,
        Total_Sales,

        LAG(Total_Sales) OVER (
            ORDER BY Sales_Year, Sales_Month
        ) AS Previous_Month_Sales

    FROM Monthly_Sales
)

SELECT
    Sales_Year,
    Month_Name,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(Previous_Month_Sales, 2) AS Previous_Month_Sales,

    ROUND(
        ((Total_Sales - Previous_Month_Sales)
        / NULLIF(Previous_Month_Sales, 0)) * 100, 2
    ) AS Sales_Growth_Percentage

FROM Sales_Growth

ORDER BY Sales_Year, Sales_Month;

/*
SECTION 3: PRODUCT PERFORMANCE ANALYSIS

 SALES PERFORMANCE BY PRODUCT CATEGORY

OBJECTIVE:
Evaluate revenue, profitability and sales volume
across the different product categories.
*/

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity_Sold,
    COUNT(DISTINCT Product_ID) AS Total_Products
FROM superstore_cleaned
GROUP BY Category
ORDER BY Total_Sales DESC;


/* Sub-Category */

SELECT
    Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity_Sold
FROM superstore_cleaned
GROUP BY Sub_Category
ORDER BY Total_Sales DESC;

/* Profitability by Product Category */

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        (SUM(Profit) / NULLIF(SUM(Sales), 0)) * 100,
        2
    ) AS Profit_Margin_Percentage
FROM superstore_cleaned
GROUP BY Category
ORDER BY Profit_Margin_Percentage DESC;


/* Most Profitable Products */

SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_cleaned
GROUP BY
    Product_ID,
    Product_Name,
    Category,
    Sub_Category
ORDER BY Total_Profit DESC
LIMIT 10;


/* Most Loss-Making  Products */

SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_cleaned
GROUP BY
    Product_ID,
    Product_Name,
    Category,
    Sub_Category
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 10; category


/*
SECTION 4: CUSTOMER ANALYSIS

 SALES PERFORMANCE BY CUSTOMER SEGMENT

OBJECTIVE:
Evaluate sales, profit and order volume
across different customer segments.
*/

SELECT
    Segment,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM superstore_cleaned
GROUP BY Segment
ORDER BY Total_Sales DESC;


/*
 TOP 10 CUSTOMERS BY SALES

OBJECTIVE:
Identify customers who generate the highest sales revenue.
*/

SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_cleaned
GROUP BY
    Customer_ID,
    Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;


/*
TOP 10 CUSTOMERS BY PROFIT

OBJECTIVE:
Identify customers who contribute the highest
profit to the business.
*/

SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_cleaned
GROUP BY
    Customer_ID,
    Customer_Name
ORDER BY Total_Profit DESC
LIMIT 10;


/*
CUSTOMER PURCHASING PATTERNS

OBJECTIVE:
Examine customer order frequency to understand
purchasing behaviour.
*/

WITH Customer_Orders AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS Total_Orders
    FROM superstore_cleaned
    GROUP BY Customer_ID
)
SELECT
    Total_Orders,
    COUNT(*) AS Number_of_Customers
FROM Customer_Orders
GROUP BY Total_Orders
ORDER BY Total_Orders;


/*
SECTION 5: REGIONAL PERFORMANCE ANALYSIS

SALES PERFORMANCE BY REGION

OBJECTIVE:
Compare revenue, profit and order volume
across geographical regions.
*/

SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM superstore_cleaned
GROUP BY Region
ORDER BY Total_Sales DESC;


/*
SALES PERFORMANCE BY STATE

OBJECTIVE:
Compare sales, profit and order volume
across individual states.
*/

SELECT
    State,
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM superstore_cleaned
GROUP BY State, Region
ORDER BY Total_Sales DESC;


/*
 TOP 10 CITIES BY SALES

OBJECTIVE:
Identify the highest-revenue cities
and compare their profitability.
*/

SELECT
    City,
    State,
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM superstore_cleaned
GROUP BY City, State, Region
ORDER BY Total_Sales DESC
LIMIT 10;


/*
 LOSS-MAKING CITIES

OBJECTIVE:
Identify the 10 cities with the
lowest profit contributions.
*/

SELECT
    City,
    State,
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_cleaned
GROUP BY City, State, Region
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 10; 


