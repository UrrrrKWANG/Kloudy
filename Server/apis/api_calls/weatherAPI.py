from ..models import Weather, Main
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
    (day_max_temperature, day_min_temperature) = getMaxMinTemperature(headers, METEOROGICAL_KEY, day, time, x_coordinate, y_coordinate)
    umbrellaIndex = getUmbrellaIndex(headers, METEOROGICAL_KEY, day, time, x_coordinate, y_coordinate)

    print(f"This is current_weather : {current_weather}, the type is { type(current_weather) }")    
    print(f"This is current_temperature : {current_temperature}, the type is { type(current_temperature) }")
    print(f"This is day_max_temperature : {day_max_temperature}, the type is { type(day_max_temperature) }")    
    print(f"This is day_min_temperature : {day_min_temperature}, the type is { type(day_min_temperature) }")
    
    weather = Weather.objects.create(today = day)
    Main.objects.create(weather = weather, current_weather = current_weather, current_temperature = current_temperature, day_max_temperature = day_max_temperature, day_min_temperature = day_min_temperature)

    return weather

def getCurrentWeather(headers, key, day, time, x_coordinate, y_coordinate):
    url = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?serviceKey={key}&numOfRows=19&pageNo=1&dataType=JSON&base_date={day}&base_time={time}&nx={x_coordinate}&ny={y_coordinate}'
    response = requests.get(url, headers=headers)
    jsonObject = json.loads(response.text)
    # 만약 currentWeather 3 or 4라면 다른 요청을 보내야함 맑으면 보낼 필요 없음
    nowStatus = jsonObject.get('response').get('body').get('items').get('item')[0].get('fcstValue')
    if nowStatus == "0":
        return 0
    else:
        rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey={key}&numOfRows=1&pageNo=1&dataType=JSON&base_date={day}&base_time={time}&nx={x_coordinate}&ny={y_coordinate}'
        response = requests.get(rainURL, headers=headers)
        jsonObject = json.loads(response.text)
        nowRain = jsonObject.get('response').get('body').get('items').get('item')[0].get('obsrValue')
        if nowRain == "0":
            return int(nowStatus)
        # 3번은 nowStatus랑 겹칠 수 있음
        else:
            return "5" if nowRain == 3 else int(nowRain)
    
    return

def getCurrentTemperature(headers, key, day, time, x_coordinate, y_coordinate):
    rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey={key}&numOfRows=4&pageNo=1&dataType=JSON&base_date={day}&base_time={time}&nx={x_coordinate}&ny={y_coordinate}'
    response = requests.get(rainURL, headers=headers)
    jsonObject = json.loads(response.text)
    
    for obj in jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'T1H':
            currentTemperature = obj.get('obsrValue')

    return float(currentTemperature)

def getMaxMinTemperature(headers, key, day, time, x_coordinate, y_coordinate):
    # 오늘의 MaxMin은 전날 2300시
    rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey={key}&numOfRows=290&pageNo=1&dataType=JSON&base_date={int(day)-1}&base_time=2300&nx={x_coordinate}&ny={y_coordinate}'
    response = requests.get(rainURL, headers=headers)
    jsonObject = json.loads(response.text)
    max_temperature = 0.0
    min_temperature = 0.0

    for obj in jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'TMX':
            max_temperature = obj.get('fcstValue')

        if obj.get('category') == 'TMN':
            min_temperature = obj.get('fcstValue')

    return [float(max_temperature), float(min_temperature)]

def getUmbrellaIndex(headers, key, day, time, x_coordinate, y_coordinate):
    # Base_time : 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300 (1일 8회)
    rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey={key}&numOfRows=290&pageNo=1&dataType=JSON&base_date={day}&base_time={time}&nx={x_coordinate}&ny={y_coordinate}'
    response = requests.get(rainURL, headers=headers)
    jsonObject = json.loads(response.text)
    rain = []
    wind = []
    for obj in jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'PCP':
            if obj.get('fcstValue') == '강수없음':
                rain.append(0)
            else:
                rain.append(float(obj.get('fcstValue')))
        if obj.get('category') == 'WSD':
            wind.append(float(obj.get('fcstValue')))

    # 24개가 오지만 12개만 봐야함, 시간 순으로 오기 앞에서 12개 자르면 됨
    rain = rain[:12]
    wind = wind[:12]

    P = sum(rain) / 12
    PMAX1 = max(rain)
    PMAX3 = 0
    for i in range(0, 12-3, 3):
        temp = 0
        for j in range(3):
            temp += rain[i+j]

        temp = temp / 3
        if temp > PMAX3:
            PMAX3 = temp

    V = sum(wind) / 12
    umbrella_index = (P + (PMAX1 * 1.2) + (PMAX3 * 1.1)) / 3 + (P * (V/4))
    return umbrella_index