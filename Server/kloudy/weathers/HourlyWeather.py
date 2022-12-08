from apis.models import HourlyWeatherEven, HourlyWeatherOdd
import datetime

def get_hour_weather(weather_info, code, time):
    # 시간대별 날씨를 담아둠
    try:
        hour_weather_infos = [[0] * 4 for _ in range(24)] # 0 : hour | 1 : status | 2 : temperature | 3 : precipitation
        # 24시간의 날씨 정보
        forecast_hourly = weather_info.get('forecastHourly').get('hours')
        reported_time = weather_info.get('forecastHourly').get('metadata').get('reportedTime')
        hour_index = 0
        for i in range(len(forecast_hourly)):
            forecast = forecast_hourly[i]
            if reported_time == forecast.get('forecastStart'):
                hour_index = i


        for i in range(hour_index, hour_index+24):
            forecast = forecast_hourly[i]

            cloud_cover = forecast.get('cloudCover')
            precipitation_intensity = forecast.get('precipitationIntensity')
            condition_code = forecast.get('conditionCode')
            status = cal_weather_status(cloud_cover, precipitation_intensity, condition_code)
            temperature = forecast.get('temperature')
            precipitation = forecast.get('precipitationAmount')

            hour_weather_infos[i-hour_index][0] = i # hour
            hour_weather_infos[i-hour_index][1] = status # status
            hour_weather_infos[i-hour_index][2] = temperature # temperature
            hour_weather_infos[i-hour_index][3] = precipitation # precipitation
            
        return hour_weather_infos
            
    except:
        print("Hour Weather Exception")
        hour_weather_infos = [[0] * 4 for _ in range(24)]
        return hour_weather_infos

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

def save_hour_weather(hour_weather_infos, code, local_weather_odd, local_weather_even):
    time = int(datetime.datetime.now().strftime("%H"))
    # 만약 location code를 가진 시간대별 날씨가 있으면 갱신 없으면, 만들어줌.
    if HourlyWeatherOdd.objects.filter(code = code):
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
        for i in range(len(hour_weather_infos)):
            hour_weather_info = hour_weather_infos[i]
            hourly_weather_odd = HourlyWeatherOdd.objects.create(local_weather = local_weather_odd, code = code, hour = i, status = hour_weather_info[1], temperature = hour_weather_info[2], precipitation = hour_weather_info[3])
            hourly_weather_even = HourlyWeatherEven.objects.create(local_weather = local_weather_even, code = code, hour = i, status = hour_weather_info[1], temperature = hour_weather_info[2], precipitation = hour_weather_info[3])
            hourly_weather_odd.save()
            hourly_weather_even.save()

    return