# PIZZA_SALES

````SQL
USE pizaa_sales;
````

**Checking Dataset**

````sql
SELECT * FROM pizza_sales;
````


**After uploading the data from CSV file, ORDER_DATE and ORDER_TIME were changed to changed to VARCHAR.**

**TYPE CONVERSION : Updating PIZZA_SALES table to change the "ORDER_DATE" and "ORDER_TIME" column from VARCHAR to DATE and TIME format respectively.**

````sql
update pizza_sales set order_date = str_to_date(order_date,"%d-%m-%Y");
update pizza_sales set order_time =  time_format(order_time,'%H:%i:%s');
````
**Changing Table format**

````sql
ALTER TABLE `pizaa_sales`.`pizza_sales` 
CHANGE COLUMN `order_date` `order_date` DATE NULL DEFAULT NULL ,
ADD PRIMARY KEY (`pizza_id`),
CHANGE COLUMN `order_time` `order_time` TIME NULL DEFAULT NULL ;
````

**Q1 : TO FIND THE TOTAL SUM OF SALES.**

````sql
select round(sum(total_price),2) as Total_revenue from pizza_sales;
````
**Result :**

| Total_revenue |
|---------------|
|     817860.05 |



**Q2 : AVERAGE ORDER VALUE.**

````sql
SELECT ROUND(SUM(TOTAL_PRICE) / COUNT(DISTINCT ORDER_ID),2) AS AVG_ORDER_VALUE FROM PIZZA_SALES;
````

**Result :**

| AVG_ORDER_VALUE |
|-----------------|
|           38.31 |

** Q3 : TOTAL PIZZAS SOLD**

````sql
SELECT SUM(QUANTITY) AS TOTAL_PIZZAS_SOLD FROM PIZZA_SALES;
````

**Result :**


| TOTAL_PIZZAS_SOLD |
|-------------------|
|             49574 |

**Q4 : TOTAL ORDERS PLACED**

````sql
SELECT COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDERS FROM PIZZA_SALES;
````

**Result :**


| TOTAL_ORDERS |
|--------------|
|        21350 |

**Q5 : AVG PIZZAS SOLD IN EACH ORDER (SUM OF NUMBER OF PIZZAS SOLD/ UNIQUE ORDERS)**

````sql
SELECT SUM(QUANTITY)/COUNT(DISTINCT ORDER_ID) AS AVG_PIZZA_SOLD FROM PIZZA_SALES;
````

**Result :**


| AVG_PIZZA_SOLD |
|----------------|
|         2.3220 |


**Q6 : DAILY TREND OF SALES.**

````sql
SELECT DATE_FORMAT(ORDER_DATE, "%a") AS DAYS, COUNT(DISTINCT ORDER_ID) AS NUMBER_OF_ORDERS
FROM PIZZA_SALES
GROUP BY days;
````

**Result :**


| DAYS | NUMBER_OF_ORDERS |
+------+------------------+
| Fri  |             3538 |
| Mon  |             2794 |
| Sat  |             3158 |
| Sun  |             2624 |
| Thu  |             3239 |
| Tue  |             2973 |
| Wed  |             3024 |


**Q7 : HOURLY TREND.**

````sql
SELECT TIME_FORMAT(ORDER_TIME, "%H") AS TIME_INTERVAL, COUNT(DISTINCT ORDER_ID) AS NUMBER_OF_ORDERS
FROM PIZZA_SALES
GROUP BY TIME_INTERVAL;
````

**Result :**


| TIME_INTERVAL | NUMBER_OF_ORDERS |
|---------------|------------------|
| 09            |                1 |
| 10            |                8 |
| 11            |             1231 |
| 12            |             2520 |
| 13            |             2455 |
| 14            |             1472 |
| 15            |             1468 |
| 16            |             1920 |
| 17            |             2336 |
| 18            |             2399 |
| 19            |             2009 |
| 20            |             1642 |
| 21            |             1198 |
| 22            |              663 |
| 23            |               28 |


**Q8 : PERCENTAGE OF SALES BY PIZZA CATEGORY**

