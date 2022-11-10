from apis.models import *
import os
import django
import csv
import sys

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

    # Main에 아무것도 없으면 DB 처음 킨 것.
    if Main.objects.count() == 0:
        generate_first_time()

    return

# 처음에 날씨 DB 갱신함.
def generate_first_time():
    print("It's First Time !")
    now = ""
    locations = Locations.objects.all()
    for location in locations:
        generateDB(now, location)

    return

# 30분마다 30분 DB에 저장.
def time_interval_weather_30():
    print("HI. It's 30 minutes")
    now = ""
    locations = Locations.objects.all()
    for location in locations:
        updateDB(now, location)
    return

def time_interval_weather_00():
    print("HI. It's 00 minutes")
    now = ""
    locations = Locations.objects.all()
    for location in locations:
        updateDB(now, location)
    return

# create 해줘야 함.
def generateDB(time, location):
    # 현재 지역과 시간을 중심으로 DB를 생성한다.

    # main 생성

    # umbrella_index 생성

    # mask_index 생성

    # outer_index 생성

    # laundry_index 생성

    # carwash_index 생성

    # compare_index 생성

    # weekly_index 생성
    # > 날씨를 기반으로 날짜까지 같이 넣어준다. 나중에 사용할 때는 filter를 코드로 먼저 받고 이 쿼리셋을 돌리면서 날짜별로 넣어주면 됨.

    # hourly_index 생성
    # > 위클리와 마찬가지임

    return

# update해줘야 함.
def updateDB():
    # 현재 지역과 시간을 중심으로 DB를 갱신한다.

    # main 갱신

    # umbrella_index 갱신

    # mask_index 갱신

    # outer_index 갱신

    # laundry_index 갱신

    # carwash_index 갱신

    # compare_index 갱신

    # weekly_index 갱신
    # > 날씨를 기반으로 날짜까지 같이 넣어준다. 나중에 사용할 때는 filter를 코드로 먼저 받고 이 쿼리셋을 돌리면서 날짜별로 넣어주면 됨.

    # hourly_index 갱신
    # > 위클리와 마찬가지

    return
    
