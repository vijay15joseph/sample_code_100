Pre-requisite:
1) Create cleaned-up folder in the cloud storage location after downloading the files from playfab first time.
2)Create the BQ dataset and update that in pg_loadBQ.sh

Steps:
1) Setup Transfer Service to download from S3 to Cloud storage
2) Setup Airflow/Cloud Composer Environment.
3) Copy the scripts(pg_bq_load.py,pg_unzip.sh and pg_loadBQ.sh ) to the <cloudstorage_bucket>/dags/scripts
4)Go to Airflow and trigger the job


References:
https://cloud.google.com/composer/docs/how-to/using/installing-python-dependencies
https://cloud.google.com/composer/docs/how-to/managing/creating

us-east1-pg-composer-ba266b25-bucket/dags/scripts
