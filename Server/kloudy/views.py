from apis.models import *
import os
import django
import csv
import sys
import json
import requests
import pymysql
import datetime
from pathlib import Path
import environ
from .networkAPI import *

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

    # Weather에 아무것도 없으면 DB 처음 킨 것임으로 일단 한번 실행함.
    if WeatherEven.objects.count() == 0:
        time_interval_weather()

    return

# 30분 혹은 00분 마다 DB에 저장.
def time_interval_weather():
    print("HI. It's Update Time")
    
    # 모든 지역을 갱신 혹은 만듬
    locations = Locations.objects.all()
    print(locations)
    for location in locations:
        today, time = calculate_time()
        if time == "2330":
            today = str(int(today) - 1)

        weather_infos = getDatas(today, time, location)
        
        main_state_jsonObject         = weather_infos[0]
        main_state_short_jsonObject   = weather_infos[1]
        main_current_jsonObject       = weather_infos[2]
        weather_24h_jsonObject        = weather_infos[3]
        air_jsonObject                = weather_infos[4]
        weather_48h_jsonObject        = weather_infos[5]
        main_max_min_jsonObject       = weather_infos[6]
        flower_jsonObject             = weather_infos[7]
        middle_state_jsonObject       = weather_infos[8]
        middle_temperature_jsonObject = weather_infos[9]
        # 처음이 아니면 업데이트해줌.
        if LocalWeatherOdd.objects.filter(local_code = location.code):
            print("업데이트해줌 !!!!!!")
            time = int(datetime.datetime.now().strftime("%H"))

            # 메인 지수
            main_info = get_main_weather(main_state_jsonObject, main_state_short_jsonObject, main_current_jsonObject, main_max_min_jsonObject)
            if main_info != [0, 0, 0, 0]:
                if time % 2 != 0:
                    main = MainEven.objects.filter(code = location.code).first()
                else:
                    main = MainOdd.objects.filter(code = location.code).first()
                current_weather, current_temperature, day_max_temperature, day_min_temperature = main_info
                # 갱신
                main.current_weather     = current_weather
                main.current_temperature = current_temperature
                main.day_max_temperature = day_max_temperature
                main.day_min_temperature = day_min_temperature
                main.save()

            if time % 2 != 0:
                weather_index = WeatherIndexEven.objects.filter(code = location.code).first()
            else:
                weather_index = WeatherIndexOdd.objects.filter(code = location.code).first()
            
            # 우산지수
            umbrella_info = get_umbrella_index(weather_24h_jsonObject)
            if umbrella_info != [0, 0, 0, 0, 0]:
                if time % 2 != 0:
                    umbrella_index = UmbrellaIndexEven.objects.filter(code = location.code).first()
                else:
                    umbrella_index = UmbrellaIndexOdd.objects.filter(code = location.code).first()
                    
                umbrella_status, precipitation_24h, precipitation_1h_max, precipitation_3h_max, wind = umbrella_info
                # 갱신
                umbrella_index.status               = umbrella_status
                umbrella_index.precipitation_24h     = precipitation_24h
                umbrella_index.precipitation_1h_max  = precipitation_1h_max
                umbrella_index.precipitation_3h_max = precipitation_3h_max
                umbrella_index.wind                 = wind
                umbrella_index.save()

                save_umbrella_hourly(umbrella_index, rains, location.code)
                
            # 마스크 지수
            mask_info = get_mask_index(air_jsonObject, flower_jsonObject)
            if mask_info != [0, 0, 0, 0]:
                if time % 2 != 0:
                    mask_index = MaskIndexEven.objects.filter(code = location.code).first()
                else:
                    mask_index = MaskIndexOdd.objects.filter(code = location.code).first()
                mask_status, pm25value, pm10value, pollen_index = mask_info
                # mask_index 갱신
                mask_index.status  = mask_status
                mask_index.pm25value    = pm25value
                mask_index.pm10value    = pm10value
                mask_index.pollen_index = pollen_index
                mask_index.save()
            
            #  아우터 지수
            outer_info = get_outer_index(weather_24h_jsonObject)
            if outer_info != [0, 0, 0]:
                if time % 2 != 0:
                    outer_index = OuterIndexEven.objects.filter(code = location.code).first()
                else:
                    outer_index = OuterIndexOdd.objects.filter(code = location.code).first()
                outer_status, day_min_temperature, morning_temperature = outer_info
                # outer_index 갱신
                outer_index.status              = outer_status
                outer_index.day_min_temperature = day_min_temperature
                outer_index.morning_temperature = morning_temperature
                outer_index.save()

            # 빨래 지수
            laundry_info = get_laundry_index(weather_24h_jsonObject)
            if laundry_info != [0, 0, 0, 0]:
                if time % 2 != 0:
                    laundry_index = LaundryIndexEven.objects.filter(code = location.code).first()
                else:
                    laundry_index = LaundryIndexOdd.objects.filter(code = location.code).first()
                laundry_status, humidity, day_max_temperature, daily_weather = laundry_info
                # laundry_index 갱신
                laundry_index.status              = laundry_status
                laundry_index.humidity            = humidity
                laundry_index.day_max_temperature = day_max_temperature
                laundry_index.daily_weather       = daily_weather
                laundry_index.save()

            # 세차 지수
            carwash_info = get_carwash_index(weather_48h_jsonObject, middle_state_jsonObject, air_jsonObject, flower_jsonObject, today)
            if carwash_info != [0, 0, 0, 0, 0, 0, "", 0, 0]:
                if time % 2 != 0:
                    carwash_index = CarwashIndexEven.objects.filter(code = location.code).first()
                else:
                    carwash_index = CarwashIndexOdd.objects.filter(code = location.code).first()
                carwash_status, daily_weather, day_min_temperature, daily_precipitation, tomorrow_weather, tomorrow_precipitation, weather_3Am7pm, pm10grade, pollen_index = carwash_info
                # carwash_index 갱신
                carwash_index.status                 = carwash_status
                carwash_index.daily_weather          = daily_weather
                carwash_index.day_max_temperature    = day_max_temperature
                carwash_index.daily_precipitation    = daily_precipitation
                carwash_index.tomorrow_weather       = tomorrow_weather
                carwash_index.tomorrow_precipitation = tomorrow_precipitation
                carwash_index.weather_3Am7pm         = weather_3Am7pm
                carwash_index.pm10grade              = pm10grade
                carwash_index.pollen_index           = pollen_index
                carwash_index.save()

            # 날씨 비교
            compare_info = get_compare_index(weather_24h_jsonObject, today, False, location.code)
            if compare_info != ["", 0, 0, "", 0, 0]:
                if time % 2 != 0:
                    compare_index = CompareIndexEven.objects.filter(code = location.code).first()
                else:
                    compare_index = CompareIndexOdd.objects.filter(code = location.code).first()
                weather_yesterday, yesterday_max_temperature, yesterday_min_temperature, weather_today, today_max_temperature, today_min_temperature = compare_info
                # compare_index 갱신
                compare_index.yesterday                 = weather_yesterday
                compare_index.yesterday_max_temperature = yesterday_max_temperature
                compare_index.yesterday_min_temperature = yesterday_min_temperature
                compare_index.today                     = weather_today
                compare_index.today_max_temperature     = today_max_temperature
                compare_index.today_min_temperature     = today_min_temperature
                compare_index.save()

            weather_odd = WeatherOdd.objects.filter(code = location.code).first()
            weather_even = WeatherEven.objects.filter(code = location.code).first()
            
            local_weather_odd = LocalWeatherOdd.objects.filter(weather = weather_odd).first()
            local_weather_even = LocalWeatherEven.objects.filter(weather = weather_even).first()

            hour_weather_infos = get_hour_weather(weather_24h_jsonObject, location.code, time)
            if hour_weather_infos != [[0] * 4 for _ in range(24)]:
                save_hour_weather(hour_weather_infos, location.code, local_weather_odd, local_weather_even)

            weekly_weather_infos = get_weekly_weather(weather_48h_jsonObject, middle_state_jsonObject, middle_temperature_jsonObject, today)
            if weekly_weather_infos != [[0] * 4 for _ in range(10)]:
                save_weekly_weather(weekly_weather_infos, location.code, local_weather_odd, local_weather_even)

        # 처음이면 새로 만든다.
        else:
            print("새로 만듦 !!!!")
            weather_odd = WeatherOdd.objects.create(today = today, code = location.code)
            weather_even = WeatherEven.objects.create(today = today, code = location.code)
            weather_odd.save()
            weather_even.save()

            local_weather_odd = LocalWeatherOdd.objects.create(weather = weather_odd, local_code = location.code, local_name = location.city)
            local_weather_even = LocalWeatherEven.objects.create(weather = weather_even, local_code = location.code, local_name = location.city)
            local_weather_odd.save()
            local_weather_even.save()

            main_info = get_main_weather(main_state_jsonObject, main_state_short_jsonObject, main_current_jsonObject, main_max_min_jsonObject)
            current_weather, current_temperature, day_max_temperature, day_min_temperature = main_info
            print(f'메인 지수: {current_weather}, {current_temperature}, {day_max_temperature}, {day_min_temperature}')
            main_odd = MainOdd.objects.create(local_weather = local_weather_odd, code = location.code, current_weather = current_weather, current_temperature = current_temperature, day_max_temperature = day_max_temperature, day_min_temperature = day_min_temperature)
            main_even = MainEven.objects.create(local_weather = local_weather_even, code = location.code, current_weather = current_weather, current_temperature = current_temperature, day_max_temperature = day_max_temperature, day_min_temperature = day_min_temperature)
            main_odd.save()
            main_even.save()

            weather_index_odd = WeatherIndexOdd.objects.create(local_weather = local_weather_odd, code = location.code)
            weather_index_even = WeatherIndexEven.objects.create(local_weather = local_weather_even, code = location.code)
            weather_index_odd.save()
            weather_index_even.save()

            umbrella_info = get_umbrella_index(weather_24h_jsonObject)
            umbrella_status, precipitation_24h, precipitation_1h_max, precipitation_3h_max, wind, rains = umbrella_info
            print(f'우산 지수: {umbrella_status}, {precipitation_24h}, {precipitation_1h_max}, {precipitation_3h_max}, {wind}')
            umbrella_index_odd = UmbrellaIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status = umbrella_status, precipitation_24h = precipitation_24h, precipitation_1h_max = precipitation_1h_max, precipitation_3h_max = precipitation_3h_max, wind = wind)
            umbrella_index_even = UmbrellaIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status = umbrella_status, precipitation_24h = precipitation_24h, precipitation_1h_max = precipitation_1h_max, precipitation_3h_max = precipitation_3h_max, wind = wind)
            umbrella_index_odd.save()
            umbrella_index_even.save()
            save_umbrella_hourly(umbrella_index_odd, rains, location.code)

            mask_info = get_mask_index(air_jsonObject, flower_jsonObject)
            mask_status, pm25value, pm10value, pollen_index = mask_info
            print(f'마스크 지수: {mask_status}, {pm25value}, {pm10value}, {pollen_index}')
            mask_index_odd = MaskIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status = mask_status, pm25value = pm25value, pm10value = pm10value, pollen_index = pollen_index)
            mask_index_even = MaskIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status = mask_status, pm25value = pm25value, pm10value = pm10value, pollen_index = pollen_index)
            mask_index_odd.save()
            mask_index_even.save()

            outer_info = get_outer_index(weather_24h_jsonObject)
            outer_status, day_min_temperature, morning_temperature = outer_info
            print(f"아우터 지수: {outer_status}, {day_min_temperature}, {morning_temperature}")
            outer_index_odd = OuterIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status= outer_status, day_min_temperature = day_min_temperature, morning_temperature = morning_temperature)
            outer_index_even = OuterIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status= outer_status, day_min_temperature = day_min_temperature, morning_temperature = morning_temperature)
            outer_index_odd.save()
            outer_index_even.save()

            laundry_info = get_laundry_index(weather_24h_jsonObject)
            laundry_status, humidity, day_max_temperature, daily_weather = laundry_info
            print(f"빨래 지수 : {laundry_status}, {humidity}, {day_max_temperature}, {daily_weather}")
            laundry_index_odd = LaundryIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status = laundry_status, humidity = humidity, day_max_temperature = day_max_temperature, daily_weather = daily_weather)
            laundry_index_even = LaundryIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status = laundry_status, humidity = humidity, day_max_temperature = day_max_temperature, daily_weather = daily_weather)
            laundry_index_odd.save()
            laundry_index_even.save()

            carwash_info = get_carwash_index(weather_48h_jsonObject, middle_state_jsonObject, air_jsonObject, flower_jsonObject, today)
            carwash_status, daily_weather, day_max_temperature, daily_precipitation, tomorrow_weather, tomorrow_precipitation, weather_3Am7pm, pm10grade, pollen_index = carwash_info
            print(f"세차 지수: {carwash_status}, {daily_weather}, {day_max_temperature}, {daily_precipitation}, {tomorrow_weather}, {tomorrow_precipitation}, {weather_3Am7pm}, {pm10grade}, {pollen_index}")
            carwash_index_odd = CarwashIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status = carwash_status, daily_weather = daily_weather, day_max_temperature = day_max_temperature, daily_precipitation = daily_precipitation, tomorrow_weather = tomorrow_weather, tomorrow_precipitation = tomorrow_precipitation, weather_3Am7pm = weather_3Am7pm, pm10grade = pm10grade, pollen_index = pollen_index)
            carwash_index_even = CarwashIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status = carwash_status, daily_weather = daily_weather, day_max_temperature = day_max_temperature, daily_precipitation = daily_precipitation, tomorrow_weather = tomorrow_weather, tomorrow_precipitation = tomorrow_precipitation, weather_3Am7pm = weather_3Am7pm, pm10grade = pm10grade, pollen_index = pollen_index)
            carwash_index_odd.save()
            carwash_index_even.save()

            compare_info = get_compare_index(weather_24h_jsonObject, today, True, location.code)
            weather_yesterday, yesterday_max_temperature, yesterday_min_temperature, weather_today, today_max_temperature, today_min_temperature = compare_info
            print(f"날씨 비교: {weather_yesterday}, {yesterday_max_temperature}, {yesterday_min_temperature}, {weather_today}, {today_max_temperature}, {today_min_temperature}")
            compare_index_odd = CompareIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, yesterday = weather_yesterday, yesterday_max_temperature = yesterday_max_temperature, yesterday_min_temperature = yesterday_min_temperature, today = weather_today, today_max_temperature = today_max_temperature, today_min_temperature = today_min_temperature)
            compare_index_even = CompareIndexEven.objects.create(weather_index = weather_index_even, code = location.code, yesterday = weather_yesterday, yesterday_max_temperature = yesterday_max_temperature, yesterday_min_temperature = yesterday_min_temperature, today = weather_today, today_max_temperature = today_max_temperature, today_min_temperature = today_min_temperature)
            compare_index_odd.save()
            compare_index_even.save()

            hour_weather_infos = get_hour_weather(weather_24h_jsonObject, location.code, time)
            save_hour_weather(hour_weather_infos, location.code, local_weather_odd, local_weather_even)

            weekly_weather_infos = get_weekly_weather(weather_48h_jsonObject, middle_state_jsonObject, middle_temperature_jsonObject, today)
            save_weekly_weather(weekly_weather_infos, location.code, local_weather_odd, local_weather_even)

