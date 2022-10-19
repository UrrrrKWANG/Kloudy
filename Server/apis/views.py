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
    
    weather = weatherAPI.weatherAPI(day, time, x_coordinate, y_coordinate)
    print(weather.main)

    serializer = WeatherSerializer(weather)

    return Response(serializer.data)