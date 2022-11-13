from rest_framework import serializers
from .models import *

class UmbrellaIndexSerializer(serializers.ModelSerializer):
    class Meta:
        model = UmbrellaIndex
        fields = [
            "status",
            "precipitaion_24h",
            "precipitaion_1h_max",
            "precipitation_3h_max",
            "wind"
        ]

class MaskIndexSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaskIndex
        fields = [
            "status",
            "pm25value",
            "pm10value",
            "pollen_index"
        ]

class OuterIndexSerializer(serializers.ModelSerializer):
    class Meta:
        model = OuterIndex
        fields = [
            "status",
            "day_min_temperature",
            "morning_temperature"
        ]

class LaundryIndexSerializer(serializers.ModelSerializer):
    class Meta:
        model = LaundryIndex
        fields = [
            "status",
            "humidity",
            "day_max_temperature",
            "daily_weather"
        ]

class CarwashIndexSerializer(serializers.ModelSerializer):
    class Meta:
        model = CarwashIndex
        fields = [
            "status",
            "daily_weather",
            "day_min_temperature",
            "daily_precipitation",
            "tomorrow_weather",
            "tomorrow_precipitation",
            "weather_3Am7pm",
            "pm10grade",
            "pollen_index"
        ]

class CompareIndexSerializer(serializers.ModelSerializer):
    class Meta:
        model = CompareIndex
        fields = [
            "yesterday_max_temperature",
            "yesterday_min_temperature",
            "today_max_temperature",
            "today_min_temperature",
        ]

class WeatherIndexSerializer(serializers.ModelSerializer):
    umbrella_index = UmbrellaIndexSerializer(many=True, read_only=True)
    mask_index = MaskIndexSerializer(many=True, read_only=True)
    outer_index = OuterIndexSerializer(many=True, read_only=True)
    laundry_index = LaundryIndexSerializer(many=True, read_only=True)
    carwash_index = CarwashIndexSerializer(many=True, read_only=True)
    compare_index = CompareIndexSerializer(many=True, read_only=True)

    class Meta:
        model = WeatherIndex
        fields = [
            "umbrella_index",
            "mask_index",
            "outer_index",
            "laundry_index",
            "carwash_index",
            "compare_index"
        ]

    def create(self):
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

class WeeklyWeatherSerializer(serializers.ModelSerializer):
    class Meta:
        model = WeeklyWeather
        fields = [
            "day",
            "status",
            "max_temperature",
            "min_temperature",
        ]
    def create(self):
        return

    def update(self):
        return

class HourlyWeatherSerializer(serializers.ModelSerializer):
    class Meta:
        model = HourlyWeather
        fields = [
            "hour",
            "status",
            "temperature",
            "precipitation",
        ]
    def create(self):
        return

    def update(self):
        return

class LocalWeatherSerializer(serializers.ModelSerializer):
    main = MainSerializer(many=True, read_only=True)
    weather_index = WeatherIndexSerializer(many=True, read_only=True)
    weekly_weather = WeeklyWeatherSerializer(many=True, read_only=True)
    hourly_weather = HourlyWeatherSerializer(many=True, read_only=True)

    class Meta:
        model = LocalWeather
        fields = [
            "local_code",
            "local_name",
            "main",
            "weather_index",
            "weekly_weather",
            "hourly_weather"
        ]

class WeatherSerializer(serializers.ModelSerializer):
    local_weather = LocalWeatherSerializer(many=True, read_only=True)

    class Meta:
        model = Weather
        fields = [
            "today",
            "local_weather"
        ]

    def create(self):
        return

    def update(self):
        return