# navicat连接oracle数据库ORA-28547：connection to server failed, probable Oracle Net admin error错误，解决方法

> navicat自带的oci.dll文件的版本和服务器端的oralce数据库的版本不一致造成的，于是按照网上的方法，
下载了最新的instantclient-basic-windows.x64-12.1.0.2.0

# 下载地址。
http://download.csdn.net/download/qq_27384769/10139808

>* 下载完成之后解压到任意目录
>* 然后打开navicat的工具----->选项------>OCI    
>* 选择刚刚下载的文件中的oci.dll，关闭navicat
>* 重启，重新链接oracle即可解决问题！