from fastapi import FastAPI
import pandas as pd
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
        CORSMiddleware,
        allow_origins=['*']
    )

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