def calculate_time():
    now = datetime.datetime.now()
    print(now)
    today = now.strftime("%Y%m%d")
    print(f"날짜 : {today}")
    time = cal_time([now.strftime("%H"), now.strftime("%M")])
    
    return [today, time]

def get_main_weather(main_state_jsonObject, main_state_short_jsonObject, main_current_jsonObject, main_max_min_jsonObject):
    if main_state_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]
    elif main_state_short_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]
    elif main_current_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]
    elif main_max_min_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]
    else:
        main_status = cal_main_status(main_state_jsonObject, main_state_short_jsonObject)
        main_current_temerature = cal_current_temperature(main_current_jsonObject)
        main_max_temperature, main_min_temperature = cal_min_max_temperature(main_max_min_jsonObject)

    return [main_status, main_current_temerature, main_max_temperature, main_min_temperature]

def cal_main_status(main_state_jsonObject, main_state_short_jsonObject):
    nowStatus = main_state_jsonObject.get('response').get('body').get('items').get('item')[0].get('fcstValue')
    if nowStatus == "0":
        return 0
    else:
        nowRain = main_state_short_jsonObject.get('response').get('body').get('items').get('item')[0].get('obsrValue')
        if nowRain == "0":
            return int(nowStatus)
        # 3번은 nowStatus랑 겹칠 수 있음
        else:
            return "5" if nowRain == 3 else int(nowRain)

