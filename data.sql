SELECT
    (
        SELECT
            string_agg(x, '')
        FROM
            (
                select
                    start_arr [ 1 + ( (random() * 25)::int) % 16 ]
                FROM
                    (
                        select
                            '{CO,GE,FOR,SO,CO,GIM,SE,CO,GE,CA,FRA,GEC,GE,GA,FRO,GIP}' :: text [] as start_arr
                    ) syllarr,
                    generate_series(1, 3 + (generator * 0))
            ) AS comp3syl(x)
    )
FROM
    generate_series(1, 10) as generator;