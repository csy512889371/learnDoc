# python unit test使用

## 一、简单例子

```
#coding:utf-8
import unittest

class TestMethod(unittest.TestCase):

	@classmethod
	def setUpClass(cls):
		print("类执行之前的方法")

	@classmethod
	def tearDownClass(cls):
		print("类执行之后的方法")

	#每次方法之前执行
	def setUp(self):
		print("test-->setup")
		
	#每个方法之后执行
	def tearDown(self):
		print("test--->tearDown")

	def test_01(self):
		print('this is test 01')

	def test_02(self):
		print('this is test 02')

if __name__ == '__main__':
	unittest.main()
```


## 二、例子

* 全局变量 globlas
* assertEqual
* unittest.skip 跳过测试
```
#coding:utf-8
import unittest
import json
from demo import RunMain

class TestMethod(unittest.TestCase):

	def setUp(self):
		self.run = RunMain()


	def test_01(self):
		data = {
			'username':'nick',
			'password':'123',
			'errorCode':'1000'
		}

		url = "http://localhost:8000/login/"
		res = self.run.run_main(url, 'POST', data)

		#self.assertEqual(res['errorCode'],'1000',"测试成功")
		print(res)

		# 打印全局变量
		#print(userid)


	#@unittest.skip('test_02')
	def test_02(self):

		# 全局变量
		#globlas()['userid'] = '10000'

		data = {
			'username':'nick',
			'password':'123',
			'errorCode':1001
		}

		url = "http://localhost:8000/login/"
		res = self.run.run_main(url, 'POST', data)
		
		#self.assertEqual(res['errorCode'],'1001',"测试失败")
		
		print(res)

if __name__ == '__main__':
	#unittest.main()

	suite = unittest.TestSuite()
	suite.addTest(TestMethod('test_02'))
	suite.addTest(TestMethod('test_01'))
	unittest.TextTestRunner().run(suite)
```

