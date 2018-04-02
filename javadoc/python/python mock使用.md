# python mock 使用

## 概述

使用mock 模拟接口返回数据

安装：
```
pip install mock
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/26.png)


## 一、简单例子

* 导入mock
* 模拟方法


```
# coding:utf-8
import unittest
import json
from mock import mock
import HTMLTestRunner
from demo import RunMain
class TestMethod(unittest.TestCase):

    def setUp(self):
        self.run = RunMain()

    def test_01(self):
        data = {
            'username': 'nick',
            'password': '123',
            'errorCode': '1000'
        }

        url = "http://localhost:8000/login/"

    # res = self.run.run_main(url, 'POST', data)

    # self.assertEqual(res['errorCode'],'1000',"测试成功")
    # print(res)

    # 打印全局变量
    # print(userid)

    # @unittest.skip('test_02')
    def test_02(self):
        # 全局变量
        # globlas()['userid'] = '10000'

        data = {
            'username': 'nick',
            'password': '123',
            'errorCode': 1001
        }

        url = "http://localhost:8000/login/"
        mock_data = mock.Mock(return_value=data

        self.run.run_main = mock_data

        res = self.run.run_main(url, 'POST', data)

        print(res)

        # res = self.run.run_main(url, 'POST', data)

        # self.assertEqual(res['errorCode'],'1001',"测试失败")


if __name__ == '__main__':
    # unittest.main()

    filepath = "../report/htmlreport.html"
    fp = open(filepath, 'wb')
    suite = unittest.TestSuite()
    suite.addTest(TestMethod('test_02'))
    suite.addTest(TestMethod('test_01'))
    unittest.TextTestRunner().run(suite)
    # runner = HTMLTestRunner.HTMLTestRunner(stream=fp, title='report')
    # runner.run(suite)

```


## 二、对mock 进行简单分装

mock_demo.py

* mock_method 调用的方法名
* request_data 请求值
* url请求url
* method post/get
* response_data 返回值


```
#coding:utf-8
from mock import mock
#模拟mock 封装
def mock_test(mock_method,request_data,url,method,response_data):
	mock_method = mock.Mock(return_value=response_data)
	res = mock_method(url,method,request_data)
	return res

```


调用

```
from mock_demo import mock_test


res = mock_test(self.run.run_main,data,url,"POST",data)

```





