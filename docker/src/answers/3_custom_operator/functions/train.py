from sklearn.linear_model import LogisticRegression

LABEL_COLUMN = 'variety'


def train_model(df):
    X = df.drop(columns=LABEL_COLUMN)
    y = df[LABEL_COLUMN]
    print(X)
    model = LogisticRegression(solver='liblinear', multi_class='auto')
    model.fit(X, y)

    return model
