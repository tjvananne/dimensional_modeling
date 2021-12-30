# dimensional_modeling

Will be working through many different concepts in dimensional data modeling, starting with SQL (PostgreSQL) and hopefully transitioning into more advanced topics involving streaming.

Concepts I want to explore:
- Basic full-load (truncate and insert) dimensional data modeling
- Incremental dimensional data modeling
- Different strategies for dealing with slowly changing dimensions (type 2 is most interesting to me)
- Stream / event-driven dimensional data modeling

Tools I'd like to use:
- PostgreSQL for the basics (VirtualBox on my local machine)
- Python (likely sql alchemy); I'll probably use Python to simulate events and chunks of transactional data to create the necessary environment for testing incremental loads and streaming
- Kafka; I've been looking for an excuse to play with it, specifically for streaming and pub/sub style concepts
- Spark (likely on Azure databricks)

What I'm optimizing for in this repo:
- Reproducibility; all software versions made explicit. If someone else can't reproduce what I've done here (with a reasonable amount of experience), then I consider this a failed experiment
- Clarity; in many cases, I'll care more about a specific concept than true production-grade code that may contain quite a bit of boiler-plate logic
- Documenting resources used / references

Table of Contents (and to-do list):

1. [**IN WORK**] Ingest data into PostgreSQL from csv using `psql` command and create a full-load, kill-and-fill style dimensional model (Iowa Liquor Sales data set) 
2. Explore options for refactoring the full-load logic into incremental logic (Iowa Liquor Sales data set)
3. 


