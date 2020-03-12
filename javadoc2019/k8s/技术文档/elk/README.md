项目日志 -> Filebeat -> redis -> Logstash -> ElasticSearch -> Kibana (性能高，会影响到redis)
项目日志 -> Filebeat -> kafka -> Logstash -> ElasticSearch -> Kibana  (性能高)
项目日志 -> kafka -> Logstash -> ElasticSearch -> Kibana (有代码依赖性)
项目日志 -> Logstash -> ElasticSearch -> Kibana (性能低)
项目日志 json -> Filebeat -> ElasticSearch -> Kibana