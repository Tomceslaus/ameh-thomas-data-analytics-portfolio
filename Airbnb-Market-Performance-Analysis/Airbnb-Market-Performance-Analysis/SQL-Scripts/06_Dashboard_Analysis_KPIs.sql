
-- Overall dashboard KPIs
SELECT
    COUNT(DISTINCT listing_id) AS Total_Listings,
    COUNT(DISTINCT city) AS Total_Cities,
    SUM(CASE WHEN host_is_superhost = 1
             THEN 1 ELSE 0 END) AS Superhost_Listings,
    AVG(CAST(review_scores_rating AS DECIMAL(10,2)))
        AS Average_Listing_Rating
FROM analytics.Listings_Clean;
GO

--  Total reviews
SELECT
    COUNT_BIG(*) AS Total_Reviews
FROM analytics.Reviews_Clean;
GO

--  Average host performance by city
SELECT
    city,
    AVG(CAST(host_response_rate AS DECIMAL(10,4)))
        AS Average_Host_Response_Rate,
    AVG(CAST(host_acceptance_rate AS DECIMAL(10,4)))
        AS Average_Host_Acceptance_Rate,
    CAST(
        100.0 * SUM(CASE WHEN host_is_superhost = 1
                         THEN 1 ELSE 0 END)
        / NULLIF(
            SUM(CASE WHEN host_is_superhost IS NOT NULL
                     THEN 1 ELSE 0 END), 0
        )
        AS DECIMAL(10,2)
    ) AS Superhost_Percentage
FROM analytics.Listings_Clean
GROUP BY city
ORDER BY city;
GO

--  Host identity verification status
SELECT
    host_identity_verified,
    COUNT(DISTINCT listing_id) AS Total_Listings
FROM analytics.Listings_Clean
GROUP BY host_identity_verified
ORDER BY host_identity_verified;
GO

-- Instant booking availability
SELECT
    instant_bookable,
    COUNT(DISTINCT listing_id) AS Total_Listings
FROM analytics.Listings_Clean
GROUP BY instant_bookable
ORDER BY instant_bookable;
GO

--  Number of rated listings by city
SELECT
    city,
    COUNT(DISTINCT CASE
        WHEN review_scores_rating IS NOT NULL
        THEN listing_id
    END) AS Rated_Listings
FROM analytics.Listings_Clean
GROUP BY city
ORDER BY Rated_Listings DESC;
GO

--  Guest experience scores by city
SELECT
    city,
    AVG(CAST(review_scores_accuracy AS DECIMAL(10,2)))
        AS Average_Accuracy_Score,
    AVG(CAST(review_scores_cleanliness AS DECIMAL(10,2)))
        AS Average_Cleanliness_Score,
    AVG(CAST(review_scores_checkin AS DECIMAL(10,2)))
        AS Average_Checkin_Score,
    AVG(CAST(review_scores_communication AS DECIMAL(10,2)))
        AS Average_Communication_Score,
    AVG(CAST(review_scores_location AS DECIMAL(10,2)))
        AS Average_Location_Score,
    AVG(CAST(review_scores_value AS DECIMAL(10,2)))
        AS Average_Value_Score
FROM analytics.Listings_Clean
GROUP BY city
ORDER BY city;
GO

-- Monthly review activity
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
