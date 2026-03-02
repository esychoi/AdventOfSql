SELECT
  cdf.food_item_id,
  COUNT(*) AS food_count
FROM
  christmas_dinner_food cdf
  JOIN christmas_dinner cd ON cd.id = cdf.event_id
WHERE
  cd.number_of_guests > 78
GROUP BY
  cdf.food_item_id
ORDER BY
  food_count DESC
LIMIT
  1;