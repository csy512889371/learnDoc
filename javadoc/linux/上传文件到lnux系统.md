# Windows 机器通过 WinSCP 上传文件

WinSCP 是一个在 Windows 环境下使用 SSH 的开源图形化 SFTP 客户端，同时支持 SCP 协议。它的主要功能是在本地与远程计算机之间安全地复制文件。与使用 FTP 上传代码相比，通过 WinSCP 可以直接使用服务器账户密码访问服务器，无需在服务器端做任何配置。

# 操作步骤

## 下载 WinSCP 客户端并安装。下载地址：
* [官方下载](https://winscp.net/eng/docs/lang:chs)
* 安装完成后启动 WinSCP

## 字段填写说明：
* 协议：选填 SFTP 或者 SCP 均可。
* 主机名：云服务器的公网 IP。登录 云服务器控制台 即可查看对应云服务器的公网 IP。
* 端口：默认 22。
* 密码：云服务器的用户名对应的密码。
* 用户名：云服务器的系统用户名。
>* SUSE/CentOS/Debian 系统：root
>* Windows 系统：Administrator
>* Ubuntu 系统：ubuntu

## 信息填写完毕之后单击 **登录**

## 登录成功之后，鼠标选中左侧本地文件，拖拽到右侧的远程站点，即可将文件上传到 Linux 云服务器