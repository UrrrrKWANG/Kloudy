from django.db import models


class Weather(models.Model):
    today = models.CharField(max_length=10)

class Main(models.Model):
    weather = models.ForeignKey(Weather, related_name="main", on_delete=models.CASCADE)
    current_weather = models.IntegerField()
    current_temperature = models.FloatField()
    day_max_temperature = models.FloatField()
    day_min_temperature = models.FloatField()
    
class WeatherIndex(models.Model):
    weather = models.ForeignKey(Weather, related_name="weather_index", on_delete=models.CASCADE)
    umbrella_index = models.FloatField()

class MaskIndex(models.Model):
    weather_index = models.ForeignKey(WeatherIndex, related_name="mask_index", on_delete=models.CASCADE)
    air_quality = models.IntegerField()
    flower_quality = models.IntegerField()
    dust_quality = models.IntegerField()

# class ByTime(models.Model):
#     hourly_weather = models.ForeignKey(HourlyWeatherInfo, on_delete=models.CASCADE)

# class ByWeek(models.Model):
#     daily_weather = models.ForeignKey(DailyWeatherInfo, on_delete=models.CASCADE)

# class HourlyWeatherInfo(models.Model):
#     status = model.IntegerField()
#     rain = model.FloatField()
#     temperature = model.IntegerField()

# class DailyWeatherInfo(models.Model):
#     status = model.IntegerField()
#     max_temperature = models.FloatField()
#     min_temperature = models.FloatField()