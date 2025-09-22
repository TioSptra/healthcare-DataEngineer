from datetime import datetime
from airflow import DAG
from airflow.models.baseoperator import chain
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from scripts.notification import discord_notification

default_args = {
    "owner": "airflow",
    "depends_on_past": False
}

with DAG(
    dag_id="jcdeol005_finalproject_transformation",
    default_args=default_args,
    description="Run DBT transformation via BashOperator",
    start_date=datetime(2025, 1, 1),
    catchup=False
) as dag:

    start = EmptyOperator(task_id="start")
    staging = BashOperator(
        task_id="create_dataset_staging",
        bash_command="dbt run --project-dir /opt/airflow/dbt --profiles-dir /opt/airflow/dbt --select staging",
        on_failure_callback=discord_notification,
        on_success_callback=discord_notification
    )

    model = BashOperator(
        task_id="create_dataset_model",
        bash_command="dbt run --project-dir /opt/airflow/dbt --profiles-dir /opt/airflow/dbt --select model",
        on_failure_callback=discord_notification,
        on_success_callback=discord_notification
    )

    validasi = BashOperator(
        task_id="validasi_model",
        bash_command="dbt test --project-dir /opt/airflow/dbt --profiles-dir /opt/airflow/dbt --select model",
        on_failure_callback=discord_notification,
        on_success_callback=discord_notification
    )

    marts = BashOperator(
        task_id="create_dataset_marts",
        bash_command="dbt run --project-dir /opt/airflow/dbt --profiles-dir /opt/airflow/dbt --select marts",
        on_failure_callback=discord_notification,
        on_success_callback=discord_notification
    )

    end = EmptyOperator(task_id="end")
    chain(start, staging, model, validasi, marts, end)
