# Generated by Django 4.1.2 on 2022-11-09 13:48

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("apis", "0001_initial"),
    ]

    operations = [
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
    ]
