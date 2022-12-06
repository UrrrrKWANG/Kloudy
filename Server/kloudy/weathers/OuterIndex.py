# 일일 최저, 06시, 07시, 08시, 09시의 온도를 더해서 5로 나누어줌.
def get_outer_index(weather_24h_jsonObject):
    if weather_24h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return [0, 0, 0]

     # 0: 06시, 1: 07시, 2: 08시, 3: 09시
    temperatures = [0.0] * 4
    min_temperature = 0.0

    for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):
        if obj.get('category') == 'TMN':
            min_temperature = float(obj.get('fcstValue'))
        elif obj.get('category') == 'TMP':
            if obj.get('fcstTime') == '0600':
                temperatures[0] = float(obj.get('fcstValue'))
            elif obj.get('fcstTime') == '0700':
                temperatures[1] = float(obj.get('fcstValue'))
            elif obj.get('fcstTime') == '0800':
                temperatures[2] = float(obj.get('fcstValue'))
            elif obj.get('fcstTime') == '0900':
                temperatures[3] = float(obj.get('fcstValue'))
    
    outer_index = (sum(temperatures) + min_temperature) / 5

    status = cal_outer_status(outer_index)
    day_min_temperature = min_temperature
    morning_temperature = sum(temperatures) / 4

    return [status, day_min_temperature, morning_temperature]

def cal_outer_status(outer_index):
    result = 0
    # 12~16도 : 캐주얼 재킷, 가디건 1 | 9~11도 : 라이더 재킷, 트렌치 코트 2| 5~8도 : 코트, 무스탕, 항공 점퍼 3 | 4도 이하 : 패딩, 두꺼운 코트 4| -5도 이하 : 중무장(목도리, 장갑 등) 5
    if 16 <= outer_index:
        result = 0
    elif 12 <= outer_index < 16:
        result = 1
    elif 9 <= outer_index < 12:
        result = 2
    elif 5 <= outer_index < 9:
        result = 3
    elif -5 <= outer_index < 5:
        result = 4
    elif outer_index < -5:
        result = 5

    return result