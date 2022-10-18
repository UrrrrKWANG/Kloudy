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

    current_weather = getCurrentWeather(headers, METEOROGICAL_KEY, day, time, x_coordinate, y_coordinate)
    current_temperature = getCurrentTemperature(headers, METEOROGICAL_KEY, day, time, x_coordinate, y_coordinate)
    
    print(f"This is current_weather : {current_weather}")    
    print(f"This is current_temperature : {current_temperature}")

    return Weather(name = "test", visibility = "test")

def getCurrentWeather(headers, key, day, time, x_coordinate, y_coordinate):
    url = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?serviceKey={key}&numOfRows=19&pageNo=1&dataType=JSON&base_date={day}&base_time={time}&nx={x_coordinate}&ny={y_coordinate}'
    
    response = requests.get(url, headers=headers)
    jsonObject = json.loads(response.text)
    # 만약 currentWeather 3 or 4라면 다른 요청을 보내야함 맑으면 보낼 필요 없음
    nowStatus = jsonObject.get('response').get('body').get('items').get('item')[0].get('fcstValue')
    if nowStatus == "0":
        return "0"
    else:
        rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey={key}&numOfRows=1&pageNo=1&dataType=JSON&base_date={day}&base_time={time}&nx={x_coordinate}&ny={y_coordinate}'
        response = requests.get(rainURL, headers=headers)
        jsonObject = json.loads(response.text)
        nowRain = jsonObject.get('response').get('body').get('items').get('item')[0].get('obsrValue')
        if nowRain == "0":
            return nowStatus
        # 3번은 nowStatus랑 겹칠 수 있음
        else:
            return "5" if nowRain == "3" else nowRain
    return

def getCurrentTemperature(headers, key, day, time, x_coordinate, y_coordinate):
    rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey={key}&numOfRows=4&pageNo=1&dataType=JSON&base_date={day}&base_time={time}&nx={x_coordinate}&ny={y_coordinate}'
    response = requests.get(rainURL, headers=headers)
    jsonObject = json.loads(response.text)
    
    for obj in jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'T1H':
            currentTemperature = obj.get('obsrValue')

    return currentTemperature

def getMaxMinTemperature(headers, key, day, time, x_coordinate, y_coordinate):
    return