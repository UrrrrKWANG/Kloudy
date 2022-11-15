from rest_framework import serializers
from .models import *

class UmbrellaIndexSerializerOdd(serializers.ModelSerializer):
    class Meta:
        model = UmbrellaIndexOdd
        fields = [
            "status",
            "precipitaion_24h",
            "precipitaion_1h_max",
            "precipitation_3h_max",
            "wind"
        ]
    def create(self):
        return

    def update(self):
        return

class MaskIndexSerializerOdd(serializers.ModelSerializer):
    class Meta:
        model = MaskIndexOdd
        fields = [
            "status",
            "pm25value",
            "pm10value",
            "pollen_index"
        ]
    def create(self):
        return

    def update(self):
        return

class OuterIndexSerializerOdd(serializers.ModelSerializer):
    class Meta:
        model = OuterIndexOdd
        fields = [
            "status",
            "day_min_temperature",
            "morning_temperature"
        ]
    def create(self):
        return

    def update(self):
        return

class LaundryIndexSerializerOdd(serializers.ModelSerializer):
    class Meta:
        model = LaundryIndexOdd
        fields = [
            "status",
            "humidity",
            "day_max_temperature",
            "daily_weather"
        ]
    def create(self):
        return

    def update(self):
        return

class CarwashIndexSerializerOdd(serializers.ModelSerializer):
    class Meta:
        model = CarwashIndexOdd
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
    def create(self):
        return

    def update(self):
        return

class CompareIndexSerializerOdd(serializers.ModelSerializer):
    class Meta:
        model = CompareIndexOdd
        fields = [
            "yesterday_max_temperature",
            "yesterday_min_temperature",
            "today_max_temperature",
            "today_min_temperature",
        ]
    def create(self):
        return

    def update(self):
        return

class WeatherIndexSerializerOdd(serializers.ModelSerializer):
    umbrella_index = UmbrellaIndexSerializerOdd(many=True, read_only=True)
    mask_index = MaskIndexSerializerOdd(many=True, read_only=True)
    outer_index = OuterIndexSerializerOdd(many=True, read_only=True)
    laundry_index = LaundryIndexSerializerOdd(many=True, read_only=True)
    carwash_index = CarwashIndexSerializerOdd(many=True, read_only=True)
    compare_index = CompareIndexSerializerOdd(many=True, read_only=True)

    class Meta:
        model = WeatherIndexOdd
        fields = [
            "umbrella_index",
            "mask_index",
            "outer_index",
            "laundry_index",
            "carwash_index",
            "compare_index"
        ]

    def create(self, validated_data):
        new_weather_index = WeatherIndexOdd.objects.create(poll=1)
        new_weather_index.umbrella_index.set(validated_data['umbrella_index'])
        new_weather_index.mask_index.set(validated_data['mask_index'])
        new_weather_index.outer_index.set(validated_data['outer_index'])
        new_weather_index.laundry_index.set(validated_data['laundry_index'])
        new_weather_index.carwash_index.set(validated_data['carwash_index'])
        new_weather_index.compare_index.set(validated_data['compare_index'])

        return new_weather_index

    def update(self):
        return

class MainSerializerOdd(serializers.ModelSerializer):
    class Meta:
        model = MainOdd
        fields = [
            "current_weather",
            "current_temperature",
            "day_max_temperature",
            "day_min_temperature",
        ]
    def create(self):
        return

    def update(self):
        return

class WeeklyWeatherSerializerOdd(serializers.ModelSerializer):
    class Meta:
        model = WeeklyWeatherOdd
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

class HourlyWeatherSerializerOdd(serializers.ModelSerializer):
    class Meta:
        model = HourlyWeatherOdd
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

class LocalWeatherSerializerOdd(serializers.ModelSerializer):
    main = MainSerializerOdd(many=True, read_only=True)
    weather_index = WeatherIndexSerializerOdd(many=True, read_only=True)
    weekly_weather = WeeklyWeatherSerializerOdd(many=True, read_only=True)
    hourly_weather = HourlyWeatherSerializerOdd(many=True, read_only=True)

    class Meta:
        model = LocalWeatherOdd
        fields = [
            "local_code",
            "local_name",
            "main",
            "weather_index",
            "weekly_weather",
            "hourly_weather"
        ]

    def create(self):
        return

    def update(self):
        return

class WeatherSerializerOdd(serializers.ModelSerializer):
    local_weather = LocalWeatherSerializerOdd(many=True, read_only=True)

    class Meta:
        model = WeatherOdd
        fields = [
            "today",
            "local_weather"
        ]

    def create(self):
        return

    def update(self):
        return

