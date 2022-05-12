import pandas as pd

df = pd.read_csv("moodapp_public_events.csv")
agg_df = df.groupby('season').agg({
    'grade': 'mean'
}).reset_index()

print(agg_df['season'].values.tolist())