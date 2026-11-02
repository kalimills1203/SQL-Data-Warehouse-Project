/* 
=====================================
Create Database & Schemas
=====================================

Strict Purpose: This script creates a new database named 'Warehouse' after checking it already exists.
If the databse exists, then it is dropped and recreated. Additionally, the script sets up three schemas
within the database: "bronze", "silver", "gold".

*WARNING:
Running this script will drop the entire 'DataWarehouse' database if it exists. 
All data in the database will be permanently deleted. Proceed with caution 
and ensure you have proper backups before running this script. 
*/


IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Warehouse')
  BEGIN 
    ALTER DATABASE Warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Warehouse;
  END;
  

-- Create Database 'DataWarehouse'

USE master;

CREATE DATABASE DataWarehouse;

USE DataWarehouse;

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
