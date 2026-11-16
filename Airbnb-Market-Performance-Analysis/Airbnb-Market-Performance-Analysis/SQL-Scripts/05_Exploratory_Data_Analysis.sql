SELECT
    city,
    COUNT(DISTINCT listing_id) AS Total_Listings
FROM analytics.Listings_Clean
GROUP BY city
ORDER BY Total_Listings DESC;
GO

-- 2. Room type distribution by city
SELECT
    city,
    room_type,
    COUNT(DISTINCT listing_id) AS Total_Listings
FROM analytics.Listings_Clean
GROUP BY city, room_type
ORDER BY city, Total_Listings DESC;
GO

-- 3. Top 20 property types
SELECT TOP 20
    property_type,
    COUNT(DISTINCT listing_id) AS Total_Listings
FROM analytics.Listings_Clean
GROUP BY property_type
ORDER BY Total_Listings DESC;
GO

-- 4. Average listing price by city
-- Zero prices excluded.
-- Prices are nominal and may use different city currencies.
SELECT
    city,
    COUNT(DISTINCT listing_id) AS Listings_With_Price,
    AVG(price) AS Average_Price,
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY price)
        OVER (PARTITION BY city) AS Median_Price
FROM analytics.Listings_Clean
WHERE price > 0
ORDER BY Average_Price DESC;
GO

-- 5. Top neighbourhood by listing count in each city
WITH NeighbourhoodCounts AS (
    SELECT
        city,
        neighbourhood,
        COUNT(DISTINCT listing_id) AS Total_Listings,
        ROW_NUMBER() OVER (
            PARTITION BY city
            ORDER BY COUNT(DISTINCT listing_id) DESC
        ) AS Ranking
    FROM analytics.Listings_Clean
    WHERE neighbourhood IS NOT NULL
    GROUP BY city, neighbourhood
)
SELECT
    city,
    neighbourhood,
    Total_Listings
FROM NeighbourhoodCounts
WHERE Ranking = 1
ORDER BY city;
GO

-- 6. Average guest rating by city
SELECT
    city,
    COUNT(DISTINCT listing_id) AS Total_Listings,
    COUNT(review_scores_rating) AS Rated_Listings,
    AVG(CAST(review_scores_rating AS DECIMAL(10,2)))
        AS Average_Overall_Rating,
    AVG(CAST(review_scores_cleanliness AS DECIMAL(10,2)))
        AS Average_Cleanliness,
    AVG(CAST(review_scores_communication AS DECIMAL(10,2)))
        AS Average_Communication,
    AVG(CAST(review_scores_location AS DECIMAL(10,2)))
        AS Average_Location,
    AVG(CAST(review_scores_value AS DECIMAL(10,2)))
        AS Average_Value
FROM analytics.Listings_Clean
GROUP BY city
ORDER BY Average_Overall_Rating DESC;
GO

-- 7. Monthly review activity
SELECT
    YEAR(review_date) AS Review_Year,
    MONTH(review_date) AS Review_Month,
    COUNT_BIG(*) AS Total_Reviews
FROM analytics.Reviews_Clean
GROUP BY
    YEAR(review_date),
    MONTH(review_date)
ORDER BY
    Review_Year,
    Review_Month;
GO
