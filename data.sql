DROP TABLE test;

DROP FUNCTION get_ipp;

DROP SEQUENCE ipp_sequence;

CREATE SEQUENCE ipp_sequence MINVALUE 1 START 1;

CREATE FUNCTION get_ipp() RETURNS TEXT AS $$
SELECT
    concat(
        rpad(current_date :: TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date :: TEXT, 4), '-01-01')) :: DATE
        ) :: TEXT,
        '-',
        nextval('serial')
    ) $$ LANGUAGE SQL STRICT;

CREATE TABLE test (
    id VARCHAR(100) DEFAULT get_ipp(),
    nom VARCHAR(55)
);