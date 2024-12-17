WITH CityNewPassengers AS (
    SELECT 
        ct.city_name,
        SUM(ft.new_passengers) AS total_new_passengers
    FROM
        trips_db.dim_city AS ct
    JOIN
        trips_db.fact_passenger_summary AS ft
        ON ct.city_id = ft.city_id
    GROUP BY 
        ct.city_name
),
RankedCities AS (
    SELECT
        city_name,
        total_new_passengers,
        RANK() OVER (ORDER BY total_new_passengers DESC) AS Ranking,
        RANK() OVER (ORDER BY total_new_passengers ASC) AS low_rank
    FROM 
        CityNewPassengers
)
SELECT
    city_name,
    total_new_passengers,
    Ranking,
    CASE
        WHEN Ranking <= 3 THEN 'Top 3' 
        ELSE 'Bottom 3'
    END AS city_category
FROM 
    RankedCities
WHERE 
    Ranking <= 3 OR low_rank <= 3
ORDER BY 
    total_new_passengers DESC, 
    city_category ASC;
