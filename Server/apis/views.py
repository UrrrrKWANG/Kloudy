from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .api_calls import weatherAPI
from .serializers import WeatherSerializerOdd, WeatherSerializerEven
from .models import *
import datetime

# 지역 코드를 기반으로 DB에서 받아옴.
@api_view(["GET"])
def getWeathers(request):
    code = request.GET.get("code")

    now = datetime.datetime.now()
    today = now.strftime("%Y%m%d")
    hour = int(now.strftime("%H"))
    if hour <= 1:
        today = str(int(today) - 1)

    print(today, hour, code)
    # 홀수일 때는 짝수 시간 대를 업데이트함으로 짝수일 때 짝수 시간 대를 가져간다.
    if hour % 2 == 0:
        print("짝수시간대")
        weather = WeatherEven.objects.filter(code = code).first()
        print(weather)
        serializer = WeatherSerializerEven(weather)
        return Response(serializer.data)

    else:
        print("홀수시간대")
        weather = WeatherOdd.objects.filter(code = code).first()
        serializer = WeatherSerializerOdd(weather)
        return Response(serializer.data)


    