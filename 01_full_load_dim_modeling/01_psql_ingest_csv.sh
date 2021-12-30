psql -h localhost -d liquor -U taylor -c "\copy liquor_sales (invoice_item_num, date, \
store_num, store_name, address, city, zip_code, store_location, county_num, county, \
category_num, category_name, vendor_num, vendor_name, item_num, item_description, pack, \
bottle_volume_ml, state_bottle_cost, state_bottle_retail, bottles_sold, sale_dollars, \
volume_sold_liters, volume_sold_gallons) \
from 'data/Iowa_Liquor_Sales_scrubbed.csv' CSV HEADER";
