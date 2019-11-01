FROM jupyter/scipy-notebook:1386e2046833

# install python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    rm requirements.txt && \
    rm -rf work

# configure jupyter
COPY jupyter_notebook_config.py .jupyter

# copy workshop content
COPY src/Workshop.ipynb .
COPY src/answers answers
