

-- ===== creating a 1-n id field manually ======
-- the reason I want to do this is so I can represent missing data with
-- a "-1" value in an id field. This will no-doubt make incremental loads 
-- much more challenging though...

DROP TABLE IF EXISTS tv1;
CREATE TEMP TABLE tv1 (
	myid int4,
	col1 varchar(20),
	col2 int4
);

INSERT INTO tv1 (col1, col2)
VALUES ('hey', 100), ('whatsup', 200), ('a few more', 300), ('last one', 400);

SELECT * FROM tv1;

-- This is one way, but would only work with full loads, not incremental...
SELECT row_number() OVER () as someid FROM tv1;

-- Here's another way that would be more incremental friendly
-- https://stackoverflow.com/a/23358625/3586093
SELECT a.n
FROM generate_series(5, 10) as a(n);
-- with the query above, you could dynamically set the min/max of your range
-- which would be convenient for populating a dim table...

SELECT a.n
FROM generate_series(1, (select count(*) from liquor_sales)) as a(n);

myvar int;
DECLARE myvar int;


--ok so pretend like we've done this already
INSERT INTO tv1 (myid) 
SELECT a.n
FROM generate_series(1, 4) a(n); 

select * from tv1;







-- ==============================

select * from liquor_sales 
LIMIT 10;


select count(distinct city)
from liquor_sales;

-- creating a city dimension table
-- actually, no. that's too many dimensions
-- let's forget about saving disk space and create a location dimension
-- dim_location
	-- address 		varchar(50)
	-- city    		varchar(25)
	-- zip_code		varchar(12)
	-- county_num	real
	-- county		varchar(30)
DROP TABLE IF EXISTS dim_location;
CREATE TABLE dim_location (
	
);

-- this is essentially what I want the location dimension to be, minus the num_records
-- this returned ~4k records, highest num_records per group was like 81k, then 70k, dropped off quick.
SELECT address, city, zip_code, county_num, county, count(*) as num_records
FROM liquor_sales
GROUP BY address, city, zip_code, county_num, county
ORDER BY num_records desc;


-- side question, is this even allowed? yes
SELECT count(*) as num_records
FROM liquor_sales
GROUP BY address, city, zip_code, county_num, county
ORDER BY num_records desc;


-- interesting casting between data types
SELECT 
	state_bottle_cost,
	(state_bottle_cost::NUMERIC * 100)::INT AS state_bottle_cost_cents 
FROM liquor_sales
LIMIT 10;



select state_bottle_cost
from liquor_sales
LIMIT 10;




create temp table tbl1 (
	rec_id int,
	firstname varchar(30),
	lastname varchar(40)
);

insert into tbl1 (rec_id, firstname, lastname) values (1, 'taylor', 'van anne');
insert into tbl1 (rec_id, firstname, lastname) values
	(2, 'ari', 'spunt'), (3, 'nelson', 'spunt');

select * from tbl1;

/*
create temp table tbl2 (
	rec_id int,
	firstname varchar(30),
	lastname varchar(40)
);
*/

drop table if exists tbl2;
select * into tbl2 
from tbl1 where rec_id = 3;

select * from tbl2;

-- In tbl1 but not in tbl2; this can be used for identifying new dimension values
select * from tbl1
except
select * from tbl2;

-- ok, so how do you select 














