from apis.models import *
import os
import django
import csv
import sys
import json
import requests
import pymysql
from pathlib import Path
import environ

CSV_PATH = './kloudy/csv/Locations.csv'

def csv_reader():    
    with open(CSV_PATH, newline='', encoding='utf8') as csvfile:
        data_reader = csv.DictReader(csvfile)
        for row in data_reader:
            if not Locations.objects.filter(code=row['code']).exists():
                Locations.objects.create(
                    code = row['code'],
                    daily_status_code = row['daily_status_code'],
                    daily_temperature_code = row['daily_temperature_code'],
                    engProvince = row['engProvince'],
                    province = row['province'],
                    engCity = row['engCity'],
                    city = row['city'],
                    airCoditionMeasuring = row['airCoditionMeasuring'],
                    xCoordination = row['xCoordination'],
                    yCoordination = row['yCoordination'],
                    longitude = row['longitude'],
                    latitude = row['latitude']
                    )

    print('LOCATION DATA UPLOADED SUCCESSFULY!')

    # Main에 아무것도 없으면 DB 처음 킨 것임으로 일단 한번 실행함.
    if Main.objects.count() == 0:
        time_interval_weather()

    return

# 30분 혹은 00분 마다 DB에 저장.
def time_interval_weather():
    print("HI. It's Update Time")
    
    BASE_DIR = Path(__file__).resolve().parent.parent
    env = environ.Env(DEBUG=(bool, True))
    environ.Env.read_env(env_file=os.path.join(BASE_DIR, '.env'))
    pymysql.install_as_MySQLdb()
    key = env('METEOROGICAL_KEY')
    headers = {'Content-Type': 'application/json', 'charset': 'UTF-8', 'Accept': '*/*'}
    
    today, time = calculate_time()
    # Location은 이미 만들어졌음
    locations = Locations.objects.all()

    for location in locations:
        print(location)
         # Local_Weather 없으면 만들고 아니면 찾아서 같이 보내줌.
        if LocalWeather.objects.filter(local_code = location.code):
            local_weather = LocalWeather.objects.filter(local_code = location.code).first()
            generateDB(headers, key, local_weather, today, time, location)
        else:
            # TODO: Weather도 만들어줘야함.
            weather = Weather.objects.create(today = today)
            weather.save()
            local_weather = LocalWeather.objects.create(weather = weather, local_code = location.code, local_name = location.city)
            local_weather.save()
            generateDB(headers, key, local_weather, today, time, location)

    return


def generateDB(headers, key, local_weather, today, time, location):

    # 현재 지역과 시간을 중심으로 DB를 생성한다.
    # main 생성
    getMainWeather(headers, key, local_weather, location.code, today, time, location.xCoordination, location.yCoordination)
    
    # 현재 지역에 관한 WeatherIndex가 갖고 있으면 갖고 있음 => 아래에 갱신 싹 새로해서 넣어줄 예정.
    if WeatherIndex.objects.filter(code = location.code):
        weather_index = WeatherIndex.objects.filter(local_code = location.code).first()
    else:
        weather_index = WeatherIndex.objects.create(local_weather = local_weather, code = location.code)
        weather_index.save()

    # 우산 지수는 하루에 8번 제공됨
    umbrella_time = ["0200", "0500", "0800", "1100", "1400", "1700", "2000", "2300"]
    if time in umbrella_time:
        if UmbrellaIndex.objects.filter(code = location.code):
            umbrella_index = UmbrellaIndex.objects.filter(local_code = location.code).first()
            new_umbrella_index_info = getUmbrellaIndex(headers, key, day, time, location.xCoordination, location.yCoordination)
            
            umbrella_index.status = new_umbrella_index_info[0]
            umbrella_index.precipitaion_24h = new_umbrella_index_info[1]
            umbrella_index.precipitaion_1h_max = new_umbrella_index_info[2]
            umbrella_index.precipitation_3h_max = new_umbrella_index_info[3]
            umbrella_index.wind = new_umbrella_index_info[4]

            umbrealla_index.save()

        else:
            new_umbrella_index_info = getUmbrellaIndex(headers, key, day, time, location.xCoordination, location.yCoordination)
            umbrella_index = UmbrellaIndex.objects.create(weather_index = weather_index, code = location.code, status = new_umbrella_index_info[0], precipitaion_24h = new_umbrella_index_info[1], precipitaion_1h_max = new_umbrella_index_info[2], precipitation_3h_max = new_umbrella_index_info[3], wind = new_umbrella_index_info[4])
            
            umbrella_index.save()

    else:
        # 갱신할 시간이 아니고 처음이 아니라면 그냥 갖고 있음 (갱신이 일어나지 않음)
        if UmbrellaIndex.objects.filter(code = location.code):
            umbrella_index = UmbrellaIndex.objects.filter(local_code = location.code).first()
        else:
            umbrella_time = calUmbreallaTime(time)
            new_umbrella_index_info = getUmbrellaIndex(headers, key, day, umbrella_time, location.xCoordination, location.yCoordination)
            umbrella_index = UmbrellaIndex.objects.create(weather_index = weather_index, code = location.code, status = new_umbrella_index_info[0], precipitaion_24h = new_umbrella_index_info[1], precipitaion_1h_max = new_umbrella_index_info[2], precipitation_3h_max = new_umbrella_index_info[3], wind = new_umbrella_index_info[4])
            
            umbrella_index.save()

    # TODO: mask_index 생성

    # TODO: outer_index 생성

    # TODO: laundry_index 생성

    # TODO: carwash_index 생성

    # TODO: compare_index 생성

    # TODO: 다 담아서 저장하기

    # TODO: weekly_index 생성
    # > 날씨를 기반으로 날짜까지 같이 넣어준다. 나중에 사용할 때는 filter를 코드로 먼저 받고 이 쿼리셋을 돌리면서 날짜별로 넣어주면 됨.

    # TODO: hourly_index 생성
    # > 위클리와 마찬가지임

    return


