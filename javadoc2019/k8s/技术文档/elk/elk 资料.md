###### logstash 和filebeat 是什么关系
因为logstash是jvm跑的，资源消耗比较大，所以后来作者又用golang写了一个功能较少但是资源消耗也小的轻量级的logstash-forwarder。不过作者只是一个人，加入http://elastic.co公司以后，因为es公司本身还收购了另一个开源项目packetbeat，而这个项目专门就是用golang的，有整个团队，所以es公司干脆把logstash-forwarder的开发工作也合并到同一个golang团队来搞，于是新的项目就叫filebeat了。



logstash 和filebeat都具有日志收集功能，filebeat更轻量，占用资源更少，但logstash 具有filter功能，能过滤分析日志。一般结构都是filebeat采集日志，然后发送到消息队列，redis，kafaka。然后logstash去获取，利用filter功能过滤分析，然后存储到elasticsearch中
