SELECT
    c.name,
    w.wishes ->> '$.first_choice' AS primary_wish,
    w.wishes ->> '$.second_choice' AS backup_wish,
    w.wishes ->> '$.colors[0]' AS favorite_color,
    JSON_LENGTH(w.wishes -> '$.colors') AS color_count,
    CASE
        WHEN tc.difficulty_to_make = 1 THEN "Simple Gift"
        WHEN tc.difficulty_to_make = 2 THEN "Moderate Gift"
        WHEN tc.difficulty_to_make >= 3 THEN "Complex Gift"
    END AS gift_complexity,
    CASE tc.category
        WHEN "outdoor" THEN "Outside Workshop"
        WHEN "educational" THEN "Learning Workshop"
        ELSE "General Workshop"
    END AS workshop_assignment
FROM
    wish_lists w
    JOIN children c ON w.child_id = c.child_id
    JOIN toy_catalogue tc ON w.wishes ->> '$.first_choice' = tc.toy_name
ORDER BY
    c.name;