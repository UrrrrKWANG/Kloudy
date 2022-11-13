# Generated by Django 4.1.2 on 2022-11-13 11:16

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="LocalWeather",
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
            name="Weather",
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
            ],
        ),
        migrations.CreateModel(
            name="WeeklyWeather",
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
                        to="apis.localweather",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="WeatherIndex",
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
                        to="apis.localweather",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="UmbrellaIndex",
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
                ("precipitaion_24h", models.FloatField()),
                ("precipitaion_1h_max", models.FloatField()),
                ("precipitation_3h_max", models.FloatField()),
                ("wind", models.FloatField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="umbrealla_index",
                        to="apis.weatherindex",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="OuterIndex",
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
                        to="apis.weatherindex",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="MaskIndex",
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
                ("pm25value", models.FloatField()),
                ("pm10value", models.FloatField()),
                ("pollen_index", models.IntegerField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="mask_index",
                        to="apis.weatherindex",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Main",
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
                        to="apis.localweather",
                    ),
                ),
            ],
        ),
        migrations.AddField(
            model_name="localweather",
            name="weather",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="local_weather",
                to="apis.weather",
            ),
        ),
        migrations.CreateModel(
            name="LaundryIndex",
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
                        to="apis.weatherindex",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="HourlyWeather",
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
                        to="apis.localweather",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="CompareIndex",
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
                        to="apis.weatherindex",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="CarwashIndex",
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
                ("day_min_temperature", models.FloatField()),
                ("daily_precipitation", models.FloatField()),
                ("tomorrow_weather", models.IntegerField()),
                ("tomorrow_precipitation", models.FloatField()),
                ("weather_3Am7pm", models.CharField(max_length=20)),
                ("pm10grade", models.IntegerField()),
                ("pollen_index", models.IntegerField()),
                (
                    "weather_index",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="carwash_index",
                        to="apis.weatherindex",
                    ),
                ),
            ],
        ),
    ]
