WITH
    previous_tags_cte AS (
        SELECT
            tp.toy_id,
            jt.tag
        FROM
            toy_production tp
            JOIN JSON_TABLE(
                tp.previous_tags,
                '$[*]' COLUMNS (tag VARCHAR(100) PATH '$')
            ) jt
    ),
    new_tags_cte AS (
        SELECT
            tp.toy_id,
            jt.tag
        FROM
            toy_production tp
            JOIN JSON_TABLE(
                tp.new_tags,
                '$[*]' COLUMNS (tag VARCHAR(100) PATH '$')
            ) jt
    ),
    combined_cte AS (
        SELECT
            toy_id,
            tag,
            'new' AS tag_source
        FROM
            new_tags_cte
        UNION ALL
        SELECT
            toy_id,
            tag,
            'prev' AS tag_source
        FROM
            previous_tags_cte
    )
SELECT
    x.toy_id,
    SUM(
        x.tag_count = 1
        AND x.tag_source = 'new'
    ) AS added_tags_count,
    SUM(x.tag_count = 2) AS unchanged_tags_count,
    SUM(
        x.tag_count = 1
        AND x.tag_source = 'prev'
    ) AS removed_tags_count
FROM
    (
        SELECT
            toy_id,
            tag,
            COUNT(*) AS tag_count,
            ANY_VALUE(tag_source) AS tag_source
        FROM
            combined_cte
        GROUP BY
            toy_id,
            tag
    ) x
GROUP BY
    x.toy_id
ORDER BY
    added_tags_count DESC;