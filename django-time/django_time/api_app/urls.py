from django.urls import path
from . import views

urlpatterns = [
    path('time', views.current_time, name='current_time'),
    # other URL patterns go here
]
