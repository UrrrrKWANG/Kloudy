from apis.models import CarwashIndexOdd, CarwashIndexEven, PrecipitationDailyOdd, PrecipitationDailyEven
from datetime import datetime

def get_carwash_index(weather_info, air_jsonObject, flower_jsonObject):
    try:
        today_weather_info = weather_info.get('forecastDaily').get('days')[0]
        tomorrow_weather_info = weather_info.get('forecastDaily').get('days')[1]

        today_cloud_cover = today_weather_info.get('daytimeForecast').get('cloudCover')
        today_precipitation_amount = today_weather_info.get('daytimeForecast').get('precipitationAmount')
        today_condition_code = today_weather_info.get('daytimeForecast').get('conditionCode')

        tomorrow_cloud_cover = tomorrow_weather_info.get('daytimeForecast').get('cloudCover')
        tomorrow_precipitation_amount = tomorrow_weather_info.get('daytimeForecast').get('precipitationAmount')
        tomorrow_condition_code = tomorrow_weather_info.get('daytimeForecast').get('conditionCode')

        daily_weather = cal_weather_status(today_cloud_cover, today_precipitation_amount, today_condition_code)
        tomorrow_weather = cal_weather_status(tomorrow_cloud_cover, tomorrow_precipitation_amount, tomorrow_condition_code)

        if air_jsonObject.get('response').get('header').get('resultCode') != "00" or air_jsonObject.get('response').get('body').get('totalCount') == 0:
            pm10grade = 0
        else:
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
        day_max_temperature = weather_info.get('forecastDaily').get('days')[0].get('temperatureMax')
        pollen_index = max(flower_qualities)

        when_is_rainy, daily_precipitation, tomorrow_precipitation, precipitation_for_days = cal_precipitation(weather_info)
        weather_3Am7pm = "예보없음" if when_is_rainy == 9 else f"{when_is_rainy}일 후"
        # 0 : 세차하기 좋음, 1: 세차 괜찮음, 2: 세차 미루기, 3: 세차 하지마
        status = cal_carwash_status(when_is_rainy, day_max_temperature, pm10grade, pollen_index)
        
        return [status, daily_weather, day_max_temperature, daily_precipitation, tomorrow_weather, tomorrow_precipitation, weather_3Am7pm, pm10grade, pollen_index, precipitation_for_days]

    except:
        print("CarWash Index Exception")
        return [0, 0, 0, 0, 0, 0, "", 0, 0]

def cal_precipitation(weather_info):
    when_is_rainy = 9
    daily_precipitation = 0
    tomorrow_precipitation = weather_info.get('forecastDaily').get('days')[1].get('precipitationAmount')

    precipitation_for_days = []
    forecast_daily = weather_info.get('forecastDaily').get('days')
    for i in range(1, 8):
        forecast = forecast_daily[i]
        precipitation_amount = float(forecast.get('precipitationAmount'))
        if precipitation_amount > 0:
            when_is_rainy = min(i, when_is_rainy)
        precipitation_for_days.append(precipitation_amount)
    
    forecast_hourly = weather_info.get('forecastHourly').get('hours')
    for i in range(24):
        forecast = forecast_hourly[i]
        precipitation_intensity = float(forecast.get('precipitationIntensity'))
        if precipitation_intensity > 0:
            when_is_rainy = 0
        daily_precipitation += precipitation_intensity

    daily_precipitation = 0 if daily_precipitation == 0 else daily_precipitation / 24

    return [when_is_rainy, daily_precipitation, tomorrow_precipitation, precipitation_for_days]

def cal_weather_status(cloud_cover, precipitation_intensity, condition_code):
    cloud_cover = float(cloud_cover)
    precipitation_intensity = float(precipitation_intensity)
    snow_case = ["snow", "frigid", "flurries", "sunFlurries", "blowingSnow", "intryMix", "blizzard", "blowingSnow", "freezingRain", "heavySnow"]
    snow_rain_case = ["sleet", "freezingDrizzle"]
    if cloud_cover <= 0.3 and precipitation_intensity == 0:
        return 0
    elif 0.3 < cloud_cover <= 0.8 and precipitation_intensity == 0:
        return 1
    elif 0.8 < cloud_cover and precipitation_intensity == 0:
        return 2
    elif precipitation_intensity > 0 and condition_code not in snow_case:
        return 3
    elif precipitation_intensity > 0 and condition_code in snow_case:
        return 4
    elif precipitation_intensity > 0 and condition_code in snow_rain_case:
        return 5

    return 0

def cal_carwash_status(when_is_rainy, max_temperature, pm10grade, pollen_index):
    result = 0

    if 150 < pm10grade or pollen_index == 3 or max_temperature <= -2 or when_is_rainy <= 2:
        result = 3
        return result
    elif 80 < pm10grade < 151 or pollen_index == 2 or when_is_rainy <= 4:
        result = 2
        return result
    elif when_is_rainy <= 6:
        result = 1
        return result
    
    return result

def save_precipitation_daily(precipitation_for_days, code):
    time = int(datetime.now().strftime("%H"))
    # 지금 처음이 아니면
    if PrecipitationDailyEven.objects.filter(code = code):
        if time % 2 != 0:
            precipitation_daily_queries = PrecipitationDailyEven.objects.filter(code = code).all()
        else:
            precipitation_daily_queries = PrecipitationDailyOdd.objects.filter(code = code).all()
        for precipitation_daily_query in precipitation_daily_queries:
            try:
                now_day = precipitation_daily_query.day
                precipitation_daily_query.precipitation = precipitation_for_days[now_day]
                precipitation_daily_query.save()
            except:
                return

    else:
        carwash_index_odd = CarwashIndexOdd.objects.filter(code = code).first()
        carwash_index_even = CarwashIndexEven.objects.filter(code = code).first()
        for i in range(len(precipitation_for_days)):
            precipitation_daily_odd = PrecipitationDailyOdd.objects.create(carwash_index = carwash_index_odd, code = code, day = i+1, precipitation = precipitation_for_days[i])
            precipitation_daily_even = PrecipitationDailyEven.objects.create(carwash_index = carwash_index_even, code = code, day = i+1, precipitation = precipitation_for_days[i])
            precipitation_daily_odd.save()
            precipitation_daily_even.save()
    return
