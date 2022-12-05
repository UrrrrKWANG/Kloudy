from apis.models import HourlyWeatherEven, HourlyWeatherOdd
import datetime

def get_hour_weather(weather_24h_jsonObject, code, time):
    # 시간대별 날씨를 담아둠
    hour_weather_infos = [[0] * 4 for _ in range(24)] # 0 : hour | 1 : status | 2 : temperature | 3 : precipitation
    if weather_24h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return hour_weather_infos
    # 24시간 후의 날씨를 받아올 수 있음
    for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):

        base_time = int(obj.get('baseTime'))
        fcst_time = int(obj.get('fcstTime')) if int(obj.get('fcstTime')) > base_time else int(obj.get('fcstTime')) + 2400
        now_index = ((fcst_time - base_time) // 100) - 1

        hour_weather_infos[now_index][0] = now_index
        if obj.get('category') == 'SKY':
            if obj.get('fcstValue') == "1":
                hour_weather_infos[now_index][1] = 0 
            else:
                hour_weather_infos[now_index][1] = int(obj.get('fcstValue'))
        # 오늘 강수 상태
        elif obj.get('category') == 'PTY':
            if obj.get('fcstValue') == "0":
                continue
            elif obj.get('fcstValue') == "3":
                hour_weather_infos[now_index][1] = 5
            else:
                hour_weather_infos[now_index][1] = int(obj.get('fcstValue'))
        # 이 시간 온도
        elif obj.get('category') == 'TMP':
            hour_weather_infos[now_index][2] = float(obj.get('fcstValue'))
        # 이 시간 강수량
        elif obj.get('category') == 'PCP':
            if obj.get('fcstValue') == "강수없음":
                hour_weather_infos[now_index][3] = 0.0
            else:
                hour_weather_infos[now_index][3] = float(obj.get('fcstValue').replace('mm', ''))

    return hour_weather_infos

def save_hour_weather(hour_weather_infos, code, local_weather_odd, local_weather_even):
    time = int(datetime.datetime.now().strftime("%H"))
    # 만약 location code를 가진 시간대별 날씨가 있으면 갱신 없으면, 만들어줌.
    if HourlyWeatherOdd.objects.filter(code = code):
        print("시간 정보 갱신 시작 !!!!!!!!!")
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
        print("시간 정보 생성 시작 !!!!!!!!!")
        for i in range(len(hour_weather_infos)):
            hour_weather_info = hour_weather_infos[i]
            hourly_weather_odd = HourlyWeatherOdd.objects.create(local_weather = local_weather_odd, code = code, hour = i, status = hour_weather_info[1], temperature = hour_weather_info[2], precipitation = hour_weather_info[3])
            hourly_weather_even = HourlyWeatherEven.objects.create(local_weather = local_weather_even, code = code, hour = i, status = hour_weather_info[1], temperature = hour_weather_info[2], precipitation = hour_weather_info[3])
            hourly_weather_odd.save()
            hourly_weather_even.save()

    return