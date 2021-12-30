
# Full Load Dimensional Modeling

A few notes for reproducibility sake:

- `01_psql_ingest_csv.sh` needs to be run from the root of this repo, as the script references the data set at `./data/(name of data set)`
- `01_psql_ingest_csv.sh` will execute the script as the database user "taylor", you'll need to modify that to be whatever username you're using for your database. You'll also need to make sure your database account has the necessary access to create tables, insert records, delete tables, etc.





