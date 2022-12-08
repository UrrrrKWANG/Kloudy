import os
import sys
import json
import requests
import pymysql
from pathlib import Path
import environ
import ssl
from socket import error as SocketError
import errno
from time import time
import jwt

ssl._create_default_https_context = ssl._create_unverified_context
BASE_DIR = Path(__file__).resolve().parent.parent
env = environ.Env(DEBUG=(bool, True))
environ.Env.read_env(env_file=os.path.join(BASE_DIR, '.env'))
pymysql.install_as_MySQLdb()

def getDataFromWeatherKit(location):
    private_key = open("./kloudy/AuthKey_QUZPUV9HLS.p8", "r").read()

    current_time = int(time())
    expiry_time = current_time + 3600
    key = private_key
    algorithm = "ES256"
    team_id = env("TEAM_ID")
    Bundle_ID = env("BUNDLE_ID")
    key_ID = env("KEY_ID")

    payload={
        "iss": team_id,
        'iat': current_time,
        'exp': expiry_time,
        "sub": Bundle_ID,
        }
    
    headers= {
        "kid": key_ID,
        "id": f"{team_id}.{Bundle_ID}",
    }

    token = jwt.encode(payload, key, algorithm, headers)
    headers = { 
        "Authorization": f"Bearer {token}"
        }

    language = 'en'
    latitude = location.latitude
    longitude = location.longitude
    
    url = f"https://weatherkit.apple.com/api/v1/weather/{language}/{latitude}/{longitude}"
    countryCode = "KR"
    timezone = "Asia/Seoul"
    dataSets = ["currentWeather", "forecastDaily", "forecastHourly", "forecastNextHour", "weatherAlerts"]

    params = {
            "countryCode": countryCode,
            "timezone": timezone,
            "dataSets": ",".join(dataSets),
        }

    try:
        weather_response           = requests.get(url, headers = headers, params= params)
        weather_jsonObject         = json.loads(weather_response.text)
    except:
        weather_jsonObject         = {'response': {'header': {'resultCode': '-1', 'resultMsg': '잘못된 응답이 들어왔습니다.'}}}

    return weather_jsonObject

def getDataFromKorea(today, time, location):
    key = env('METEOROGICAL_KEY')
    headers = {'Content-Type': 'application/json', 'charset': 'UTF-8', 'Accept': '*/*'}

    print("It's Time to get Data")
    print(today, time, location.city)
    period = "DAILY"
    # getMaskIndex & getCarWashIndex => 매시간
    air_url = f'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey={key}&returnType=JSON&numOfRows=1&pageNo=1&stationName={location.airCoditionMeasuring}&dataTerm={period}&ver=1.3'
    # getMaskIndex & getCarWashIndex => 하루 2번 -> 날짜 + 06시 18시에만 받을 수 있는데 06시에만 오늘의 꽃가루지수를 받을 수 있음 -> 06시로 고정.
    flower_url = f'https://apis.data.go.kr/1360000/HealthWthrIdxServiceV2/getPinePollenRiskIdxV2?serviceKey={key}&numOfRows=10&pageNo=1&dataType=JSON&areaNo={location.code}&time={str(today) + "06"}'
    
    try:
        air_response                  = requests.get(air_url, headers=headers, verify=False)
        air_jsonObject                = json.loads(air_response.text)
    except:
        air_jsonObject                = {'response': {'header': {'resultCode': '-1', 'resultMsg': '잘못된 응답이 들어왔습니다.'}}}
    
    try:
        flower_response               = requests.get(flower_url, headers=headers, verify=False)
        flower_jsonObject             = json.loads(flower_response.text)
    except:
        flower_jsonObject             = {'response': {'header': {'resultCode': '-1', 'resultMsg': '잘못된 응답이 들어왔습니다.'}}}
    
    return [ air_jsonObject, flower_jsonObject]

def cal_weather_24h_time(time):
    timer = int(time)
    result = ""
    # Base_time : 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300 (1일 8회)
    if 2030 <= timer < 2400:
        result = "2000"
    elif 1730 <= timer < 2030:
        result = "1700"
    elif 1430 <= timer < 1730:
        result = "1400"
    elif 1130 <= timer < 1430:
        result = "1100"
    elif 830 <= timer < 1130:
        result = "0800"
    elif 530 <= timer < 830:
        result = "0500"
    elif 230 <= timer < 530:
        result = "0200"
    elif 0 <= timer < 230:
        result = "2300"

    return result

def cal_middle_time(today, time):
    timer = int(time)
    if 700 <= timer < 2400:
        return str(today) + "0600"
    else:
        return str(int(today)-1) + "0600"