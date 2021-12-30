
/*
Usually, I would try to avoid the "money" data type that PostgreSQL provides, but
in this case, I'd like to treat this "liquor_sales" table as a type of staging
table that houses the truly raw data prior to any transformations. Because the
data is in the $##.## format, I'll make these fields
*/

-- DDL01_liquor_sales.sql
DROP TABLE IF EXISTS liquor_sales;
CREATE TABLE liquor_sales (
	record_id serial PRIMARY KEY,
	invoice_item_num varchar(18),
	date date,  
	store_num int4, 
	store_name varchar(50),
	address varchar(50),
	city varchar(25),
	zip_code varchar(12),
	store_location varchar(100),
	county_num float4,
	county varchar(30),
	category_num float8,
	category_name varchar(50),
	vendor_num int2,
	vendor_name varchar(50),
	item_num int4,                  	-- int2 (some values were out of range of an int2)
	item_description varchar(200),
	pack int2,
	bottle_volume_ml int4, 				-- int2 (some values were out of range)
	state_bottle_cost money,   			-- "money" type not ideal, but this is staging
	state_bottle_retail money, 			-- "money" type not ideal, but this is staging
	bottles_sold int2,
	sale_dollars money,                	-- "money" type not ideal, but this is staging
	volume_sold_liters float4,
	volume_sold_gallons float4
);


