# Spring Cloud Zuul微服务网关的API限流


## API限流


微服务开发中有时需要对API做限流保护，防止网络攻击，比如做一个短信验证码API，限制客户端的请求速率能在一定程度上抵御短信轰炸攻击，降低损失。

微服务网关是每个请求的必经入口，非常适合做一些API限流、认证之类的操作，这里有一个基于zuul微服务网关的API限流库： 
https://github.com/marcosbarbero/spring-cloud-zuul-ratelimit

### 使用方法

比如我们要对userinfo-consumer这个服务进行限流，限制每个请求源每分钟最多只能请求三次，首先在项目中添加zuul和ratelimit的依赖，然后再添加如下配置即可：

```
zuul.routes.userinfo.path=/getuser/**
zuul.routes.userinfo.serviceId=userinfo-consumer
zuul.ratelimit.enabled=true
zuul.ratelimit.policies.userinfo.limit=3
zuul.ratelimit.policies.userinfo.refresh-interval=60
zuul.ratelimit.policies.userinfo.type=origin
```

* 测试客户端如果60s内请求超过三次，服务端就抛出异常，一分钟后又可以正常请求
* 某个IP的客户端被限流并不影响其他客户端，即API网关对每个客户端限流是相互独立的

### 原理分析

> 对API限流是基于zuul过滤器完成的，如果不使用redis，限流数据是记录在内存中的，一般在开发环境中可以直接记录在内存中，生产环境中还是要使用Redis。

### 限流拦截时机

限流过滤器是在请求被转发之前调用的


```
@Override
    public String filterType() {
        return "pre";
    }
```

> 限流类型

限流类型主要包括url、origin、user三种

```
if (types.contains(URL)) {
       joiner.add(route.getPath());
   }
   if (types.contains(ORIGIN)) {
       joiner.add(getRemoteAddr(request));
   }
   if (types.contains(USER)) {
       joiner.add(request.getUserPrincipal() != null ? request.getUserPrincipal().getName() : ANONYMOUS);
   }
```

* url类型的限流就是通过请求路径区分
* origin是通过客户端IP地址区分
* user是通过登录用户名进行区分，也包括匿名用户
* 也可以多个限流类型结合使用
* 如果不配置限流类型，就不做以上区分


### 拦截限流请求

在过滤器的run方法中判断请求剩余次数

```
 if (rate.getRemaining() < 0) {
       ctx.setResponseStatusCode(TOO_MANY_REQUESTS.value());
       ctx.put("rateLimitExceeded", "true");
       throw new ZuulRuntimeException(new ZuulException(TOO_MANY_REQUESTS.toString(),
               TOO_MANY_REQUESTS.value(), null));
   }
```
