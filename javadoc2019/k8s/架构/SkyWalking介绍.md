## 一、SkyWalking介绍
随着微服务架构的流行，一些微服务架构下的问题也会越来越突出，比如一个请求会涉及多个服务，而服务本身可能也会依赖其他服务，整个请求路径就构成了一个网状的调用链，而在整个调用链中一旦某个节点发生异常，整个调用链的稳定性就会受到影响，所以会深深的感受到 “银弹” 这个词是不存在的，每种架构都有其优缺点 。

**service map**

面对以上情况， 我们就需要一些可以帮助理解系统行为、用于分析性能问题的工具，以便发生故障的时候，能够快速定位和解决问题，这时候 APM（应用性能管理）工具就该闪亮登场了。

目前主要的一些 APM 工具有: Cat、Zipkin、Pinpoint、SkyWalking，这里主要介绍 SkyWalking ，它是一款优秀的国产 APM 工具，包括了分布式追踪、性能指标分析、应用和服务依赖分析等。

**下面是 SkyWalking 6.x 的架构图：**

6.x architecture

说明： SkyWalking 的核心是数据分析和度量结果的存储平台，通过 HTTP 或 gRPC 方式向 SkyWalking Collecter 提交分析和度量数据，SkyWalking Collecter 对数据进行分析和聚合，存储到 Elasticsearch、H2、MySQL、TiDB 等其一即可，最后我们可以通过 SkyWalking UI 的可视化界面对最终的结果进行查看。Skywalking 支持从多个来源和多种格式收集数据：多种语言的 Skywalking Agent 、Zipkin v1/v2 、Istio 勘测、Envoy 度量等数据格式。

## 二、界面

* 仪表盘-服务仪表盘-概要信息
* * 概要信息如慢响应、吞吐量、相应时间统计等
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222013316.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
* 仪表盘-服务仪表盘-服务信息
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222119628.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
* 仪表盘-服务仪表盘-端点
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/2020010122214565.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
* 仪表盘-服务仪表盘-实例
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222210942.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
* 仪表盘-服务仪表盘-数据库性能指标
* *  慢sql等
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222409151.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
* 拓扑图
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222453212.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222515255.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
追踪-查看调用链路
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222541745.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
追踪-服务调用情况
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222616519.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
追踪-sql 执行情况
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222636559.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
* 告警
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222742850.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
* 指标对比
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200101222748506.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)