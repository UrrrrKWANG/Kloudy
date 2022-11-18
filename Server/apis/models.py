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
    
class WeatherOdd(models.Model):
    today = models.CharField(max_length=10)
    code = models.CharField(max_length=10)

class LocalWeatherOdd(models.Model):
    weather = models.ForeignKey(WeatherOdd, related_name="local_weather", on_delete=models.CASCADE)
    local_code = models.CharField(max_length=10)
    local_name = models.CharField(max_length=10)

class MainOdd(models.Model):
    local_weather = models.ForeignKey(LocalWeatherOdd, related_name="main", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    current_weather = models.IntegerField()
    current_temperature = models.FloatField()
    day_max_temperature = models.FloatField()
    day_min_temperature = models.FloatField()
    
class WeatherIndexOdd(models.Model):
    local_weather = models.ForeignKey(LocalWeatherOdd, related_name="weather_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    
class UmbrellaIndexOdd(models.Model):
    weather_index = models.ForeignKey(WeatherIndexOdd, related_name="umbrella_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    precipitation_24h = models.FloatField()
    precipitation_1h_max = models.FloatField()
    precipitation_3h_max = models.FloatField()
    wind = models.FloatField()

class MaskIndexOdd(models.Model):
    weather_index = models.ForeignKey(WeatherIndexOdd, related_name="mask_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    pm25value = models.FloatField()
    pm10value = models.FloatField()
    pollen_index = models.IntegerField()

class OuterIndexOdd(models.Model):
    weather_index = models.ForeignKey(WeatherIndexOdd, related_name="outer_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    day_min_temperature = models.FloatField()
    morning_temperature = models.FloatField()

class LaundryIndexOdd(models.Model):
    weather_index = models.ForeignKey(WeatherIndexOdd, related_name="laundry_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    humidity = models.FloatField()
    day_max_temperature = models.FloatField()
    daily_weather = models.IntegerField()

class CarwashIndexOdd(models.Model):
    weather_index = models.ForeignKey(WeatherIndexOdd, related_name="carwash_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    daily_weather = models.IntegerField()
    day_max_temperature = models.FloatField()
    daily_precipitation = models.FloatField()
    tomorrow_weather = models.IntegerField()
    tomorrow_precipitation = models.FloatField()
    weather_3Am7pm = models.CharField(max_length=20)
    pm10grade = models.IntegerField()
    pollen_index = models.IntegerField()

class CompareIndexOdd(models.Model):
    weather_index = models.ForeignKey(WeatherIndexOdd, related_name="compare_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    yesterday = models.CharField(max_length=20)
    yesterday_max_temperature = models.FloatField()
    yesterday_min_temperature = models.FloatField()
    today = models.CharField(max_length=20)
    today_max_temperature = models.FloatField()
    today_min_temperature = models.FloatField()

# Week
class WeeklyWeatherOdd(models.Model):
    local_weather = models.ForeignKey(LocalWeatherOdd, related_name="weekly_weather", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    day = models.IntegerField()
    status = models.IntegerField()
    max_temperature = models.FloatField()
    min_temperature = models.FloatField()

# Hour
class HourlyWeatherOdd(models.Model):
    local_weather = models.ForeignKey(LocalWeatherOdd, related_name="hourly_weather", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    hour = models.IntegerField()
    status = models.IntegerField()
    temperature = models.FloatField()
    precipitation = models.FloatField()

#################

class WeatherEven(models.Model):
    today = models.CharField(max_length=10)
    code = models.CharField(max_length=10)

class LocalWeatherEven(models.Model):
    weather = models.ForeignKey(WeatherEven, related_name="local_weather", on_delete=models.CASCADE)
    local_code = models.CharField(max_length=10)
    local_name = models.CharField(max_length=10)

class MainEven(models.Model):
    local_weather = models.ForeignKey(LocalWeatherEven, related_name="main", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    current_weather = models.IntegerField()
    current_temperature = models.FloatField()
    day_max_temperature = models.FloatField()
    day_min_temperature = models.FloatField()
    
class WeatherIndexEven(models.Model):
    local_weather = models.ForeignKey(LocalWeatherEven, related_name="weather_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    
class UmbrellaIndexEven(models.Model):
    weather_index = models.ForeignKey(WeatherIndexEven, related_name="umbrella_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    precipitation_24h = models.FloatField()
    precipitation_1h_max = models.FloatField()
    precipitation_3h_max = models.FloatField()
    wind = models.FloatField()

class MaskIndexEven(models.Model):
    weather_index = models.ForeignKey(WeatherIndexEven, related_name="mask_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    pm25value = models.FloatField()
    pm10value = models.FloatField()
    pollen_index = models.IntegerField()

class OuterIndexEven(models.Model):
    weather_index = models.ForeignKey(WeatherIndexEven, related_name="outer_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    day_min_temperature = models.FloatField()
    morning_temperature = models.FloatField()

class LaundryIndexEven(models.Model):
    weather_index = models.ForeignKey(WeatherIndexEven, related_name="laundry_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    humidity = models.FloatField()
    day_max_temperature = models.FloatField()
    daily_weather = models.IntegerField()

class CarwashIndexEven(models.Model):
    weather_index = models.ForeignKey(WeatherIndexEven, related_name="carwash_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    status = models.IntegerField()
    daily_weather = models.IntegerField()
    day_max_temperature = models.FloatField()
    daily_precipitation = models.FloatField()
    tomorrow_weather = models.IntegerField()
    tomorrow_precipitation = models.FloatField()
    weather_3Am7pm = models.CharField(max_length=20)
    pm10grade = models.IntegerField()
    pollen_index = models.IntegerField()

class CompareIndexEven(models.Model):
    weather_index = models.ForeignKey(WeatherIndexEven, related_name="compare_index", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    yesterday = models.CharField(max_length=20)
    yesterday_max_temperature = models.FloatField()
    yesterday_min_temperature = models.FloatField()
    today = models.CharField(max_length=20)
    today_max_temperature = models.FloatField()
    today_min_temperature = models.FloatField()

# Week
class WeeklyWeatherEven(models.Model):
    local_weather = models.ForeignKey(LocalWeatherEven, related_name="weekly_weather", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    day = models.IntegerField()
    status = models.IntegerField()
    max_temperature = models.FloatField()
    min_temperature = models.FloatField()

# Hour
class HourlyWeatherEven(models.Model):
    local_weather = models.ForeignKey(LocalWeatherEven, related_name="hourly_weather", on_delete=models.CASCADE)
    code = models.CharField(max_length=10)
    hour = models.IntegerField()
    status = models.IntegerField()
    temperature = models.FloatField()
    precipitation = models.FloatField()