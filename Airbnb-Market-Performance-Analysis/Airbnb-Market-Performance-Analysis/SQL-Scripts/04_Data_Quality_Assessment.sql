

USE Airbnb_Market_Intelligence;
GO

-- 1. Check missing host response and acceptance rates
SELECT
    COUNT_BIG(*) AS Total_Listings,

    SUM(CASE WHEN host_response_rate IS NULL
             THEN 1 ELSE 0 END) AS Missing_Response_Rate,

    SUM(CASE WHEN host_acceptance_rate IS NULL
             THEN 1 ELSE 0 END) AS Missing_Acceptance_Rate

FROM analytics.Listings_Clean;
GO

-- 2. Check host response and acceptance rate ranges
SELECT
    MIN(host_response_rate) AS Minimum_Response_Rate,
    MAX(host_response_rate) AS Maximum_Response_Rate,

    MIN(host_acceptance_rate) AS Minimum_Acceptance_Rate,
    MAX(host_acceptance_rate) AS Maximum_Acceptance_Rate

FROM analytics.Listings_Clean;
GO

-- 3. Check missing bedroom values and unusual bedroom counts
SELECT
    COUNT_BIG(*) AS Total_Listings,

    SUM(CASE WHEN bedrooms IS NULL
             THEN 1 ELSE 0 END) AS Missing_Bedrooms,

    MAX(bedrooms) AS Maximum_Bedrooms

FROM analytics.Listings_Clean;
GO

-- 4. Check price quality
SELECT
    MIN(price) AS Minimum_Price,
    MAX(price) AS Maximum_Price,
    AVG(price) AS Average_Price,

    SUM(CASE WHEN price = 0
             THEN 1 ELSE 0 END) AS Zero_Price_Records,

    SUM(CASE WHEN price < 0
             THEN 1 ELSE 0 END) AS Negative_Price_Records

FROM analytics.Listings_Clean;
GO

-- 5. Check superhost status distribution
SELECT
    host_is_superhost,
    COUNT_BIG(*) AS Listing_Count
FROM analytics.Listings_Clean
GROUP BY host_is_superhost
ORDER BY host_is_superhost;
GO

-- 6. Check host identity verification distribution
SELECT
    host_identity_verified,
    COUNT_BIG(*) AS Listing_Count
FROM analytics.Listings_Clean
GROUP BY host_identity_verified
ORDER BY host_identity_verified;
GO

-- 7. Check review date range
SELECT
    MIN(review_date) AS Earliest_Review_Date,
    MAX(review_date) AS Latest_Review_Date
FROM analytics.Reviews_Clean;
GO

-- 8. Check listings with no recorded reviews
SELECT
    COUNT_BIG(*) AS Listings_Without_Reviews
FROM analytics.Listings_Clean AS l
WHERE NOT EXISTS (
    SELECT 1
    FROM analytics.Reviews_Clean AS r
    WHERE r.listing_id = l.listing_id
);
GO

-- 9. Check unmatched review listing IDs
SELECT
    COUNT_BIG(*) AS Orphan_Reviews
FROM analytics.Reviews_Clean AS r
LEFT JOIN analytics.Listings_Clean AS l
    ON r.listing_id = l.listing_id
WHERE l.listing_id IS NULL;
GO

-- 10. Check duplicate review-listing combinations
SELECT
    review_id,
    listing_id,
    COUNT_BIG(*) AS Duplicate_Count
FROM analytics.Reviews_Clean
GROUP BY review_id, listing_id
HAVING COUNT_BIG(*) > 1;
GO
