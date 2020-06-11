SELECT
    (
        SELECT
            concat_ws(' ', name_first, name_last) as generated
        FROM
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
                            -- need 3 syllabes, and force generator interpretation with the '*0' (else 3 same syllabes)
                            generate_series(1, 3 + (generator * 0))
                    ) AS comp3syl(x)
            ) AS comp_name_1st(name_first),
            (
                SELECT
                    x [ 1 + ( (random() * 25)::int) % 14 ]
                FROM
                    (
                        select
                            '{Ltd,& Co,SARL,SA,Gmbh,United,Brothers,& Sons,International,Ext,Worldwide,Global,2000,3000}' :: text []
                    ) AS z2(x)
            ) AS comp_name_last(name_last)
    )
FROM
    generate_series(1, 10) as generator




CREATE ROLE winhealth WITH
    LOGIN
    SUPERUSER
    INHERIT
    CREATEDB
    CREATEROLE
    REPLICATION
    ENCRYPTED PASSWORD 'md57efff143e418ee16274f35ad7df30354'
    VALID UNTIL 'infinity'

    CREATE DATABASE mytest WITH
        OWNER = winhealth
        ENCODING = 'UTF-8'
        LC_LOCATE = 'fr_FR.UTF-8'
        LC_CTYPE = 'fr_FR.UTF-8'
        TABLESPACE = pg_default
        CONNECTION LIMIT = -1

        su postgres
           psql
             CREATE ROLE u_ecliss WITH LOGIN ENCRYPTED PASSWORD 'p_ecliss' SUPERUSER;
             CREATE DATABASE db_ecliss OWNER u_ecliss;
             \q
           exit