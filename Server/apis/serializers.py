from rest_framework import serializers
from .models import *

class MaskIndexSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaskIndex
        fields = [
            "air_quality",
            "flower_quality",
            "dust_quality",
        ]

class WeatherIndexSerializer(serializers.ModelSerializer):
    mask_index = MaskIndexSerializer(many=True, read_only=True)
    class Meta:
        model = WeatherIndex
        fields = [
            "umbrella_index",
            "mask_index"
        ]
    def create(self):
        # data를 받아서 각 객체를 생성한 후에 다 넣어줘야함.
        return

    def update(self):
        return

class MainSerializer(serializers.ModelSerializer):
    class Meta:
        model = Main
        fields = [
            "current_weather",
            "current_temperature",
            "day_max_temperature",
            "day_min_temperature",
        ]

class WeatherSerializer(serializers.ModelSerializer):
    main = MainSerializer(many=True, read_only=True)
    weather_index = WeatherIndexSerializer(many=True, read_only=True)

    class Meta:
        model = Weather
        fields = ["today", "main", "weather_index"]

    def create(self):
        # data를 받아서 각 객체를 생성한 후에 다 넣어줘야함.
        return

    def update(self):
        return


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
