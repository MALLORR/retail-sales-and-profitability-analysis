/* =====================================================
   PROJECT: SUPERSTORE SALES ANALYSIS
   FILE: 01_DDL.sql
   PURPOSE: Database and table creation
   ===================================================== */


/* STEP 1: Create database */

CREATE DATABASE superstore_project;

USE superstore_project;


/* STEP 2: Create superstore_table */

/* This table stores the source CSV data.
   VARCHAR is used for dates to preserve the
   different date formats found in the CSV.
*/

CREATE TABLE superstore_table (
    row_id INT,
    order_id VARCHAR(20),
    order_date VARCHAR(30),
    ship_date VARCHAR(30),
    ship_mode VARCHAR(30),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    region VARCHAR(20),
    product_id VARCHAR(30),
    category VARCHAR(30),
    sub_category VARCHAR(30),
    product_name VARCHAR(255),
    sales DECIMAL(12,4),
    quantity INT,
    discount DECIMAL(5,4),
    profit DECIMAL(12,4)
);


/* STEP 3: Create superstore_cleaned */

/* This table stores the transformed data.
   DATE is used for standardised dates.
   NULL is allowed for missing dates.
*/

CREATE TABLE superstore_cleaned (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    order_date DATE NULL,
    ship_date DATE NULL,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(20) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    segment VARCHAR(30),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    region VARCHAR(20),
    product_id VARCHAR(30) NOT NULL,
    category VARCHAR(30),
    sub_category VARCHAR(30),
    product_name VARCHAR(255),
    sales DECIMAL(12,4),
    quantity INT,
    discount DECIMAL(5,4),
    profit DECIMAL(12,4)
);