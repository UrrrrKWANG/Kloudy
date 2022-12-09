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
from .weathers import MainWeather, UmbrellaIndex, MaskIndex, OuterIndex, LaundryIndex, CarWashIndex, CompareIndex, HourlyWeather, WeeklyWeather

cache_memory = []
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

        weather_info = getDataFromWeatherKit(location)
        weather_infos = getDataFromKorea(today, time, location)
        
        air_jsonObject                = weather_infos[0]
        flower_jsonObject             = weather_infos[1]

        # 처음이 아니면 업데이트해줌.
        if LocalWeatherOdd.objects.filter(local_code = location.code):
            print("업데이트해줌 !!!!!!")
            time = int(datetime.datetime.now().strftime("%H"))

            # 메인 지수
            main_info = MainWeather.get_main_weather(weather_info)
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
            umbrella_info = UmbrellaIndex.get_umbrella_index(weather_info)
            if umbrella_info != [0, 0, 0, 0, 0]:
                if time % 2 != 0:
                    umbrella_index = UmbrellaIndexEven.objects.filter(code = location.code).first()
                else:
                    umbrella_index = UmbrellaIndexOdd.objects.filter(code = location.code).first()
                    
                umbrella_status, precipitation_24h, precipitation_1h_max, precipitation_3h_max, wind, rains = umbrella_info
                # 갱신
                umbrella_index.status                = umbrella_status
                umbrella_index.precipitation_24h     = precipitation_24h
                umbrella_index.precipitation_1h_max  = precipitation_1h_max
                umbrella_index.precipitation_3h_max  = precipitation_3h_max
                umbrella_index.wind                  = wind
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
                mask_index.status       = mask_status
                mask_index.pm25value    = pm25value
                mask_index.pm10value    = pm10value
                mask_index.pollen_index = pollen_index
                mask_index.save()
            
            #  아우터 지수
            outer_info = OuterIndex.get_outer_index(weather_info)
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
            laundry_info = LaundryIndex.get_laundry_index(weather_info)
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
            carwash_info = CarWashIndex.get_carwash_index(weather_info, air_jsonObject, flower_jsonObject)
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
            compare_info = CompareIndex.get_compare_index(weather_info, today, False, location.code)
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

            hour_weather_infos = HourlyWeather.get_hour_weather(weather_info, location.code, time)
            if hour_weather_infos != [[0] * 4 for _ in range(24)]:
                HourlyWeather.save_hour_weather(hour_weather_infos, location.code, local_weather_odd, local_weather_even, False)

            weekly_weather_infos = WeeklyWeather.get_weekly_weather(weather_info, today)
            if weekly_weather_infos != [[0] * 4 for _ in range(10)]:
                WeeklyWeather.save_weekly_weather(weekly_weather_infos, location.code, local_weather_odd, local_weather_even)

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
            
            main_info = MainWeather.get_main_weather(weather_info)
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

            umbrella_info = UmbrellaIndex.get_umbrella_index(weather_info)
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

            outer_info = OuterIndex.get_outer_index(weather_info)
            outer_status, day_min_temperature, morning_temperature = outer_info
            print(f"아우터 지수: {outer_status}, {day_min_temperature}, {morning_temperature}")
            outer_index_odd = OuterIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status= outer_status, day_min_temperature = day_min_temperature, morning_temperature = morning_temperature)
            outer_index_even = OuterIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status= outer_status, day_min_temperature = day_min_temperature, morning_temperature = morning_temperature)
            outer_index_odd.save()
            outer_index_even.save()

            laundry_info = LaundryIndex.get_laundry_index(weather_info)
            laundry_status, humidity, day_max_temperature, daily_weather = laundry_info
            print(f"빨래 지수 : {laundry_status}, {humidity}, {day_max_temperature}, {daily_weather}")
            laundry_index_odd = LaundryIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status = laundry_status, humidity = humidity, day_max_temperature = day_max_temperature, daily_weather = daily_weather)
            laundry_index_even = LaundryIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status = laundry_status, humidity = humidity, day_max_temperature = day_max_temperature, daily_weather = daily_weather)
            laundry_index_odd.save()
            laundry_index_even.save()

            carwash_info = CarWashIndex.get_carwash_index(weather_info, air_jsonObject, flower_jsonObject)
            carwash_status, daily_weather, day_max_temperature, daily_precipitation, tomorrow_weather, tomorrow_precipitation, weather_3Am7pm, pm10grade, pollen_index = carwash_info
            print(f"세차 지수: {carwash_status}, {daily_weather}, {day_max_temperature}, {daily_precipitation}, {tomorrow_weather}, {tomorrow_precipitation}, {weather_3Am7pm}, {pm10grade}, {pollen_index}")
            carwash_index_odd = CarwashIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, status = carwash_status, daily_weather = daily_weather, day_max_temperature = day_max_temperature, daily_precipitation = daily_precipitation, tomorrow_weather = tomorrow_weather, tomorrow_precipitation = tomorrow_precipitation, weather_3Am7pm = weather_3Am7pm, pm10grade = pm10grade, pollen_index = pollen_index)
            carwash_index_even = CarwashIndexEven.objects.create(weather_index = weather_index_even, code = location.code, status = carwash_status, daily_weather = daily_weather, day_max_temperature = day_max_temperature, daily_precipitation = daily_precipitation, tomorrow_weather = tomorrow_weather, tomorrow_precipitation = tomorrow_precipitation, weather_3Am7pm = weather_3Am7pm, pm10grade = pm10grade, pollen_index = pollen_index)
            carwash_index_odd.save()
            carwash_index_even.save()

            compare_info = CompareIndex.get_compare_index(weather_info, today, True, location.code)
            weather_yesterday, yesterday_max_temperature, yesterday_min_temperature, weather_today, today_max_temperature, today_min_temperature = compare_info
            print(f"날씨 비교: {weather_yesterday}, {yesterday_max_temperature}, {yesterday_min_temperature}, {weather_today}, {today_max_temperature}, {today_min_temperature}")
            compare_index_odd = CompareIndexOdd.objects.create(weather_index = weather_index_odd, code = location.code, yesterday = weather_yesterday, yesterday_max_temperature = yesterday_max_temperature, yesterday_min_temperature = yesterday_min_temperature, today = weather_today, today_max_temperature = today_max_temperature, today_min_temperature = today_min_temperature)
            compare_index_even = CompareIndexEven.objects.create(weather_index = weather_index_even, code = location.code, yesterday = weather_yesterday, yesterday_max_temperature = yesterday_max_temperature, yesterday_min_temperature = yesterday_min_temperature, today = weather_today, today_max_temperature = today_max_temperature, today_min_temperature = today_min_temperature)
            compare_index_odd.save()
            compare_index_even.save()

            hour_weather_infos = HourlyWeather.get_hour_weather(weather_info, location.code, time)
            HourlyWeather.save_hour_weather(hour_weather_infos, location.code, local_weather_odd, local_weather_even, True)

            weekly_weather_infos = WeeklyWeather.get_weekly_weather(weather_info, today)
            WeeklyWeather.save_weekly_weather(weekly_weather_infos, location.code, local_weather_odd, local_weather_even)

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