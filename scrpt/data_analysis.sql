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