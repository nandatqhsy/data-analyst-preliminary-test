import pandas as pd
import numpy as np
from scipy import stats

df = pd.read_csv("dataset.csv")
user_qty = df.groupby("user_id")["quantity"].sum()

lambda_poisson = user_qty.mean()
