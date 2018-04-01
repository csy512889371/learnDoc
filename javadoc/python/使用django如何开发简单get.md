# 使用django如何开发简单get

## 概述
如何安装Django 请看 [Pycharm python 及 Django 安装详细教程](https://blog.csdn.net/qq_27384769/article/details/79767998)


## 代码


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/20.png)


### 1、login.html

登录页面:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>login</title>
</head>
<body>
<form action="/login/" method="POST">
    <h1>用户名: <input name="username"></h1>
    <h1>密码: <input name="password"></h1>
    <input type="submit" value="登录">
</form>

</body>
</html>
```


### 2、urls.py


```python

from django.contrib import admin
from django.urls import path

from web.views import Login

urlpatterns = [
    path(r'admin/', admin.site.urls),
    path(r"login/", Login)
]

```

###  3、views.py


```python
from django.http.response import HttpResponse
from django.shortcuts import render_to_response
import json

def Login(request):
    if request.method == 'POST':
        result = {}
        username = request.POST.get("username")
        password = request.POST.get("password")

        result["username"] = username
        result['password'] = password
        result = json.dumps(result)
        return HttpResponse(result, content_type="application/json")
    else:
        return render_to_response('login.html')


```


### 4、settings.py

* 注释掉:#'django.middleware.csrf.CsrfViewMiddleware',
* 'DIRS': [os.path.join(BASE_DIR, 'templates')]

```
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    #'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]


TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')]
        ,
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]



```
