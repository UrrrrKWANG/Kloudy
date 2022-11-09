from django.apps import AppConfig


class MyAppConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = "kloudy"

    def ready(self):
        from apis.models import Locations
        import os
        import django
        import csv
        import sys

        CSV_PATH = './kloudy/csv/Locations.csv'

        def csv_reader():    
            with open(CSV_PATH, newline='', encoding='utf8') as csvfile:
                data_reader = csv.DictReader(csvfile)
                for row in data_reader:
                    if not Locations.objects.filter(code=row['code']).exists():
                        Locations.objects.create(
                            code = row['code'],
                            daily_status_code = row['daily_status_code'],
                            daily_temperature_code = row['daily_temperature_code'],
                            engProvince = row['engProvince'],
                            province = row['province'],
                            engCity = row['engCity'],
                            city = row['city'],
                            airCoditionMeasuring = row['airCoditionMeasuring'],
                            xCoordination = row['xCoordination'],
                            yCoordination = row['yCoordination'],
                            longitude = row['longitude'],
                            latitude = row['latitude']
                            )
            print('LOCATION DATA UPLOADED SUCCESSFULY!')
            return

        csv_reader()