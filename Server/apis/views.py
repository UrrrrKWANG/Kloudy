from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .api_calls import weatherAPI
from .serializers import WeatherSerializer
# Create your views here.

@api_view(["GET"])
def getWeathers(request):

    day = request.GET.get("day")
    time = request.GET.get("time")
    x_coordinate = request.GET.get("x")
    y_coordinate = request.GET.get("y")
    air_condition_measuring = request.GET.get("air")
    code = request.GET.get("code")

    weather = weatherAPI.weatherAPI(day, time, x_coordinate, y_coordinate, air_condition_measuring, code)

    serializer = WeatherSerializer(weather)

    return Response(serializer.data)