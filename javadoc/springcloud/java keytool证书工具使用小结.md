# java keytool证书工具使用小结

Keytool 是一个Java数据证书的管理工具 ,Keytool将密钥（key）和证书（certificates）存在一个称为keystore的文件中在keystore里，包含两种数据:密钥实体（Key entity）-密钥（secret key）或者是私钥和配对公钥（采用非对称加密）可信任的证书实体（trusted certificate entries）-只包含公钥.

> JDK中keytool常用参数说明（不同版本有差异）

* -genkey 在用户主目录中创建一个默认文件”.keystore”,还会产生一个mykey的别名，mykey中包含用户的公钥、私钥和证书(在没有指定生成位置的情况下,keystore会存在用户系统默认目录)
* -alias 产生别名 每个keystore都关联这一个独一无二的alias，这个alias通常不区分大小写
* -keystore 指定密钥库的名称(产生的各类信息将不在.keystore文件中)
* -keyalg 指定密钥的算法 (如 RSA DSA，默认值为：DSA)
* -validity 指定创建的证书有效期多少天(默认 90)
* -keysize 指定密钥长度 （默认 1024）
* -storepass 指定密钥库的密码(获取keystore信息所需的密码)
* -keypass 指定别名条目的密码(私钥的密码)
* -dname 指定证书发行者信息 其中： “CN=名字与姓氏,OU=组织单位名称,O=组织名称,L=城市或区域名 称,ST=州或省份名称,C=单位的两字母国家代码”
* -list 显示密钥库中的证书信息 keytool -list -v -keystore 指定keystore -storepass 密码
* -v 显示密钥库中的证书详细信息
* -export 将别名指定的证书导出到文件 keytool -export -alias 需要导出的别名 -keystore 指定keystore -file 指定导出的证书位置及证书名称 -storepass 密码
* -file 参数指定导出到文件的文件名
* -delete 删除密钥库中某条目 keytool -delete -alias 指定需删除的别 -keystore 指定keystore – storepass 密码
* -printcert 查看导出的证书信息 keytool -printcert -file g:\sso\michael.crt
* -keypasswd 修改密钥库中指定条目口令 keytool -keypasswd -alias 需修改的别名 -keypass 旧密码 -new 新密码 -storepass keystore密码 -keystore sage
* -storepasswd 修改keystore口令 keytool -storepasswd -keystore g:\sso\michael.keystore(需修改口令的keystore) -storepass pwdold(原始密码) -new pwdnew(新密码)
* -import 将已签名数字证书导入密钥库 keytool -import -alias 指定导入条目的别名 -keystore 指定keystore -file 需导入的证书

## 目录说明：
* 生成证书
* 查看证书
* 证书导出
* 附录资料

## 生成证书
> 按win键+R，弹出运行窗口，输入 cmd 回车，打开命令行窗户，输入如下命令：
```shell
keytool -genkey -alias michaelkey -keyalg RSA -keysize 1024 -keypass michaelpwd -validity 365 -keystore g:\sso\michael.keystore -storepass michaelpwd2


您的名字与姓氏是什么?
  [Unknown]:  nick
您的组织单位名称是什么?
  [Unknown]:  ctoedu.com
您的组织名称是什么?
  [Unknown]:  ctoedu
您所在的城市或区域名称是什么?
  [Unknown]:  fj
您所在的省/市/自治区名称是什么?
  [Unknown]:  fz
该单位的双字母国家/地区代码是什么?
  [Unknown]:  CN
CN=nick, OU=ctoedu.com, O=ctoedu, L=fj, ST=fz, C=CN是否正确?
  [否]:  y
```


## 查看证书
缺省情况下，-list 命令打印证书的 MD5 指纹。而如果指定了 -v 选项，将以可读格式打印证书，如果指定了 -rfc 选项，将以可打印的编码格式输出证书。
```shell
keytool -list  -v -keystore g:\sso\michael.keystore -storepass michaelpwd2
```

