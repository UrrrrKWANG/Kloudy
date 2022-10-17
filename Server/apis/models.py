from django.db import models

# Create your models here.
class Weather(models.Model):

    name = models.CharField(max_length=50)
    visibility = models.IntegerField()

    def __str__(self):
        return self.name