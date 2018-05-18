# Flask简单项目


## 一、概述

* Flask官网： http://flask-sqlalchemy.pocoo.org/
* 中文 http://www.pythondoc.com/flask-sqlalchemy/
* Flask安装：pip install Flask-SQLAlchemy
* MySQLdb：pip install Flask-MySQLdb


项目地址

https://github.com/csy512889371/learndemo/tree/master/python/nowstagram

## 二、安装mysql 客户端

```
pip install mysqlclient 
```

安装 VCForPython27.msi 下载地址：

```
链接：https://pan.baidu.com/s/1xzJeg77qS4npbii1PgyVhQ 密码：0rps
```


```
    _mysql.c(29) : fatal error C1083: Cannot open include file: 'mysql.h': No such file or directory
    error: command 'C:\\Users\\Administrator\\AppData\\Local\\Programs\\Common\\Microsoft\\Visual C++ for Python\\9.0\\VC\\Bin\\amd64\\cl.exe' failed with exit status 2

```

在http://www.lfd.uci.edu/~gohlke/pythonlibs/#mysql-python下载对应的包版本，如果是win7 64位2.7版本的python


然后在命令行执行pip install mysqlclient-1.3.12-cp27-cp27m-win_amd64.whl

```
pip install mysqlclient-1.3.12-cp27-cp27m-win_amd64.whl

```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/192.png)



## 三、数据库配置



对象关系映射（Object-Relational Mapping）提供了概念性的、易于理解的模型化数据的方法


```
SQLALCHEMY_DATABASE_URI = 'mysql://root:niu@localhost:3306/test'
#SQLALCHEMY_DATABASE_URI = 'sqlite:///../nowstagram.db'
SQLALCHEMY_TRACK_MODIFICATIONS = True
SQLALCHEMY_ECHO = False
SQLALCHEMY_NATIVE_UNICODE = True
SQLALCHEMY_RECORD_QUERIES = False

#dialect+driver://username:password@host:port/database
```



http://flask-sqlalchemy.pocoo.org/2.1/config/#connection-uri-format

## 四、数据模型

```
class User(db.Model):
    #__tablename__ = 'myuser' 指定表名字
    __table_args__ = {'mysql_collate': 'utf8_general_ci'}
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(80), unique=True)
    password = db.Column(db.String(32))
    head_url = db.Column(db.String(256))
    images = db.relationship('Image', backref='user', lazy='dynamic')
    #images = db.relationship('Image')

    def __init__(self, username, password):
        self.username = username
        self.password = password #暂时明文，下节课讲解加密
        self.head_url = 'http://images.niu.com/head/' + str(random.randint(0, 1000)) + 't.png'

    def __repr__(self):
        return ('<User %d %s>' % (self.id, self.username)).encode('gbk')
```


## 五、插入数据

```
@manager.command
def init_database():
    db.drop_all()
    db.create_all()
    for i in range(0, 100):
        db.session.add(User('牛牛' +str(i), 'a'+str(i)))

        for j in range(0, 3): #每人发三张图
            db.session.add(Image(get_image_url(), i + 1))
            for k in range(0, 3):
                db.session.add(Comment('这是一条评论'+str(k), 1+3*i+j, i+1))
    db.session.commit()

    # 更新
    for i in range(0, 100, 10):
        # 通过update函数
        User.query.filter_by(id=i+1).update({'username':'牛牛新'+str(i)})

    for i in range(1, 100, 2):
        # 通过设置属性
        u = User.query.get(i + 1)
        u.username = 'd' + str(i*i)
    db.session.commit()

    # 删除
    for i in range(50, 100, 2):
        Comment.query.filter_by(id = i + 1).delete()
    for i in range(51, 100, 2):
        comment = Comment.query.get(i + 1)
        db.session.delete(comment)
    db.session.commit()

    print 1, User.query.all()
    print 2, User.query.get(3) # primary key = 3
    print 3, User.query.filter_by(id=2).first()
    print 4, User.query.order_by(User.id.desc()).offset(1).limit(2).all()
    print 5, User.query.paginate(page=1, per_page=10).items
    u = User.query.get(1)
    print 6, u
    print 7, u.images
    print 8, Image.query.get(1).user
    #print 7, User.query.get(1).images.filter_by(id=1).first() # Base query:User.query.get(1).images
    #print User.query.filter_by(id=2).first_or_404()

if __name__ == '__main__':
    manager.run()
```



