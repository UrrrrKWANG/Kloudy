from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .api_calls import weatherAPI
from .serializers import WeatherSerializer
# Create your views here.

@api_view(["GET"])
def getWeathers(request):

    weather = weatherAPI.weatherAPI()
    serializer = WeatherSerializer(weather)

    return Response(serializer.data)