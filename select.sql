-- destroying old data
DROP SEQUENCE id_goods_seq CASCADE;
DROP SEQUENCE id_sales_seq CASCADE;
DROP TABLE IF EXISTS goods CASCADE;
DROP TABLE IF EXISTS sales CASCADE;

-- creating sequenseces (a sort of autoincrement)
CREATE SEQUENCE id_sales_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 23
  CACHE 1;
ALTER TABLE id_sales_seq
  OWNER TO postgres;

CREATE SEQUENCE id_goods_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 15
  CACHE 1;
ALTER TABLE id_goods_seq
  OWNER TO postgres;

-- creating table goods
CREATE TABLE goods
(
  id integer NOT NULL DEFAULT nextval('id_goods_seq'::regclass),
  name text NOT NULL,
  CONSTRAINT goods_pkey PRIMARY KEY (id )
)
WITH (
  OIDS=TRUE
);
ALTER TABLE goods
  OWNER TO postgres;

-- creating table sales
CREATE TABLE sales
(
  id integer NOT NULL DEFAULT nextval('id_sales_seq'::regclass),
  sales_date date NOT NULL,
  good_id integer NOT NULL,
  price double precision NOT NULL,
  CONSTRAINT sales_pkey PRIMARY KEY (id ),
-- delete data from sales when it's deleted from goods
  CONSTRAINT "$1" FOREIGN KEY (good_id)
      REFERENCES goods (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=TRUE
);
ALTER TABLE sales
  OWNER TO postgres;

-- creating test data
INSERT INTO goods ("name", "id") VALUES ('Товар 1', 1);
INSERT INTO goods ("name", "id") VALUES ('Товар 2', 2);
INSERT INTO goods ("name", "id") VALUES ('Товар 3', 3);
INSERT INTO goods ("name", "id") VALUES ('Товар 4', 4);
INSERT INTO goods ("name", "id") VALUES ('Товар 5', 5);
INSERT INTO goods ("name", "id") VALUES ('Товар 6', 6);
INSERT INTO goods ("name", "id") VALUES ('Товар 7', 7);
INSERT INTO sales (good_id, price, sales_date) VALUES (1, 15, '1900-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (1, 30, '1900-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (1, 45, '1900-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (2, 15, '1900-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (2, 30, '1900-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (2, 45, '1900-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (3, 15, '1900-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (4, 15, '1900-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (5, 15, '1900-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (1, 16, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (1, 31, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (1, 46, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (2, 16, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (2, 31, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (2, 46, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (3, 14, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (3, 17, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (3, 18, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (4, 20, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (5, 5, '1901-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (1, 15, '1903-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (1, 15, '1903-07-13');
INSERT INTO sales (good_id, price, sales_date) VALUES (1, 15, '1903-07-13');

-- check the result
select * from sales;

-- first task select
select goods.name, count(*) as quantity, min(price) as min, max(price) as max
from sales full outer join goods on sales.good_id = goods.id 
where sales.sales_date >= DATE('1800-01-01') and sales.sales_date <= DATE('1903-01-01')
group by goods.id order by quantity desc;

-- second task delete
delete from sales as s1 where id < (
select max(id) from sales as s2 
where s2.good_id = s1.good_id and s2.sales_date = s1.sales_date
--group by s2.good_id, s2.sales_date
) ;

-- create second task unique constraint
alter table sales add constraint "$2" unique(good_id, sales_date);

-- check the result
select * from sales;



