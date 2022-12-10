from apis.models import MaskIndexEven, MaskIndexOdd
import datetime

def get_mask_index(air_jsonObject, flower_jsonObject, day_we_got, is_first_time):
    try:
        
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
        
        if is_first_time:
            status = cal_mask_status(pm25)
            pollen_index = flower_quality
            yesterday = day_we_got
            yesterday_pm25value = pm25
            yesterday_pm10value = pm10
            today = day_we_got
            today_pm25value = pm25
            today_pm10value = pm10

            return [status, pollen_index, yesterday, yesterday_pm25value, yesterday_pm10value, today, today_pm25value, today_pm10value]
        
        else:
            time = int(datetime.datetime.now().strftime("%H"))
            if time % 2 != 0:
                mask_index = MaskIndexEven.objects.filter(code = code).first()
            else:
                mask_index = MaskIndexOdd.objects.filter(code = code).first()

            if mask_index.today == day_we_got:
                status              = mask_index.status
                pollen_index        = mask_index.pollen_index
                yesterday           = mask_index.yesterday
                yesterday_pm25value = mask_index.yesterday_pm25value
                yesterday_pm10value = mask_index.yesterday_pm10value
                today               = mask_index.today
                today_pm25value     = mask_index.today_pm25value
                today_pm10value     = mask_index.today_pm10value

            else:
                status              = cal_mask_status(pm25)
                pollen_index        = flower_quality
                yesterday           = mask_index.today
                yesterday_pm25value = mask_index.today_pm25value
                yesterday_pm10value = mask_index.today_pm10value
                today               = day_we_got
                today_pm25value     = pm25
                today_pm10value     = pm10

            return [status, pollen_index, yesterday, yesterday_pm25value, yesterday_pm10value, today, today_pm25value, today_pm10value]

    except:
        return [0, 0, "", 0, 0, "", 0, 0]
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
