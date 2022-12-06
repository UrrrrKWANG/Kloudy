def get_laundry_index(weather_24h_jsonObject):
    if weather_24h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]

    max_temperature = 0.0
    humidities = []
    rainy = 0 
    sky_status = [0, 0] # 0: 흐림, 구름많음, 1: 맑음

    for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'TMX':
            max_temperature = float(obj.get('fcstValue'))
        elif obj.get('category') == 'REH':
            humidities.append(float(obj.get('fcstValue')))
        
        elif obj.get('category') == 'PTY':
            if obj.get('fcstValue') == "1":
                rainy += 1
        elif obj.get('category') == 'SKY':
            if obj.get('fcstValue') == "3" or obj.get('fcstValue') == "4":
                sky_status[0] += 1
            elif obj.get('fcstValue') == "1":
                sky_status[1] += 1
    
    humidity = cal_humidity(humidities)
    day_max_temperature = max_temperature
    daily_weather = cal_daily_weather(rainy, sky_status[0], sky_status[1])

    status = cal_laundry_status(humidity, day_max_temperature, daily_weather)

    return [status, humidity, day_max_temperature, daily_weather]

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

def cal_daily_weather(rainy, cloudy, sunny):
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