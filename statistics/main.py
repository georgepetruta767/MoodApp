# http://127.0.0.1:8000/get-bar-grade/season/mean/f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0
import psycopg2 as psycopg2
from fastapi import FastAPI
import pandas as pd
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*']
)

season_dict = {
    0: 'Winter',
    1: 'Spring',
    2: 'Summer',
    3: 'Autum'
}

event_type_dict = {
    0: 'Recreational',
    1: 'Educational',
    2: 'WorkRelated'
}


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


@app.get("/get-bar-grade/{group}/{ctd_measure}/{user_id}")
async def get_bar(group: str, ctd_measure: str, user_id: str):
    if ctd_measure == 'mean':
        query = f"SELECT {group}, AVG(grade) FROM events " + \
                f"WHERE context_id = (select id from context where aspnetuserid = '{user_id}') " + \
                f"GROUP BY {group};"
    elif ctd_measure == 'median':
        query = f"SELECT {group}, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY grade) FROM events " + \
                f"WHERE context_id = (select id from context where aspnetuserid = '{user_id}') " + \
                f"GROUP BY {group};"
    else:
        return {
            "No": "Data"
        }

    data = get_data_by_query(query)

    if 'season' in data.columns:
        data['season'] = data['season'].map(season_dict)

    if 'type' in data.columns:
        data['type'] = data['type'].map(event_type_dict)

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


@app.get("/get-scatter/{col1}/{col2}/{user_id}")
async def get_scatter(col1: str, col2: str, user_id: str):
    query = f"SELECT {col1}, {col2} FROM events E " + \
            f"WHERE E.context_id = (select id from context where aspnetuserid = '{user_id}') AND E.status = 2 AND E.amount_spent is not null"
    data = get_data_by_query(query)

    scatter_dict = {
        'xAxis': {
            'name': col1
        },
        'yAxis': {
            'name': col2
        },
        'series': [{
            'symbolSize': 20,
            'data': data.values.tolist(),
            'type': 'scatter'
        }]
    }

    return scatter_dict


async def get_histogram(group: str, ctd_measure: str, user_id: str):
    pass


async def get_polygon_map():
    pass


async def get_tree_map():
    pass


async def get_table():
    pass


async def get_bar_2():
    pass


async def gradient_stack_area():
    pass


@app.get("/get-moving-average/{year}/{month}/{day}/{user_id}")
async def moving_average(year: int, month: int, day: int, user_id: str):
    ma_dict = {}
    if month == -1 and day == -1 and year == -1:
        query = f"""
            WITH cte_grade_over_date AS (
                SELECT EXTRACT(YEAR FROM starting_time) AS year, grade
                FROM events E
                WHERE E.context_id = (select id from context where aspnetuserid = '{user_id}' AND E.status = 2))
            SELECT year, AVG(grade)
            FROM cte_grade_over_date
            GROUP BY year
            ORDER BY year;
            """

        data = get_data_by_query(query)

        data['year'] = data['year'].astype(int).astype(str)
        data['date'] = data['year'].astype(str) + '-05'
        data['date'] = pd.to_datetime(data['date'])

        print(data)
        print(data.values)
        dates = data.values[:, len(data.values)].tolist()

        formatted_dates = []
        for date_time in dates:
            formatted_dates.append(date_time.strftime("%Y"))

        ma_dict = {
            'xAxis': {
                'type': 'category',
                'data': formatted_dates
            },
            'yAxis': {
                'type': 'value'
            },
            'series': [
                {
                    'data': data.values[:, len(data.values) - 1].tolist(),
                    'type': 'line',
                    'smooth': 'true'
                }
            ]
        }

    elif year != -1 and month == -1:
        query = f"""
        WITH cte_grade_over_date AS (
            SELECT EXTRACT(MONTH FROM starting_time) AS month, grade
            FROM events E
            WHERE (E.context_id = (select id from context where aspnetuserid = '{user_id}' AND E.status = 2) and EXTRACT(YEAR FROM starting_time) = {year})
        )
        SELECT month, AVG(grade)
        FROM cte_grade_over_date
        GROUP BY month
        ORDER BY month;
            """

        data = get_data_by_query(query)

        print(data)

        data['month'] = data['month'].astype(int).astype(str)
        data['date'] = str(year) + '-' + data['month'].astype(str)
        data['date'] = pd.to_datetime(data['date'])

        dates = data.values[:, 2].tolist()

        formatted_dates = []
        for date_time in dates:
            formatted_dates.append(date_time.strftime("%m"))

        ma_dict = {
            'xAxis': {
                'type': 'category',
                'data': formatted_dates
            },
            'yAxis': {
                'type': 'value'
            },
            'series': [
                {
                    'data': data.values[:, 1].tolist(),
                    'type': 'line',
                    'smooth': 'true'
                }
            ]
        }

    elif year != -1 and month != -1:
        query = f"""
        WITH cte_grade_over_date AS (
            SELECT EXTRACT(DAY FROM starting_time) as day, grade
            FROM events E
            WHERE (E.context_id = (select id from context where aspnetuserid = '{user_id}' AND E.status = 2) and EXTRACT(MONTH FROM starting_time) = {month} and EXTRACT(YEAR FROM starting_time) = {year})
        )
        SELECT day, AVG(grade)
        FROM cte_grade_over_date
        GROUP BY day
        ORDER BY day;
            """

        data = get_data_by_query(query)
        data['day'] = data['day'].astype(int).astype(str)
        data['date'] = str(year) + '-' + str(month) + '-' +  data['day'].astype(str)
        data['date'] = pd.to_datetime(data['date'])

        dates = data.values[:, 2].tolist()

        formatted_dates = []
        for date_time in dates:
            formatted_dates.append(date_time.strftime("%d"))

        ma_dict = {
            'xAxis': {
                'type': 'category',
                'data': formatted_dates
            },
            'yAxis': {
                'type': 'value'
            },
            'series': [
                {
                    'data': data.values[:, 1].tolist(),
                    'type': 'line',
                    'smooth': 'true'
                }
            ]
        }


    return ma_dict


@app.get("/get-top-bottom-friends/{top}/{nr_people}/{user_id}")
async def get_top_bottom(top: bool, nr_people: int, user_id: str):
    if(top):
        order = 'DESC'
    else:
        order = 'ASC'

    query = f"""
        SELECT CONCAT(ppl.firstname, ' ', ppl.lastname), AVG(evt.grade)
        FROM (select * from events
        WHERE context_id = (select id from context where aspnetuserid = '{user_id}' AND status = 2)) as evt
        INNER JOIN people ppl on evt.context_id = ppl.context_id
        GROUP BY CONCAT(ppl.firstname, ' ', ppl.lastname)
        ORDER BY AVG(evt.grade) {order}
        LIMIT '{nr_people}';
    """

    data = get_data_by_query(query)

    chartData = []
    for obj in data.values:
        dict = {}
        dict['value'] = obj[1]
        dict['name'] = obj[0]
        chartData.append(dict)

    top_bottom_dict = {
        'tooltip': {
            'trigger': 'item'
        },
        'legend': {
            'orient': 'vertical',
            'left': 'left'
        },
        'series': [
            {
                'type': 'pie',
                'radius': '50%',
                'data': chartData,
                'emphasis': {
                    'itemStyle': {
                        'shadowBlur': 10,
                        'shadowOffsetX': 0,
                        'shadowColor': 'rgba(0, 0, 0, 0.5)'
                    }
                }
            }
        ]
    }
    return top_bottom_dict