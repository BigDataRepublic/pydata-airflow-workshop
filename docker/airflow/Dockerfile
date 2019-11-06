FROM puckel/docker-airflow:1.10.4

# install python dependencies
USER root
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    rm requirements.txt
COPY entrypoint.sh /entrypoint.sh
USER airflow
