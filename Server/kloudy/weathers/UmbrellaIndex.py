from apis.models import UmbrellaIndexEven, UmbrellaIndexOdd, UmbrellaHourlyEven, UmbrellaHourlyOdd
import json
import datetime

def get_umbrella_index(weather_info):
    try:
        precipitation_intensity = float(weather_info.get('currentWeather').get('precipitationIntensity'))
        forecast_hourly = weather_info.get('forecastHourly').get('hours')

        status = cal_umbrella_status(precipitation_intensity)
        precipitation_24h, precipitation_1h_max, precipitation_3h_max, rains = cal_hour_rains(forecast_hourly)
        wind = float(weather_info.get('currentWeather').get('windGust'))
        
        return [status, precipitation_24h, precipitation_1h_max, precipitation_3h_max, wind, rains]

    except:
        temp_rains = [0.0] * 24
        return [0, 0, 0, 0, 0, temp_rains]

def save_umbrella_hourly(umbrella_index, rains, code):
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
            
    return

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

def cal_hour_rains(forecast_hourly):
    rains = []
    for forecast in forecast_hourly:
        rain_for_hour = float(forecast.get('precipitationIntensity'))

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
    
    precipitation_24h = P
    precipitation_1h_max = PMAX1
    precipitation_3h_max = PMAX3

    return [precipitation_24h, precipitation_1h_max, precipitation_3h_max, rains]