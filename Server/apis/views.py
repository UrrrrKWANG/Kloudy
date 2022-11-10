from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .api_calls import weatherAPI
from .serializers import WeatherSerializer
from .models import Locations
# Create your views here.

# 지역 코드를 기반으로 DB에서 받아옴.
@api_view(["GET"])
def getWeathers(request):

    code = request.GET.get("code")
    location = Locations.objects.get(code=code)

    print(location.xCoordination, location.yCoordination, location.airCoditionMeasuring, location.code)
    
    # weather = weatherAPI.weatherAPI(day, time, x_coordinate, y_coordinate, air_condition_measuring, code)

    # serializer = WeatherSerializer(weather)

    # return Response(serializer.data)
    return

def calculateTime():
    return