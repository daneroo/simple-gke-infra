from django.shortcuts import render

# Create your views here.

import datetime
from django.http import JsonResponse

def current_time(request):
    now = datetime.datetime.now()
    response_data = {'time': now.isoformat()+'Z','lang': 'Django/Python'}
    return JsonResponse(response_data)

