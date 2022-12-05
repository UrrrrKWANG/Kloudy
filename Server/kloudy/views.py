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
from .weathers import MainWeather, UmbrellaIndex, MaskIndex, OuterIndex, LaundryIndex, CarWashIndex, CompareIndex, HourlyWeather

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
            main_info = MainWeather.get_main_weather(main_state_jsonObject, main_state_short_jsonObject, main_current_jsonObject, main_max_min_jsonObject)
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
            umbrella_info = UmbrellaIndex.get_umbrella_index(weather_24h_jsonObject)
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

                UmbrellaIndex.save_umbrella_hourly(umbrella_index, rains, location.code)
                
            # 마스크 지수
            mask_info = MaskIndex.get_mask_index(air_jsonObject, flower_jsonObject)
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
            outer_info = OuterIndex.get_outer_index(weather_24h_jsonObject)
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
            laundry_info = LaundryIndex.get_laundry_index(weather_24h_jsonObject)
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
            carwash_info = CarWashIndex.get_carwash_index(weather_48h_jsonObject, middle_state_jsonObject, air_jsonObject, flower_jsonObject, today)
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
            compare_info = CompareIndex.get_compare_index(weather_24h_jsonObject, today, False, location.code)
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

            hour_weather_infos = HourlyWeather.get_hour_weather(weather_24h_jsonObject, location.code, time)
            if hour_weather_infos != [[0] * 4 for _ in range(24)]:
                HourlyWeather.save_hour_weather(hour_weather_infos, location.code, local_weather_odd, local_weather_even)

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
            main_info = MainWeather.get_main_weather(main_state_jsonObject, main_state_short_jsonObject, main_current_jsonObject, main_max_min_jsonObject)
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

            umbrella_info = UmbrellaIndex.get_umbrella_index(weather_24h_jsonObject)
            umbrella_status, precipitation_24h, precipitation_1h_max, precipitation_3h_max, wind, rains = umbrella_info
            print(f'우산 지수: {umbrella_status}, {precipitation_24h}, {precipitation_1h_max}, {precipitation_3h_max}, {wind}')
            umbrella_index_odd = UmbrellaIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status = umbrella_status, precipitation_24h = precipitation_24h, precipitation_1h_max = precipitation_1h_max, precipitation_3h_max = precipitation_3h_max, wind = wind)
            umbrella_index_even = UmbrellaIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status = umbrella_status, precipitation_24h = precipitation_24h, precipitation_1h_max = precipitation_1h_max, precipitation_3h_max = precipitation_3h_max, wind = wind)
            umbrella_index_odd.save()
            umbrella_index_even.save()
            UmbrellaIndex.save_umbrella_hourly(umbrella_index_odd, rains, location.code)

            mask_info = MaskIndex.get_mask_index(air_jsonObject, flower_jsonObject)
            mask_status, pm25value, pm10value, pollen_index = mask_info
            print(f'마스크 지수: {mask_status}, {pm25value}, {pm10value}, {pollen_index}')
            mask_index_odd = MaskIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status = mask_status, pm25value = pm25value, pm10value = pm10value, pollen_index = pollen_index)
            mask_index_even = MaskIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status = mask_status, pm25value = pm25value, pm10value = pm10value, pollen_index = pollen_index)
            mask_index_odd.save()
            mask_index_even.save()

            outer_info = OuterIndex.get_outer_index(weather_24h_jsonObject)
            outer_status, day_min_temperature, morning_temperature = outer_info
            print(f"아우터 지수: {outer_status}, {day_min_temperature}, {morning_temperature}")
            outer_index_odd = OuterIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status= outer_status, day_min_temperature = day_min_temperature, morning_temperature = morning_temperature)
            outer_index_even = OuterIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status= outer_status, day_min_temperature = day_min_temperature, morning_temperature = morning_temperature)
            outer_index_odd.save()
            outer_index_even.save()

            laundry_info = LaundryIndex.get_laundry_index(weather_24h_jsonObject)
            laundry_status, humidity, day_max_temperature, daily_weather = laundry_info
            print(f"빨래 지수 : {laundry_status}, {humidity}, {day_max_temperature}, {daily_weather}")
            laundry_index_odd = LaundryIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status = laundry_status, humidity = humidity, day_max_temperature = day_max_temperature, daily_weather = daily_weather)
            laundry_index_even = LaundryIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status = laundry_status, humidity = humidity, day_max_temperature = day_max_temperature, daily_weather = daily_weather)
            laundry_index_odd.save()
            laundry_index_even.save()

            carwash_info = CarWashIndex.get_carwash_index(weather_48h_jsonObject, middle_state_jsonObject, air_jsonObject, flower_jsonObject, today)
            carwash_status, daily_weather, day_max_temperature, daily_precipitation, tomorrow_weather, tomorrow_precipitation, weather_3Am7pm, pm10grade, pollen_index = carwash_info
            print(f"세차 지수: {carwash_status}, {daily_weather}, {day_max_temperature}, {daily_precipitation}, {tomorrow_weather}, {tomorrow_precipitation}, {weather_3Am7pm}, {pm10grade}, {pollen_index}")
            carwash_index_odd = CarwashIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status = carwash_status, daily_weather = daily_weather, day_max_temperature = day_max_temperature, daily_precipitation = daily_precipitation, tomorrow_weather = tomorrow_weather, tomorrow_precipitation = tomorrow_precipitation, weather_3Am7pm = weather_3Am7pm, pm10grade = pm10grade, pollen_index = pollen_index)
            carwash_index_even = CarwashIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status = carwash_status, daily_weather = daily_weather, day_max_temperature = day_max_temperature, daily_precipitation = daily_precipitation, tomorrow_weather = tomorrow_weather, tomorrow_precipitation = tomorrow_precipitation, weather_3Am7pm = weather_3Am7pm, pm10grade = pm10grade, pollen_index = pollen_index)
            carwash_index_odd.save()
            carwash_index_even.save()

            compare_info = CompareIndex.get_compare_index(weather_24h_jsonObject, today, True, location.code)
            weather_yesterday, yesterday_max_temperature, yesterday_min_temperature, weather_today, today_max_temperature, today_min_temperature = compare_info
            print(f"날씨 비교: {weather_yesterday}, {yesterday_max_temperature}, {yesterday_min_temperature}, {weather_today}, {today_max_temperature}, {today_min_temperature}")
            compare_index_odd = CompareIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, yesterday = weather_yesterday, yesterday_max_temperature = yesterday_max_temperature, yesterday_min_temperature = yesterday_min_temperature, today = weather_today, today_max_temperature = today_max_temperature, today_min_temperature = today_min_temperature)
            compare_index_even = CompareIndexEven.objects.create(weather_index = weather_index_even, code = location.code, yesterday = weather_yesterday, yesterday_max_temperature = yesterday_max_temperature, yesterday_min_temperature = yesterday_min_temperature, today = weather_today, today_max_temperature = today_max_temperature, today_min_temperature = today_min_temperature)
            compare_index_odd.save()
            compare_index_even.save()

            hour_weather_infos = HourlyWeather.get_hour_weather(weather_24h_jsonObject, location.code, time)
            HourlyWeather.save_hour_weather(hour_weather_infos, location.code, local_weather_odd, local_weather_even)

            weekly_weather_infos = get_weekly_weather(weather_48h_jsonObject, middle_state_jsonObject, middle_temperature_jsonObject, today)
            save_weekly_weather(weekly_weather_infos, location.code, local_weather_odd, local_weather_even)

def calculate_time():
    now = datetime.datetime.now()
    print(now)
    today = now.strftime("%Y%m%d")
    print(f"날짜 : {today}")
    time = cal_time([now.strftime("%H"), now.strftime("%M")])
    
    return [today, time]

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
