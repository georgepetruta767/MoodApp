import psycopg2 as psycopg2
from fastapi import FastAPI
import pandas as pd
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*']
)

def get_data_by_query(db_query):
    conn = psycopg2.connect("dbname=moodapp user=postgres password=postgres")

    cur = conn.cursor()
    cur.execute(db_query)
    records = cur.fetchall()
    records = pd.DataFrame(records, columns=[desc[0] for desc in cur.description])
    cur.close()
    conn.close()

    return records

def preprocess_data(data):
    ...
f"""

"""
@app.get("/get-bar-grade/{group}/{ctd_measure}/{user_id}")
async def get_histogram(group: str, ctd_measure: str, user_id: str):
    if ctd_measure == 'mean':
        query = f"SELECT {group}, AVG(grade) FROM events " +\
                f"WHERE context_id = (select id from context where aspnetuserid = '{user_id}') " +\
                f"GROUP BY {group};"
    elif ctd_measure == 'median':
        query = f"SELECT {group}, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY grade) FROM events " +\
                f"WHERE context_id = (select id from context where aspnetuserid = '{user_id}') " +\
                f"GROUP BY {group};"
    else:
        return {
            "No": "Data"
        }

    season_dict = {
        0: 'Winter',
        1: 'Spring',
        2: 'Summer',
        3: 'Autum'
    }

    data = get_data_by_query(query)

    #map(season_dict, data.values[:, 0])

    api_data = {
        'xAxis': {
            'type': 'category',
            'data': data.values[:, 0].tolist()
        },
        'yAxis': {
            'type': 'value',
        },
        'series': [{
            'data': data.values[:, 1].tolist(),
            'type': 'bar'
        }
        ]
    }

    return api_data

@app.get("/get-scatter-plot")
async def get_histogram():
    api_data = {
        'xAxis': {},
        'yAxis': {},
        'series': [
        {
          'symbolSize': 20,
          'data': [
            [10.0, 8.04],
            [8.07, 6.95],
            [13.0, 7.58],
            [9.05, 8.81],
            [11.0, 8.33],
            [14.0, 7.66],
            [13.4, 6.81],
            [10.0, 6.33],
            [14.0, 8.96],
            [12.5, 6.82],
            [9.15, 7.2],
            [11.5, 7.2],
            [3.03, 4.23],
            [12.2, 7.83],
            [2.02, 4.47],
            [1.05, 3.33],
            [4.05, 4.96],
            [6.03, 7.24],
            [12.0, 6.26],
            [12.0, 8.84],
            [7.08, 5.82],
            [5.02, 5.68]
          ],
          'type': 'scatter'
        }
      ]
    }

    return api_data