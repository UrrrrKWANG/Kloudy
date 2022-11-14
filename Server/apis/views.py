from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .api_calls import weatherAPI
from .serializers import WeatherSerializer
from .models import *
import datetime

# 지역 코드를 기반으로 DB에서 받아옴.
@api_view(["GET"])
def getWeathers(request):

    code = request.GET.get("code")
    location = Locations.objects.get(code = code)
    print("현재 요청")
    print(location.xCoordination, location.yCoordination, location.airCoditionMeasuring, location.code)

    now = datetime.datetime.now()
    today = now.strftime("%Y%m%d")
    weather = Weather.objects.filter(today = today, code = code).first()

    serializer = WeatherSerializer(weather)
    return Response(serializer.data)
    # return