````sql
SELECT PIZZA_CATEGORY, ROUND(SUM(TOTAL_PRICE) * 100 / (SELECT SUM(TOTAL_PRICE) FROM PIZZA_SALES),2) AS SALES_PERCENTAGE
FROM PIZZA_SALES
GROUP BY PIZZA_CATEGORY;
````

**Result :**


| PIZZA_CATEGORY | SALES_PERCENTAGE |
|----------------|------------------|
| Classic        |            26.91 |
| Veggie         |            23.68 |
| Supreme        |            25.46 |
| Chicken        |            23.96 |


**Q9 : PERCENTAGE OF SALES BY PIZZA SIZE**

````sql
SELECT PIZZA_SIZE, ROUND(SUM(TOTAL_PRICE) * 100 / (SELECT SUM(TOTAL_PRICE) FROM PIZZA_SALES),2) AS SALES_PERCENTAGE
FROM PIZZA_SALES
GROUP BY PIZZA_SIZE
ORDER BY SALES_PERCENTAGE DESC ;
````

**Result :**


| PIZZA_SIZE | SALES_PERCENTAGE |
|------------|------------------|
| L          |            45.89 |
| M          |            30.49 |
| S          |            21.77 |
| XL         |             1.72 |
| XXL        |             0.12 |

**Q10 : Daily sales Quarter wise in each day of the week.**

````sql
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
````


**Result :**


| DAYS | Q1      | Q2      | Q3       | Q4       |
|------|---------|---------|----------|----------|
| Fri  | 2337496 | 7297091 | 11751260 | 16000223 |
| Mon  | 2113141 | 6559030 | 10195512 |  9869011 |
| Sat  | 2010414 | 6463383 | 11382374 | 13910823 |
| Sun  | 1814606 | 5451506 |  8952386 | 11560519 |
| Thu  | 1957843 | 6143549 |  9501729 | 17911472 |
| Tue  | 2250927 | 5937063 | 10479613 | 13295519 |
| Wed  | 1936708 | 5998653 | 11212744 | 13627330 |


**Q11 : TOTAL PIZZAS SOLD IN EACH PIZZA CATEGORY.**

````sql
SELECT PIZZA_CATEGORY, SUM(QUANTITY) AS TOTAL_QUANTITY_SOLD
FROM PIZZA_SALES
GROUP BY PIZZA_CATEGORY;
````


**Result :**


| PIZZA_CATEGORY | TOTAL_QUANTITY_SOLD |
|----------------|---------------------|
| Classic        |               14888 |
| Veggie         |               11649 |
| Supreme        |               11987 |
| Chicken        |               11050 |


**Q12 : TOP 5 PIZZAS SOLD**

````sql
SELECT PIZZA_NAME, SUM(QUANTITY) AS NUMBER_OF_PIZZAS_SOLD
FROM PIZZA_SALES
GROUP BY PIZZA_NAME
ORDER BY NUMBER_OF_PIZZAS_SOLD DESC
LIMIT 5;
````

**Result :**


| PIZZA_NAME                 | NUMBER_OF_PIZZAS_SOLD |
|----------------------------|-----------------------|
| The Classic Deluxe Pizza   |                  2453 |
| The Barbecue Chicken Pizza |                  2432 |
| The Hawaiian Pizza         |                  2422 |
| The Pepperoni Pizza        |                  2418 |
| The Thai Chicken Pizza     |                  2371 |


**Q13 : BOTTOM 5 PIZZAS SOLD**

````sql
SELECT PIZZA_NAME, SUM(QUANTITY) AS NUMBER_OF_PIZZAS_SOLD
FROM PIZZA_SALES
GROUP BY PIZZA_NAME
ORDER BY NUMBER_OF_PIZZAS_SOLD ASC
LIMIT 5;
````

**Result :**


| PIZZA_NAME                | NUMBER_OF_PIZZAS_SOLD |
|---------------------------|-----------------------|
| The Brie Carre Pizza      |                   490 |
| The Mediterranean Pizza   |                   934 |
| The Calabrese Pizza       |                   937 |
| The Spinach Supreme Pizza |                   950 |
| The Soppressata Pizza     |                   961 |


