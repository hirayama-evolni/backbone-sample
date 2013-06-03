drop table if exists addresses;
create table addresses (
  id integer auto_increment primary key,
  name text,
  address text,
  tel text
);
