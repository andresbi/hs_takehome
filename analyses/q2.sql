/*
#2 - Neighborhood Pricing
Write a query to find the average price increase for each neighborhood from July 12th 2021 to July 11th 2022.
Tip: For example, the Back Bay neighborhood only has one listing, so the difference of $44 is the average for the whole neighborhood based solely on listing 10813.
*/

SELECT 
  neighborhood,
  round(avg(case when date = '2021-07-12' then price else null end),1) avg_yr_2021,
  round(avg(case when date = '2022-07-11' then price else null end),1) avg_yr_2022,
  avg_yr_2022-avg_yr_2021 increase
FROM marts.listings_daily
group by 1
order by 1;


/*
NEIGHBORHOOD	AVG_YR_2022	AVG_YR_2021	INCREASE
Back Bay	150.0	106.0	44.0
Bay Village	65.0	65.0	0.0
Beacon Hill	312.5	312.5	0.0
Brighton	124.5	124.5	0.0
Charlestown	225.6	203.8	21.8
Dorchester	67.3	59.3	8.0
Downtown	271.0	256.5	14.5
East Boston	125.0	125.0	0.0
Fenway	415.0	415.0	0.0
Jamaica Plain	235.8	235.8	0.0
North End	132.0	130.0	2.0
Roslindale	36.7	35.3	1.4
Roxbury	136.8	143.0	-6.2
South Boston	150.0	175.0	-25.0
South End	207.4	207.4	0.0
*/