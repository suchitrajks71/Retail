-- Retail Analytics--

-- Create a schema named retail_data
create schema retail_data;

-- set retail_data as the default schema
use retail_data;

-- Loading the data
select * from marketing_campaign;

-- 3: Data Preprocessing
-- 3.1 Total no of customer encounters
select count(*) as total_encounters from marketing_campaign;

-- 3.2 Top 10 most purchased products
SELECT 
    CASE 
        WHEN product_name = 'MntWines'        THEN 'Wines'
        WHEN product_name = 'MntFruits'       THEN 'Fruits'
        WHEN product_name = 'MntMeatProducts' THEN 'Meat Products'
        WHEN product_name = 'MntFishProducts' THEN 'Fish Products'
        WHEN product_name = 'MntSweetProducts' THEN 'Sweet Products'
        WHEN product_name = 'MntGoldProds'    THEN 'Gold Products'
    END AS product_category,
    SUM(product_amount) AS total_purchases
FROM (
    SELECT 'MntWines' AS product_name, MntWines AS product_amount
    FROM marketing_campaign
    UNION ALL
    SELECT 'MntFruits' AS product_name, MntFruits AS product_amount
    FROM marketing_campaign
    UNION ALL
    SELECT 'MntMeatProducts' AS product_name, MntMeatProducts AS product_amount
    FROM marketing_campaign
    UNION ALL
    SELECT 'MntFishProducts' AS product_name, MntFishProducts AS product_amount
    FROM marketing_campaign
    UNION ALL
    SELECT 'MntSweetProducts' AS product_name, MntSweetProducts AS product_amount
    FROM marketing_campaign
    UNION ALL
    SELECT 'MntGoldProds' AS product_name, MntGoldProds AS product_amount
    FROM marketing_campaign
) AS subquery
GROUP BY product_category
ORDER BY total_purchases DESC
LIMIT 10;

-- 3.3 Count of response values
select response, count(*)
from marketing_campaign
group by response;

-- 3.4 Distribution of customer based on their education level and marital status
select education, marital_status, count(*) as cust_count
from marketing_campaign
group by education, marital_status
order by education, marital_status ;

-- 3.5 Average income of customers who participated in the marketing campaign
SELECT AVG(Income) AS avg_income
FROM marketing_campaign;

-- 3.6 Total no of promotions accepted by customers
SELECT 
    id,
    SUM(AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5) 
    AS total_promotions_accepted
FROM marketing_campaign
GROUP BY id;

-- 3.7 Distribution of customers response to last campaign
SELECT 
    Response,
    COUNT(*) AS response_count
FROM marketing_campaign
GROUP BY Response;

-- 3.8 Average no of children and teenagers in customers housholds
select avg(kidhome) as avg_children, 
       avg(teenhome) as avg_teenagers
from marketing_campaign;

-- 3.9 Create age column by subtracting year_birth from current year
ALTER TABLE marketing_campaign
ADD Age INT;

SET sql_safe_updates = 0;
UPDATE marketing_campaign
SET Age = YEAR(NOW()) - year_birth;
SET sql_safe_updates = 1;

-- 3.10 create Age-group column
ALTER TABLE marketing_campaign
ADD Age_group TEXT;

set sql_safe_updates = 0;
update marketing_campaign
SET Age_group = CASE 
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 55 THEN '46-55'
    ELSE '56+'
END;
set sql_safe_updates = 1;

-- 3.11 Average no of visits per month for customers in eaach age group
select age_group, avg(numwebvisitsmonth) as avgnumvisits
from marketing_campaign
group by age_group
order by age_group;







