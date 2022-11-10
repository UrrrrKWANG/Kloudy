from apscheduler.schedulers.background import BackgroundScheduler
from .. import views

def start():
    scheduler = BackgroundScheduler()
    myView = views
    scheduler.add_job(myView.time_interval_weather_30, "cron", minute='*')
    scheduler.add_job(myView.time_interval_weather_00, "cron", minute=00)
    scheduler.start()