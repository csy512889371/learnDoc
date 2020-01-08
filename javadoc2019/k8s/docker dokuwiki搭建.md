# pull镜像

我用的是同组同学推荐的，上海大学的镜像，你也可以用官方的，都是可以的，都差不
 多。这个是他们的[github](https://links.jianshu.com/go?to=%5Bhttps%3A%2F%2Fgithub.com%2Fshuopensourcecommunity%2Fdocker-dokuwiki%5D(https%3A%2F%2Fgithub.com%2Fshuopensourcecommunity%2Fdocker-dokuwiki))



```undefined
docker pull shuosc/dokuwiki
```

拉取镜像结束，就可以run了，可以在服务器上面新建个目录，比如cd /data/wiki
 然后创建一个docker-compose.yml的文件，如果服务器上面没有安装docker-compose记得安装一下apt install docker-compose。然后编辑一下docker-compose.yml文件。



```kotlin
version: '2'
services:
  dokuwiki:
    build: .
    image: shuosc/dokuwiki:latest
    ports:
      - 8004:80
    environment:
      - DIR=wiki
    volumes:
      - ./.data:/opt/data
```

接下来就是



```undefined
docker-compose up -d
```

就可以通过[http://ip:8004/wiki](https://links.jianshu.com/go?to=http%3A%2F%2Fip%3A8004%2Fwiki)访问了。首先需要配置一下，所以访问[http://ip:8004/wiki/install.php](https://links.jianshu.com/go?to=http%3A%2F%2Fip%3A8004%2Fwiki%2Finstall.php)，这个docker有一点问题，显示的页面提示说xx文件已存在，那我们就删除他们就好了，首先进入指定目录，然后删除这三个文件，重新刷新即可。设置一下wiki的名字、管理员账号密码。安全起见，可以删掉这个install.php文件。



```kotlin
cd /data/wiki/.data/conf
rm local.php users.auth.php acl.auth.php
```

# 安装一些插件、模板

## 安装模板

可以安装一些插件、模板更方便、美观的使用wiki。首先可以去[英文文档](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.dokuwiki.org%2Ftemplate)或者[中文文档](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.dokuwiki.org%2Fzh%3Atemplate)找到自己喜欢的，然后在“下载”按钮上面右键复制链接地址，放到下图位置即可。当然也可以搜索安装

![img](https:////upload-images.jianshu.io/upload_images/5183118-972fb16182cc0052.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

image.png


 上面的截图就是使用模板之后的样子，稍微好看一些。记得安装之后，要设置一下才能生效，设置方式如下图。

![img](https:////upload-images.jianshu.io/upload_images/5183118-d07106346c340c29.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

template设置



## 安装插件

可以安装markdown插件，[MarkdownExtra Plugin](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fnaokij%2Fdokuwiki-plugin-markdownextra%2Ftarball%2Fmaster)可以和安装模板一样，复制链接地址进行安装。然后新建文件的时候保存后缀为.md即可。
 也可以安装Add New Page Plugin插件，不然增加页面需要进入到服务器里面进行mkdir，很麻烦。

![img](https:////upload-images.jianshu.io/upload_images/5183118-332608ddd7b81934.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

Add New Page Plugin


 然后如下图所示找到wiki/welcome进行点击

![img](https:////upload-images.jianshu.io/upload_images/5183118-a7aca8619f889f20.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

sidebar


 然后编辑，填入{{NEWPAGE}}然后保存即可。

![img](https:////upload-images.jianshu.io/upload_images/5183118-28d2a815f185261c.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

NEWPAGE


 接下来新建一个MD文件

![img](https:////upload-images.jianshu.io/upload_images/5183118-ecdf8a3be3bc424a.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

MD文件



![img](https:////upload-images.jianshu.io/upload_images/5183118-c45bf072eba9a28d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

编辑MD



![img](https:////upload-images.jianshu.io/upload_images/5183118-dd35ae2a5cf233af.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

test


 最终结果就是在根目录下创建了test目录，在test目录下创建了hello.md文件。
 如果要移动目录里面的文件，还需要一个插件Move Plugin。

![img](https:////upload-images.jianshu.io/upload_images/5183118-c231fd55eda6bf4a.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

Move Plugin



![img](https:////upload-images.jianshu.io/upload_images/5183118-8a2454b091522ee3.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

move


 然后你的文件上面就会多了一个按钮，上图中的1所示，然后点击1，通过修改2就可以移动文件了。



# 删除文件、目录

删除文件很简单，只要把文件里面的内容删除干净，然后保存就没了。同理删除目录也很简单，只要把目录里面的文件删除干净就行了。

# ACL权限问题

![img](https:////upload-images.jianshu.io/upload_images/5183118-a580c1d9b3e98a83.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

ACL权限

上图中的权限设置，其中删除>上传>创建>编辑>读取>无，权限一次递减，权限可以分为个人和小组，权限，都很好理解。但是会有一个问题，就是会sidebar提示权限不够，不能创建。死活修改都不行，最后网上百度找到答案。首先可以删除路径`/data/wiki/.data/data/cache`(如果前面没有按照docker安装，路径可以类比一下)下面的数字和字母文件夹，然后修改一下`/data/wiki/.data/lib/plugins/addnewpage`目录下的syntax.php一行代码，将$renderer->info['cache'] = false;这行代码放到render函数的开头。如下图所示。

![img](https:////upload-images.jianshu.io/upload_images/5183118-bd2c3a2aee1a4e3a.png?imageMogr2/auto-orient/strip|imageView2/2/w/1196/format/webp)

syntax.php



作者：星辰大海__xcdh
链接：https://www.jianshu.com/p/80a9308e9586
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。