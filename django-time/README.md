# Django start (in CodeSpaces)

```bash
python -m venv .venv
python -m pip install Django

$ python -m django --version
4.1.7

python manage.py startapp timesvc
```

Start again
```bash
mkdir django_time
cd django_time
python3 -m venv env
. env/bin/activate # MAC or Linux 

django-admin startproject django_time
cd django_time/
python3 manage.py startapp api_app
# add 'rest_framework',    'api_app', to settings/INSTALLED_APPS
python3 manage.py migrate  # Initialize database
python3 manage.py createsuperuser # Prompts for username and password

python3 manage.py runserver
curl http://127.0.0.1:8000/api/time
```