### 六、一对多和查询数据

http://flask-sqlalchemy.pocoo.org/2.1/models/#one-to-many-relationships


一对多
```
images = db.relationship('Image', backref='user', lazy='dynamic')
```

```
User.query.paginate(page=1, per_page=10).items
```


### 7、删除数据


query.delete()

```
Comment.query.filter_by(id = i + 1).delete()
```

db.session.delete()

```
for i in range(51, 100, 2):
	comment = Comment.query.get(i + 1)
	db.session.delete(comment)
```

### 更新数据

query.update()

```
User.query.filter_by(id>2).update({‘username’:‘新名字’+str(i)})
```

db.session.commit()


```

for i in range(1, 100, 2):
	# 通过设置属性
	u = User.query.get(i + 1)
	u.username = 'd' + str(i*i)

```


### 模板继承



base.html

```
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="description" content="">
    <meta name="Keywords" content="">

    <title>{% block title %}{% endblock%}</title>
    <link rel="stylesheet" href="{% block css %}{% endblock%}">
</head>
<body>
    <div class="container">
        <section>
            <header class="header">
                <div class="header-cont">
                    <a class="logo" href="/">logo</a>
                    <div class="web-menu">
                        <a class="profile-ico">个人主页</a>
                    </div>
                </div>
            </header>
            {% block content %}{% endblock%}

            <footer class="footer">
                <div class="footer-cont" style="max-width:935px;">
                    <nav>
                        <ul class="footer-items">
                            <li>
                                <a href="#">关于我们</a>
                            </li>
                            <li>
                                <a href="#">支持</a>
                            </li>
                            <li>
                                <a href="#">博客</a>
                            </li>
                            <li>
                                <a href="#">新闻中心</a>
                            </li>
                            <li>
                                <a href="#">API</a>
                            </li>
                            <li>
                                <a href="#">工作信息</a>
                            </li>
                            <li>
                                <a href="#">隐私</a>
                            </li>
                            <li>
                                <a href="#">条款</a>
                            </li>
                            <li>
                                <a href="#">语言</a>
                            </li>
                        </ul>
                    </nav>
                    <span class="copy-right">© 2016 niu</span>
                </div>
            </footer>
        </section>
    </div>
</body>
</html>

```


### index.html

```
{% extends "base.html" %}
{% block title %}首页{% endblock%}
{% block css %}/static/styles/pages/index.css{% endblock%}
{% block content %}
<div class="page-main clearfix">
{% for image in images: %}
    <article class="mod">
        <header class="mod-hd">
            <time class="time">{{ image.created_date }}</time>
            <a href="/profile/{{image.user.id}}" class="avatar">
                <img src="{{image.user.head_url}}">
            </a>
            <div class="profile-info">
                <a title="{{image.user.username}}" href="/profile/{{image.user.id}}">{{image.user.username}}</a>
            </div>
        </header>
        <div class="mod-bd">
            <div class="img-box">
                <a href="/image/{{image.id}}">
                    <img src="{{image.url}}">
                </a>
            </div>
        </div>
        <div class="mod-ft">
            <ul class="discuss-list">
                <li class="more-discuss">
                    <a>
                        <span>全部 </span><span class="">{{image.comments|length}}</span>
                        <span> 条评论</span></a>
                </li>
                {% for comment in image.comments: %}
                {% if loop.index > 2 %} {% break %} {% endif %}
                <li>
                    <!-- <a class=" icon-remove" title="删除评论"></a> -->
                    <a class="_4zhc5 _iqaka" title="zjuyxy" href="/profile/{{comment.user_id}}" data-reactid=".0.1.0.0.0.2.1.2:$comment-17856951190001917.1">{{comment.user.username}}</a>
                    <span>
                        <span>{{comment.content}}</span>
                    </span>
                </li>
                {%endfor%}
            </ul>
            <section class="discuss-edit">
                <form>
                    <input placeholder="添加评论..." type="text">
                </form>
                <button class="more-info">提交</button>
            </section>
        </div>
    </article>
{% endfor %}
</div>
{% endblock%}
```
