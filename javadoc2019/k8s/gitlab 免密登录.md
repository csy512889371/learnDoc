### 生成 SSH KEY

使用 ssh-keygen 工具生成，位置在 Git 安装目录下，我的是 `C:\Program Files\Git\usr\bin`

输入命令：

```
ssh-keygen -t rsa -C "512889371@qq.com"
```

执行成功后的效果：

```
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/nick/.ssh/id_rsa):
/c/Users/nick/.ssh/id_rsa already exists.
Overwrite (y/n)? y
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /c/Users/nick/.ssh/id_rsa.
Your public key has been saved in /c/Users/nick/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:D4iujDj1OSzQD1wnIR8awwvQPyPwp1EfOpLB+yts2SM 512889371@qq.com
The key's randomart image is:
+---[RSA 3072]----+
|o+               |
|o O + .          |
| + & = .         |
|  X @.o.         |
| o O.*. S        |
|. *..    o       |
| + B.o    .      |
|ooE.X            |
|ooo+ o           |
+----[SHA256]-----+
```
### 复制 SSH-KEY 信息到 GitHub

秘钥位置在：C:\Users\你的用户名\.ssh 目录下，找到 id_rsa.pub 并使用编辑器打开并拷贝


