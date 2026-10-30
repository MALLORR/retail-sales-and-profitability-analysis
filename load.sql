/* =====================================================
   PROJECT: SUPERSTORE SALES ANALYSIS
   FILE: 02_Load.sql
   PURPOSE: Importing CSV data into MySQL
   ===================================================== */


/* STEP 1: Select the project database */

USE superstore_table;


/* STEP 2: Load the original CSV into the staging table */

/* LOCAL INFILE reads the CSV from the local computer.

   FIELDS TERMINATED BY ',' separates the columns.
   ENCLOSED BY '"' handles text enclosed in quotation marks.
   LINES TERMINATED BY '\r\n' identifies Windows line endings.
   IGNORE 1 ROWS skips the CSV header.
*/

LOAD DATA LOCAL INFILE
'C:/Users/LENOVO T14S/Desktop/PROJECT/Sales project/data/Sample - Superstore Cleaned Preserved.csv'

INTO TABLE superstore_cleaned

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;


/* STEP 3: Verify the imported records */

SELECT COUNT(*) AS total_records
FROM superstore_cleaned;


/* STEP 4: Preview the imported data */

SELECT *
FROM superstore_cleaned
LIMIT 200;


