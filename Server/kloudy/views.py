# import os
# import django
# import csv
# import sys


# # system setup
# os.chdir('.')
# print('Current dir의 경로 : ', end=''), print(os.getcwd())               # os가 파악한 현재 경로를 표기
# print('os.path.abspath(__file__)의 경로 : ',os.path.abspath(__file__))    # 현재 작업중인 파일을 포함 경로를 구체적으로 표기
# BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# print('BASE_DIR=', end=''), print(BASE_DIR)
# print('똑같나? 다르나?', BASE_DIR == os.getcwd()) # 소문자 c , 대문자 C 차이 때문인것 같네요.

# sys.path.append(BASE_DIR)  # sys 모듈은 파이썬을 설치할 때 함께 설치되는 라이브러리 모듈이다. sys에 대해서는 뒤에서 자세하게 다룰 것이다. 이 sys 모듈을 사용하면 파이썬 라이브러리가 설치되어 있는 디렉터리를 확인할 수 있다.
# os.environ.setdefault("DJANGO_SETTINGS_MODULE", 'kloudy.settings') 
#  # python이 실행될 때 DJANGO_SETTINGS_MODULE라는 환경 변수에
# # 현재 프로젝트의 settings.py 파일 경로를 등록
# django.setup() # python manage.py shell 을 실행하는 것이랑 비슷한 방법이다. 즉 파이썬 파일에서도 django를 실행 시킬수 있다.

# # import model
# from .models import Location

# # insert data while reading csv file into table
# CSV_PATH = './csv/Locations.csv'

# # open csv file and insert row data in MySQL

# # Menu Table

# def csv_reader():    
#     # with open(CSV_PATH, newline='', encoding='utf8') as csvfile:
#     #     data_reader = csv.DictReader(csvfile)
#     #     for row in data_reader:
#     #         if not Menu.objects.filter(name=row['menu']).exists():
#     #             menu_id = Menu.objects.create(
#     #                 name = row['menu'] )
#     print('MENU DATA UPLOADED SUCCESSFULY!')
#     return

