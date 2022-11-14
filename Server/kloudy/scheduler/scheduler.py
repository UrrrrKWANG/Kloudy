from apscheduler.schedulers.background import BackgroundScheduler
from .. import views

def start():
    scheduler = BackgroundScheduler()
    myView = views
    scheduler.add_job(myView.time_interval_weather, "cron", minute=52)
    # scheduler.add_job(myView.time_interval_weather, "cron", minute=00)
    scheduler.start()