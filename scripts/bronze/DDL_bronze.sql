/*
======================================================================
DDL Script: Create Bronze Tables
======================================================================
Script Purpose: 
    This script creates tables in the 'bronze' schema, dropping existing tabl
    if they already exists.
    Run this script to re-define the DDL Structure of 'Bronze' Tables 
======================================================================
*/

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL 
  DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_material_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE

)

CREATE TABLE bronze.crm_prd_info (
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost NVARCHAR(50),
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE
)


CREATE TABLE bronze.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT
)
ALTER TABLE bronze.crm_sales_details
ALTER COLUMN sls_order_dt NVARCHAR(50);

CREATE TABLE bronze.erp_cust_az12 (
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50)
)

CREATE TABLE bronze.erp_loc_a101 (
CID NVARCHAR(50),
CNTRY NVARCHAR(50)
)

CREATE TABLE bronze.erp_px_cat_g1v2 (
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50)
)

SELECT * FROM bronze.crm_prd_info

EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN 
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
	SET @batch_start_time = GETDATE();
	PRINT '======================================';
	PRINT 'Loading Bronze Layer';
	PRINT '======================================';

	PRINT '--------------------------------------';
	PRINT 'Loading CRM Tables';
	PRINT '--------------------------------------';


	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.crm_cust_info';
TRUNCATE TABLE bronze.crm_cust_info;

PRINT '>> Inserting Data Into: bronze.crm_cust_info';
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\kalli.mills\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\01_datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	); 
		SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
	PRINT '>> -------------';
	--SELECT COUNT(*) FROM bronze.crm_cust_info


		SET @start_time = GETDATE();
PRINT '>> Truncating Table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;

PRINT '>> Inserting Data Into: bronze.crm_prd_info';
BULK INSERT bronze.crm_prd_info
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
	PRINT '>> Truncating Table: bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details;

PRINT '>> Inserting Data Into: bronze.crm_sales_details';
BULK INSERT bronze.crm_sales_details
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
	PRINT	'>> Truncating Table: bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12;

PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
BULK INSERT bronze.erp_cust_az12
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
	PRINT	'>> Truncating Table: bronze.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101;

PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
BULK INSERT bronze.erp_loc_a101
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
	PRINT	'>> Truncating Table: bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
BULK INSERT bronze.erp_px_cat_g1v2
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
	PRINT'Loading Bronze Layer is Completed';
	PRINT'	-Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
	PRINT'=======================================';

	END TRY
	BEGIN CATCH
	PRINT '=========================================='
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
	PRINT 'ERROR Message' + ERROR_MESSAGE();
	PRINT 'ERROR Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'ERROR Message' + CAST(ERROR_STATE() AS NVARCHAR);
	PRINT '=========================================='
	END CATCH
	END
