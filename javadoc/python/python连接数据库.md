# python连接数据库


## 概述

PyMySQL:

安装方式一

```
pip install PyMySQL
```

安装方式二:

```
$ git clone https://github.com/PyMySQL/PyMySQL
$ cd PyMySQL/
$ python3 setup.py install
```


## 例子
* 如果需要返回字段名则要设置：cursorclass=pymysql.cursors.DictCursor

```
# coding:utf-8
import pymysql
import json

class OperationMysql:
    def __init__(self):
        self.conn = pymysql.connect(
            host='localhost',
            port=3306,
            user='root',
            passwd='123456',
            db='demoone',
            charset='utf8',
            cursorclass=pymysql.cursors.DictCursor
        )
        self.cur = self.conn.cursor()

    # 查询一条数据
    def search_one(self, sql):
        try:
            self.cur.execute(sql)
            result = self.cur.fetchone()
            result = json.dumps(result)
            return result
        except:
            print("Error: unable to fetch data")

if __name__ == '__main__':
    op_mysql = OperationMysql()
    res = op_mysql.search_one("select id,app_sn from UMS_LOG where id='40283d816010026f0160100344e70000'")
    print(res)

```


结果
```
{"id": "40283d816010026f0160100344e70000", "app_sn": " admin"}
```
