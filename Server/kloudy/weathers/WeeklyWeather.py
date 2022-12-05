from apis.models import WeeklyWeatherOdd, WeeklyWeatherEven
import datetime

def get_weekly_weather(weather_48h_jsonObject, middle_state_jsonObject, middle_temperature_jsonObject, today):
    weekly_weather_infos = [[0] * 4 for _ in range(10)] # day 0, status 1, max_temperature 2, min_temperature 3
    if weather_48h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return weekly_weather_infos
    if middle_state_jsonObject.get('response').get('header').get('resultCode') != "00":
        return weekly_weather_infos
    if middle_temperature_jsonObject.get('response').get('header').get('resultCode') != "00":
        return weekly_weather_infos
    # 0: "맑음", 1: "비", 2: "비/눈, 3: "구름 많음", 4: "흐림", 5: "눈"
    # 내일
    weekly_weather_infos[0][0] = 1
    weekly_weather_infos[1][0] = 2

    for obj in weather_48h_jsonObject.get('response').get('body').get('items').get('item'):
        # 오늘 최저 기온
        if obj.get('category') == 'TMN' and obj.get('fcstDate') == today:
            weekly_weather_infos[0][3] = float(obj.get('fcstValue'))
        # 내일 최저 기온
        elif obj.get('category') == 'TMN' and obj.get('fcstDate') == f'{int(today) + 1}':
            weekly_weather_infos[1][3] = float(obj.get('fcstValue'))
        # 오늘 최고 기온
        elif obj.get('category') == 'TMX' and obj.get('fcstDate') == today:
            weekly_weather_infos[0][2] = float(obj.get('fcstValue'))
        # 내일 최고 기온
        elif obj.get('category') == 'TMX' and obj.get('fcstDate') == f'{int(today) + 1}':
            weekly_weather_infos[1][2] = float(obj.get('fcstValue'))
        # 오늘 날씨 상태
        elif obj.get('category') == 'SKY' and obj.get('fcstDate') == today:
            if obj.get('fcstValue') == "1":
                weekly_weather_infos[0][1] = 0
            else:
                weekly_weather_infos[0][1] = int(obj.get('fcstValue'))
        # 내일 날씨 상태
        elif obj.get('category') == 'SKY' and obj.get('fcstDate') == f'{int(today) + 1}':
            if obj.get('fcstValue') == "1":
                weekly_weather_infos[1][1] = 0
            else:
                weekly_weather_infos[1][1] = int(obj.get('fcstValue'))
        # 오늘 강수 상태
        elif obj.get('category') == 'PTY' and obj.get('fcstDate') == today:
            if obj.get('fcstValue') == "0":
                continue
            elif obj.get('fcstValue') == "3":
                weekly_weather_infos[0][1] = 5
            else:
                weekly_weather_infos[0][1] = int(obj.get('fcstValue'))
        # 내일 강수 상태
        elif obj.get('category') == 'PTY' and obj.get('fcstDate') == f'{int(today) + 1}':
            if obj.get('fcstValue') == "0":
                continue
            elif obj.get('fcstValue') == "3":
                weekly_weather_infos[1][1] = 5
            else:
                weekly_weather_infos[0][1] = int(obj.get('fcstValue'))

    # 3일부터 6이 생김
    # 0: "맑음", 1: "비", 2: "비/눈, 3: "구름 많음", 4: "흐림", 5: "눈", 6: "소나기"
    # 맑음, 구름많음, 구름많고 비, 구름많고 눈, 구름많고 비/눈, 구름많고 소나기, 흐림, 흐리고 비, 흐리고 눈, 흐리고 비/눈, 흐리고 소나기
    middle_state = middle_state_jsonObject.get('response').get('body').get('items').get('item')[0]
    # print(middle_state)

    for i in range(2, 7):
        weekly_weather_infos[i][1] = check_state(middle_state[f'wf{i+1}Am'], middle_state[f'wf{i+1}Pm'])

    for i in range(7, 10):
        weekly_weather_infos[i][1] = check_state(middle_state[f'wf{i+1}'], "")

    middle_temperature = middle_temperature_jsonObject.get('response').get('body').get('items').get('item')[0]
    for i in range(2, 10):
        weekly_weather_infos[i][0] = i + 1
        weekly_weather_infos[i][2] = middle_temperature[f'taMax{i+1}']
        weekly_weather_infos[i][3] = middle_temperature[f'taMin{i+1}']

    return weekly_weather_infos

def check_state(am_state, pm_state):
    result = 0
    case_0 = ["맑음"]
    case_1 = ["구름많고 비", "흐리고 비"]
    case_2 = ["구름많고 비/눈", "흐리고 비/눈"]
    case_3 = ["구름많음"]
    case_4 = ["흐림"]
    case_5 = ["구름많고 눈", "흐리고 눈"]
    case_6 = ["구름많고 소나기", "흐리고 소나기"]
    weather_cases = [case_0, case_1, case_2, case_3, case_4, case_5, case_6]

    for i in range(len(weather_cases)):
        now_case = weather_cases[i]
        if am_state in now_case and i > result:
            result = i
        elif pm_state in now_case and i > result:
            result = i

    return result

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
                now_day = hour_query.day
                weekly_query.status          = weekly_weather_infos[now_day][1]
                weekly_query.max_temperature = weekly_weather_infos[now_day][2]
                weekly_query.min_temperature = weekly_weather_infos[now_day][3]
                weekly_query.save()
            except:
                return
                
    else:
        for i in range(len(weekly_weather_infos)):
            weekly_weather_info = weekly_weather_infos[i]
            weekly_weather_odd = WeeklyWeatherOdd.objects.create(local_weather = local_weather_odd, code = code, day = i, status = weekly_weather_info[1], max_temperature = weekly_weather_info[2], min_temperature = weekly_weather_info[3])
            weekly_weather_even = WeeklyWeatherEven.objects.create(local_weather = local_weather_even, code = code, day = i, status = weekly_weather_info[1], max_temperature = weekly_weather_info[2], min_temperature = weekly_weather_info[3])
            weekly_weather_odd.save()
            weekly_weather_even.save()

    return
