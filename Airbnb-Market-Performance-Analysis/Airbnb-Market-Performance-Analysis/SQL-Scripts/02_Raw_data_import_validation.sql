
/*

DATABASE: Airbnb_Market_Intelligence

RAW TABLES:
staging.Listings_Raw
staging.Reviews_Raw

*/

USE Airbnb_Market_Intelligence;
GO

-- 1. Validate raw listings row count
SELECT
    COUNT_BIG(*) AS Total_Raw_Listings
FROM staging.Listings_Raw;
GO

-- 2. Validate raw reviews row count
SELECT
    COUNT_BIG(*) AS Total_Raw_Reviews
FROM staging.Reviews_Raw;
GO

-- 3. Check total and distinct listing IDs
SELECT
    COUNT_BIG(*) AS Total_Records,
    COUNT(DISTINCT listing_id) AS Distinct_Listing_IDs
FROM staging.Listings_Raw;
GO

-- 4. Check duplicate review IDs
SELECT
    COUNT_BIG(*) AS Total_Review_Records,
    COUNT(DISTINCT review_id) AS Distinct_Review_IDs
FROM staging.Reviews_Raw;
GO

-- 5. Identify review IDs appearing more than once
SELECT
    review_id,
    COUNT(*) AS Occurrences
FROM staging.Reviews_Raw
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC;
GO

-- 6. Check for reviews without a matching listing
SELECT
    COUNT_BIG(*) AS Orphan_Review_Records
FROM staging.Reviews_Raw AS r
LEFT JOIN staging.Listings_Raw AS l
    ON r.listing_id = l.listing_id
WHERE l.listing_id IS NULL;
GO
