# requests库的相关使用


## 使用

安装

```

pip install requests
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/21.png)

验证是否安装成功: python 客户端 import requests 是否报错，没有报错者表示成功

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/22.png)


## 例子一

* 使用requests 请求post 获取返回数据

```python

import requests
import json

data = {
	'username':'nick',
	'password':'123'
}

url = "http://localhost:8000/login/"

res = requests.post(url=url, data=data)

print (type(res.json()))
print (res.json())

```


* 对post 和 get 请求进一步分组


```
import requests
import json


def send_post(url, data):
	res = requests.post(url=url, data=data).json()
	return json.dumps(res, indent=2, sort_keys=True)


def send_get(url,data):
	res = requests.get(url=url,data=data).json()
	return json.dumps(res, indent=2, sort_keys=True)

def run_main(url,method,data=None):
	res = None
	if method == 'GET':
		res = send_get(url,data)
	else:
		res = send_post(url,data)
	return res

data = {
	'username':'nick',
	'password':'123'
}

url = "http://localhost:8000/login/"
run_main(url, "POST", data)

print(run_main(url, "POST", data))


```

* 将其封装成类


```
import requests
import json

class RunMain:	

	def __init__(self, url, method, data=None):
		self.res = self.run_main(url, method, data)

	def send_post(self, url, data):
		res = requests.post(url=url, data=data).json()
		return json.dumps(res, indent=2, sort_keys=True)


	def send_get(self, url, data):
		res = requests.get(url=url,data=data).json()
		return json.dumps(res, indent=2, sort_keys=True)

	def run_main(self, url, method, data=None):
		res = None
		if method == 'GET':
			res = self.send_get(url,data)
		else:
			res = self.send_post(url,data)
		return res

if __name__ == '__main__':

	data = {
		'username':'nick',
		'password':'123'
	}

	url = "http://localhost:8000/login/"
	run = RunMain(url, "POST", data)
	print(run.res)

```


## 其他

查看python 安装路径

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/23.png)


notepad 小技巧如何多行同时在前面和后面添加相同字符串

ctrl + alt 然后向下键。会有多行选中效果





