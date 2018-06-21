= opencv图片操作

== 概述

https://opencv.org/releases.html 

* opencv 版本及其相关文档

== 图片读取

```python
import cv2 
# 1 文件的读取 2 封装格式解析 3 数据解码 4 数据加载
img = cv2.imread('image0.jpg',1)
cv2.imshow('image',img)
# jpg png  1 文件头 2 文件数据
cv2.waitKey (0)
# 1.14M 130k
```



* cv2.imread 读取图片 0表示 gray 灰度图片 1表示color 彩色图片

* cv2.imshow 第一个参数 窗口名称 第二个参数 图片

* cv2.waitKey 程序的暂停

== 图片写入

```python
import cv2
img = cv2.imread('image0.jpg',1)
cv2.imwrite('image1.jpg',img) # 1 name 2 data 
```

== 图片压缩

```
import cv2
img = cv2.imread('image0.jpg',1)
cv2.imwrite('imageTest.jpg',img,[cv2.IMWRITE_JPEG_QUALITY,50])
#1M 100k 10k 0-100 有损压缩
```

```
# 1 无损 2 透明度属性
import cv2
img = cv2.imread('image0.jpg',1)
cv2.imwrite('imageTest.png',img,[cv2.IMWRITE_PNG_COMPRESSION,0])
# jpg 0 压缩比高0-100 png 0 压缩比低0-9
```


== 像素操作基础

```python
import cv2
img = cv2.imread('image0.jpg',1)
(b,g,r) = img[100,100]
print(b,g,r)# bgr
#10 100 --- 110 100
for i in range(1,100):
    img[10+i,100] = (255,0,0)
cv2.imshow('image',img)
cv2.waitKey(0) #1000 ms
```

* 1 像素
* 2 RGB
* 3 颜色深度 8 bit 0-255
* 4 图片宽高 640 * 480 表示行有640个像素点,高有480个像素点
* 5 对于jpg图片：
```
1.14M = 720*547*3*8 bit/8 (B) = 1.14M
```

* 6 对于png图片： RGB alpha 
* 7 RGB bgr(红色)


