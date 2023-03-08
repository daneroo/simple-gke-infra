from django.shortcuts import render

# Create your views here.

import datetime
from django.http import JsonResponse

def current_time(request):
    now = datetime.datetime.now()
    response_data = {'time': now.strftime('%Y-%m-%d %H:%M:%S')}
    return JsonResponse(response_data)

