{% set amenities_interest = ["Air conditioning", "Lockbox", "First aid kit"] %}

SELECT 
  listing_id,
  valid_from, 
  valid_to,

  --Jinja: DRY Code. dbt user can add amenities at the top and downstream
  {% for amenity in amenities_interest -%} 
  array_contains('{{amenity}}'::VARIANT,all_amenities) as "has_{{amenity}}",
  {% endfor %}

  all_amenities
FROM {{ref('stg_postgres__amenities_changelog')}}


/*
SELECT 
  listing_id,
  valid_from, 
  valid_to,

  --Jinja: DRY Code. dbt user can add amenities at the top and downstream
  array_contains('Air conditioning'::VARIANT,all_amenities) as "has_Air conditioning",
  array_contains('Lockbox'::VARIANT,all_amenities) as "has_Lockbox",
  array_contains('First aid kit'::VARIANT,all_amenities) as "has_First aid kit",
  all_amenities
FROM hbnb.staging.stg_postgres__amenities_changelog
*/