def cal_current_temperature(main_current_jsonObject):
    for obj in main_current_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'T1H':
            currentTemperature = obj.get('obsrValue')

    return float(currentTemperature)

def cal_min_max_temperature(main_max_min_jsonObject):
    for obj in main_max_min_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'TMX':
            max_temperature = obj.get('fcstValue')

        if obj.get('category') == 'TMN':
            min_temperature = obj.get('fcstValue')

    return (float(max_temperature), float(min_temperature))


def get_umbrella_index(weather_24h_jsonObject):
    temp_rains = [0.0] * 24
    if weather_24h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0, 0, temp_rains]

    rains = []
    winds = []
    for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'PCP':
            if obj.get('fcstValue') == '강수없음':
                rains.append(0)
            else:
                rains.append(float(obj.get('fcstValue').replace('mm', '')))
        if obj.get('category') == 'WSD':
            winds.append(float(obj.get('fcstValue')))

    P = sum(rains) / 24
    PMAX1 = max(rains)
    PMAX3 = 0
    for i in range(22):
        temp = 0
        for j in range(3):
            temp += rains[i+j]

        temp = temp / 3
        if temp > PMAX3:
            PMAX3 = temp
    V = sum(winds) / 24
    
    umbrella_index = (P + (PMAX1 * 1.2) + (PMAX3 * 1.1)) / 3 + (P * (V/4))
    
    status = cal_umbrella_status(umbrella_index)
    precipitation_24h = P
    precipitation_1h_max = PMAX1
    precipitation_3h_max = PMAX3
    wind = V

    return [status, precipitation_24h, precipitation_1h_max, precipitation_3h_max, wind, rains]

