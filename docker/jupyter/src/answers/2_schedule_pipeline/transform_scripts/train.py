#!usr/bin/env python
import pickle
import sys
import pandas as pd
from sklearn.linear_model import LogisticRegression

LABEL_COLUMN = 'variety'


def read_dataset(file_name):
    df = pd.read_csv(file_name)

    return df


def train_model(df):
    X = df.drop(columns=LABEL_COLUMN)
    y = df[LABEL_COLUMN]

    model = LogisticRegression(solver='liblinear', multi_class='auto')
    model.fit(X, y)

    return model


def write_model(model, file_name):
    with open(file_name, 'wb') as f:
        pickle.dump(model, f)


def main():
    dataset_file_name = sys.argv[1]
    saved_model_file_name = sys.argv[2]

    df = read_dataset(dataset_file_name)
    model = train_model(df)
    write_model(model, saved_model_file_name)


if __name__ == '__main__':
    main()
