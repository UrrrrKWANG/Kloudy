from rest_framework import serializers
from .models import *

class MainSerializer(serializers.ModelSerializer):
    class Meta:
        model = Main
        fields = (
            "current_weather",
            "current_temperature",
            "day_max_temperature",
            "day_min_temperature",
        )

# class WeatherIndex(serializers.ModelSerializer):
#     class Meta:
#         model = WeatherIndex
#         fields = (
#             "umbrella_index",
#             "mask_index",
#         )

# class ByTime(serializers.ModelSerializer):
#     class Meta:
#         model = ByTime
#         fields = (
#             "hourly_weather",
#         )

class WeatherSerializer(serializers.ModelSerializer):

    class Meta:
        model = Weather
        fields = "__all__"

    def create(self):
        # data를 받아서 각 객체를 생성한 후에 다 넣어줘야함.
        return

    def update(self):
        return