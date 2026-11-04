/*
=========================================================
DDL Script: Create Silver Tables
=========================================================
This script creates tables in the 'silver' schema, dropping existing tables
if they already exist.
Run this script tp re-define the DDL structure of'bronze' tables.
=============================================================
*/

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL 
	DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_material_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL 
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
prd_id INT,
cat_id NVARCHAR(50),
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL 
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
)
ALTER TABLE silver.crm_sales_details
ALTER COLUMN sls_order_dt NVARCHAR(50);

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL 
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL 
	DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
CID NVARCHAR(50),
CNTRY NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
)


IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL 
	DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
)


--EXEC silver.load_bronze

CREATE OR ALTER PROCEDURE silver.load_bronze AS
BEGIN 
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
	SET @batch_start_time = GETDATE();
	PRINT '======================================';
	PRINT 'Loading Silver Layer';
	PRINT '======================================';

	PRINT '--------------------------------------';
	PRINT 'Loading CRM Tables';
	PRINT '--------------------------------------';


	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;

PRINT '>> Inserting Data Into: silver.crm_cust_info';
BULK INSERT silver.crm_cust_info
FROM 'C:\Users\kalli.mills\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	); 
		SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '>> -------------';
	--SELECT COUNT(*) FROM silver.crm_cust_info


		SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.crm_prd_info';
	TRUNCATE TABLE silver.crm_prd_info;

PRINT '>> Inserting Data Into: silver.crm_prd_info';
BULK INSERT silver.crm_prd_info
FROM 'C:\Users\kalli.mills\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	); 
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '>> -------------';


	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: silver.crm_sales_details';
	TRUNCATE TABLE silver.crm_sales_details;

PRINT '>> Inserting Data Into: silver.crm_sales_details';
BULK INSERT silver.crm_sales_details
FROM 'C:\Users\kalli.mills\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	); 
		SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '>> -------------';



	PRINT '--------------------------------------';
	PRINT 'Loading ERP Tables';
	PRINT '--------------------------------------';


	SET @start_time = GETDATE();
	PRINT	'>> Truncating Table: silver.erp_cust_az12';
	TRUNCATE TABLE silver.erp_cust_az12;

PRINT '>> Inserting Data Into: silver.erp_cust_az12';
BULK INSERT silver.erp_cust_az12
FROM 'C:\Users\kalli.mills\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_erp\cust_az12.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	); 
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '>> -------------';


		SET @start_time = GETDATE();
	PRINT	'>> Truncating Table: silver.erp_loc_a101';
	TRUNCATE TABLE silver.erp_loc_a101;

PRINT '>> Inserting Data Into: silver.erp_loc_a101';
BULK INSERT silver.erp_loc_a101
FROM 'C:\Users\kalli.mills\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_erp\loc_a101.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	); 
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '>> -------------';


	SET @start_time = GETDATE();
	PRINT	'>> Truncating Table: silver.erp_px_cat_g1v2';
	TRUNCATE TABLE silver.erp_px_cat_g1v2;

PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';
BULK INSERT silver.erp_px_cat_g1v2
FROM 'C:\Users\kalli.mills\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_erp\px_cat_g1v2.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	); 
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '>> -------------';

	SET @batch_end_time = GETDATE();
	PRINT'=======================================';
	PRINT'Loading Silver Layer is Completed';
	PRINT'	-Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
	PRINT'=======================================';

	END TRY
	BEGIN CATCH
	PRINT '=========================================='
	PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
	PRINT 'ERROR Message' + ERROR_MESSAGE();
	PRINT 'ERROR Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'ERROR Message' + CAST(ERROR_STATE() AS NVARCHAR);
	PRINT '=========================================='
	END CATCH
	END

	
EXEC silver.load_bronze
