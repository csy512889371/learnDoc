# 使用Nexus Repository 3

随着Nexus Repository Manager OSS 3的发布，虽然目前还是Nexus 2和Nexus 3并行的状态，但是Nexus 3在很多方面已经显现出很大的优势，等到Nexus 3在Maven方面的支持稳定之后就应该是Nexus 3的全面使用之时

## 安装更加简单

安装变得更加方便
*[安装参照URL](http://books.sonatype.com/nexus-book/3.0/reference/install.html?__hstc=239247836.f7854f6edce31b386d0c10d0555205f0.1487887540518.1487887540518.1489490179025.2&__hssc=239247836.3.1489490179025&__hsfp=285730640)


## 官方Docker镜像

使用官方Docker镜像使得更加容易的导入Repository Manager

1） 官方镜像	https://hub.docker.com/r/sonatype/nexus3/
2） Easypack镜像	https://github.com/liumiaocn/easypack/tree/master/containers/standard/nexus


## REST API

使用Nexus提供的API使得集成更容易进行

[API](http://books.sonatype.com/nexus-book/3.0/reference/scripting.html?__hstc=239247836.f7854f6edce31b386d0c10d0555205f0.1487887540518.1487887540518.1489490179025.2&__hssc=239247836.3.1489490179025&__hsfp=285730640)

## 用户界面

Nexus ３的界面增加了一些现代的元素，多多少少使人稍稍有些眼前一亮的感觉

## 性能

据说性能依然很好，像其标榜的那样

## Docker 私库

现在可以用Nexus 来管理Docker 私库了，统一管理，是不是很具有吸引力

[参照](https://www.sonatype.com/concepts-benefits-repo-management?__hstc=239247836.f7854f6edce31b386d0c10d0555205f0.1487887540518.1487887540518.1489490179025.2&__hssc=239247836.3.1489490179025&__hsfp=285730640)

## npm与bower

支持npm和bower的package管理，对前端工程师造成了很大的诱惑，目前此项优势继续保持中。

## Raw repositories

在Nexus 3中支持一种新的方式：raw repositories。利用这种方式，任何文件都可以像Maven管理对象文件那样被管理起来，对所有的artifacts进行统一集成管理。

## NuGet repositories

支持NuGet repositories，对于.Net开发者来说，这无疑是一个福音

## 支持检索

对于Nexus所支持的任何类型都支持检索功能，这使得无论任何情况下我们都能利用这些功能进行精确定位

## 支持浏览

支持对其仓库的内容进行浏览，非常方便

## 检查机制

对Maven/NuGet/npm仓库，支持安全以及license的检查，使得使用起来更无后顾之忧

> Nexus物美价廉，又提供功能全面的oss版，加之支持种类众多的倚赖管理，又可以统一管理docker镜像，界面也在慢慢好看起来.