def save_umbrella_hourly(umbrella_index, rains, code):
    print("Save Umbrella Hourly")
    time = int(datetime.datetime.now().strftime("%H"))
    # 지금 처음이 아니면
    if UmbrellaHourlyEven.objects.filter(code = code):
        if time % 2 != 0:
            umbrella_hourly_queries = UmbrellaHourlyEven.objects.filter(code = code).all()
        else:
            umbrella_hourly_queries = UmbrellaHourlyOdd.objects.filter(code = code).all()
        for umbrella_hour_query in umbrella_hourly_queries:
            try:
                now_time = umbrella_hour_query.time
                umbrella_hour_query.precipitation = rains[now_time]
                umbrella_hour_query.save()
            except:
                return

    else:
        umbrella_index_odd = UmbrellaIndexOdd.objects.filter(code = code).first()
        umbrella_index_even = UmbrellaIndexEven.objects.filter(code = code).first()
        for i in range(len(rains)):
            umbrella_hourly_odd = UmbrellaHourlyOdd.objects.create(umbrella_index = umbrella_index_odd, code = code, time = i, precipitation = rains[i])
            umbrella_hourly_even = UmbrellaHourlyEven.objects.create(umbrella_index = umbrella_index_even, code = code, time = i, precipitation = rains[i])
            umbrella_hourly_odd.save()
            umbrella_hourly_even.save()


# 30~ : 경보 특보 급(4) / ~30 : 많이(3) / ~15 : 적당히(2) / ~3 : 조금(1) / 0 : 안 써도 된다.(0)
def cal_umbrella_status(umbrella_index):
    result = 0

    if umbrella_index == 0:
        result = 0
    elif 1 <= umbrella_index < 3:
        result = 1
    elif 3 <= umbrella_index < 15:
        result = 2
    elif 15 <= umbrella_index < 30:
        result = 3
    elif 30 <= umbrella_index:
        result = 4

    return result

def get_mask_index(air_jsonObject, flower_jsonObject):
    if air_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]
    if flower_jsonObject.get('response').get('header').get('resultCode') != "00" and flower_jsonObject.get('response').get('header').get('resultCode') != "99" :
        return [0, 0, 0, 0]

    pm25_str = air_jsonObject.get('response').get('body').get('items')[0].get('pm25Value')
    if pm25_str != "-":
        pm25 = float(pm25_str)
    else:
        pm25 = 0

    pm10_str = air_jsonObject.get('response').get('body').get('items')[0].get('pm10Value')
    if pm10_str != "-":
        pm10 = float(pm10_str)
    else:
        pm10 = 0

    flower_quality = 0
    if flower_jsonObject.get('response').get('header').get('resultCode') == '0':
        flower_quality = int(flower_jsonObject.get('response').get('body').get('items').get('item').get('today'))

    status = cal_mask_status(pm25)
    pm25value = pm25
    pm10value = pm10
    pollen_index = flower_quality

    return [status, pm25value, pm10value, pollen_index]

# 0~15 : 좋음 0 / 16~35 : 보통 1 / 36~75 : 나쁨 2 / 76 : 매우나쁨 3
def cal_mask_status(pm25):
    result = 0

    if 0 <= pm25 < 16:
        result = 0
    elif 16 <= pm25 < 36:
        result = 1
    elif 36 <= pm25 < 76:
        result = 3
    elif 76 <= pm25:
        result = 4

    return result

# 일일 최저, 06시, 07시, 08시, 09시의 온도를 더해서 5로 나누어줌.
def get_outer_index(weather_24h_jsonObject):
    if weather_24h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0]

     # 0: 06시, 1: 07시, 2: 08시, 3: 09시
    temperatures = [0.0] * 4
    min_temperature = 0.0

    for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'TMN':
            min_temperature = float(obj.get('fcstValue'))
        elif obj.get('category') == 'TMP':
            if obj.get('fcstTime') == '0600':
                temperatures[0] = float(obj.get('fcstValue'))
            elif obj.get('fcstTime') == '0700':
                temperatures[1] = float(obj.get('fcstValue'))
            elif obj.get('fcstTime') == '0800':
                temperatures[2] = float(obj.get('fcstValue'))
            elif obj.get('fcstTime') == '0900':
                temperatures[3] = float(obj.get('fcstValue'))
    
    outer_index = (sum(temperatures) + min_temperature) / 5

    status = cal_outer_status(outer_index)
    day_min_temperature = min_temperature
    morning_temperature = sum(temperatures) / 4

    return [status, day_min_temperature, morning_temperature]

