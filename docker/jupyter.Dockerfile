FROM jupyter/scipy-notebook:1386e2046833

COPY requirements.txt .
RUN pip install -r requirements.txt && \
    rm requirements.txt && \
    rm -rf work

COPY jupyter_notebook_config.py .jupyter
COPY src/Workshop.ipynb .
COPY src/answers answers