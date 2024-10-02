/*
#3 - Long Stay / Picky Renter
A) Write a query to find the maximum duration one could stay in each of these listings, based on the availability and what the owner allows.
Tip: For example, listing 863788 is heavily booked. The largest timespan for which it is available is four days from September 18th to 21st in 2021. The correct solution should show that three listings are tied for the longest possible stay.
*/

SELECT 
  listing_id,
  max(availability_block_size_in_days) max_availability_block_size_in_days
FROM marts.listings_daily
GROUP BY 1
ORDER BY 2 DESC;

/*
LISTING_ID	NEIGHBORHOOD	LONGEST_AVAILABLE_DURATION
1454258	Dorchester	365
743759	Roslindale	365
1510876	Dorchester	365
753446	Roslindale	364
1551205	Fenway	364
1128894	Dorchester	346
10813	Back Bay	331
10986	North End	307
1682936	Roxbury	286
77681	Charlestown	273
611081	Charlestown	272
1692573	Jamaica Plain	258
1374434	Roxbury	238
1403408	Roxbury	213
568234	Jamaica Plain	206
1303261	Beacon Hill	180
1374466	Roxbury	180
257588	South Boston	132
447826	Jamaica Plain	120
182613	Charlestown	112
163941	Roxbury	96
1038465	South End	90
743211	Jamaica Plain	90
526970	South End	90
1109224	Jamaica Plain	90
22354	South End	90
3781	East Boston	84
69369	Roxbury	75
801680	Roxbury	74
1167987	Roslindale	73
6695	Roxbury	69
60029	Roxbury	64
220676	North End	43
210097	Jamaica Plain	31
891661	North End	30
1544144	Charlestown	30
5506	Roxbury	22
1677807	Brighton	11
1644031	South Boston	5
820073	Downtown	5
863788	South End	4
1077105	South End	0
1252489	Beacon Hill	0
1541166	Charlestown	0
349347	Roxbury	0
507525	Bay Village	0
13247	Roxbury	0
583255	Brighton	0
1055627	Downtown	0
276450	Roxbury	0
*/