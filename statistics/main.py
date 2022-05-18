import psycopg2 as psycopg2
from fastapi import FastAPI
import pandas as pd
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
        CORSMiddleware,
        allow_origins=['*']
    )

conn = psycopg2.connect("dbname=moodapp user=postgres password=postgres")

async def get_data_by_query(db_query):
    cur = conn.cursor()

    cur.execute(db_query)

    records = cur.fetchall()

    cur.close()

    return records


@app.get("/get-bar-grade/{type_}")
async def get_bar_(type_: str):
    df = pd.read_csv("moodapp_public_events.csv", engine = 'pyarrow')
    df['season'] = df['season'].map({
        0: 'Winter',
        1: 'Spring',
        2: 'Summer',
        3: 'Autum'
    })
    agg_df = df.groupby('season').agg({
        'grade': type_
    }).reset_index()
    
    data = {
        'xAxis': {
            'type': 'category',
            'data': agg_df['season'].values.tolist()
        },
        'yAxis': {
            'type': 'value',
        },
        'series': [ {
            'data': agg_df['grade'].values.tolist(),
            'type': 'bar'
            }
        ]
    }

    return data


conn.close()