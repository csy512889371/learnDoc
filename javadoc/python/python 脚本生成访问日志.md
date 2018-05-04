# 使用 Python 脚本实时产生数据

# 脚本


因为我们要使用实时数据，不可能从主站拿到，只能模仿，我们一般使用是脚本 python 或者 java


generate.py

```
# coding=UTF-8
import random
import time

url_paths = [
    "www/2",
    "www/1",
    "www/6",
    "www/4",
    "www/3",
    "pianhua/130",
    "toukouxu/821"
]

status_code = [404, 302, 200]

ip_slices = [132, 156, 124, 10, 29, 167, 143, 187, 30, 100]

http_referers = [
    "https://www.baidu.com/s?wd={query}",
    "https://www.sogou.com/web?qu={query}",
    "http://cn.bing.com/search?q={query}",
    "https://search.yahoo.com/search?p={query}"
]

search_keyword = [
    "猎场",
    "快乐人生",
    "极限挑战",
    "我的体育老师",
    "幸福满院"
]


# ip地址
def sample_ip():
    slice = random.sample(ip_slices, 4)
    return ".".join([str(item) for item in slice])


def sample_url():
    return random.sample(url_paths, 1)[0]


def sample_status():
    return random.sample(status_code, 1)[0]


def sample_referer():
    if random.uniform(0, 1) > 0.2:
        return "-"
    refer_str = random.sample(http_referers, 1)
    # print refer_str[0]
    query_str = random.sample(search_keyword, 1)
    # print query_str[0]
    return refer_str[0].format(query=query_str[0])


# 产生log
def generate_log(count=10):
    time_str = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    f = open("F:\\api\\logs\log.txt","w+")
    # f = open("/home/centos/log/log", "a+")
    while count >= 1:
        query_log = "{ip}\t{localtime}\t\"GET {url} HTTP/1.0\"\t{referece}\t{status1}".format(ip=sample_ip(),
                                                                                              url=sample_url(),
                                                                                              status1=sample_status(),
                                                                                              referece=sample_referer(),
                                                                                              localtime=time_str)
        # print query_log
        f.write(query_log + "\n")
        count = count - 1;


if __name__ == '__main__':
    generate_log(100)
# print "1111"

```

python 3

```
python generate.py

```


### 生成的结果：

```
30.29.187.10	2018-05-04 11:42:16	"GET www/2 HTTP/1.0"	-	302
187.30.167.143	2018-05-04 11:42:16	"GET www/2 HTTP/1.0"	-	404
30.143.187.124	2018-05-04 11:42:16	"GET toukouxu/821 HTTP/1.0"	-	200
132.187.167.100	2018-05-04 11:42:16	"GET www/4 HTTP/1.0"	https://www.baidu.com/s?wd=快乐人生	200
124.187.29.100	2018-05-04 11:42:16	"GET pianhua/130 HTTP/1.0"	-	200
30.143.187.124	2018-05-04 11:42:16	"GET www/6 HTTP/1.0"	-	404
29.167.187.132	2018-05-04 11:42:16	"GET www/1 HTTP/1.0"	https://www.baidu.com/s?wd=极限挑战	302
187.10.29.132	2018-05-04 11:42:16	"GET www/1 HTTP/1.0"	-	302
187.30.156.29	2018-05-04 11:42:16	"GET toukouxu/821 HTTP/1.0"	-	302
```