############


class UmbrellaIndexSerializerEven(serializers.ModelSerializer):
    class Meta:
        model = UmbrellaIndexEven
        fields = [
            "status",
            "precipitaion_24h",
            "precipitaion_1h_max",
            "precipitation_3h_max",
            "wind"
        ]
    def create(self):
        return

    def update(self):
        return

class MaskIndexSerializerEven(serializers.ModelSerializer):
    class Meta:
        model = MaskIndexEven
        fields = [
            "status",
            "pm25value",
            "pm10value",
            "pollen_index"
        ]
    def create(self):
        return

    def update(self):
        return

class OuterIndexSerializerEven(serializers.ModelSerializer):
    class Meta:
        model = OuterIndexEven
        fields = [
            "status",
            "day_min_temperature",
            "morning_temperature"
        ]
    def create(self):
        return

    def update(self):
        return

class LaundryIndexSerializerEven(serializers.ModelSerializer):
    class Meta:
        model = LaundryIndexEven
        fields = [
            "status",
            "humidity",
            "day_max_temperature",
            "daily_weather"
        ]
    def create(self):
        return

    def update(self):
        return

class CarwashIndexSerializerEven(serializers.ModelSerializer):
    class Meta:
        model = CarwashIndexEven
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
    def create(self):
        return

    def update(self):
        return

class CompareIndexSerializerEven(serializers.ModelSerializer):
    class Meta:
        model = CompareIndexEven
        fields = [
            "yesterday_max_temperature",
            "yesterday_min_temperature",
            "today_max_temperature",
            "today_min_temperature",
        ]
    def create(self):
        return

    def update(self):
        return

class WeatherIndexSerializerEven(serializers.ModelSerializer):
    umbrella_index = UmbrellaIndexSerializerEven(many=True, read_only=True)
    mask_index = MaskIndexSerializerEven(many=True, read_only=True)
    outer_index = OuterIndexSerializerEven(many=True, read_only=True)
    laundry_index = LaundryIndexSerializerEven(many=True, read_only=True)
    carwash_index = CarwashIndexSerializerEven(many=True, read_only=True)
    compare_index = CompareIndexSerializerEven(many=True, read_only=True)

    class Meta:
        model = WeatherIndexEven
        fields = [
            "umbrella_index",
            "mask_index",
            "outer_index",
            "laundry_index",
            "carwash_index",
            "compare_index"
        ]

    def create(self, validated_data):
        new_weather_index = WeatherIndexEven.objects.create(poll=1)
        new_weather_index.umbrella_index.set(validated_data['umbrella_index'])
        new_weather_index.mask_index.set(validated_data['mask_index'])
        new_weather_index.outer_index.set(validated_data['outer_index'])
        new_weather_index.laundry_index.set(validated_data['laundry_index'])
        new_weather_index.carwash_index.set(validated_data['carwash_index'])
        new_weather_index.compare_index.set(validated_data['compare_index'])

        return new_weather_index

    def update(self):
        return

class MainSerializerEven(serializers.ModelSerializer):
    class Meta:
        model = MainEven
        fields = [
            "current_weather",
            "current_temperature",
            "day_max_temperature",
            "day_min_temperature",
        ]
    def create(self):
        return

    def update(self):
        return

class WeeklyWeatherSerializerEven(serializers.ModelSerializer):
    class Meta:
        model = WeeklyWeatherEven
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

class HourlyWeatherSerializerEven(serializers.ModelSerializer):
    class Meta:
        model = HourlyWeatherEven
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

class LocalWeatherSerializerEven(serializers.ModelSerializer):
    main = MainSerializerEven(many=True, read_only=True)
    weather_index = WeatherIndexSerializerEven(many=True, read_only=True)
    weekly_weather = WeeklyWeatherSerializerEven(many=True, read_only=True)
    hourly_weather = HourlyWeatherSerializerEven(many=True, read_only=True)

    class Meta:
        model = LocalWeatherEven
        fields = [
            "local_code",
            "local_name",
            "main",
            "weather_index",
            "weekly_weather",
            "hourly_weather"
        ]
    def create(self):
        return

    def update(self):
        return

class WeatherSerializerEven(serializers.ModelSerializer):
    local_weather = LocalWeatherSerializerEven(many=True, read_only=True)

    class Meta:
        model = WeatherEven
        fields = [
            "today",
            "local_weather"
        ]

    def create(self):
        return

    def update(self):
        return