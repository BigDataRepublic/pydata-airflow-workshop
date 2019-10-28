FROM puckel/docker-airflow:1.10.4

COPY airflow/requirements.txt .
RUN pip install -r requirements.txt && \
    rm requirements.txt