def cal_outer_status(outer_index):
    result = 0
    # 12~16도 : 캐주얼 재킷, 가디건 1 | 9~11도 : 라이더 재킷, 트렌치 코트 2| 5~8도 : 코트, 무스탕, 항공 점퍼 3 | 4도 이하 : 패딩, 두꺼운 코트 4| -5도 이하 : 중무장(목도리, 장갑 등) 5
    if 16 <= outer_index:
        result = 0
    elif 12 <= outer_index < 16:
        result = 1
    elif 9 <= outer_index < 12:
        result = 2
    elif 5 <= outer_index < 9:
        result = 3
    elif -5 <= outer_index < 5:
        result = 4
    elif outer_index < -5:
        result = 5

    return result

def get_laundry_index(weather_24h_jsonObject):
    if weather_24h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]

    max_temperature = 0.0
    humidities = []
    rainy = 0 
    sky_status = [0, 0] # 0: 흐림, 구름많음, 1: 맑음

    for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'TMX':
            max_temperature = float(obj.get('fcstValue'))
        elif obj.get('category') == 'REH':
            humidities.append(float(obj.get('fcstValue')))
        
        elif obj.get('category') == 'PTY':
            if obj.get('fcstValue') == "1":
                rainy += 1
        elif obj.get('category') == 'SKY':
            if obj.get('fcstValue') == "3" or obj.get('fcstValue') == "4":
                sky_status[0] += 1
            elif obj.get('fcstValue') == "1":
                sky_status[1] += 1
    
    humidity = cal_humidity(humidities)
    day_max_temperature = max_temperature
    daily_weather = cal_daily_weather(rainy, sky_status[0], sky_status[1])

    status = cal_laundry_status(humidity, day_max_temperature, daily_weather)

    return [status, humidity, day_max_temperature, daily_weather]

def cal_humidity(humidities):
    avg_humidity = 100 - (sum(humidities) / len(humidities))
    # 가중치 <= 60 : 0 | 61 <= x < 71 : 0.9 | 71 <= x < 81 : 0.8 | 81 <= x : 0.6
    result = 0.0
    if avg_humidity <= 60:
        result = avg_humidity
    elif 61 <= avg_humidity < 71:
        result = avg_humidity * 0.9
    elif 71 <= avg_humidity < 81:
        result = avg_humidity * 0.8
    elif 81 <= avg_humidity:
        result = avg_humidity * 0.6

    return result

def cal_daily_weather(rainy, cloudy, sunny):
    result = 0

    if rainy >= 3:
        result = -15

    elif rainy >= 1:
        result = -10

    else:
        if cloudy > sunny:
            result = 0
        else:
            result = 10

    return result

def cal_laundry_status(humidity, day_max_temperature, daily_weather):

    laundry_index = humidity + (day_max_temperature - 15) + (daily_weather + 10)
    result = 0
    # 빨래하기 좋은 날 WI 55 이상 0 | 빨래하기 적당한 날 WI 41~55 1 | 실내 건조 하세요 WI 31~40 2 | 하지 않는 것을 추천해요 WI 30 이하, 일 최고기온 -2도 이하 3
    if 55 <= laundry_index:
        result = 0
    elif 41 <= laundry_index < 55:
        result = 1
    elif 31 <= laundry_index < 41:
        result = 2
    elif laundry_index < 31 or day_max_temperature < -2:
        result = 3
        
    return result

