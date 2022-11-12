import os
import sys
import json
import requests
import pymysql
from pathlib import Path
import environ
import ssl

ssl._create_default_https_context = ssl._create_unverified_context
BASE_DIR = Path(__file__).resolve().parent.parent
env = environ.Env(DEBUG=(bool, True))
environ.Env.read_env(env_file=os.path.join(BASE_DIR, '.env'))
pymysql.install_as_MySQLdb()
key = env('METEOROGICAL_KEY')
headers = {'Content-Type': 'application/json', 'charset': 'UTF-8', 'Accept': '*/*'}

def getDatas(today, time, location):
    print("It's Time to get Data")
    print(today, time, location.city)
    period = "DAILY"
    # getCurrentWeather
    main_state_url = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?serviceKey={key}&numOfRows=19&pageNo=1&dataType=JSON&base_date={today}&base_time={time}&nx={location.xCoordination}&ny={location.yCoordination}'
    main_state_short_url = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey={key}&numOfRows=1&pageNo=1&dataType=JSON&base_date={today}&base_time={time}&nx={location.xCoordination}&ny={location.yCoordination}'
    # getCurrentTemperature
    main_current_url =  f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey={key}&numOfRows=4&pageNo=1&dataType=JSON&base_date={today}&base_time={time}&nx={location.xCoordination}&ny={location.yCoordination}'
    
    # getUmbrellaIndex & HourlyIndex => ["0200", "0500", "0800", "1100", "1400", "1700", "2000", "2300"]
    weather_24h_time = cal_weather_24h_time(time)
    weather_24h_url = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey={key}&numOfRows=290&pageNo=1&dataType=JSON&base_date={today}&base_time={weather_24h_time}&nx={location.xCoordination}&ny={location.yCoordination}'
    # getMaskIndex & getCarWashIndex => 매시간
    air_url = f'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey={key}&returnType=JSON&numOfRows=1&pageNo=1&stationName={location.airCoditionMeasuring}&dataTerm={period}&ver=1.3'
    
    # WeeklyWeather
    weather_48h_url = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey={key}&numOfRows=580&pageNo=1&dataType=JSON&base_date={int(today)-1}&base_time=2300&nx={location.xCoordination}&ny={location.yCoordination}'
    main_max_min_url = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey={key}&numOfRows=290&pageNo=1&dataType=JSON&base_date={int(today)-1}&base_time=2300&nx={location.xCoordination}&ny={location.yCoordination}'
    
    # getMaskIndex & getCarWashIndex => 하루 2번 -> 날짜 + 06시 18시에만 받을 수 있는데 06시에만 오늘의 꽃가루지수를 받을 수 있음 -> 06시로 고정.
    flower_url = f'https://apis.data.go.kr/1360000/HealthWthrIdxServiceV2/getPinePollenRiskIdxV2?serviceKey={key}&numOfRows=10&pageNo=1&dataType=JSON&areaNo={location.code}&time={today + "06"}'
    # getCarWashIndex & WeeklyWeather => 시간에 날짜+0600 or 날짜+1800으로만 넣어야함.
    middle_state_url = f'http://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst?serviceKey={key}&numOfRows=10&pageNo=1&dataType=JSON&regld={location.daily_status_code}&tmFc={date_0618+"00"}'
    # WeeklyWeather => 시간에 날짜+0600 or 날짜+1800으로만 넣어야함.
    middle_temperature_url = f'http://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?serviceKey={key}&numOfRows=10&pageNo=1&dataType=JSON&regld={location.daily_temperature_code}&tmFc={date_0618+"00"}'
    
    main_state_response           = requests.get(main_state_url, headers=headers, verify=False)
    main_state_short_response     = requests.get(main_state_short_url, headers=headers, verify=False)
    main_current_response         = requests.get(main_current_url, headers=headers, verify=False)
    weather_24h_response          = requests.get(weather_24h_url, headers=headers, verify=False)
    air_response                  = requests.get(air_url, headers=headers, verify=False)
    weather_48h_response          = requests.get(weather_48h_url, headers=headers, verify=False)
    main_max_min_response         = requests.get(main_max_min_url, headers=headers, verify=False)
    flower_response               = requests.get(flower_url, headers=headers, verify=False)
    middle_state_response         = requests.get(middle_state_url, headers=headers, verify=False)
    middle_temperature_response   = requests.get(middle_temperature_url, headers=headers, verify=False)

    main_state_jsonObject         = json.loads(main_state_response.text)
    main_state_short_jsonObject   = json.loads(main_state_short_response.text)
    main_current_jsonObject       = json.loads(main_current_response.text)
    weather_24h_jsonObject        = json.loads(weather_24h_response.text)
    air_jsonObject                = json.loads(air_response.text)
    weather_48h_jsonObject        = json.loads(weather_48h_response.text)
    main_max_min_jsonObject       = json.loads(main_max_min_response.text)
    flower_jsonObject             = json.loads(flower_response.text)
    middle_state_jsonObject       = json.loads(middle_state_response.text)
    middle_temperature_jsonObject = json.loads(middle_temperature_response.text)

    return [main_state_jsonObject, main_state_short_jsonObject, main_current_jsonObject, weather_24h_jsonObject, air_jsonObject, weather_48h_jsonObject, main_max_min_jsonObject, flower_jsonObject, middle_state_jsonObject, middle_temperature_jsonObject]

def cal_weather_24h_time(time):
    timer = int(time)
    print(f'umbrella time: {timer}')
    result = ""
    # Base_time : 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300 (1일 8회)
    if 2030 <= timer < 2400:
        result = "2300"
    elif 1730 <= timer < 2030:
        result = "2000"
    elif 1430 <= timer < 1730:
        result = "1700"
    elif 1130 <= timer < 1430:
        result = "1400"
    elif 830 <= timer < 1130:
        result = "1100"
    elif 530 <= timer < 830:
        result = "0800"
    elif 230 <= timer < 530:
        result = "0500"
    elif 0 <= timer < 230:
        result = "2300"
    else:
        result = "0200"

    print(result)
    return result

