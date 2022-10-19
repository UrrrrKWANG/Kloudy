from django.db import models


class Weather(models.Model):
    today = models.CharField(max_length=10)
    # main = models.ForeignKey(Main, related_name='main', on_delete=models.CASCADE)

    # 나중에 사용 예정
    # weather_index = models.ForeignKey(WeatherIndex, on_delete=models.CASCADE)
    # by_time = models.ForeignKey(ByTime, on_delete=models.CASCADE)
    # by_week = models.ForeignKey(ByWeek, on_delete=models.CASCADE)

class Main(models.Model):
    weather = models.ForeignKey(Weather, related_name="main", on_delete=models.CASCADE)
    current_weather = models.IntegerField()
    current_temperature = models.FloatField()
    day_max_temperature = models.FloatField()
    day_min_temperature = models.FloatField()
    

# 나중에 사용 예정
# class WeatherIndex(models.Model):
#     umbrella_index = models.IntegerField()
#     mask_index = models.IntegerField()

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