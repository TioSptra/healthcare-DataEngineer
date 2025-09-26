from airflow import DAG
from airflow.models.baseoperator import chain
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from scripts.notification import discord_notification
from datetime import datetime

default_args = {
    'owner': 'airflow',
    'depends_on_past': False
}

with DAG(
    dag_id='jcdeol005_finalproject_producer',
    default_args=default_args,
    start_date=datetime(2025, 1, 1),
    description="generate dummy data to csv file",
    catchup=False
) as dag:
    start = EmptyOperator(task_id="start")
    producer = BashOperator(
        task_id='producer',
        bash_command='python /opt/airflow/dags/scripts/producer.py',
        on_failure_callback=discord_notification,
        on_success_callback=discord_notification
    )
    delay = BashOperator(
        task_id ='delay',
        bash_command = 'sleep 30'
    )
    trigger = TriggerDagRunOperator(
        task_id="trigger_extraction_dag",
        trigger_dag_id="jcdeol005_finalproject_extraction",
        wait_for_completion=False,
        on_failure_callback=discord_notification,
        on_success_callback=discord_notification 
    )

    chain(start,producer,delay,trigger)
