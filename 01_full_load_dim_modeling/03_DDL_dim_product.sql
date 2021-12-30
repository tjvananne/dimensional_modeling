
-- table: dim_product
-- refresh cadence: nightly
-- refresh strategy: full kill-and-fill (drop and rebuild table)

DROP TABLE IF EXISTS dim_product;
CREATE TABLE dim_product (
	product_id serial,
	category_num float8,
	category_name varchar(50),
	vendor_num int2,
	vendor_name varchar(50),
	item_num int4, --int2 (some values were out of range of an int2)
	item_description varchar(200)
);

INSERT INTO dim_product (category_num, category_name, vendor_num,
						vendor_name, item_num, item_description)
SELECT category_num, category_name, vendor_num, vendor_name, item_num, item_description
FROM liquor_sales
GROUP BY category_num, category_name, vendor_num, vendor_name, item_num, item_description;


SELECT * FROM dim_product LIMIT 1000;
