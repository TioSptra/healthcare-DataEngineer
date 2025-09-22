import os
from google.cloud import bigquery
import logging
import time


logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] %(levelname)s - %(message)s'
)
log = logging.getLogger()

def load_dataRaw():
    log.info("Configuration to google cloud-bigquery...")
    key_path = os.path.join("/opt/airflow/keys","credentials.json")
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = key_path
    project_id = "purwadika"  
    dataset_id = "jcdeol005_finalproject_Tio_raw"  
    table_id = f"raw_healthcare" 

    log.info("initiating client Bigquery...")
    client = bigquery.Client(project=project_id)
    dataset_ref = client.dataset(dataset_id)
    table_ref = dataset_ref.table(table_id)
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        autodetect=True,  
        write_disposition="WRITE_TRUNCATE"  
    )

    log.info(f"Loading csv to {dataset_id}.{table_id}' ")
    try:
        file = os.path.join('/opt/airflow/tmp','healthcare_data.csv')
        with open(file,'rb') as source_file:
            load_job = client.load_table_from_file(source_file, table_ref, job_config=job_config)
        load_job.result() 
        log.info(f"[SUCCESS] '{file}' uploaded to {dataset_id}.{table_id} ")
        time.sleep(1)
    except Exception as e:
        log.exception(f"Unexpected error while loading to {dataset_id}.{table_id}: {e}")
        raise

if __name__ == "__main__":
    load_dataRaw()


