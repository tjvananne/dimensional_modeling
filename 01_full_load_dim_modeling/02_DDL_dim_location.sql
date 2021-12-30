
-- table: dim_location 
-- refresh cadence: nightly 
-- refresh strategy: full-load (drop table and rebuild from all raw staging data)


DROP TABLE IF EXISTS dim_location;
CREATE TABLE dim_location (
	location_id serial,
	--location_id int4, -- may want to self-populate surrogate key so I can have -1 for missing?
	address varchar(50),
	city varchar(25),
	zip_code varchar(12),
	county_num real,
	county varchar(30)
);

-- populate table from the entire raw data set
INSERT INTO dim_location(address, city, zip_code, county_num, county)
SELECT 
	address, 
	city, 
	zip_code, 
	county_num, 
	county --, count(*) as num_records
FROM liquor_sales
WHERE address IS NOT NULL
GROUP BY address, city, zip_code, county_num, county;
--ORDER BY num_records desc;

--and now create an index on the key column in dim table (is this a good idea?)
-- do I put indexes on a surrogate key in a dimension table? this feels silly.
CREATE INDEX dim_location_id_idx on dim_location (location_id);


select * from dim_location LIMIT 10;

-- Nope, this will require a CTE apparently...
--UPDATE dim_location SET location_id = ROW_NUMBER() OVER ();


/*
-- So all this below here is me just trying to self-populate location_id (surrogate key).
-- The goal of this would be so I can represent missingness in the fact table with
-- a foreign key of -1, then I could insert a -1 record in the dimension with values
-- such as 'missing_city', 'missing_address'. It'd be some standard like 'missing_<columnname>'.


select row_number() OVER () as rowid, * from tbl1;

WITH v_dim_location AS
(
	SELECT row_number() over () as location_id,
	
	FROM dim_location
)
UPDATE dim_location SET location_id = v_dim_location.location_id
FROM v_dim_location;

select * from dim_location;
*/