def get_carwash_index(weather_48h_jsonObject, middle_state_jsonObject, air_jsonObject, flower_jsonObject, today):
    if weather_48h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0, 0, 0, "", 0, 0]
    if middle_state_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0, 0, 0, "", 0, 0]
    if air_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0, 0, 0, "", 0, 0]
    if flower_jsonObject.get('response').get('header').get('resultCode') != "00" and flower_jsonObject.get('response').get('header').get('resultCode') != "99":
        return [0, 0, 0, 0, 0, 0, "", 0, 0]

    # 오늘 날씨 => 0: "맑음", 1: "비", 2: "비/눈, 3: "구름 많음", 4: "흐림", 5: "눈"
    day_max_temperature = 0.0
    daily_weathers = []
    daily_precipitations = []
    # 내일 날씨 => 0: "맑음", 1: "비", 2: "비/눈, 3: "구름 많음", 4: "흐림", 5: "눈"
    tomorrow_weathers = []
    tomorrow_precipitations = []
    for obj in weather_48h_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'TMX' and obj.get('fcstDate') == today:
            day_max_temperature = float(obj.get('fcstValue'))
        # 오늘 날씨 상태
        elif obj.get('category') == 'SKY' and obj.get('fcstDate') == today:
            if obj.get('fcstValue') == "1":
                daily_weathers.append(0)
            else:
                daily_weathers.append(int(obj.get('fcstValue')))
        # 내일 날씨 상태
        elif obj.get('category') == 'SKY' and obj.get('fcstDate') == f'{int(today) + 1}':
            if obj.get('fcstValue') == "1":
                tomorrow_weathers.append(0)
            else:
                tomorrow_weathers.append(int(obj.get('fcstValue')))
        # 오늘 강수량
        elif obj.get('category') == 'PCP' and obj.get('fcstDate') == today:
            if obj.get('fcstValue') == "강수없음":
                daily_precipitations.append(0.0)
            else:
                daily_precipitations.append(float(obj.get('fcstValue').replace('mm', '')))
        # 내일 강수량
        elif obj.get('category') == 'PCP' and obj.get('fcstDate') == f'{int(today) + 1}':
            if obj.get('fcstValue') == "강수없음":
                daily_precipitations.append(0.0)
            else:
                tomorrow_precipitations.append(float(obj.get('fcstValue').replace('mm', '')))
        # 오늘 강수 상태
        elif obj.get('category') == 'PTY' and obj.get('fcstDate') == today:
            if obj.get('fcstValue') == "0":
                continue
            elif obj.get('fcstValue') == "3":
                daily_weathers.append(5)
            else:
                daily_weathers.append(int(obj.get('fcstValue')))
        # 내일 강수 상태
        elif obj.get('category') == 'PTY' and obj.get('fcstDate') == f'{int(today) + 1}':
            if obj.get('fcstValue') == "0":
                continue
            elif obj.get('fcstValue') == "3":
                tomorrow_weathers.append(5)
            else:
                tomorrow_weathers.append(int(obj.get('fcstValue')))
    
    daily_weather = max(daily_weathers)
    tomorrow_weather = max(tomorrow_weathers)

    when_is_rainy = 9
    if daily_weather == 1 or daily_weather == 2 or daily_weather == 5:
        when_is_rainy = 1
    elif tomorrow_weather == 1 or tomorrow_weather == 2 or tomorrow_weather == 5:
        when_is_rainy = 2

    # 가장 가까운 비오는 날을 찾는다.
    rainy_cases = ["구름많고 비", "구름많고 눈", "구름많고 비/눈", "구름많고 소나기", "흐리고 비", "흐리고 눈", "흐리고 비/눈", "흐리고 소나기"]
    middle_state = middle_state_jsonObject.get('response').get('body').get('items').get('item')[0]
    if middle_state['wf3Am'] in rainy_cases or middle_state['wf3Pm'] in rainy_cases:
        when_is_rainy = min(3, when_is_rainy)
    elif middle_state['wf4Am'] in rainy_cases or middle_state['wf4Pm'] in rainy_cases:
        when_is_rainy = min(4, when_is_rainy)
    elif middle_state['wf5Am'] in rainy_cases or middle_state['wf5Pm'] in rainy_cases:
        when_is_rainy = min(5, when_is_rainy)
    elif middle_state['wf6Am'] in rainy_cases or middle_state['wf6Pm'] in rainy_cases:
        when_is_rainy = min(6, when_is_rainy)
    elif middle_state['wf7Am'] in rainy_cases or middle_state['wf7Pm'] in rainy_cases:
        when_is_rainy = min(7, when_is_rainy)
        
    pm10_str = air_jsonObject.get('response').get('body').get('items')[0].get('pm10Value')
    if pm10_str != "-":
        pm10grade = float(pm10_str)
    else:
        pm10grade = 0
    # 낮음 : 0, 보통 : 1, 높음 : 2, 매우높음 : 3
    flower_qualities = [0, 0, 0, 0] # 0:오늘 | 1:내일 | 2:모레 | 3:글피
    if flower_jsonObject.get('response').get('header').get('resultCode') == '0':
        flower_qualities[0] = int(flower_jsonObject.get('response').get('body').get('items').get('item').get('today'))
        flower_qualities[1] = int(flower_jsonObject.get('response').get('body').get('items').get('item').get('tomorrow'))
        flower_qualities[2] = int(flower_jsonObject.get('response').get('body').get('items').get('item').get('dayaftertomorrow'))
        flower_qualities[3] = int(flower_jsonObject.get('response').get('body').get('items').get('item').get('twodaysaftertomorrow'))

    # 오늘 날씨 상태
    daily_precipitation = 0 if sum(daily_precipitations) == 0 else sum(daily_precipitations) / len(daily_precipitations)
    tomorrow_precipitation = 0 if sum(tomorrow_precipitations) == 0 else sum(tomorrow_precipitations) / len(tomorrow_precipitations)
    weather_3Am7pm = "예보없음" if when_is_rainy == 9 else f"{when_is_rainy}일 후"
    pollen_index = max(flower_qualities)
    # 0 : 세차하기 좋음, 1: 세차 괜찮음, 2: 세차 미루기, 3: 세차 하지마
    status = cal_carwash_status(when_is_rainy, day_max_temperature, pm10grade, pollen_index)

    return [status, daily_weather, day_max_temperature, daily_precipitation, tomorrow_weather, tomorrow_precipitation, weather_3Am7pm, pm10grade, pollen_index]

def cal_carwash_status(when_is_rainy, max_temperature, pm10grade, pollen_index):
    result = 0

    if 150 < pm10grade or pollen_index == 3 or max_temperature <= -2 or when_is_rainy <= 2:
        reulst = 3
        return result
    elif 80 < pm10grade < 151 or pollen_index == 2 or when_is_rainy <= 4:
        result = 2
        return result
    elif when_is_rainy <= 6:
        result = 1
        return result
    
    return result
    
