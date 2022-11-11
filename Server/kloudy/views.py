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
    if Main.objects.count() == 0:
        time_interval_weather()

    return

# 30분 혹은 00분 마다 DB에 저장.
def time_interval_weather():
    print("HI. It's Update Time")

    today, time = calculate_time()
    print(today, time)

    # 모든 지역을 갱신 혹은 만듬
    locations = Locations.objects.all()
    for location in locations:
        print(location.city)
        weather_infos = getDatas(today, time, location)
        
        main_state_jsonObject         = weather_infos[0]
        main_state_short_jsonObject   = weather_infos[1]
        main_current_jsonObject       = weather_infos[2]
        weather_24h_jsonObject        = weather_infos[3] # 24시간 날씨 min_max 정보가 있음.
        air_jsonObject                = weather_infos[4]
        weather_48h_jsonObject        = weather_infos[5]
        main_max_min_jsonObject       = weather_infos[6]
        flower_jsonObject             = weather_infos[7]
        middle_state_jsonObject       = weather_infos[8]
        middle_temperature_jsonObject = weather_infos[9]

        # 처음이 아니면 업데이트해줌.
        if Main.objects.count() != 0:
            print("업데이트해줌 !!!!!!")
            local_weather = LocalWeather.objects.filter(local_code = location.code).first()
            
            main_info = get_main_weather(main_state_jsonObject, main_state_short_jsonObject, main_current_jsonObject, main_max_min_jsonObject)
            main = Main.objects.filter(code = location.code).first()
            # TODO: main 갱신
            main.save()

            weather_index = WeatherIndex.objects.filter(code = location.code).first()

            umbrella_info = get_umbrella_index(weather_24h_jsonObject)
            umbrella_index = UmbrellaIndex.objects.filter(code = location.code).first()
            # TODO: umbrella_index 갱신
            umbrella_index.save()

            mask_info = get_mask_index(air_jsonObject, flower_jsonObject)
            mask_index = MaskIndex.objects.filter(code = location.code).first()
            # TODO: mask_index 갱신
            mask_index.save()

            outer_info = get_outer_index(weather_24h_jsonObject)
            outer_index = OuterIndex.objects.filter(code = location.code).first()
            # TODO: outer_index 갱신
            outer_index.save()

            laundry_info = get_laundry_index(weather_24h_jsonObject)
            laundry_index = LaundryIndex.objects.filter(code = location.code).first()
            # TODO: laundry_index 갱신
            laundry_index.save()
            
            carwash_info = get_carwash_index(weather_24h_jsonObject, middle_state_jsonObject, air_jsonObject, flower_jsonObject)
            carwash_index = CarwashIndex.objects.filter(code = location.code).first()
            # TODO: carwash_index 갱신
            carwash_index.save()

            compare_info = get_compare_index(weather_24h_jsonObject)
            compare_index = CompareIndex.objects.filter(code = location.code).first()
            # TODO: compare_index 갱신
            compare_index.save()

            # TODO: 필요한 것 => 저장할 local_weather
            hour_weather_info = get_hour_weather(weather_24h_jsonObject)
            save_hour_weather(hour_weather_info, location)

            # TODO: 필요한 것 => 저장할 local_weather
            weekly_weather_info = get_weekly_weather(weather_48h_jsonObject, middle_state_jsonObject, middle_temperature_jsonObject)
            save_weekly_weather(weekly_weather_info, location)


        # 처음이면 새로 만든다.
        else:
            print("새로 만듦 !!!!")
            weather = Weather.objects.create(today = today)
            weather.save()
            
            local_weather = LocalWeather.objects.create(weather = weather, local_code = location.code, local_name = location.city)
            local_weather.save()

            # TODO: 필요한 것
            main_info = get_main_weather(main_state_jsonObject, main_state_short_jsonObject, main_current_jsonObject, main_max_min_jsonObject)
            print(main_info)
            # main = Main.objects.create(local_weather = local_weather, )
            # main.save()

            # weather_index = WeatherIndex.objects.create(local_weather = local_weather, code = location.code)
            # weather_index.save()

            # # TODO: 필요한 것
            # umbrella_info = get_umbrella_index(weather_24h_jsonObject)
            # umbrella_index = UmbrellaIndex.objects.create(weather_index = weather_index, code = location.code, )
            # umbrella_index.save()

            # # TODO: 필요한 것
            # mask_info = get_mask_index(air_jsonObject, flower_jsonObject)
            # mask_index = MaskIndex.objects.create(weather_index = weather_index, code = location.code, )
            # mask_index.save()

            # # TODO: 필요한 것
            # outer_info = get_outer_index(weather_24h_jsonObject)
            # outer_index = OuterIndex.objects.create(weather_index = weather_index, code = location.code, )
            # outer_index.save()

            # # TODO: 필요한 것
            # laundry_info = get_laundry_index(weather_24h_jsonObject)
            # laundry_index = LaundryIndex.objects.create(weather_index = weather_index, code = location.code, )
            # laundry_index.save()

            # # TODO: 필요한 것
            # carwash_info = get_carwash_index(weather_24h_jsonObject, middle_state_jsonObject, air_jsonObject, flower_jsonObject)
            # carwash_index = CarwashIndex.objects.create(weather_index = weather_index, code = location.code, )
            # carwash_index.save()

            # # TODO: 필요한 것
            # compare_info = get_compare_index(weather_24h_jsonObject)
            # compare_index = CompareIndex.objects.create(weather_index = weather_index, code = location.code, )
            # compare_index.save()

            # # TODO: 필요한 것
            # hour_weather_infos = get_hour_weather(weather_24h_jsonObject)
            # save_hour_weather(hour_weather_infos)

            # # TODO: 필요한 것 => 저장할 local_weather
            # weekly_weather_info = get_weekly_weather(weather_48h_jsonObject, middle_state_jsonObject, middle_temperature_jsonObject)
            # save_weekly_weather(weekly_weather_infos)

