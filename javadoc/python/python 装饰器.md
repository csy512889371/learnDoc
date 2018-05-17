# python 装饰器


## 概述

装饰器本质上是一个Python函数，它可以让其他函数在不需要做任何代码变动的前提下增加额外功能，装饰器的返回值也是一个函数对象。它经常用于有切面需求的场景，比如：插入日志、性能测试、事务处理、缓存、权限校验等场景。装饰器是解决这类问题的绝佳设计，有了装饰器，我们就可以抽离出大量与函数功能本身无关的雷同代码并继续重用。概括的讲，装饰器的作用就是为已经存在的对象添加额外的功能。

## 代码

```
#-*- encoding=UTF-8 -*-

def log(level, *args, **kvargs):
    def inner(func):
        '''
        * 无名字参数
        ** 有名字参数
        '''

        def wrapper(*args, **kvargs):
            print level, 'before calling ', func.__name__
            print level, 'args', args, 'kvargs', kvargs
            func(*args, **kvargs)
            print level, 'end calling ', func.__name__

        return wrapper
    return inner


@log(level='INFO')
def hello(name, age):
    print 'hello', name, age

if __name__ == '__main__':
    hello(name='nowcoder', age=2) #= log(hello())
```