SELECT
    GROUP_CONCAT(c.decoded_char SEPARATOR '')
FROM
    (
        SELECT
            id,
            CHAR(VALUE) AS decoded_char
        FROM
            letters_a
        WHERE
            (
                VALUE >= 65
                AND VALUE <= 90
            )
            OR (
                VALUE >= 97
                AND VALUE <= 122
            )
            OR VALUE IN (32, 33, 34, 39, 40, 41, 44, 45, 46, 58, 59, 63)
        UNION
        SELECT
            id,
            CHAR(VALUE) AS decoded_char
        FROM
            letters_b
        WHERE
            (
                VALUE >= 65
                AND VALUE <= 90
            )
            OR (
                VALUE >= 97
                AND VALUE <= 122
            )
            OR VALUE IN (32, 33, 34, 39, 40, 41, 44, 45, 46, 58, 59, 63)
        ORDER BY
            id
    ) AS c;