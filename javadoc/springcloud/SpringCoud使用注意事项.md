# 一、幂等问题

* 因为目前工程中很多接口未实现幂等，所以不可以超时重试。 
* spring cloud默认会尝试5次调用。在每一次调用中，尝试对某一提供方发起调用，若连接拒绝，则会进行下一个提供方的尝试。

提供方配置自定义超时时间及重试次数
```java
@Configuration
public class FeignConfig {

    @Bean
    public Feign.Builder feignBuilder() {
        Feign.Builder fb = Feign.builder();
        fb.logLevel(Logger.Level.FULL);
        fb.retryer(new Retryer.Default(100, SECONDS.toMillis(1), 1));
        return fb;
    }

    @Bean
    public Options feignOptions() {
        return new Options(2 * 1000, 10 * 1000);
    }
}
```

