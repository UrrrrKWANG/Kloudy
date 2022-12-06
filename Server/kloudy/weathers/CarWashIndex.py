def get_carwash_index(weather_48h_jsonObject, middle_state_jsonObject, air_jsonObject, flower_jsonObject, today):
    if weather_48h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0, 0, 0, "", 0, 0]
    if middle_state_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0, 0, 0, "", 0, 0]
    if air_jsonObject.get('response').get('header').get('resultCode') != "00" or air_jsonObject.get('response').get('body').get('totalCount') == 0:
        return [0, 0, 0, 0, 0, 0, "", 0, 0]
    if flower_jsonObject.get('response').get('header').get('resultCode') != "00" and flower_jsonObject.get('response').get('header').get('resultCode') != "99":
        return [0, 0, 0, 0, 0, 0, "", 0, 0]

    # 오늘 날씨 => 0: "맑음", 1: "비", 2: "비/눈, 3: "구름 많음", 4: "흐림", 5: "눈"
    day_max_temperature = 0.0
    daily_weathers = []
    daily_precipitations = []
    # 내일 날씨 => 0: "맑음", 1: "비", 2: "비/눈, 3: "구름 많음", 4: "흐림", 5: "눈"
    tomorrow_weathers = []
    tomorrow_precipitations = []
    for obj in weather_48h_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'TMX' and obj.get('fcstDate') == today:
            day_max_temperature = float(obj.get('fcstValue'))
        # 오늘 날씨 상태
        elif obj.get('category') == 'SKY' and obj.get('fcstDate') == today:
            if obj.get('fcstValue') == "1":
                daily_weathers.append(0)
            else:
                daily_weathers.append(int(obj.get('fcstValue')))
        # 내일 날씨 상태
        elif obj.get('category') == 'SKY' and obj.get('fcstDate') == f'{int(today) + 1}':
            if obj.get('fcstValue') == "1":
                tomorrow_weathers.append(0)
            else:
                tomorrow_weathers.append(int(obj.get('fcstValue')))
        # 오늘 강수량
        elif obj.get('category') == 'PCP' and obj.get('fcstDate') == today:
            if obj.get('fcstValue') == "강수없음":
                daily_precipitations.append(0.0)
            else:
                daily_precipitations.append(float(obj.get('fcstValue').replace('mm', '')))
        # 내일 강수량
        elif obj.get('category') == 'PCP' and obj.get('fcstDate') == f'{int(today) + 1}':
            if obj.get('fcstValue') == "강수없음":
                daily_precipitations.append(0.0)
            else:
                tomorrow_precipitations.append(float(obj.get('fcstValue').replace('mm', '')))
        # 오늘 강수 상태
        elif obj.get('category') == 'PTY' and obj.get('fcstDate') == today:
            if obj.get('fcstValue') == "0":
                continue
            elif obj.get('fcstValue') == "3":
                daily_weathers.append(5)
            else:
                daily_weathers.append(int(obj.get('fcstValue')))
        # 내일 강수 상태
        elif obj.get('category') == 'PTY' and obj.get('fcstDate') == f'{int(today) + 1}':
            if obj.get('fcstValue') == "0":
                continue
            elif obj.get('fcstValue') == "3":
                tomorrow_weathers.append(5)
            else:
                tomorrow_weathers.append(int(obj.get('fcstValue')))
    
    daily_weather = max(daily_weathers)
    tomorrow_weather = max(tomorrow_weathers)

    when_is_rainy = 9
    if daily_weather == 1 or daily_weather == 2 or daily_weather == 5:
        when_is_rainy = 1
    elif tomorrow_weather == 1 or tomorrow_weather == 2 or tomorrow_weather == 5:
        when_is_rainy = 2

    # 가장 가까운 비오는 날을 찾는다.
    rainy_cases = ["구름많고 비", "구름많고 눈", "구름많고 비/눈", "구름많고 소나기", "흐리고 비", "흐리고 눈", "흐리고 비/눈", "흐리고 소나기"]
    middle_state = middle_state_jsonObject.get('response').get('body').get('items').get('item')[0]
    if middle_state['wf3Am'] in rainy_cases or middle_state['wf3Pm'] in rainy_cases:
        when_is_rainy = min(3, when_is_rainy)
    elif middle_state['wf4Am'] in rainy_cases or middle_state['wf4Pm'] in rainy_cases:
        when_is_rainy = min(4, when_is_rainy)
    elif middle_state['wf5Am'] in rainy_cases or middle_state['wf5Pm'] in rainy_cases:
        when_is_rainy = min(5, when_is_rainy)
    elif middle_state['wf6Am'] in rainy_cases or middle_state['wf6Pm'] in rainy_cases:
        when_is_rainy = min(6, when_is_rainy)
    elif middle_state['wf7Am'] in rainy_cases or middle_state['wf7Pm'] in rainy_cases:
        when_is_rainy = min(7, when_is_rainy)
        
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
    daily_precipitation = 0 if sum(daily_precipitations) == 0 else sum(daily_precipitations) / len(daily_precipitations)
    tomorrow_precipitation = 0 if sum(tomorrow_precipitations) == 0 else sum(tomorrow_precipitations) / len(tomorrow_precipitations)
    weather_3Am7pm = "예보없음" if when_is_rainy == 9 else f"{when_is_rainy}일 후"
    pollen_index = max(flower_qualities)
    # 0 : 세차하기 좋음, 1: 세차 괜찮음, 2: 세차 미루기, 3: 세차 하지마
    status = cal_carwash_status(when_is_rainy, day_max_temperature, pm10grade, pollen_index)

    return [status, daily_weather, day_max_temperature, daily_precipitation, tomorrow_weather, tomorrow_precipitation, weather_3Am7pm, pm10grade, pollen_index]

def cal_carwash_status(when_is_rainy, max_temperature, pm10grade, pollen_index):
    result = 0

    if 150 < pm10grade or pollen_index == 3 or max_temperature <= -2 or when_is_rainy <= 2:
        reulst = 3
        return result
    elif 80 < pm10grade < 151 or pollen_index == 2 or when_is_rainy <= 4:
        result = 2
        return result
    elif when_is_rainy <= 6:
        result = 1
        return result
    
    return result