def get_compare_index(weather_24h_jsonObject, day_we_got, isFisrtTime, code):
    if weather_24h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return ["", 0, 0, "", 0, 0]
    # 전전날 날씨는 못받아 오기 때문에 처음 만들 때는 일단 똑같이 보내주고, 
    # 그게 아니면 현재 DB에 저장된 것을 어제로 바꾸고, 현재 날씨를 넣어줘야함.
    # 근데 30분마다 실행되기 때문에 업데이트할 때는 오늘 날짜를 체크해줘야함.
    yesterday                 = ""
    yesterday_max_temperature = 0.0
    yesterday_min_temperature = 0.0
    today                     = ""
    today_max_temperature     = 0.0
    today_min_temperature     = 0.0

    if isFisrtTime:
        yesterday = day_we_got
        today = day_we_got
        # min max 찾아서 어제 오늘 똑같이 내뱉어줌.
        for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):
            if obj.get('category') == 'TMX':
                today_max_temperature = float(obj.get('fcstValue'))
                yesterday_max_temperature = today_max_temperature
            elif obj.get('category') == 'TMN':
                today_min_temperature = float(obj.get('fcstValue'))
                yesterday_min_temperature = today_min_temperature
        
    else:
        time = int(datetime.datetime.now().strftime("%H"))
        if time % 2 != 0:
            compare_index = CompareIndexEven.objects.filter(code = code).first()
        else:
            compare_index = CompareIndexOdd.objects.filter(code = code).first()

        # code로 compare_index 잡아줌.
        # 업데이트 해야하는지 확인 (가져온 compare_index의 today와 현재 today가 같으면 업데이트 안함.)
        if compare_index.today == day_we_got:
            yesterday                 = compare_index.yesterday
            yesterday_max_temperature = compare_index.yesterday_max_temperature
            yesterday_min_temperature = compare_index.yesterday_min_temperature
            today                     = compare_index.today
            today_max_temperature     = compare_index.today_max_temperature
            today_min_temperature     = compare_index.today_min_temperature

        else:
            # 업데이트 해야하면 가져온 compare_index의 today 지수들을 yesterday로 넣어주고
            # 오늘의 min max를 찾아서 today로 넣어줌.
            yesterday = compare_index.today
            today = day_we_got
            for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):
                if obj.get('category') == 'TMX':
                    today_max_temperature = float(obj.get('fcstValue'))
                    yesterday_max_temperature = compare_index.today_max_temperature
                elif obj.get('category') == 'TMN':
                    today_min_temperature = float(obj.get('fcstValue'))
                    yesterday_min_temperature = compare_index.today_min_temperature

    return [yesterday, yesterday_max_temperature, yesterday_min_temperature, today, today_max_temperature, today_min_temperature]