# TODO: 요청 보낼 시간을 계산해서 내보냄 -> Xcode 참고할 것
def calculate_time():
    today = "20221110"
    time = "1130"

    return [today, time]

def getMainWeather(headers, key, local_weather, code, today, time, xCoordination, yCoordination):
    current_weather = getCurrentWeather(headers, key, today, time, xCoordination, yCoordination)
    current_temperature = getCurrentTemperature(headers, key, today, time, xCoordination, yCoordination)
    (day_max_temperature, day_min_temperature) = getMaxMinTemperature(headers, key, today, time, xCoordination, yCoordination)
    
    # TODO: time의 마지막이 00이면 Main00, 아니면 Main30 -> 현재는 Main만 있음.
    nowMain = Main

    if nowMain.objects.filter(code = code):
        main = nowMain.objects.filter(local_code = location.code)
        main.current_weather = current_weather
        main.current_temperature = current_temperature
        main.day_max_temperature = day_max_temperature
        main.day_min_temperature = day_min_temperature
        main.save()

    # code로 된 main이 없다면 만들어줌
    else:
        main = nowMain.objects.create(local_weather = local_weather, code = code, current_weather = current_weather, current_temperature = current_temperature, day_max_temperature = day_max_temperature, day_min_temperature = day_min_temperature)
        main.save()

    return

def getCurrentWeather(headers, key, today, time, xCoordination, yCoordination):
    url = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?serviceKey={key}&numOfRows=19&pageNo=1&dataType=JSON&base_date={today}&base_time={time}&nx={xCoordination}&ny={yCoordination}'
    response = requests.get(url, headers=headers)
    jsonObject = json.loads(response.text)
    # 만약 currentWeather 3 or 4라면 다른 요청을 보내야함 맑으면 보낼 필요 없음
    nowStatus = jsonObject.get('response').get('body').get('items').get('item')[0].get('fcstValue')
    if nowStatus == "0":
        return 0
    else:
        rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey={key}&numOfRows=1&pageNo=1&dataType=JSON&base_date={today}&base_time={time}&nx={xCoordination}&ny={yCoordination}'
        response = requests.get(rainURL, headers=headers)
        jsonObject = json.loads(response.text)
        nowRain = jsonObject.get('response').get('body').get('items').get('item')[0].get('obsrValue')
        if nowRain == "0":
            return int(nowStatus)
        # 3번은 nowStatus랑 겹칠 수 있음
        else:
            return "5" if nowRain == 3 else int(nowRain)
    
    return

def getCurrentTemperature(headers, key, day, time, xCoordination, yCoordination):
    rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey={key}&numOfRows=4&pageNo=1&dataType=JSON&base_date={day}&base_time={time}&nx={xCoordination}&ny={yCoordination}'
    response = requests.get(rainURL, headers=headers)
    jsonObject = json.loads(response.text)
    
    for obj in jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'T1H':
            currentTemperature = obj.get('obsrValue')

    return float(currentTemperature)

def getMaxMinTemperature(headers, key, day, time, xCoordination, yCoordination):
    # 오늘의 MaxMin은 전날 2300시
    rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey={key}&numOfRows=290&pageNo=1&dataType=JSON&base_date={int(day)-1}&base_time=2300&nx={xCoordination}&ny={yCoordination}'
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

# TODO : 정보를 내뱉어줄 것
def getUmbrellaIndex(headers, key, day, time, xCoordination, yCoordination):
    
    # T현재 시간을 기준으로 시간 최신 시간 계산.
    umbrella_time = calUmbreallaTime(time)
    rainURL = f'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey={key}&numOfRows=290&pageNo=1&dataType=JSON&base_date={day}&base_time={umbrella_time}&nx={xCoordinate}&ny={yCoordination}'
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
    status = (P + (PMAX1 * 1.2) + (PMAX3 * 1.1)) / 3 + (P * (V/4))

    return (status, )

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