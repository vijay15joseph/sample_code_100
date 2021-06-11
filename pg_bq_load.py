"""
********************
JOB DESCRIPTION
********************
"""

import datetime

# [START import_operators]
from airflow import models
from airflow.operators.bash import BashOperator
from airflow.contrib.operators import bigquery_operator
# [END import_operators]

# [START custom_vars]
#dag_dataset_name = 'sandbox'
#dag_target_table1_id = dag_dataset_name + '.wiki_views_2019'
#dag_target_table2_id = dag_dataset_name + '.wiki_page_views_2019'
#source_table = 'bigquery-public-data.wikipedia.pageviews_2019' 

# [END custom_vars]

# [START required_vars]
today = datetime.datetime.combine(
    datetime.datetime.today(),
    datetime.datetime.min.time())

yesterday = datetime.datetime.combine(
    datetime.datetime.today() - datetime.timedelta(1),
    datetime.datetime.min.time())


	
default_dag_args = {
    'start_date': today,
    # Email whenever an Operator in the DAG fails.
#    'email': models.Variable.get('email'),
#    'email_on_failure': True,
#    'email_on_retry': False,
#    'retries': 1,
#    'retry_delay': datetime.timedelta(minutes=5),
#    'project_id': models.Variable.get('gcp_project')
}
# [END required_vars]


# [START dag_definition]
with models.DAG(
        'pg_bq_load',
        schedule_interval=None,
        #schedule_interval='0 */2 * * *',
        default_args=default_dag_args) as dag:
# [END dag_definition]


# [START task_definitions]

    # [START t_startup]
    # Enter description here
    t_startup = BashOperator(
        task_id='t_startup',
        bash_command='echo "Starting the Task";',
    )
    # [END t_startup]

    # [START t_unzip]
    # Enter description here
    t_unzip = BashOperator(
        task_id='t_unzip',
        bash_command='bash /home/airflow/gcs/dags/scripts/pg_unzip.sh > /home/airflow/gcs/logs/pg_unzip.out ',
    )
    # [END t_unzip]

    # [START t_loadBQ]
    # Enter description here
    t_loadBQ = BashOperator(
        task_id='t_loadBQ',
        bash_command='bash /home/airflow/gcs/dags/scripts/pg_loadBQ.sh > /home/airflow/gcs/logs/pg_loadBQ.out ',
    )
    # [END t_loadBQ]

    # [START t_finish]
    # Enter description here
    t_finish = BashOperator(
        task_id='t_finish',
        bash_command='echo "Ending the Task"',
    )
    # [END t_finish]


# [END task_definitions]

# [START dag_dependencies]
    #task_bq1 >> task_bq2
    t_startup >> t_unzip >> t_loadBQ >> t_finish
# [END dag_dependencies]