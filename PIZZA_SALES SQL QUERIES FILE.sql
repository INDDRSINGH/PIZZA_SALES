USE pizaa_sales;

SELECT * FROM pizza_sales;

update pizza_sales set order_date = str_to_date(order_date,"%d-%m-%Y");
update pizza_sales set order_time =  time_format(order_time,'%H:%i:%s');

ALTER TABLE `pizaa_sales`.`pizza_sales` 
CHANGE COLUMN `order_date` `order_date` DATE NULL DEFAULT NULL ,
ADD PRIMARY KEY (`pizza_id`),
CHANGE COLUMN `order_time` `order_time` TIME NULL DEFAULT NULL ;


-- Q1 : TO FIND THE TOTAL SUM 

select round(sum(total_price),2) as Total_revenue from pizza_sales;

-- Q2 : AVERAGE ORDER VALUE.

SELECT ROUND(SUM(TOTAL_PRICE) / COUNT(DISTINCT ORDER_ID),2) AS AVG_ORDER_VALUE FROM PIZZA_SALES;

-- Q3 : TOTAL PIZZAS SOLD

SELECT SUM(QUANTITY) AS TOTAL_PIZZAS_SOLD FROM PIZZA_SALES;

-- Q4 : TOTAL ORDERS PLACED

SELECT COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDERS FROM PIZZA_SALES;

-- Q5 : AVG PIZZAS SOLD IN EACH ORDER (SUM OF NUMBER OF PIZZAS SOLD/ UNIQUE ORDERS)

SELECT SUM(QUANTITY)/COUNT(DISTINCT ORDER_ID) AS AVG_PIZZA_SOLD FROM PIZZA_SALES;

-- Q6 : DAILY TREND OF SALES.

SELECT DATE_FORMAT(ORDER_DATE, "%a") AS DAYS, COUNT(DISTINCT ORDER_ID) AS NUMBER_OF_ORDERS
FROM PIZZA_SALES
GROUP BY days;


-- Q7 : HOURLY TREND.

SELECT TIME_FORMAT(ORDER_TIME, "%H") AS TIME_INTERVAL, COUNT(DISTINCT ORDER_ID) AS NUMBER_OF_ORDERS
FROM PIZZA_SALES
GROUP BY TIME_INTERVAL;


-- Q8 : PERCENTAGE OF SALES BY PIZZA CATEGORY

SELECT PIZZA_CATEGORY, ROUND(SUM(TOTAL_PRICE) * 100 / (SELECT SUM(TOTAL_PRICE) FROM PIZZA_SALES),2) AS SALES_PERCENTAGE
FROM PIZZA_SALES
GROUP BY PIZZA_CATEGORY;


-- Q9 : PERCENTAGE OF SALES BY PIZZA SIZE

SELECT PIZZA_SIZE, ROUND(SUM(TOTAL_PRICE) * 100 / (SELECT SUM(TOTAL_PRICE) FROM PIZZA_SALES),2) AS SALES_PERCENTAGE
FROM PIZZA_SALES
GROUP BY PIZZA_SIZE
ORDER BY SALES_PERCENTAGE DESC ;


-- Q10 : Daily sales Quarter wise in each day of the week.

with month_wise as (
select DATE_FORMAT(ORDER_DATE, "%a") AS DAYS, case when quarter(order_date) = 1  then order_id end as q1,
case when quarter(order_date) = 2  then order_id end as q2,
case when quarter(order_date) = 3  then order_id end as q3,
case when quarter(order_date) = 4  then order_id end as q4
from pizza_sales)

SELECT  days,SUM(distinct Q1) AS Q1, SUM(distinct Q2) AS Q2, SUM(distinct Q3) AS Q3,SUM(distinct Q4) AS Q4
FROM MONTH_WISE
group by days
order by days;


-- Q11 : TOTAL PIZZAS SOLD IN EACH PIZZA CATEGORY.

SELECT PIZZA_CATEGORY, SUM(QUANTITY) AS TOTAL_QUANTITY_SOLD
FROM PIZZA_SALES
GROUP BY PIZZA_CATEGORY;


-- Q12 : TOP 5 PIZZAS SOLD

SELECT PIZZA_NAME, SUM(QUANTITY) AS NUMBER_OF_PIZZAS_SOLD
FROM PIZZA_SALES
GROUP BY PIZZA_NAME
ORDER BY NUMBER_OF_PIZZAS_SOLD DESC
LIMIT 5;


-- Q13 : BOTTOM 5 PIZZAS SOLD

SELECT PIZZA_NAME, SUM(QUANTITY) AS NUMBER_OF_PIZZAS_SOLD
FROM PIZZA_SALES
GROUP BY PIZZA_NAME
ORDER BY NUMBER_OF_PIZZAS_SOLD ASC
LIMIT 5;