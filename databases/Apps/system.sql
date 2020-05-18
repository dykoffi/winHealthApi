DROP FUNCTION get_ipp CASCADE;
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
        lpad(nextval('ipp_sequence')::TEXT,3,'00')
    ) $$ LANGUAGE SQL STRICT;