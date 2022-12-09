from apis.models import LaundryIndexOdd, LaundryIndexEven, HumidityHourlyOdd, HumidityHourlyEven
from datetime import datetime
def get_laundry_index(weather_info):
    try:
        humidities = []
        sky_status = [0, 0, 0] # 0: 흐림, 구름많음, 1: 맑음, 2: 비, 눈, 눈비
        forecast_hourly = weather_info.get('forecastHourly').get('hours')

        for i in range(24):
            forecast = forecast_hourly[i]
            humidity_hour = float(forecast.get('humidity'))
            humidities.append(humidity_hour)
            sky_status_index = cal_weather_status_for_hour(forecast)
            sky_status[sky_status_index] += 1
        
        humidity = cal_humidity(humidities)
        day_max_temperature = weather_info.get('forecastDaily').get('days')[0].get('temperatureMax')
        daily_weather = cal_daily_weather(sky_status[0], sky_status[1], sky_status[2])

        status = cal_laundry_status(humidity, day_max_temperature, daily_weather)

        return [status, humidity, day_max_temperature, daily_weather, humidities]

    except:
        print("Laundry Index exeption")
        return [0, 0, 0, 0]

def cal_weather_status_for_hour(forecast):

    condition_code = forecast.get('conditionCode')
    cloud_cover = float(forecast.get('cloudCover'))
    precipitation_intensity = float(forecast.get('precipitationIntensity'))
    precipitation_amount = float(forecast.get('precipitationAmount'))
    snow_fall_amount = float(forecast.get('snowfallAmount'))
    snow_rain_case = ["sleet", "freezingDrizzle"]

    if cloud_cover <= 0.3 and precipitation_intensity == 0: # 맑음
        return 1
    elif 0.3 < cloud_cover <= 0.8 and precipitation_amount == 0: # 구름많음
        return 0
    elif 0.8 < cloud_cover and precipitation_amount == 0: # 흐림
        return 0
    elif precipitation_intensity > 0 and snow_fall_amount == 0: # 비
        return 2
    elif precipitation_intensity > 0 and snow_fall_amount > 0: # 눈
        return 2
    elif precipitation_intensity > 0 and condition_code in snow_rain_case: # 눈비
        return 2

    # 혹시 위에서 다 안걸릴 수 있음
    return 1

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

def cal_daily_weather(cloudy, sunny, rainy):
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

def save_humidity_hourly(humidities, code):
    time = int(datetime.now().strftime("%H"))
    # 지금 처음이 아니면
    if HumidityHourlyEven.objects.filter(code = code):
        if time % 2 != 0:
            humidity_hourly_queries = HumidityHourlyEven.objects.filter(code = code).all()
        else:
            humidity_hourly_queries = HumidityHourlyOdd.objects.filter(code = code).all()
        for humidity_hour_query in humidity_hourly_queries:
            try:
                now_time = humidity_hour_query.time
                humidity_hour_query.precipitation = humidities[now_time]
                humidity_hour_query.save()
            except:
                return

    else:
        laundry_index_odd = LaundryIndexOdd.objects.filter(code = code).first()
        laundry_index_even = LaundryIndexEven.objects.filter(code = code).first()
        for i in range(len(humidities)):
            humidity_hourly_odd = HumidityHourlyOdd.objects.create(laundry_index = laundry_index_odd, code = code, time = i, humidity = humidities[i])
            humidity_hourly_even = HumidityHourlyEven.objects.create(laundry_index = laundry_index_even, code = code, time = i, humidity = humidities[i])
            humidity_hourly_odd.save()
            humidity_hourly_even.save()
        print("humidity 저장완료 !!!!")
    return