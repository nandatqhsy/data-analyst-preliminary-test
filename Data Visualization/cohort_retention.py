df["order_month"] = pd.to_datetime(df["order_date"]).dt.to_period("M")
first_order = df.groupby("user_id")["order_month"].min()

df = df.join(first_order, on="user_id", rsuffix="_cohort")
df["cohort_index"] = (df["order_month"] - df["order_month_cohort"]).apply(attrgetter("n"))
