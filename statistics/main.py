# http://127.0.0.1:8000/get-bar-grade/season/mean/f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0
import json

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

social_status_dict = {
    0: 'Employed',
    1: 'Retired',
    2: 'Student',
    3: 'Child',
    4: 'Unemployed'
}

gender_dict = {
    0: 'Female',
    1: 'Male'
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


@app.get("/get-bar-grade/{group}/{ctd_measure}/{user_id}")
async def get_bar(group: str, ctd_measure: str, user_id: str):
    if group in ['season', 'type']:
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
    else:
        query = f"""
            WITH extended_events AS (
                SELECT *, 
                    CASE 
                        WHEN EXTRACT(HOUR FROM starting_time) < 12 THEN 'Morning'
                        WHEN EXTRACT(HOUR FROM starting_time) < 18 THEN 'Afternoon'
                        ELSE 'Evening'
                    END AS time_of_day,
                    (ending_time - starting_time) AS event_duration
                FROM events
                WHERE context_id = (select id from context where aspnetuserid = '{user_id}' AND status = 2)
            ),
            extended_people AS (
                SELECT *,
                    CASE
                        WHEN age < 18 THEN 'young'
                        WHEN age < 28 THEN 'young adult'
                        WHEN age < 55 THEN 'adult'
                        ELSE 'old'
                    END AS age_group
                FROM people
                WHERE context_id = (select id from context where aspnetuserid = '{user_id}')
            )
            SELECT e.time_of_day, AVG(e.grade)
            FROM extended_events e
            INNER JOIN event_person_relation epr ON e.id = epr.event_id
            INNER JOIN extended_people ppl ON epr.person_id = ppl.id
            GROUP BY e.time_of_day;
            """

    data = get_data_by_query(query)

    if 'season' in data.columns:
        data['season'] = data['season'].map(season_dict)

    if 'type' in data.columns:
        data['type'] = data['type'].map(event_type_dict)

    api_data = {
        'xAxis': {
            'name': group,
            'type': 'category',
            'data': data.values[:, 0].tolist()
        },
        'yAxis': {
            'name': 'grade',
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
    query = ''
    if(col1 == 'amount_spent'):
        query = f"SELECT {col1}, {col2} FROM events E " + \
                f"WHERE E.context_id = (select id from context where aspnetuserid = '{user_id}') AND E.status = 2 AND E.amount_spent is not null"
    if(col1 == 'nrPeople'):
        query = f"SELECT COUNT(*), AVG(e.grade) " + \
                f"FROM events e " + \
                f"LEFT JOIN event_person_relation epr ON epr.event_id = e.id " + \
                f"LEFT JOIN people per ON per.id = epr.person_id " + \
                f"WHERE E.context_id = (select id from context where aspnetuserid = 'f1d9d883-fcaf-4a02-8f90-e20b4c2f1da0' AND E.status = 2) " + \
                f"GROUP BY e.id;"
    if(col1 == 'age'):
        query = f"WITH extended_events AS (" + \
                f"SELECT * " + \
                f"FROM events " + \
                f"WHERE context_id = (select id from context where aspnetuserid = '{user_id}' AND status = 2))," + \
                f"extended_people AS ( " + \
                f"SELECT *, " + \
                f"CASE " + \
                    f"WHEN age < 18 THEN 'Young' " + \
                    f"WHEN age < 28 THEN 'Young adult' " + \
                    f"WHEN age < 55 THEN 'Adult' " + \
                    f"ELSE 'Old' " + \
                f"END AS age_group " + \
                f"FROM people " + \
                f"WHERE context_id = (select id from context where aspnetuserid = '{user_id}')) " + \
                f"SELECT age, e.grade " + \
                f"FROM extended_events e " + \
                f"INNER JOIN event_person_relation epr ON e.id = epr.event_id " + \
                f"INNER JOIN extended_people ppl ON epr.person_id = ppl.id;"

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


async def get_polygon_map():
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

        dates = data.values[:, 2].tolist()

        formatted_dates = []
        for date_time in dates:
            formatted_dates.append(date_time.strftime("%Y"))

        ma_dict = {
            'xAxis': {
                'name': 'time',
                'type': 'category',
                'data': formatted_dates
            },
            'yAxis': {
                'name': 'grade',
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

        data['month'] = data['month'].astype(int).astype(str)
        data['date'] = str(year) + '-' + data['month'].astype(str)
        data['date'] = pd.to_datetime(data['date'])

        dates = data.values[:, 2].tolist()

        formatted_dates = []
        for date_time in dates:
            formatted_dates.append(date_time.strftime("%m"))

        ma_dict = {
            'xAxis': {
                'name': 'time',
                'type': 'category',
                'data': formatted_dates
            },
            'yAxis': {
                'name': 'grade',
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
                'name': 'time',
                'type': 'category',
                'data': formatted_dates
            },
            'yAxis': {
                'name': 'grade',
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
        select CONCAT(X.firstName, ' ', X.lastName), AVG(X.grade) from
        (select * from (select a.firstname, a.lastName, r.event_id from people a inner join event_person_relation r on a.id = r.person_id) as lNei inner join events e on e.id = lNei.event_id where e.context_id = (select id from context where aspnetuserid = '{user_id}')) as X
        group by CONCAT(X.firstName, ' ', X.lastName)
        order by AVG(x.grade) {order}
        LIMIT {nr_people};
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


@app.get("/geo-scatter/{column}/{user_id}")
def geo_scatter(column: str, user_id: str):
    query = f"""SELECT city, longitude, latitude, AVG({column})
        FROM events e
        INNER JOIN locations l
        ON e.location_id = l.id
        WHERE E.context_id = (select id from context where aspnetuserid = '{user_id}' AND E.status = 2)
        GROUP BY city, longitude, latitude;"""

    data = get_data_by_query(query)

    chartData = []
    for obj in data.values:
        dict = {}
        dict['value'] = obj[3]*10
        dict['name'] = obj[0]
        chartData.append(dict)


    api_data = {
      'tooltip': {
        'trigger': 'item',
        'formatter': '{a} <br/>{b} : {c}%'
      },
      'legend': {
        'data': ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
      },
      'series': [
        {
          'name': 'Funnel',
          'type': 'funnel',
          'left': '10%',
          'top': 60,
          'bottom': 60,
          'width': '80%',
          'min': 0,
          'max': 100,
          'minSize': '0%',
          'maxSize': '100%',
          'sort': 'descending',
          'gap': 2,
          'label': {
            'show': 'true',
            'position': 'inside'
          },
          'labelLine': {
            'length': 10,
            'lineStyle': {
              'width': 1,
              'type': 'solid'
            }
          },
          'itemStyle': {
            'borderColor': '#fff',
            'borderWidth': 1
          },
          'emphasis': {
            'label': {
              'fontSize': 20
            }
          },
          'data': chartData
        }
      ]
    }

    return api_data


@app.get("/bar-extended/{group}/{user_id}")
def get_bar_mean_grade_extened(group: str, user_id: str):
    # ppl.social_status, ppl.gender, e.time_of_day
    if group == 'social_status':
        agg_group = 'ppl.social_status'
    elif group == 'gender':
        agg_group = 'ppl.gender'
    elif group == 'time_of_day':
        agg_group = 'e.time_of_day'
    else:
        return {"No": "Data"}

    query = f"""
    WITH extended_events AS (
        SELECT *, 
            CASE 
                WHEN EXTRACT(HOUR FROM starting_time) < 12 THEN 'Morning'
                WHEN EXTRACT(HOUR FROM starting_time) < 18 THEN 'Afternoon'
                ELSE 'Evening'
            END AS time_of_day,
            (ending_time - starting_time) AS event_duration
        FROM events
        WHERE context_id = (select id from context where aspnetuserid = '{user_id}' AND status = 2)
    ),
    extended_people AS (
        SELECT *,
            CASE
                WHEN age < 18 THEN 'young'
                WHEN age < 28 THEN 'young adult'
                WHEN age < 55 THEN 'adult'
                ELSE 'old'
            END AS age_group
        FROM people
        WHERE context_id = (select id from context where aspnetuserid = '{user_id}')
    )
    SELECT {agg_group}, AVG(e.grade)
    FROM extended_events e
    INNER JOIN event_person_relation epr ON e.id = epr.event_id
    INNER JOIN extended_people ppl ON epr.person_id = ppl.id
    GROUP BY {agg_group};
    """

    data = get_data_by_query(query)

    if 'gender' in data.columns:
        data['gender'] = data['gender'].map(gender_dict)

    if 'social_status' in data.columns:
        data['social_status'] = data['social_status'].map(social_status_dict)


    api_data = {
        'xAxis': {
            'name': group,
            'type': 'category',
            'data': data.values[:, 0].tolist()
        },
        'yAxis': {
            'name': 'grade',
            'type': 'value',
        },
        'series': [{
            'data': data.values[:, 1].tolist(),
            'type': 'bar'
        }
        ]
    }

    return api_data
