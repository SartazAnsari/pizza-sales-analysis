-- CREATING DATABASE --

CREATE DATABASE IF NOT EXISTS pizza_sales_db;
USE pizza_sales_db;




-- CREATING TABLES --

CREATE TABLE IF NOT EXISTS pizza_sales_db.pizzas_tbl (
    pizza_id VARCHAR(255) NOT NULL PRIMARY KEY
    , pizza_type_id VARCHAR(255) NOT NULL
    , size CHAR (10) NOT NULL
    , price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS pizza_sales_db.pizza_types_tbl (
    pizza_type_id VARCHAR(255) NOT NULL PRIMARY KEY
    , name VARCHAR(255) NOT NULL
    , category VARCHAR(255) NOT NULL
    , ingredients VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS pizza_sales_db.orders_tbl (
    order_id INT NOT NULL PRIMARY KEY
    , date DATE NOT NULL
    , time TIME NOT  NULL
);

CREATE TABLE IF NOT EXISTS pizza_sales_db.order_details_tbl (
    order_details_id INT NOT NULL PRIMARY KEY
    , order_id INT NOT NULL
    , pizza_id VARCHAR(255) NOT NULL
    , quantity INT NOT NULL
);




-- LOADING DATA INTO TABLES --

LOAD DATA INFILE 'D:\\ProgramData\\MySQL\\MySQL Server 8.3\\Uploads\\Pizza Sales dataset\\pizzas.csv'
    INTO TABLE pizza_sales_db.pizzas_tbl
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

LOAD DATA INFILE 'D:\\ProgramData\\MySQL\\MySQL Server 8.3\\Uploads\\Pizza Sales dataset\\pizza_types.csv'
    INTO TABLE pizza_sales_db.pizza_types_tbl
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 ROWS;

LOAD DATA INFILE 'D:\\ProgramData\\MySQL\\MySQL Server 8.3\\Uploads\\Pizza Sales dataset\\orders.csv'
    INTO TABLE pizza_sales_db.orders_tbl
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

LOAD DATA INFILE 'D:\\ProgramData\\MySQL\\MySQL Server 8.3\\Uploads\\Pizza Sales dataset\\order_details.csv'
    INTO TABLE pizza_sales_db.order_details_tbl
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;




-- EXPLORATORY DATA ANALYSIS --

SELECT * FROM pizza_sales_db.pizzas_tbl LIMIT 100;
SELECT * FROM pizza_sales_db.pizza_types_tbl LIMIT 100;
SELECT * FROM pizza_sales_db.orders_tbl LIMIT 100;
SELECT * FROM pizza_sales_db.order_details_tbl LIMIT 100;


-- total number of order places

SELECT COUNT(*) FROM pizza_sales_db.orders_tbl;


-- total revenue of pizza sales

SELECT 
    SUM(od.quantity * p.price) AS total_revenue
FROM pizza_sales_db.order_details_tbl od
    JOIN pizza_sales_db.pizzas_tbl p ON od.pizza_id = p.pizza_id;


-- highest priced pizza

SELECT
    pt.name
    , p.price
FROM pizza_sales_db.pizzas_tbl p
    JOIN pizza_sales_db.pizza_types_tbl pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY
    p.price DESC
LIMIT 1;


-- most common pizza size ordered

SELECT
    p.size
    , COUNT(p.size) AS sizes_ordered
FROM pizza_sales_db.order_details_tbl od
    JOIN pizza_sales_db.pizzas_tbl p ON od.pizza_id = p.pizza_id
GROUP BY 
    p.size
ORDER BY
    sizes_ordered DESC
LIMIT 1;


-- top 5 most ordered pizzas with their quantities

SELECT
    pt.name AS pizza_name
    , SUM(od.quantity) AS total_quantities
FROM pizza_sales_db.order_details_tbl od
    JOIN pizza_sales_db.pizzas_tbl p ON od.pizza_id = p.pizza_id
    JOIN pizza_sales_db.pizza_types_tbl pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    p.pizza_type_id
ORDER BY
    total_quantities DESC
LIMIT 5;


--  total quantity of each pizza category ordered

SELECT
    pt.category
    , SUM(od.quantity) AS total_ordered
FROM pizza_sales_db.order_details_tbl od
    JOIN pizza_sales_db.pizzas_tbl p ON od.pizza_id = p.pizza_id
    JOIN pizza_sales_db.pizza_types_tbl pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category;    ;


-- distribution of orders by hour of the day

SELECT
    HOUR(time) as hour
    , COUNT(order_id) AS orders
FROM pizza_sales_db.orders_tbl
GROUP BY 
    hour;


-- category-wise distribution of pizzas

SELECT
    category
    , COUNT(category) AS pizza_count
FROM pizza_sales_db.pizza_types_tbl
GROUP BY 
    category;


-- average number of pizzas ordered per day

SELECT
    AVG(pizzas_orders) AS avg_pizza_orders
FROM (
    SELECT
        o.date AS date
        , SUM(od.quantity) AS pizzas_orders
    FROM pizza_sales_db.order_details_tbl od
        JOIN pizza_sales_db.orders_tbl o ON od.order_id = o.order_id
    GROUP BY 
        date
) AS total_orders_per_day;


-- top 3 most ordered pizza types 

SELECT
    pt.name
    , SUM(od.quantity * p.price) AS total_revenue
FROM pizza_sales_db.order_details_tbl od
    JOIN pizza_sales_db.pizzas_tbl p ON od.pizza_id = p.pizza_id
    JOIN pizza_sales_db.pizza_types_tbl pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name
ORDER BY 
    total_revenue DESC
LIMIT 3;


-- percentage of each pizza category to total revenue

SELECT
    pt.category
    , ROUND(
        SUM(od.quantity * p.price) / (
            SELECT 
                SUM(od.quantity * p.price) 
            FROM pizza_sales_db.order_details_tbl od 
                JOIN pizza_sales_db.pizzas_tbl p ON od.pizza_id = p.pizza_id
        ) * 100 
    , 2) AS revenue_percentage
FROM pizza_sales_db.order_details_tbl od
    JOIN pizza_sales_db.pizzas_tbl p ON od.pizza_id = p.pizza_id
    JOIN pizza_sales_db.pizza_types_tbl pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category


-- cumulative revenue generated over time

WITH sales_per_day AS (
    SELECT
        o.date AS date
        , SUM(od.quantity * p.price) AS revenue
    FROM pizza_sales_db.order_details_tbl od
        JOIN pizza_sales_db.pizzas_tbl p ON od.pizza_id = p.pizza_id
        JOIN pizza_sales_db.orders_tbl o ON od.order_id = o.order_id
    GROUP BY 
        date
)

SELECT
    date
    , SUM(revenue) OVER(ORDER BY date) AS cum_revenue
FROM sales_per_day;


-- top 3 most ordered pizza types based on revenue for each pizza category

WITH category_name_revenue AS (
    SELECT
        pt.category AS category
        , pt.name AS name
        , SUM(od.quantity * p.price) AS revenue
    FROM pizza_sales_db.order_details_tbl od
        JOIN pizza_sales_db.pizzas_tbl p ON od.pizza_id = p.pizza_id
        JOIN pizza_sales_db.pizza_types_tbl pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY
        category
        , name
    ORDER BY 
        category
        , revenue
)

SELECT
    rnk
    , category
    , name
    , revenue
FROM (
    SELECT
        category
        , name
        , revenue
        , RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rnk
    FROM category_name_revenue
) AS rnk_tbl
WHERE rnk <= 3;