def calculate_time():
    now = datetime.datetime.now()
    today = now.strftime("%Y%m%d")
    time = cal_time([now.strftime("%H"), now.strftime("%M")])
    
    return [today, time]

def get_main_weather(main_state_jsonObject, main_state_short_jsonObject, main_current_jsonObject, main_max_min_jsonObject):
    print("MAIN WEATHER 계산")
    
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
    return

def get_mask_index(air_jsonObject, flower_jsonObject):
    return

def get_outer_index(weather_24h_jsonObject):
    return

def get_laundry_index(weather_24h_jsonObject):
    return

def get_carwash_index(weather_24h_jsonObject, middle_state_jsonObject, air_jsonObject, flower_jsonObject):
    return

def get_compare_index(weather_24h_jsonObject):
    return

def get_hour_weather(weather_24h_jsonObject):
    return

def save_hour_weather(hour_weather_infos, location):
    # 만약 location code를 가진 시간대별 날씨가 있으면 갱신 없으면, 만들어줌.
    for hour_weather_info in hour_weather_infos:
        pass
    return

def get_weekly_weather(weather_48h_jsonObject, middle_state_jsonObject, middle_temperature_jsonObject):
    return

def save_weekly_weather(weekly_weather_infos, location):
    # 만약 location code를 가진 주간 날씨가 있으면 갱신, 없으면 만들어줌.
    for weekly_weather_info in weekly_weather_infos:
        pass

    return

def cal_time(time_string):
    hour = time_string[0]
    minute = time_string[1]
    
    if hour == "00":
        temp_minute = int(minute)
        if 0 <= temp_minute and temp_minute < 30:
            return "2330"
    
    result = hour
    minute = int(minute)
    
    if int(minute) > 30:
        result += "00"
    else:
        if int(hour) <= 10:
            result = "0" + str(int(hour) - 1)
        else:
            result = str(int(hour) - 1)
        result += "30"
    
    if result == "0000" or result == "0030":
        return "2330"
    
    return result