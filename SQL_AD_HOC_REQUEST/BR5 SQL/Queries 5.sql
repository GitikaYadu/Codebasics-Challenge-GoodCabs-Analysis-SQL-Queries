WITH CityMonthlyRevenue AS (
    SELECT 
        ct.city_name,
        DATE_FORMAT(ft.date, '%M') AS Month,
        SUM(ft.fare_amount) AS Revenue
    FROM 
        trips_db.fact_trips AS ft, 
        trips_db.dim_city AS ct
    WHERE 
        ct.city_id = ft.city_id
    GROUP BY 
        ct.city_name, Month
    ORDER BY 
        ct.city_name, Month
),
CityTotalRevenue AS (
    SELECT
        city_name,
        SUM(Revenue) AS total_city_revenue
    FROM
        CityMonthlyRevenue
    GROUP BY
        city_name
),
CityHighestRevenueMonth AS (
    SELECT
        cmr.city_name,
        cmr.Month,
        cmr.Revenue,
        DENSE_RANK() OVER (PARTITION BY cmr.city_name ORDER BY cmr.Revenue DESC) AS Rank
    FROM 
        CityMonthlyRevenue AS cmr
)
SELECT
    chr.city_name,
    chr.Month AS Highest_Revenue_Month,
    chr.Revenue,
    ctr.total_city_revenue,
    CONCAT(FORMAT((chr.Revenue / ctr.total_city_revenue) * 100, 2), '%') AS '% Contribution'
FROM
    CityHighestRevenueMonth AS chr
JOIN 
    CityTotalRevenue AS ctr
    ON chr.city_name = ctr.city_name
WHERE 
    chr.Rank = 1
ORDER BY 
    chr.Revenue DESC;
