from django.apps import AppConfig


class MyAppConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = "kloudy"

    def ready(self):
        from .views import csv_reader
        from .scheduler import scheduler
        
        # 먼저 요청정보를 보냄
        csv_reader()
        print("start Scheduler....")
        scheduler.start()
