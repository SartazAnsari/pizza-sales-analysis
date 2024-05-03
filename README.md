# Pizza Sales Analysis
## Overview
This project involves analyzing sales data of pizza using SQL queries. The dataset used can be found [here](https://www.kaggle.com/datasets/mysarahmadbhat/pizza-place-sales).

## Dataset
The dataset consists of four CSVs:

1. **pizzas**: Stores information about individual pizzas.
    * `pizza_id`: Unique identifier for the pizza.
    * `pizza_type_id`: Identifier referencing the type of pizza.
    * `size`: Size of the pizza.
    * `price`: Price of the pizza.
2. **pizza_types**: Contains details about different types of pizzas.
    * `pizza_type_id`: Unique identifier for the pizza type.
    * `name`: Name of the pizza type.
    * `category`: Category of the pizza.
    * `ingredients`: Ingredients used in the pizza.
3. **orders**: Records details about orders.
    * `order_id`: Unique identifier for the order.
    * `date`: Date of the order.
    * `time`: Time of the order.
4. **order_details**: Stores information about individual pizza orders within orders.
    * `order_details_id`: Unique identifier for the order details.
    * `order_id`: Identifier referencing the order.
    * `pizza_id`: Identifier referencing the pizza.
    * `quantity`: Quantity of pizzas ordered.

## Setup Instructions
1. Ensure you have MySQL Server 8.3 or higher installed on your system.
2. Open MySQL Workbench or any MySQL client tool.
3. **[Optional]** If you are using VSCode
    * If you are using VSCode with [MySQL by Jun Han](https://marketplace.visualstudio.com/items?itemName=formulahendry.vscode-mysql) extension then create a new user with old authentication type as the extension does't support new authentication type as of now.
        ```
        CREATE USER 'user'@'localhost' IDENTIFIED with mysql_native_password by 'password';
        GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';
        FLUSH PRIVILEGES;
        ```
    * If you are using VSCode with any other extension that supports new authentication type then you can proceed using new authentication type.
        ```
        CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';
        GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';
        FLUSH PRIVILEGES;
        ```
5. Download the [dataset](https://www.kaggle.com/datasets/mysarahmadbhat/pizza-place-sales?select=order_details.csv) from Kaggle.
4. Place it in the location specified by your MySQL server's secure file privilege setting. You can find the path by executing
    ```
    SHOW VARIABLES LIKE 'secure_file_priv';
    ```

***Note:** Make sure to adjust file paths in the `LOAD DATA INFILE` statements according to your local file system.*

## SQL Queries
The SQL queries provided below perform various analyses on the sales data:

* **Creating Database and Tables:** Defines the database schema and creates tables for storing sales and customer data.
* **Loading Data into Tables:** Loads data from CSV files into the respective tables in the database.
* **Exploratory Data Analysis:** Performs exploratory analysis on the sales data.
* **Analytical Queries:** Performs various analytical queries to gain insights into sales trends, customer demographics, and more.

## Example Queries
Here are some example SQL queries included in the project:

* Total number of orders placed
* Total revenue of pizza sales
* Highest priced pizza
* Most common pizza size ordered
* Top 5 most ordered pizzas with their quantities
* Total quantity of each pizza category ordered
* Distribution of orders by hour of the day
* Category-wise distribution of pizzas
* Average number of pizzas ordered per day
* Top 3 most ordered pizza types
* Percentage of each pizza category to total revenue
* Cumulative revenue generated over time
* Top 3 most ordered pizza types based on revenue for each pizza category

Feel free to modify and extend the queries based on your analysis requirements.