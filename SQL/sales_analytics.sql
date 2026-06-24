-- ==================================
-- SALES ANALYTICS
-- ==================================
-- Purpose: Analyze revenue trends, product performance, and sales patterns

-- ==================================
-- KPI: Total revenue & quantity sold
-- ==================================
SELECT 
  SUM(`Total Amount`) AS total_revenue, 
  SUM(`Quantity`) AS total_quantity_sold
FROM `project-5fb8896c-d461-49e8-a4c.retail_project.sales_fact`;

-- ==================================
-- Revenue by month
-- ==================================
SELECT 
  d.month_name, 
  SUM(sf.`Total amount`) AS revenue
FROM `project-5fb8896c-d461-49e8-a4c.retail_project.sales_fact` AS sf
INNER JOIN `project-5fb8896c-d461-49e8-a4c.retail_project.dates` AS d
  ON sf.Date = d.Date
GROUP BY d.month_name
ORDER BY revenue DESC;

-- ==================================
-- Revenue by weekday
-- ==================================
SELECT 
  d.weekday, 
  SUM(`Total Amount`) AS total_revenue
FROM `project-5fb8896c-d461-49e8-a4c.retail_project.sales_fact` AS sf
INNER JOIN `project-5fb8896c-d461-49e8-a4c.retail_project.dates` AS d
  ON sf.Date = d.Date
GROUP BY d.weekday
ORDER BY total_revenue DESC;

-- ==================================
-- Product / Sales behavior: Revenue by Product Category
-- ==================================
SELECT 
  `Product Category`, 
  SUM(`Total Amount`) AS revenue
FROM `project-5fb8896c-d461-49e8-a4c.retail_project.sales_fact`
GROUP BY `Product Category`
ORDER BY revenue DESC;

-- ==================================
-- Customer segment analysis: Top customers + revenue contribution
-- ==================================
WITH customer_revenue AS (
  SELECT `Customer ID`, SUM(`Total Amount`) AS total_spent
  FROM `project-5fb8896c-d461-49e8-a4c.retail_project.sales_fact` 
  GROUP BY `Customer ID` 
), 

total_revenue AS (
  SELECT SUM(total_spent) AS overall_revenue
  FROM customer_revenue
)

SELECT 
  cr.`Customer ID`, 
  cr.total_spent, 
  ROUND(cr.total_spent/tr.overall_revenue * 100, 2) AS revenue_share
FROM customer_revenue AS cr
CROSS JOIN total_revenue AS tr
ORDER BY cr.total_spent DESC;

-- ==================================
-- Revenue by age group 
-- ==================================
SELECT CASE
  WHEN cd.age BETWEEN 18 AND 25 THEN '18-25'
  WHEN cd.age BETWEEN 26 AND 35 THEN '26-35'
  WHEN cd.age BETWEEN 36 AND 50 THEN '36-50'
  ELSE '50+'
  END AS age_group, 
  SUM(sf.`Total Amount`) AS total_revenue
FROM `project-5fb8896c-d461-49e8-a4c.retail_project.sales_fact` AS sf
INNER JOIN `project-5fb8896c-d461-49e8-a4c.retail_project.customers_dim` AS cd
  ON sf.`Customer ID` = cd.`Customer ID`
GROUP BY age_group 
ORDER BY age_group;

-- ==================================
-- Revenue by gender
-- ==================================
SELECT 
  cd.gender, 
  SUM(`Total Amount`) AS total_revenue
FROM `project-5fb8896c-d461-49e8-a4c.retail_project.sales_fact` AS sf
INNER JOIN `project-5fb8896c-d461-49e8-a4c.retail_project.customers_dim` AS cd
  ON sf.`Customer ID` = cd.`Customer ID`
GROUP BY cd.gender
ORDER BY total_revenue DESC;
