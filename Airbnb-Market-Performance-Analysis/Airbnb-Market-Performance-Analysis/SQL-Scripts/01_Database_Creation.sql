
IF DB_ID('Airbnb_Market_Intelligence') IS NULL
BEGIN
    CREATE DATABASE Airbnb_Market_Intelligence;
END;
GO

-- Select the project database
USE Airbnb_Market_Intelligence;
GO

-- Create staging schema if it does not exist
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'staging'
)
BEGIN
    EXEC('CREATE SCHEMA staging');
END;
GO

-- Create analytics schema if it does not exist
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'analytics'
)
BEGIN
    EXEC('CREATE SCHEMA analytics');
END;
GO

-- Verify database and schemas
SELECT
    name AS Schema_Name
FROM sys.schemas
WHERE name IN ('staging', 'analytics');
GO
