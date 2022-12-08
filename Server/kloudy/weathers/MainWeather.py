def get_main_weather(weather_info):
    print("Main Weather 계산 잘 들어옴")
    
    try:
        cloud_cover = weather_info.get('currentWeather').get('cloudCover')
        precipitation_intensity = weather_info.get('currentWeather').get('precipitationIntensity')
        condition_code = weather_info.get('forecastDaily').get('days')[0].get('conditionCode')
        main_status = cal_main_status(cloud_cover, precipitation_intensity, condition_code)
        main_current_temerature = float(weather_info.get('currentWeather').get('temperature'))
        main_max_temperature, main_min_temperature = cal_min_max_temperature(weather_info)

        return [main_status, main_current_temerature, main_max_temperature, main_min_temperature]

    except:
        return [0, 0, 0, 0]

def cal_main_status(cloud_cover, precipitation_intensity, condition_code):
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

def cal_min_max_temperature(weather_info):
    max_temperature = weather_info.get('forecastDaily').get('days')[0].get('temperatureMax')
    min_temperature = weather_info.get('forecastDaily').get('days')[0].get('temperatureMin')

    return (float(max_temperature), float(min_temperature))