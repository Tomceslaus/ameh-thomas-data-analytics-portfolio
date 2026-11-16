

USE Airbnb_Market_Intelligence;
GO

-- 1. Confirm cleaned listings record count
SELECT
    COUNT_BIG(*) AS Clean_Listings_Count
FROM analytics.Listings_Clean;
GO

-- 2. Confirm cleaned reviews record count
SELECT
    COUNT_BIG(*) AS Clean_Reviews_Count
FROM analytics.Reviews_Clean;
GO

-- 3. Compare raw and clean listings counts
SELECT
    (SELECT COUNT_BIG(*)
     FROM staging.Listings_Raw) AS Raw_Listings,

    (SELECT COUNT_BIG(*)
     FROM analytics.Listings_Clean) AS Clean_Listings;
GO

-- 4. Compare raw and clean reviews counts
SELECT
    (SELECT COUNT_BIG(*)
     FROM staging.Reviews_Raw) AS Raw_Reviews,

    (SELECT COUNT_BIG(*)
     FROM analytics.Reviews_Clean) AS Clean_Reviews;
GO

-- 5. Inspect the cleaned listings table structure
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'analytics'
  AND TABLE_NAME = 'Listings_Clean'
ORDER BY ORDINAL_POSITION;
GO

-- 6. Inspect the cleaned reviews table structure
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'analytics'
  AND TABLE_NAME = 'Reviews_Clean'
ORDER BY ORDINAL_POSITION;
GO

-- 7. Check unusual data quality flags
SELECT
    SUM(CASE WHEN price_is_zero = 1
             THEN 1 ELSE 0 END) AS Zero_Price_Records,

    SUM(CASE WHEN bedrooms_unusually_high = 1
             THEN 1 ELSE 0 END) AS Unusual_Bedroom_Records,

    SUM(CASE WHEN minimum_nights_unusually_high = 1
             THEN 1 ELSE 0 END) AS Unusual_Minimum_Nights_Records
FROM analytics.Listings_Clean;
GO
