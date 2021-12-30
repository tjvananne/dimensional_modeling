
-- table: dim_date
-- refresh cadence: nightly
-- refresh strategy: full load kill-and-fill

/*
Write up each of these scripts in a high level design / strategic pseudo-code.
Make it very high level like:

- Check if our temp date range table exists, if so, drop it.
- Create the temp date range table. 
		-It's a table with one field
		named 'date' which represents every unique date between the
		min value in the raw transactional data liquor_sales, and
		the max-value-plus-three-years date. I wanted some runway
		for potential forecasts.
- Check if my date dimension table exists, if so, drop it.
- Create the date_dimension table.
- Select date from my temp_date_range table, and make a bunch of
transformations to it. Insert this result directly into the dim_date 
table. INSERT INTO dim_date (date, ..., all other dimensions) SELECT...
*/


-- nice, this works, creates a date range from min(date) of 
-- liquor sales data set to 3 years past the max(date) of liquor_sales
DROP TABLE IF EXISTS temp_date_range;
CREATE TEMP TABLE temp_date_range (
	date date
);

-- insert into our temp table date range
INSERT INTO temp_date_range (date)
SELECT d::date
FROM generate_series(
  (select min(date) from liquor_sales),
  ((select max(date) from liquor_sales) + (365 * 3)),
  '1 day'
) AS gs(d);  -- AS "a table named 'gs' with a field named 'd'"; (https://stackoverflow.com/a/10677499/3586093)

SELECT * from temp_date_range LIMIT 5;

-- create our date dimension table
DROP TABLE IF EXISTS dim_date;
CREATE TABLE dim_date (
	date date, -- we'll just use this as our key, it's the most reliable of natural keys...
	year int2,
	month_num int2,
	month_name varchar(3),
	day_in_month int2,
	day_in_year int2,
	day_of_week_num int2,
	day_of_week varchar(9),
	weekday_or_weekend varchar(7)
);

INSERT INTO dim_date (date, year, month_num, month_name, day_in_month,
					 day_in_year, day_of_week_num, day_of_week, weekday_or_weekend)
SELECT 
	date,
	date_part('year', date) as year,
	date_part('month', date) as month_num,
	CASE
		WHEN date_part('month', date) = 1 THEN 'Jan'
		WHEN date_part('month', date) = 2 THEN 'Feb'
		WHEN date_part('month', date) = 3 THEN 'Mar'
		WHEN date_part('month', date) = 4 THEN 'Apr'
		WHEN date_part('month', date) = 5 THEN 'May'
		WHEN date_part('month', date) = 6 THEN 'Jun'
		WHEN date_part('month', date) = 7 THEN 'Jul'
		WHEN date_part('month', date) = 8 THEN 'Aug'
		WHEN date_part('month', date) = 9 THEN 'Sep'
		WHEN date_part('month', date) = 10 THEN 'Oct'
		WHEN date_part('month', date) = 11 THEN 'Nov'
		WHEN date_part('month', date) = 12 THEN 'Dec'
	END AS month_name,
	date_part('day', date) as day_in_month,
	date_part('doy', date) as day_in_year,
	date_part('isodow', date) as day_of_week_num,
	CASE
		WHEN date_part('isodow', date) = 1 THEN 'Monday'
		WHEN date_part('isodow', date) = 2 THEN 'Tuesday'
		WHEN date_part('isodow', date) = 3 THEN 'Wednesday'
		WHEN date_part('isodow', date) = 4 THEN 'Thursday'
		WHEN date_part('isodow', date) = 5 THEN 'Friday'
		WHEN date_part('isodow', date) = 6 THEN 'Saturday'
		WHEN date_part('isodow', date) = 7 THEN 'Sunday'
	END AS day_of_week,
	CASE 
		WHEN date_part('isodow', date) IN (6, 7) THEN 'weekend' 
		ELSE 'weekday'
	END AS is_weekend
FROM temp_date_range ;


select * from dim_date limit 100;


/*
-- for reference, how to create a date range with literal values
SELECT d::date
FROM generate_series(
  timestamp without time zone '2016-10-16',
  timestamp without time zone '2016-10-17',
  '1 day'
) AS gs(d);
*/







