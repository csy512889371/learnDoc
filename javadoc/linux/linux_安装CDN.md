# 安装CDN

```shell
# rpm -qa | grep bind 
# rpm -e --nodeps bind-9.8.2-0.47.rc1.el6_8.3.x86_64 删除包
```

## 安装bind
```shell
#yum install bind-chroot bind -y
```


## 拷贝文件
```shell
#cp -R /usr/share/doc/bind-*/sample/var/named/* /var/named/chroot/var/named/ 
```
 
## bind 创建相关文件
```shell
touch /var/named/chroot/var/named/data/cache_dump.db
touch /var/named/chroot/var/named/data/named_stats.txt
touch /var/named/chroot/var/named/data/named_mem_stats.txt
touch /var/named/chroot/var/named/data/named.run
mkdir /var/named/chroot/var/named/dynamic
touch /var/named/chroot/var/named/dynamic/managed-keys.bind
```

## 设置可写

```shell
chmod -R 777 /var/named/chroot/var/named/data
chmod -R 777 /var/named/chroot/var/named/dynamic
```


## 拷贝 /etc/named.conf 
```shell
cp -p /etc/named.conf /var/named/chroot/etc/named.conf
```
