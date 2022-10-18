from ..models import Weather
import os
import json
import requests
import pymysql
from pathlib import Path
import environ

def weatherAPI(day, time, x_coordinate, y_coordinate):
    BASE_DIR = Path(__file__).resolve().parent.parent
    env = environ.Env(DEBUG=(bool, True))
    environ.Env.read_env(env_file=os.path.join(BASE_DIR, '.env'))
    pymysql.install_as_MySQLdb()
    METEOROGICAL_KEY = env('METEOROGICAL_KEY')
    
    headers = {'Content-Type': 'application/json', 'charset': 'UTF-8', 'Accept': '*/*'}

    url = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?serviceKey={METEOROGICAL_KEY}&numOfRows=19&pageNo=1&dataType=JSON&base_date={day}&base_time={time}&nx={x_coordinate}&ny={y_coordinate}'

    response = requests.get(url, headers=headers)
    jsonObject = json.loads(response.text)

    print(jsonObject.get('response'))
    return Weather(name = "test", visibility = "test")