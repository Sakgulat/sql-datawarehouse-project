/* 
=========================================================================
Quality Checks
=========================================================================
Script Purpose:
This script performs various quality checks for data consistency, accuracy and standardization across silver schema. 
It includes checks for :
- Null or duplicate primary keys
- Unwanted spaces in string fields
- Data Standardization and consistency
- Invalid Date ranges and orders
- Data consistency between related fields 

Usage Notes:
- Run these checks after data loading Silver Layer
- Investigate and resolve any discrepencies found during the checks
===========================================================================
*/

-- ========================================================================
-- Checking 'silver.crm_sales_details'
-- ========================================================================
 -- Check for Invalid Dates
 SELECT 
 NULLIF(sls_order_dt,0) sls_order_dt
 FROM [DataWarehouse].[silver].[crm_sales_details]
 WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 OR sls_order_dt > 20500101 OR sls_order_dt < 19000101
 
 SELECT 
 NULLIF(sls_ship_dt,0) sls_ship_dt
 FROM [DataWarehouse].[silver].[crm_sales_details]
 WHERE sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 OR sls_ship_dt > 20500101 OR sls_ship_dt < 19000101

 SELECT 
 NULLIF(sls_due_dt,0) sls_due_dt
 FROM [DataWarehouse].[silver].[crm_sales_details]
 WHERE sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 OR sls_due_dt > 20500101 OR sls_due_dt< 19000101

  -- Check for Invalid Date Orders

   Select * from silver.[crm_sales_details]
   WHERE sls_order_dt> sls_ship_dt OR sls_order_dt> sls_due_dt

     -- Check for Data Consistency: Between Sales, Quantity, & Price
     -- >> Sales = Quanity * Price 
     -- >> Values must not be NULL, zero, or negative.

   SELECT DISTINCT
      sls_sales
     ,sls_quantity
     ,sls_price
   FROM silver.[crm_sales_details]
   WHERE  sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
   OR sls_sales <=0 OR sls_quantity<=0 OR sls_price<=0
   ORDER BY sls_sales, sls_quantity, sls_price

-- ========================================================================
-- Checking 'silver.erp_cust_az12'
-- ========================================================================
 -- Select out of range Dates
 SELECT DISTINCT bdate
 FROM silver.erp_cust_az12
 WHERE bdate <'1924-01-01' OR bdate > GETDATE()

 -- Data Standardization & Consistency
 SELECT DISTINCT gen
 FROM silver.erp_cust_az12

 SELECT * FROM silver.erp_cust_az12


-- ========================================================================
-- Checking 'silver.erp_loc_a101'
-- ========================================================================

-- Check for Data Standardization & Consistency

SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry



