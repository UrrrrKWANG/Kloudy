from apis.models import CompareIndexEven, CompareIndexOdd
import datetime

def get_compare_index(weather_24h_jsonObject, day_we_got, isFisrtTime, code):
    if weather_24h_jsonObject.get('response').get('header').get('resultCode') != "00":
        return ["", 0, 0, "", 0, 0]
    # 전전날 날씨는 못받아 오기 때문에 처음 만들 때는 일단 똑같이 보내주고, 
    # 그게 아니면 현재 DB에 저장된 것을 어제로 바꾸고, 현재 날씨를 넣어줘야함.
    # 근데 30분마다 실행되기 때문에 업데이트할 때는 오늘 날짜를 체크해줘야함.
    yesterday                 = ""
    yesterday_max_temperature = 0.0
    yesterday_min_temperature = 0.0
    today                     = ""
    today_max_temperature     = 0.0
    today_min_temperature     = 0.0

    if isFisrtTime:
        yesterday = day_we_got
        today = day_we_got
        # min max 찾아서 어제 오늘 똑같이 내뱉어줌.
        for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):
            if obj.get('category') == 'TMX':
                today_max_temperature = float(obj.get('fcstValue'))
                yesterday_max_temperature = today_max_temperature
            elif obj.get('category') == 'TMN':
                today_min_temperature = float(obj.get('fcstValue'))
                yesterday_min_temperature = today_min_temperature
        
    else:
        time = int(datetime.datetime.now().strftime("%H"))
        if time % 2 != 0:
            compare_index = CompareIndexEven.objects.filter(code = code).first()
        else:
            compare_index = CompareIndexOdd.objects.filter(code = code).first()

        # code로 compare_index 잡아줌.
        # 업데이트 해야하는지 확인 (가져온 compare_index의 today와 현재 today가 같으면 업데이트 안함.)
        if compare_index.today == day_we_got:
            yesterday                 = compare_index.yesterday
            yesterday_max_temperature = compare_index.yesterday_max_temperature
            yesterday_min_temperature = compare_index.yesterday_min_temperature
            today                     = compare_index.today
            today_max_temperature     = compare_index.today_max_temperature
            today_min_temperature     = compare_index.today_min_temperature

        else:
            # 업데이트 해야하면 가져온 compare_index의 today 지수들을 yesterday로 넣어주고
            # 오늘의 min max를 찾아서 today로 넣어줌.
            yesterday = compare_index.today
            today = day_we_got
            for obj in weather_24h_jsonObject.get('response').get('body').get('items').get('item'):
                if obj.get('category') == 'TMX':
                    today_max_temperature = float(obj.get('fcstValue'))
                    yesterday_max_temperature = compare_index.today_max_temperature
                elif obj.get('category') == 'TMN':
                    today_min_temperature = float(obj.get('fcstValue'))
                    yesterday_min_temperature = compare_index.today_min_temperature

    return [yesterday, yesterday_max_temperature, yesterday_min_temperature, today, today_max_temperature, today_min_temperature]
