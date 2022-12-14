# Generated by Django 4.1.2 on 2022-12-09 14:37

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="CarwashIndexEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("status", models.IntegerField()),
                ("daily_weather", models.IntegerField()),
                ("day_max_temperature", models.FloatField()),
                ("daily_precipitation", models.FloatField()),
                ("tomorrow_weather", models.IntegerField()),
                ("tomorrow_precipitation", models.FloatField()),
                ("weather_3Am7pm", models.CharField(max_length=20)),
                ("pm10grade", models.IntegerField()),
                ("pollen_index", models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name="CarwashIndexOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("status", models.IntegerField()),
                ("daily_weather", models.IntegerField()),
                ("day_max_temperature", models.FloatField()),
                ("daily_precipitation", models.FloatField()),
                ("tomorrow_weather", models.IntegerField()),
                ("tomorrow_precipitation", models.FloatField()),
                ("weather_3Am7pm", models.CharField(max_length=20)),
                ("pm10grade", models.IntegerField()),
                ("pollen_index", models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name="LocalWeatherEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("local_code", models.CharField(max_length=10)),
                ("local_name", models.CharField(max_length=10)),
            ],
        ),
        migrations.CreateModel(
            name="LocalWeatherOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("local_code", models.CharField(max_length=10)),
                ("local_name", models.CharField(max_length=10)),
            ],
        ),
        migrations.CreateModel(
            name="Locations",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("daily_status_code", models.CharField(max_length=10)),
                ("daily_temperature_code", models.CharField(max_length=10)),
                ("engProvince", models.CharField(max_length=10)),
                ("province", models.CharField(max_length=10)),
                ("engCity", models.CharField(max_length=10)),
                ("city", models.CharField(max_length=10)),
                ("airCoditionMeasuring", models.CharField(max_length=10)),
                ("xCoordination", models.CharField(max_length=10)),
                ("yCoordination", models.CharField(max_length=10)),
                ("longitude", models.CharField(max_length=10)),
                ("latitude", models.CharField(max_length=10)),
            ],
        ),
        migrations.CreateModel(
            name="WeatherEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("today", models.CharField(max_length=10)),
                ("code", models.CharField(max_length=10)),
            ],
        ),
        migrations.CreateModel(
            name="WeatherOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("today", models.CharField(max_length=10)),
                ("code", models.CharField(max_length=10)),
            ],
        ),
        migrations.CreateModel(
            name="WeeklyWeatherOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("day", models.IntegerField()),
                ("status", models.IntegerField()),
                ("max_temperature", models.FloatField()),
                ("min_temperature", models.FloatField()),
                (
                    "local_weather",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="weekly_weather",
                        to="apis.localweatherodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="WeeklyWeatherEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("day", models.IntegerField()),
                ("status", models.IntegerField()),
                ("max_temperature", models.FloatField()),
                ("min_temperature", models.FloatField()),
                (
                    "local_weather",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="weekly_weather",
                        to="apis.localweathereven",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="WeatherIndexOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                (
                    "local_weather",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="weather_index",
                        to="apis.localweatherodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="WeatherIndexEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                (
                    "local_weather",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="weather_index",
                        to="apis.localweathereven",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="UmbrellaIndexOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("status", models.IntegerField()),
                ("precipitation_24h", models.FloatField()),
                ("precipitation_1h_max", models.FloatField()),
                ("precipitation_3h_max", models.FloatField()),
                ("wind", models.FloatField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="umbrella_index",
                        to="apis.weatherindexodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="UmbrellaIndexEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("status", models.IntegerField()),
                ("precipitation_24h", models.FloatField()),
                ("precipitation_1h_max", models.FloatField()),
                ("precipitation_3h_max", models.FloatField()),
                ("wind", models.FloatField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="umbrella_index",
                        to="apis.weatherindexeven",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="UmbrellaHourlyOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("time", models.IntegerField()),
                ("precipitation", models.FloatField()),
                (
                    "umbrella_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="umbrella_hourly",
                        to="apis.umbrellaindexodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="UmbrellaHourlyEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("time", models.IntegerField()),
                ("precipitation", models.FloatField()),
                (
                    "umbrella_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="umbrella_hourly",
                        to="apis.umbrellaindexeven",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="PrecipitationDailyOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("day", models.IntegerField()),
                ("precipitation", models.FloatField()),
                (
                    "carwash_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="precipitation_daily",
                        to="apis.carwashindexodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="PrecipitationDailyEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("day", models.IntegerField()),
                ("precipitation", models.FloatField()),
                (
                    "carwash_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="precipitation_daily",
                        to="apis.carwashindexeven",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="OuterIndexOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("status", models.IntegerField()),
                ("day_min_temperature", models.FloatField()),
                ("morning_temperature", models.FloatField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="outer_index",
                        to="apis.weatherindexodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="OuterIndexEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("status", models.IntegerField()),
                ("day_min_temperature", models.FloatField()),
                ("morning_temperature", models.FloatField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="outer_index",
                        to="apis.weatherindexeven",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="MaskIndexOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("status", models.IntegerField()),
                ("pollen_index", models.IntegerField()),
                ("yesterday", models.CharField(max_length=20)),
                ("yesterday_pm25value", models.FloatField()),
                ("yesterday_pm10value", models.FloatField()),
                ("today", models.CharField(max_length=20)),
                ("today_pm25value", models.FloatField()),
                ("today_pm10value", models.FloatField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="mask_index",
                        to="apis.weatherindexodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="MaskIndexEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("status", models.IntegerField()),
                ("pollen_index", models.IntegerField()),
                ("yesterday", models.CharField(max_length=20)),
                ("yesterday_pm25value", models.FloatField()),
                ("yesterday_pm10value", models.FloatField()),
                ("today", models.CharField(max_length=20)),
                ("today_pm25value", models.FloatField()),
                ("today_pm10value", models.FloatField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="mask_index",
                        to="apis.weatherindexeven",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="MainOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("current_weather", models.IntegerField()),
                ("current_temperature", models.FloatField()),
                ("day_max_temperature", models.FloatField()),
                ("day_min_temperature", models.FloatField()),
                (
                    "local_weather",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="main",
                        to="apis.localweatherodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="MainEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("current_weather", models.IntegerField()),
                ("current_temperature", models.FloatField()),
                ("day_max_temperature", models.FloatField()),
                ("day_min_temperature", models.FloatField()),
                (
                    "local_weather",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="main",
                        to="apis.localweathereven",
                    ),
                ),
            ],
        ),
        migrations.AddField(
            model_name="localweatherodd",
            name="weather",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="local_weather",
                to="apis.weatherodd",
            ),
        ),
        migrations.AddField(
            model_name="localweathereven",
            name="weather",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="local_weather",
                to="apis.weathereven",
            ),
        ),
        migrations.CreateModel(
            name="LaundryIndexOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("status", models.IntegerField()),
                ("humidity", models.FloatField()),
                ("day_max_temperature", models.FloatField()),
                ("daily_weather", models.IntegerField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="laundry_index",
                        to="apis.weatherindexodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="LaundryIndexEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("status", models.IntegerField()),
                ("humidity", models.FloatField()),
                ("day_max_temperature", models.FloatField()),
                ("daily_weather", models.IntegerField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="laundry_index",
                        to="apis.weatherindexeven",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="HumidityHourlyOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("time", models.IntegerField()),
                ("humidity", models.FloatField()),
                (
                    "laundry_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="humidity_hourly",
                        to="apis.laundryindexodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="HumidityHourlyEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("time", models.IntegerField()),
                ("humidity", models.FloatField()),
                (
                    "laundry_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="humidity_hourly",
                        to="apis.laundryindexeven",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="HourlyWeatherOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("hour", models.IntegerField()),
                ("status", models.IntegerField()),
                ("temperature", models.FloatField()),
                ("precipitation", models.FloatField()),
                (
                    "local_weather",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="hourly_weather",
                        to="apis.localweatherodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="HourlyWeatherEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("hour", models.IntegerField()),
                ("status", models.IntegerField()),
                ("temperature", models.FloatField()),
                ("precipitation", models.FloatField()),
                (
                    "local_weather",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="hourly_weather",
                        to="apis.localweathereven",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="CompareIndexOdd",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("yesterday", models.CharField(max_length=20)),
                ("yesterday_max_temperature", models.FloatField()),
                ("yesterday_min_temperature", models.FloatField()),
                ("today", models.CharField(max_length=20)),
                ("today_max_temperature", models.FloatField()),
                ("today_min_temperature", models.FloatField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="compare_index",
                        to="apis.weatherindexodd",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="CompareIndexEven",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("code", models.CharField(max_length=10)),
                ("yesterday", models.CharField(max_length=20)),
                ("yesterday_max_temperature", models.FloatField()),
                ("yesterday_min_temperature", models.FloatField()),
                ("today", models.CharField(max_length=20)),
                ("today_max_temperature", models.FloatField()),
                ("today_min_temperature", models.FloatField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="compare_index",
                        to="apis.weatherindexeven",
                    ),
                ),
            ],
        ),
        migrations.AddField(
            model_name="carwashindexodd",
            name="weather_index",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="carwash_index",
                to="apis.weatherindexodd",
            ),
        ),
        migrations.AddField(
            model_name="carwashindexeven",
            name="weather_index",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="carwash_index",
                to="apis.weatherindexeven",
            ),
        ),
    ]
