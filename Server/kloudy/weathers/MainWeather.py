def get_main_weather(main_state_jsonObject, main_state_short_jsonObject, main_current_jsonObject, main_max_min_jsonObject):
    if main_state_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]
    elif main_state_short_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]
    elif main_current_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]
    elif main_max_min_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0, 0]
    else:
        main_status = cal_main_status(main_state_jsonObject, main_state_short_jsonObject)
        main_current_temerature = cal_current_temperature(main_current_jsonObject)
        main_max_temperature, main_min_temperature = cal_min_max_temperature(main_max_min_jsonObject)

    return [main_status, main_current_temerature, main_max_temperature, main_min_temperature]

def cal_main_status(main_state_jsonObject, main_state_short_jsonObject):
    nowStatus = main_state_jsonObject.get('response').get('body').get('items').get('item')[0].get('fcstValue')
    if nowStatus == "0":
        return 0
    else:
        nowRain = main_state_short_jsonObject.get('response').get('body').get('items').get('item')[0].get('obsrValue')
        if nowRain == "0":
            return int(nowStatus)
        # 3번은 nowStatus랑 겹칠 수 있음
        else:
            return "5" if nowRain == 3 else int(nowRain)

def cal_current_temperature(main_current_jsonObject):
    for obj in main_current_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'T1H':
            currentTemperature = obj.get('obsrValue')

    return float(currentTemperature)

def cal_min_max_temperature(main_max_min_jsonObject):
    for obj in main_max_min_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'TMX':
            max_temperature = obj.get('fcstValue')

        if obj.get('category') == 'TMN':
            min_temperature = obj.get('fcstValue')

    return (float(max_temperature), float(min_temperature))