/*
#1 - Amenity Revenue
Write a query to find the total revenue and percentage of revenue by month segmented by whether or not air conditioning exists on the listing.
Tip: For example, only 21.2% of revenue in July 2022 came from listings without air conditioning.
*/

SELECT  
    TO_CHAR(DATE_TRUNC('MONTH', date), 'YYYY-MM-DD') AS month_start,
    sum(case when has_air_conditioning  then revenue else 0 end) yes_ac_revenue,
    sum(case when has_air_conditioning then 0 else revenue end) no_ac_revenue,
    round(100*no_ac_revenue/(sum(revenue)),1) pcnt_rev
FROM marts.listings_daily
group by 1
order by 1 desc;

/*
MONTH_START	YES_AC_REVENUE	NO_AC_REVENUE	PCNT_REV
2022-07-01	40157	10772	21.2
2022-06-01	116482	31042	21.0
2022-05-01	125723	27745	18.1
2022-04-01	113217	21510	16.0
2022-03-01	109212	19971	15.5
2022-02-01	108101	16549	13.3
2022-01-01	116542	17001	12.7
2021-12-01	98664	13165	11.8
2021-11-01	96406	15786	14.1
2021-10-01	122801	28426	18.8
2021-09-01	103265	25038	19.5
2021-08-01	146674	29786	16.9
2021-07-01	111363	18616	14.3
*/