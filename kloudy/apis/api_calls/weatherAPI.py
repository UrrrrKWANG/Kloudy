from ..models import Weather
import os
import json
import requests
import pymysql
from pathlib import Path
import environ

def weatherAPI():
    BASE_DIR = Path(__file__).resolve().parent.parent
    env = environ.Env(DEBUG=(bool, True))
    environ.Env.read_env(env_file=os.path.join(BASE_DIR, '.env'))
    pymysql.install_as_MySQLdb()
    OPENWEATHER_KEY = env('OPENWEATHER_KEY')
    
    city = "Seoul"

    url = f'https://api.openweathermap.org/data/2.5/weather?q={city}&appid={OPENWEATHER_KEY}'

    headers = {'Content-Type': 'application/json', 'charset': 'UTF-8', 'Accept': '*/*'}

    response = requests.get(url, headers=headers)
    jsonObject = json.loads(response.text)

    return Weather(name = jsonObject.get("name"), visibility = jsonObject.get("visibility"))