def get_hour_weather(weather_24h_jsonObject, code, time):
    # 시간대별 날씨를 담아둠
    hour_weather_infos = [[0] * 4 for _ in range(24)] # 0 : hour | 1 : status | 2 : temperature | 3 : precipitation
    if weather_24h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return hour_weather_infos
    # 24시간 후의 날씨를 받아올 수 있음
    for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):

        base_time = int(obj.get('baseTime'))
        fcst_time = int(obj.get('fcstTime')) if int(obj.get('fcstTime')) > base_time else int(obj.get('fcstTime')) + 2400
        now_index = ((fcst_time - base_time) // 100) - 1

        hour_weather_infos[now_index][0] = now_index
        if obj.get('category') == 'SKY':
            if obj.get('fcstValue') == "1":
                hour_weather_infos[now_index][1] = 0 
            else:
                hour_weather_infos[now_index][1] = int(obj.get('fcstValue'))
        # 오늘 강수 상태
        elif obj.get('category') == 'PTY':
            if obj.get('fcstValue') == "0":
                continue
            elif obj.get('fcstValue') == "3":
                hour_weather_infos[now_index][1] = 5
            else:
                hour_weather_infos[now_index][1] = int(obj.get('fcstValue'))
        # 이 시간 온도
        elif obj.get('category') == 'TMP':
            hour_weather_infos[now_index][2] = float(obj.get('fcstValue'))
        # 이 시간 강수량
        elif obj.get('category') == 'PCP':
            if obj.get('fcstValue') == "강수없음":
                hour_weather_infos[now_index][3] = 0.0
            else:
                hour_weather_infos[now_index][3] = float(obj.get('fcstValue').replace('mm', ''))

    return hour_weather_infos

def save_hour_weather(hour_weather_infos, code, local_weather_odd, local_weather_even):
    time = int(datetime.datetime.now().strftime("%H"))
    # 만약 location code를 가진 시간대별 날씨가 있으면 갱신 없으면, 만들어줌.
    if HourlyWeatherOdd.objects.filter(code = code):
        print("시간 정보 갱신 시작 !!!!!!!!!")
        if time % 2 != 0:
            every_hour_queries = HourlyWeatherEven.objects.filter(code = code).all()
        else:
            every_hour_queries = HourlyWeatherOdd.objects.filter(code = code).all()
        for hour_query in every_hour_queries:
            try:
                now_time = hour_query.hour
                hour_query.status        = hour_weather_infos[now_time][1]
                hour_query.temperature   = hour_weather_infos[now_time][2]
                hour_query.precipitation = hour_weather_infos[now_time][3]
                hour_query.save()
            except:
                return

    else:
        print("시간 정보 생성 시작 !!!!!!!!!")
        for i in range(len(hour_weather_infos)):
            hour_weather_info = hour_weather_infos[i]
            hourly_weather_odd = HourlyWeatherOdd.objects.create(local_weather = local_weather_odd, code = code, hour = i, status = hour_weather_info[1], temperature = hour_weather_info[2], precipitation = hour_weather_info[3])
            hourly_weather_even = HourlyWeatherEven.objects.create(local_weather = local_weather_even, code = code, hour = i, status = hour_weather_info[1], temperature = hour_weather_info[2], precipitation = hour_weather_info[3])
            hourly_weather_odd.save()
            hourly_weather_even.save()

    return

def get_weekly_weather(weather_48h_jsonObject, middle_state_jsonObject, middle_temperature_jsonObject, today):
    weekly_weather_infos = [[0] * 4 for _ in range(10)] # day 0, status 1, max_temperature 2, min_temperature 3
    if weather_48h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return weekly_weather_infos
    if middle_state_jsonObject.get('response').get('header').get('resultCode') != "00":
        return weekly_weather_infos
    if middle_temperature_jsonObject.get('response').get('header').get('resultCode') != "00":
        return weekly_weather_infos
    # 0: "맑음", 1: "비", 2: "비/눈, 3: "구름 많음", 4: "흐림", 5: "눈"
    # 내일
    weekly_weather_infos[0][0] = 1
    weekly_weather_infos[1][0] = 2

    for obj in weather_48h_jsonObject.get('response').get('body').get('items').get('item'):
        # 오늘 최저 기온
        if obj.get('category') == 'TMN' and obj.get('fcstDate') == today:
            weekly_weather_infos[0][3] = float(obj.get('fcstValue'))
        # 내일 최저 기온
        elif obj.get('category') == 'TMN' and obj.get('fcstDate') == f'{int(today) + 1}':
            weekly_weather_infos[1][3] = float(obj.get('fcstValue'))
        # 오늘 최고 기온
        elif obj.get('category') == 'TMX' and obj.get('fcstDate') == today:
            weekly_weather_infos[0][2] = float(obj.get('fcstValue'))
        # 내일 최고 기온
        elif obj.get('category') == 'TMX' and obj.get('fcstDate') == f'{int(today) + 1}':
            weekly_weather_infos[1][2] = float(obj.get('fcstValue'))
        # 오늘 날씨 상태
        elif obj.get('category') == 'SKY' and obj.get('fcstDate') == today:
            if obj.get('fcstValue') == "1":
                weekly_weather_infos[0][1] = 0
            else:
                weekly_weather_infos[0][1] = int(obj.get('fcstValue'))
        # 내일 날씨 상태
        elif obj.get('category') == 'SKY' and obj.get('fcstDate') == f'{int(today) + 1}':
            if obj.get('fcstValue') == "1":
                weekly_weather_infos[1][1] = 0
            else:
                weekly_weather_infos[1][1] = int(obj.get('fcstValue'))
        # 오늘 강수 상태
        elif obj.get('category') == 'PTY' and obj.get('fcstDate') == today:
            if obj.get('fcstValue') == "0":
                continue
            elif obj.get('fcstValue') == "3":
                weekly_weather_infos[0][1] = 5
            else:
                weekly_weather_infos[0][1] = int(obj.get('fcstValue'))
        # 내일 강수 상태
        elif obj.get('category') == 'PTY' and obj.get('fcstDate') == f'{int(today) + 1}':
            if obj.get('fcstValue') == "0":
                continue
            elif obj.get('fcstValue') == "3":
                weekly_weather_infos[1][1] = 5
            else:
                weekly_weather_infos[0][1] = int(obj.get('fcstValue'))

    # 3일부터 6이 생김
    # 0: "맑음", 1: "비", 2: "비/눈, 3: "구름 많음", 4: "흐림", 5: "눈", 6: "소나기"
    # 맑음, 구름많음, 구름많고 비, 구름많고 눈, 구름많고 비/눈, 구름많고 소나기, 흐림, 흐리고 비, 흐리고 눈, 흐리고 비/눈, 흐리고 소나기
    middle_state = middle_state_jsonObject.get('response').get('body').get('items').get('item')[0]
    # print(middle_state)

    for i in range(2, 7):
        weekly_weather_infos[i][1] = check_state(middle_state[f'wf{i+1}Am'], middle_state[f'wf{i+1}Pm'])

    for i in range(7, 10):
        weekly_weather_infos[i][1] = check_state(middle_state[f'wf{i+1}'], "")

    middle_temperature = middle_temperature_jsonObject.get('response').get('body').get('items').get('item')[0]
    for i in range(2, 10):
        weekly_weather_infos[i][0] = i + 1
        weekly_weather_infos[i][2] = middle_temperature[f'taMax{i+1}']
        weekly_weather_infos[i][3] = middle_temperature[f'taMin{i+1}']

    return weekly_weather_infos

def check_state(am_state, pm_state):
    result = 0
    case_0 = ["맑음"]
    case_1 = ["구름많고 비", "흐리고 비"]
    case_2 = ["구름많고 비/눈", "흐리고 비/눈"]
    case_3 = ["구름많음"]
    case_4 = ["흐림"]
    case_5 = ["구름많고 눈", "흐리고 눈"]
    case_6 = ["구름많고 소나기", "흐리고 소나기"]
    weather_cases = [case_0, case_1, case_2, case_3, case_4, case_5, case_6]

    for i in range(len(weather_cases)):
        now_case = weather_cases[i]
        if am_state in now_case and i > result:
            result = i
        elif pm_state in now_case and i > result:
            result = i

    return result

def save_weekly_weather(weekly_weather_infos, code, local_weather_odd, local_weather_even):
    time = int(datetime.datetime.now().strftime("%H"))
    # day, status, max_temperature, min_temperature
    # 만약 location code를 가진 시간대별 날씨가 있으면 갱신 없으면, 만들어줌.
    if WeeklyWeatherOdd.objects.filter(code = code):
        if time % 2 != 0:
            every_weekly_queries = WeeklyWeatherEven.objects.filter(code = code).all()
        else:
            every_weekly_queries = WeeklyWeatherOdd.objects.filter(code = code).all()

        for weekly_query in every_weekly_queries:
            try:
                now_day = hour_query.day
                weekly_query.status          = weekly_weather_infos[now_day][1]
                weekly_query.max_temperature = weekly_weather_infos[now_day][2]
                weekly_query.min_temperature = weekly_weather_infos[now_day][3]
                weekly_query.save()
            except:
                return
                
    else:
        for i in range(len(weekly_weather_infos)):
            weekly_weather_info = weekly_weather_infos[i]
            weekly_weather_odd = WeeklyWeatherOdd.objects.create(local_weather = local_weather_odd, code = code, day = i, status = weekly_weather_info[1], max_temperature = weekly_weather_info[2], min_temperature = weekly_weather_info[3])
            weekly_weather_even = WeeklyWeatherEven.objects.create(local_weather = local_weather_even, code = code, day = i, status = weekly_weather_info[1], max_temperature = weekly_weather_info[2], min_temperature = weekly_weather_info[3])
            weekly_weather_odd.save()
            weekly_weather_even.save()

    return

def cal_time(time_string):
    hour = time_string[0]
    minute = time_string[1]
    
    if hour == "00":
        return "2300"
    
    result = hour
    minute = int(minute)
    
    if int(hour) <= 10:
        result = "0" + str(int(hour) - 1)
    else:
        result = str(int(hour) - 1)
    result += "00"
    
    return result