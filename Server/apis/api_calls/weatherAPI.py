from ..models import Weather, Main, MaskIndex, WeatherIndex
import os
import json
import requests
import pymysql
from pathlib import Path
import environ

def weatherAPI(day, time, x_coordinate, y_coordinate, air_condition_measuring, code):
    BASE_DIR = Path(__file__).resolve().parent.parent
    env = environ.Env(DEBUG=(bool, True))
    environ.Env.read_env(env_file=os.path.join(BASE_DIR, '.env'))
    pymysql.install_as_MySQLdb()
    METEOROGICAL_KEY = env('METEOROGICAL_KEY')
    
    headers = {'Content-Type': 'application/json', 'charset': 'UTF-8', 'Accept': '*/*'}

    current_weather = getCurrentWeather(headers, METEOROGICAL_KEY, day, time, x_coordinate, y_coordinate)
    current_temperature = getCurrentTemperature(headers, METEOROGICAL_KEY, day, time, x_coordinate, y_coordinate)
    (day_max_temperature, day_min_temperature) = getMaxMinTemperature(headers, METEOROGICAL_KEY, day, time, x_coordinate, y_coordinate)
    umbrella_index = getUmbrellaIndex(headers, METEOROGICAL_KEY, day, time, x_coordinate, y_coordinate)
    (air_quality, flower_quality, dust_quality) = getMaskIndex(headers, METEOROGICAL_KEY, air_condition_measuring, code, day, time)

    print(f"This is current_weather : {current_weather}, the type is { type(current_weather) }")    
    print(f"This is current_temperature : {current_temperature}, the type is { type(current_temperature) }")
    print(f"This is day_max_temperature : {day_max_temperature}, the type is { type(day_max_temperature) }")    
    print(f"This is day_min_temperature : {day_min_temperature}, the type is { type(day_min_temperature) }")
    print(f"This is umbrella_index : {umbrella_index}, the type is { type(umbrella_index) } ")
    print(f"This is air_quality : {air_quality}, the type is { type(air_quality) } ")
    print(f"This is flower_quality : {flower_quality}, the type is { type(flower_quality) } ")
    print(f"This is dust_quality : {dust_quality}, the type is { type(dust_quality) } ")

    weather = Weather.objects.create(today = day)
    Main.objects.create(weather = weather, current_weather = current_weather, current_temperature = current_temperature, day_max_temperature = day_max_temperature, day_min_temperature = day_min_temperature)
    weather_index = WeatherIndex.objects.create(weather = weather, umbrella_index = umbrella_index)
    mask_index = MaskIndex.objects.create(weather_index = weather_index, air_quality = air_quality, flower_quality = flower_quality, dust_quality = dust_quality)
    
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
    
    # T현재 시간을 기준으로 시간 최신 시간 계산.
    umbrella_time = calUmbreallaTime(time)
    rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey={key}&numOfRows=290&pageNo=1&dataType=JSON&base_date={day}&base_time={umbrella_time}&nx={x_coordinate}&ny={y_coordinate}'
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

    # 24개가 오지만 12개만 봐야함, 시간 순으로 오기 때문에 앞에서 12개 자르면 됨
    rain = rain[:12]
    wind = wind[:12]

    P = sum(rain) / 12
    PMAX1 = max(rain)
    PMAX3 = 0
    for i in range(0, 10, 3):
        temp = 0
        for j in range(3):
            temp += rain[i+j]

        temp = temp / 3
        if temp > PMAX3:
            PMAX3 = temp

    V = sum(wind) / 12
    umbrella_index = (P + (PMAX1 * 1.2) + (PMAX3 * 1.1)) / 3 + (P * (V/4))

    return umbrella_index

def getMaskIndex(headers, key, air_condition_measuring, code, day, time):
    period = "DAILY"
    flower_date = day + time[0] + time[1]

    air_url = f'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey={key}&returnType=JSON&numOfRows=1&pageNo=1&stationName={air_condition_measuring}&dataTerm={period}&ver=1.3'
    flower_url = f'https://apis.data.go.kr/1360000/HealthWthrIdxServiceV2/getPinePollenRiskIdxV2?serviceKey={key}&numOfRows=10&pageNo=1&dataType=JSON&areaNo={code}&time={flower_date}'

    air_response = requests.get(air_url, headers=headers, verify=False)
    air_json_object = json.loads(air_response.text)

    flower_response = requests.get(flower_url, headers=headers, verify=False)
    flower_json_object = json.loads(flower_response.text)

    air_quality = air_json_object.get('response').get('body').get('items')[0].get('pm25Value')
    flower_quality = 0
    # TODO : 미세먼지 받아오는 거 아직 못받음
    dust_quality = 0

    # TODO : 현재 주어지지 않는데 주어졌을 때 데이터 형식이 필요함.
    if flower_json_object.get('response').get('header').get('resultCode') != '99':
        flower_quality = 0

    return [int(air_quality), flower_quality, dust_quality]

def calUmbreallaTime(time):
    time = int(time)
    # Base_time : 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300 (1일 8회)
    if 2300 <= time < 200:
        return "2300"
    elif 2000 <= time < 1700:
        return "2000"
    elif 1700 <= time < 1400:
        return "1700"
    elif 1400 <= time < 1100:
        return "1400"
    elif 1100 <= time < 800:
        return "1100"
    elif 800 <= time < 500:
        return "0800"
    elif 500 <= time < 200:
        return "0500"
    else:
        return "0200"
    