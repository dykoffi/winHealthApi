CREATE TABLE test (
    id serial primary key,
    a NUMERIC(10, 2),
    c int default get_prix_acte('B'),
    b INT generated always as (c * a) stored
)