FROM jupyter/scipy-notebook:1386e2046833

COPY requirements.txt .
RUN echo "c.NotebookApp.token = ''; c.NotebookApp.password = ''" \
        > /home/jovyan/.jupyter/jupyter_notebook_config.py && \
    pip install -r requirements.txt