## -rfc 命令如下：
```shell
keytool -list -rfc -keystore g:\sso\michael.keystore -storepass michaelpwd2

密钥库类型: JKS
密钥库提供方: SUN

您的密钥库包含 1 个条目

别名: michaelkey
创建日期: 2018-1-22
条目类型: PrivateKeyEntry
证书链长度: 1
证书[1]:
-----BEGIN CERTIFICATE-----
MIICUjCCAbugAwIBAgIEU77kLjANBgkqhkiG9w0BAQsFADBcMQswCQYDVQQGEwJD
TjELMAkGA1UECBMCZnoxCzAJBgNVBAcTAmZqMQ8wDQYDVQQKEwZjdG9lZHUxEzAR
BgNVBAsTCmN0b2VkdS5jb20xDTALBgNVBAMTBG5pY2swHhcNMTgwMTIyMDYwOTQy
WhcNMTkwMTIyMDYwOTQyWjBcMQswCQYDVQQGEwJDTjELMAkGA1UECBMCZnoxCzAJ
BgNVBAcTAmZqMQ8wDQYDVQQKEwZjdG9lZHUxEzARBgNVBAsTCmN0b2VkdS5jb20x
DTALBgNVBAMTBG5pY2swgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAK9nAMPm
kQYrpk9FQzKrQXA8kRHfSebutRO3ClP8DWwigo4QUuN8H2axjQ8Y49ML3IsyixCN
lYPXF9Jt/QDUVmdDHiy4LGXG9ROho1OAyMVEVgfmCVh7nR9HXamINb78BxWXWRd+
hZycXjQOFtDM3uuRCwRvVhxNaLw2/VsNxUZZAgMBAAGjITAfMB0GA1UdDgQWBBTz
0YpXeOxKIWxewTLABocmgYo2lzANBgkqhkiG9w0BAQsFAAOBgQAwvfATrdDhcz67
kDnFbxR3TiX6uQg0t3V/O4EZ1KE0DJVP91wOPKllMhhCt4MUqQ5UzHGCt8e8naEc
x4u7cJ1fP6vcEtikpZ1qLYNmcHDxBfNs2odaTnqq6hM9IcBxvNug0aPMove2SvIZ
5GOngNflvC3BOZI8WJHdYAk+lfKZqw==
-----END CERTIFICATE-----


*******************************************
*******************************************

```

## 证书的导出和查看：
> 导出证书命令

```shell
keytool -export -alias michaelkey -keystore g:\sso\michael.keystore -file g:\sso\michael.crt -storepass michaelpwd2
```


## 查看导出的证书信息
```shell
keytool -printcert -file g:\sso\michael.crt


所有者: CN=nick, OU=ctoedu.com, O=ctoedu, L=fj, ST=fz, C=CN
发布者: CN=nick, OU=ctoedu.com, O=ctoedu, L=fj, ST=fz, C=CN
序列号: 53bee42e
有效期开始日期: Mon Jan 22 14:09:42 CST 2018, 截止日期: Tue Jan 22 14:09:42 CST
2019
证书指纹:
         MD5: 48:9D:AD:DF:73:1B:3E:78:E6:90:D6:7E:04:29:36:FD
         SHA1: 9F:5D:A6:0C:A7:53:AF:8C:5B:D2:4E:DF:E9:DF:B3:7D:0B:16:5F:96
         SHA256: 4B:B4:DF:78:DB:94:9C:18:43:EB:B2:FD:9D:63:AD:BE:49:33:8A:70:E3:
7E:27:87:AE:29:00:09:8D:DF:98:E1
         签名算法名称: SHA256withRSA
         版本: 3

扩展:

#1: ObjectId: 2.5.29.14 Criticality=false
SubjectKeyIdentifier [
KeyIdentifier [
0000: F3 D1 8A 57 78 EC 4A 21   6C 5E C1 32 C0 06 87 26  ...Wx.J!l^.2...&
0010: 81 8A 36 97                                        ..6.
]
]

```


## 附录

官方有关keytool命令的介绍文档：
jdk1.4.2 ：http://docs.oracle.com/javase/1.4.2/docs/tooldocs/windows/keytool.html
jdk1.6    ：http://docs.oracle.com/javase/6/docs/technotes/tools/windows/keytool.html
jdk1.7    ：http://docs.oracle.com/javase/7/docs/technotes/tools/windows/keytool.html