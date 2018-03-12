# python OS模块详解


## 常见函数

* os.sep:取代操作系统特定的路径分隔符
* os.name:指示你正在使用的工作平台。比如对于Windows，它是'nt'，而对于Linux/Unix用户，它是'posix'。
* os.getcwd:得到当前工作目录，即当前python脚本工作的目录路径。
* os.getenv()和os.putenv:分别用来读取和设置环境变量
* os.listdir():返回指定目录下的所有文件和目录名
* os.remove(file):删除一个文件
* os.stat（file）:获得文件属性
* os.chmod(file):修改文件权限和时间戳
* os.mkdir(name):创建目录
* os.rmdir(name):删除目录
* os.removedirs（r“c：\python”）:删除多个目录
* os.system():运行shell命令
* os.exit():终止当前进程
* os.linesep:给出当前平台的行终止符。例如，Windows使用'\r\n'，Linux使用'\n'而Mac使用'\r'
* os.path.split():返回一个路径的目录名和文件名
* os.path.isfile()和os.path.isdir()分别检验给出的路径是一个目录还是文件
* os.path.existe():检验给出的路径是否真的存在
* os.listdir(dirname):列出dirname下的目录和文件
* os.getcwd():获得当前工作目录
* os.curdir:返回当前目录（'.'）
* os.chdir(dirname):改变工作目录到dirname
* os.path.isdir(name):判断name是不是目录，不是目录就返回false
* os.path.isfile(name):判断name这个文件是否存在，不存在返回false
* os.path.exists(name):判断是否存在文件或目录name
* os.path.getsize(name):或得文件大小，如果name是目录返回0L
* os.path.abspath(name):获得绝对路径
* os.path.isabs():判断是否为绝对路径
* os.path.normpath(path):规范path字符串形式
* os.path.split(name):分割文件名与目录（事实上，如果你完全使用目录，它也会将最后一个目录作为文件名而分离，同时它不会判断文件或目录是否存在）
* os.path.splitext():分离文件名和扩展名
* os.path.join(path,name):连接目录与文件名或目录
* os.path.basename(path):返回文件名
* os.path.dirname(path):返回文件路径


## 文件操作

* os.mknod("text.txt")：创建空文件
* fp = open("text.txt",w):直接打开一个文件，如果文件不存在就创建文件

```shell
open 模式

w 写方式
a 追加模式打开（从EOF开始，必要时创建新文件）
r+ 以读写模式打开
w+ 以读写模式打开
a+ 以读写模式打开
rb 以二进制读模式打开
wb 以二进制写模式打开 (参见 w )
ab 以二进制追加模式打开 (参见 a )
rb+ 以二进制读写模式打开 (参见 r+ )
wb+ 以二进制读写模式打开 (参见 w+ )
ab+ 以二进制读写模式打开 (参见 a+ )


fp.read([size])  #size为读取的长度，以byte为单位
 
fp.readline([size])  #读一行，如果定义了size，有可能返回的只是一行的一部分
 
fp.readlines([size])  #把文件每一行作为一个list的一个成员，并返回这个list。其实它的内部是通过循环调用readline()来实现的。如果提供size参数，size是表示读取内容的总长，也就是说可能只读到文件的一部分。
 
fp.write(str)  #把str写到文件中，write()并不会在str后加上一个换行符
 
fp.writelines(seq)  #把seq的内容全部写到文件中(多行一次性写入)。这个函数也只是忠实地写入，不会在每行后面加上任何东西。
 
fp.close()  #关闭文件。python会在一个文件不用后自动关闭文件，不过这一功能没有保证，最好还是养成自己关闭的习惯。 如果一个文件在关闭后还对其进行操作会产生ValueError
 
fp.flush()  #把缓冲区的内容写入硬盘
 
fp.fileno()  #返回一个长整型的”文件标签“
 
fp.isatty()  #文件是否是一个终端设备文件（unix系统中的）
 
fp.tell()  #返回文件操作标记的当前位置，以文件的开头为原点
 
fp.next()  #返回下一行，并将文件操作标记位移到下一行。把一个file用于for … in file这样的语句时，就是调用next()函数来实现遍历的。
 
fp.seek(offset[,whence])  #将文件打操作标记移到offset的位置。这个offset一般是相对于文件的开头来计算的，一般为正数。但如果提供了whence参数就不一定了，whence可以为0表示从头开始计算，1表示以当前位置为原点计算。2表示以文件末尾为原点进行计算。需要注意，如果文件以a或a+的模式打开，每次进行写操作时，文件操作标记会自动返回到文件末尾。
 
fp.truncate([size])  #把文件裁成规定的大小，默认的是裁到当前文件操作标记的位置。如果size比文件的大小还要大，依据系统的不同可能是不改变文件，也可能是用0把文件补到相应的大小，也可能是以一些随机的内容加上去。
 
目录操作
 
os.mkdir("file")　　创建目录
 
shutil.copyfile("oldfile","newfile")　　复制文件:oldfile和newfile都只能是文件
 
shutil.copy("oldfile","newfile")  oldfile只能是文件夹，newfile可以是文件，也可以是目标目录
 
shutil.copytree("olddir","newdir")  复制文件夹.olddir和newdir都只能是目录，且newdir必须不存在
 
os.rename("oldname","newname")  重命名文件（目录）.文件或目录都是使用这条命令
 
shutil.move("oldpos","newpos")  移动文件（目录）
 
os.rmdir("dir")  只能删除空目录
 
shutil.rmtree("dir")  空目录、有内容的目录都可以删
 
os.chdir("path")  转换目录，换路径
```
