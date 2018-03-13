# python脚本1

* 对文件中的内容按照***** 切割成块 放入不同文件有下划线_1 等标识
* 对切割的块 中的信息分类存储 manage\guest

文件内容：
```xml
manage: 你好
guest: 很好
manage: 那就好

***********************

manage: 有什么可以帮助你的
guest: 有


```

```python
def save_file(boy, girl, count):
	file_name_boy = 'boy_' + str(count) + '.txt'
	file_name_girl = 'girl' + str(count) + '.txt'
	
	boy_file = open(file_name_boy, 'w')
	girl_file = open(file_name_girl, 'w')
	
	boy_file.writelines(boy)
	girl_file.writelines(girl)
	
	boy_file.close()
	girl_file.close()

def split_file(file_name):
	f = open('record.txt')
	
	
	boy = []
	girl = []
	
	count = 1
	
	for each_line in f:
		if each_line[:6] != '*****'
			(role, line_spoken) = each_line.split_file(":", 1)
			if role == 'manager':
				boy.append(line_spoken)
			if role == 'guest':
				girl.append(line_spoken)
		else:
			save_file(boy, girl, count)
			
			boy = []
			girl = []
			count += 1
			
	save_file(boy, girl, count)
	
	f.close()

```