from django.db import models

class Locations(models.Model):
    code = models.CharField(max_length=10)
    daily_status_code = models.CharField(max_length=10)
    daily_temperature_code = models.CharField(max_length=10)
    engProvince = models.CharField(max_length=10)
    province = models.CharField(max_length=10)
    engCity = models.CharField(max_length=10)
    city = models.CharField(max_length=10)
    airCoditionMeasuring = models.CharField(max_length=10)
    xCoordination = models.CharField(max_length=10)
    yCoordination = models.CharField(max_length=10)
    longitude = models.CharField(max_length=10)
    latitude = models.CharField(max_length=10)
    
    def __str__(self):
        return self.city
    
class Weather(models.Model):
    today = models.CharField(max_length=10)

class LocalWeather(models.Model):
    weather = models.ForeignKey(Weather, related_name="local_weather", on_delete=models.CASCADE)
    local_code = models.CharField(max_length=10)
    local_name = models.CharField(max_length=10)

class Main(models.Model):
    local_weather = models.ForeignKey(LocalWeather, related_name="main", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    current_weather = models.IntegerField()
    current_temperature = models.FloatField()
    day_max_temperature = models.FloatField()
    day_min_temperature = models.FloatField()
    
class WeatherIndex(models.Model):
    local_weather = models.ForeignKey(LocalWeather, related_name="weather_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    
class UmbrellaIndex(models.Model):
    weather_index = models.ForeignKey(WeatherIndex, related_name="umbrealla_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    precipitaion_24h = models.FloatField()
    precipitaion_1h_max = models.FloatField()
    precipitation_3h_max = models.FloatField()
    wind = models.FloatField()

class MaskIndex(models.Model):
    weather_index = models.ForeignKey(WeatherIndex, related_name="mask_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    pm25value = models.FloatField()
    pm10value = models.FloatField()
    pollen_index = models.IntegerField()

class OuterIndex(models.Model):
    weather_index = models.ForeignKey(WeatherIndex, related_name="outer_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    day_min_temperature = models.FloatField()
    morning_temperature = models.FloatField()

class LaundryIndex(models.Model):
    weather_index = models.ForeignKey(WeatherIndex, related_name="laundry_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    humidity = models.FloatField()
    day_max_temperature = models.FloatField()
    daily_weather = models.IntegerField()

class CarwashIndex(models.Model):
    weather_index = models.ForeignKey(WeatherIndex, related_name="carwash_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    daily_weather = models.IntegerField()
    day_min_temperature = models.FloatField()
    daily_precipitation = models.FloatField()
    tomorrow_weather = models.IntegerField()
    tomorrow_precipitation = models.FloatField()
    weather_3Am7pm = models.CharField(max_length=20)
    pm10grade = models.IntegerField()
    pollen_index = models.IntegerField()

class CompareIndex(models.Model):
    weather_index = models.ForeignKey(WeatherIndex, related_name="compare_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    yesterday = models.CharField(max_length=20)
    yesterday_max_temperature = models.FloatField()
    yesterday_min_temperature = models.FloatField()
    today = models.CharField(max_length=20)
    today_max_temperature = models.FloatField()
    today_min_temperature = models.FloatField()

# Week
class WeeklyWeather(models.Model):
    local_weather = models.ForeignKey(LocalWeather, related_name="weekly_weather", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    day = models.IntegerField()
    status = models.IntegerField()
    max_temperature = models.FloatField()
    min_temperature = models.FloatField()

# Hour
class HourlyWeather(models.Model):
    local_weather = models.ForeignKey(LocalWeather, related_name="hourly_weather", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    hour = models.IntegerField()
    status = models.IntegerField()
    temperature = models.FloatField()
    precipitation = models.FloatField()
    