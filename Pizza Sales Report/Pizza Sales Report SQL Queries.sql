/*PIZZA SALES REPORT SQL QUERIES*/
--USE [Pizza DB];

--Total Revenue--
SELECT SUM(total_price) AS Total_Revenue FROM [Pizza DB]..pizza_sales;

--Average Order Value--
SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Average_Order_Value FROM [Pizza DB]..pizza_sales;

--Total Pizzas Sold--
SELECT SUM(quantity) AS Total_Pizzas_Sold FROM [Pizza DB]..pizza_sales;

--Total Orders--
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM [Pizza DB]..pizza_sales;

--Average Pizzas Per Order--
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Average_Pizzas_Per_Order 
FROM [Pizza DB]..pizza_sales;

--Daily Trend For Total Orders--
SELECT DATENAME(WEEKDAY, order_date) AS Order_Day, COUNT(DISTINCT order_id) AS Total_Orders FROM [Pizza DB]..pizza_sales 
GROUP BY DATENAME(WEEKDAY, order_date);

--Monthly Trend For Total Orders--
SELECT DATENAME(MONTH, order_date) AS Month_Name, COUNT(DISTINCT order_id) AS Total_Orders FROM [Pizza DB]..pizza_sales
GROUP BY DATENAME(MONTH, order_date);

--Percentage of Sales by Pizza Category--
SELECT pizza_category, CAST((CAST(SUM(total_price) AS DECIMAL(10,2)) * 100 / (SELECT SUM(total_price) FROM [Pizza DB]..pizza_sales)) AS DECIMAL(10,2)) AS PCT
FROM [Pizza DB]..pizza_sales GROUP BY pizza_category;

--Percentage of Sales by Pizza Size--
SELECT pizza_size, CAST((CAST(SUM(total_price) AS DECIMAL(10,2)) * 100 / (SELECT SUM(total_price) FROM [Pizza DB]..pizza_sales)) AS DECIMAL(10,2)) AS PCT
FROM [Pizza DB]..pizza_sales GROUP BY pizza_size;

--Total Pizzas Sold By Pizza Category--
SELECT pizza_category, SUM(quantity) AS Total_Pizzas_Sold FROM [Pizza DB]..pizza_sales GROUP BY pizza_category ORDER BY Total_Pizzas_Sold DESC;

--Top 5 Pizzas by Revenue--
SELECT TOP 5 pizza_name, SUM(total_price) AS Revenue FROM [Pizza DB]..pizza_sales GROUP BY pizza_name ORDER BY Revenue DESC;

--Bottom 5 Pizzas by Revenue--
SELECT TOP 5 pizza_name, SUM(total_price) AS Revenue FROM [Pizza DB]..pizza_sales GROUP BY pizza_name ORDER BY Revenue;

--Top 5 Pizzas by Quantity--
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizzas_Sold FROM  [Pizza DB]..pizza_sales GROUP BY pizza_name ORDER BY Total_Pizzas_Sold DESC;

--Bottom 5 Pizzas by Quantity--
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizzas_Sold FROM [Pizza DB]..pizza_sales GROUP BY pizza_name ORDER BY Total_Pizzas_Sold;

--Top 5 Pizzas by Total Orders--
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders FROM [Pizza DB]..pizza_sales GROUP BY pizza_name ORDER BY Total_Orders DESC;

--Bottom 5 Pizzas by Total Orders--
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders FROM [Pizza DB]..pizza_sales GROUP BY pizza_name ORDER BY Total_Orders;