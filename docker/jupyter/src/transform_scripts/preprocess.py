#!/usr/bin/env python
import sys
import pandas as pd


def read_dataset(file_name):
    df = pd.read_csv(file_name)

    return df


def preprocess_dataset(df):
    preprocessed_df = pd.concat([
        df,
        pd.DataFrame({
            'petal.surface': df['petal.length'] * df['petal.width'],
            'sepal.surface': df['sepal.length'] * df['sepal.width']
        })
    ], axis=1)

    return preprocessed_df


def write_dataset(df, file_name):
    df.to_csv(file_name, index=False)


def main():
    dataset_file_name = sys.argv[1]
    saved_model_file_name = sys.argv[2]

    df = read_dataset(dataset_file_name)
    model = preprocess_dataset(df)
    write_dataset(model, saved_model_file_name)


if __name__ == '__main__':
    main()
