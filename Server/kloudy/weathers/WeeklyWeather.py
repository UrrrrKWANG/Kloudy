from apis.models import WeeklyWeatherOdd, WeeklyWeatherEven
import datetime

def get_weekly_weather(weather_info, today):
    weekly_weather_infos = [[0] * 4 for _ in range(10)] # day 0, status 1, max_temperature 2, min_temperature 3
    try:
        forecast_daily = weather_info.get('forecastDaily').get('days')
        for i in range(10):
            forecast = forecast_daily[i]
            cloud_cover = forecast.get('daytimeForecast').get('cloudCover')
            precipitation_amount = forecast.get('daytimeForecast').get('precipitationAmount')
            condition_code = forecast.get('daytimeForecast').get('conditionCode')
            status = cal_weather_status(cloud_cover, precipitation_amount, condition_code)

            max_temperature = forecast.get('temperatureMax')
            min_temperature = forecast.get('temperatureMin')

            weekly_weather_infos[i][0] = i
            weekly_weather_infos[i][1] = status
            weekly_weather_infos[i][2] = max_temperature
            weekly_weather_infos[i][3] = min_temperature

        return weekly_weather_infos

    except:
        print("Weekly Weather Exception")
        return weekly_weather_infos

def cal_weather_status(cloud_cover, precipitation_amount, condition_code):
    cloud_cover = float(cloud_cover)
    precipitation_amount = float(precipitation_amount)
    snow_case = ["snow", "frigid", "flurries", "sunFlurries", "blowingSnow", "intryMix", "blizzard", "blowingSnow", "freezingRain", "heavySnow"]
    snow_rain_case = ["sleet", "freezingDrizzle"]

    if cloud_cover <= 0.3 and precipitation_amount == 0:
        return 0
    elif 0.3 < cloud_cover <= 0.8 and precipitation_amount == 0:
        return 1
    elif 0.8 < cloud_cover and precipitation_amount == 0:
        return 2
    elif precipitation_amount > 0 and condition_code not in snow_case:
        return 3
    elif precipitation_amount > 0 and condition_code in snow_case:
        return 4
    elif precipitation_amount > 0 and condition_code in snow_rain_case:
        return 5

    return 0

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
                now_day = weekly_query.day 
                weekly_query.status          = weekly_weather_infos[now_day][1]
                weekly_query.max_temperature = weekly_weather_infos[now_day][2]
                weekly_query.min_temperature = weekly_weather_infos[now_day][3]
                weekly_query.save()
            except:
                print("업데이트 실패")
                return
                
    else:
        for i in range(len(weekly_weather_infos)):
            weekly_weather_info = weekly_weather_infos[i]
            weekly_weather_odd = WeeklyWeatherOdd.objects.create(local_weather = local_weather_odd, code = code, day = i, status = weekly_weather_info[1], max_temperature = weekly_weather_info[2], min_temperature = weekly_weather_info[3])
            weekly_weather_even = WeeklyWeatherEven.objects.create(local_weather = local_weather_even, code = code, day = i, status = weekly_weather_info[1], max_temperature = weekly_weather_info[2], min_temperature = weekly_weather_info[3])
            weekly_weather_odd.save()
            weekly_weather_even.save()

    return
