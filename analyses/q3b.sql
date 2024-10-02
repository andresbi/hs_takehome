/*
B) Write a variation of the maximum duration query above for listings that have both a lockbox and a first aid kit listed in the amenities.
Tip: For example, listing 10986 has a lockbox. The correct result should show that across the results, the longest possible stay is much shorter than the answer to #3 a
*/

SELECT 
  listing_id,
  max(availability_block_size_in_days) max_availability_block_size_in_days
FROM marts.listings_daily
where has_lockbox and has_first_aid_kit
GROUP BY 1
ORDER BY 2 DESC;

-- LISTING_ID	MAX_AVAILABILITY_BLOCK_SIZE_IN_DAYS
-- 1303261	180
-- 182613	112