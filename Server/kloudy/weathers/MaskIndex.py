def get_mask_index(air_jsonObject, flower_jsonObject):
    # 제대로 값이 들어오지 않는 경우가 많음
    if air_jsonObject.get('response').get('header').get('resultCode') != "00" or air_jsonObject.get('response').get('body').get('totalCount') == 0:
        return [0, 0, 0, 0]
    if flower_jsonObject.get('response').get('header').get('resultCode') != "00" and flower_jsonObject.get('response').get('header').get('resultCode') != "99" :
        return [0, 0, 0, 0]

    pm25_str = air_jsonObject.get('response').get('body').get('items')[0].get('pm25Value')
    if pm25_str != "-":
        pm25 = float(pm25_str)
    else:
        pm25 = 0

    pm10_str = air_jsonObject.get('response').get('body').get('items')[0].get('pm10Value')
    if pm10_str != "-":
        pm10 = float(pm10_str)
    else:
        pm10 = 0

    flower_quality = 0
    if flower_jsonObject.get('response').get('header').get('resultCode') == '0':
        flower_quality = int(flower_jsonObject.get('response').get('body').get('items').get('item').get('today'))

    status = cal_mask_status(pm25)
    pm25value = pm25
    pm10value = pm10
    pollen_index = flower_quality

    return [status, pm25value, pm10value, pollen_index]

# 0~15 : 좋음 0 / 16~35 : 보통 1 / 36~75 : 나쁨 2 / 76 : 매우나쁨 3
def cal_mask_status(pm25):
    result = 0

    if 0 <= pm25 < 16:
        result = 0
    elif 16 <= pm25 < 36:
        result = 1
    elif 36 <= pm25 < 76:
        result = 3
    elif 76 <= pm25:
        result = 4

    return result
