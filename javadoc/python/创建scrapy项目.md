#  创建scrapy项目


## 概述


### 一、创建虚拟环境

* 虚拟环境是python3

```
mkvirtualenv article_spider
```

### 二、安装scrapy

```
(article_spider) C:\Users\Administrator>pip intsall -i https://pypi.douban.com/simple/ scrapy
```

安装过程报错

```
    running build_ext
    building 'twisted.test.raiser' extension
    error: Microsoft Visual C++ 14.0 is required. Get it with
```

解决

* https://www.lfd.uci.edu/~gohlke/pythonlibs/#twisted 下载twisted对应版本的whl文件

* （如我的Twisted-17.9.0-cp35-cp35m-win32.whl），cp后面是python版本，amd64代表64位

```
(article_spider) C:\Users\Administrator>pip install G:\tools\pythontool\Twisted-17.9.0-cp35-cp35m-win32.whl
```


### 三、创建scrapy项目

进入虚拟环境

workon article_spider

```
G:\pythonWorkspace>workon article_spider
(article_spider) G:\pythonWorkspace>
```

创建项目

scrapy startproject ArticleSpider

* 也可以自定义模版

```
(article_spider) G:\pythonWorkspace>scrapy startproject ArticleSpider

New Scrapy project 'ArticleSpider', using template directory 'e:\\python\\envs\\article_spider\\lib\\site-packages\\scrapy\\templates\\project', created in:
    G:\pythonWorkspace\ArticleSpider

You can start your first spider with:
    cd ArticleSpider
    scrapy genspider example example.com
```

生成模版

进入项目运行：

scrapy genspider jobbole blog.jobbole.com

```
(article_spider) G:\pythonWorkspace\ArticleSpider>scrapy genspider jobbole blog.
jobbole.com
Created spider 'jobbole' using template 'basic' in module:
  ArticleSpider.spiders.jobbole
```

### 四、pychart 导入项目

* 导入后设置 pycharm的虚拟环境

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/33.png)


安装

pypiwin32

````
(article_spider) C:\Users\Administrator>pip install pypiwin32
```

settings.py 中配置：

```
ROBOTSTXT_OBEY = False
```

 在命令行下可以通过 scrapy shell 调试页面
 
 ```
 (article_spider) C:\Users\Administrator>scrapy shell https://blog.csdn.net/qq_27384769/article/details/79439922
 ```
 
 例子 
 
 ```
 >>> title = response.xpath("//*[@id='article_content']/div/ul/li[2]/p/a")
>>> title
[<Selector xpath="//*[@id='article_content']/div/ul/li[2]/p/a" data='<a href="http://blog.csdn.net/qq_2738476'>]


>>> title.extract()[0]
'<a href="http://blog.csdn.net/qq_27384769/article/details/79060088" style="color:rgb(3,102,214);">日常git常用命令总结</a>'


 ```
 
 使用xpath 提取页面内容
 
```
    def parse(self, response):
        提取文章的具体字段
        title = response.xpath('//div[@class="entry-header"]/h1/text()').extract_first("")
        create_date = response.xpath("//p[@class='entry-meta-hide-on-mobile']/text()").extract()[0].strip().replace("·","").strip()
        praise_nums = response.xpath("//span[contains(@class, 'vote-post-up')]/h10/text()").extract()[0]
        fav_nums = response.xpath("//span[contains(@class, 'bookmark-btn')]/text()").extract()[0]
        match_re = re.match(".*?(\d+).*", fav_nums)
        if match_re:
            fav_nums = match_re.group(1)

        comment_nums = response.xpath("//a[@href='#article-comment']/span/text()").extract()[0]
        match_re = re.match(".*?(\d+).*", comment_nums)
        if match_re:
            comment_nums = match_re.group(1)

        content = response.xpath("//div[@class='entry']").extract()[0]

        tag_list = response.xpath("//p[@class='entry-meta-hide-on-mobile']/a/text()").extract()
        tag_list = [element for element in tag_list if not element.strip().endswith("评论")]
        tags = ",".join(tag_list)
        pass
```
 
 
 
 