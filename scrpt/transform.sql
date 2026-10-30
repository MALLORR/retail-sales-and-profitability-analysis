/* STEP 1: Inspect table structure */

DESCRIBE superstore_table;


/* STEP 2: Check total records */

SELECT COUNT(*) AS total_records
FROM superstore_table;


/* STEP 3: Preview the dataset */

SELECT *
FROM superstore_table
LIMIT 10;





/* STEP 4: Test Order_Date conversion */

SELECT
    order_date,

    CASE
        WHEN TRIM(order_date) = '' THEN NULL

        WHEN TRIM(order_date) LIKE '%/%'
        THEN STR_TO_DATE(TRIM(order_date), '%m/%d/%Y')

        WHEN TRIM(order_date) LIKE '% %'
        THEN STR_TO_DATE(TRIM(order_date), '%m %d %Y')

        ELSE NULL
    END AS converted_order_date

FROM superstore_table

LIMIT 20;

SELECT
    order_date,

    CASE
        WHEN TRIM(ship_date) = '' THEN NULL

        WHEN TRIM(ship_date) LIKE '%/%'
        THEN STR_TO_DATE(TRIM(order_date), '%m/%d/%Y')

        WHEN TRIM(ship_date) LIKE '% %'
        THEN STR_TO_DATE(TRIM(ship_date), '%m %d %Y')

        ELSE NULL
    END AS converted_order_date

FROM superstore_table

LIMIT 20;

/* =====================================================
   STEP 5: TRANSFORM AND LOAD CLEANED DATA
   ===================================================== */

/* Transfer cleaned records into superstore_cleaned.

   STR_TO_DATE() converts text dates into DATE values.
   TRIM() removes unnecessary spaces.
   CASE handles missing or invalid date strings.
*/

INSERT INTO superstore_cleaned (

    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit

)

SELECT

    row_id,
    order_id,

    /* Convert Order_Date */

    CASE
        WHEN TRIM(order_date) = '' THEN NULL

        WHEN TRIM(order_date) LIKE '%/%'
        THEN STR_TO_DATE(TRIM(order_date), '%m/%d/%Y')

        WHEN TRIM(order_date) LIKE '% %'
        THEN STR_TO_DATE(TRIM(order_date), '%m %d %Y')

        ELSE NULL
    END,

    /* Convert Ship_Date */

    CASE
        WHEN TRIM(ship_date) = '' THEN NULL

        WHEN TRIM(ship_date) LIKE '%/%'
        THEN STR_TO_DATE(TRIM(ship_date), '%m/%d/%Y')

        WHEN TRIM(ship_date) LIKE '% %'
        THEN STR_TO_DATE(TRIM(ship_date), '%m %d %Y')

        ELSE NULL
    END,

    /* Clean text columns */

    TRIM(ship_mode),
    customer_id,
    TRIM(customer_name),
    TRIM(segment),
    TRIM(country),
    TRIM(city),
    TRIM(state),
    postal_code,
    TRIM(region),
    product_id,
    TRIM(category),
    TRIM(sub_category),
    TRIM(product_name),

    /* Retain numerical values */

    sales,
    quantity,
    discount,
    profit

FROM superstore_table;

-- Convert Order_Date from MM-DD-YYYY text to a date value
UPDATE superstore_cleaned
SET order_date = STR_TO_DATE(TRIM(order_date), '%m-%d-%Y');

-- Convert Ship_Date from MM-DD-YYYY text to a date value
UPDATE superstore_cleaned
SET ship_date = STR_TO_DATE(TRIM(ship_date), '%m-%d-%Y');

--validate the Data 
SELECT COUNT(*) AS total_records
FROM superstore_cleaned;


--Missing Value
SELECT
    SUM(order_date IS NULL) AS missing_order_dates,
    SUM(ship_date IS NULL) AS missing_ship_dates
FROM superstore_cleaned;


--Duplicate rows
SELECT
    row_id,
    COUNT(*) AS occurrences
FROM superstore_cleaned
GROUP BY row_id
HAVING COUNT(*) > 1;

--Check The Date Range 
SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order,
    MIN(ship_date) AS earliest_shipping,
    MAX(ship_date) AS latest_shipping
FROM superstore_cleaned;