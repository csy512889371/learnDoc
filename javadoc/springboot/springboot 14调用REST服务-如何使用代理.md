# 调用REST服务
* 调用REST服务
* 使用代理调用rest服务

# 添加依赖
```xml
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
</dependency>
```

```java
@Autowired
    private RestTemplateBuilder restTemplateBuilder;

    /**
     * get请求
     */
    @Test
    public void getForObject() {

        ViewerResult bean = restTemplateBuilder.build().getForObject("http://localhost:8081/api/blog/category/findAll", ViewerResult.class);
        System.out.println(bean);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("id", 2);
        ViewerResult bean = restTemplateBuilder.build().postForObject("http://localhost:8081/api/blog/category/findAll", map, ViewerResult.class);
        System.out.println(bean);

        String result = restTemplateBuilder.additionalCustomizers(new ProxyCustomizer()).build().getForObject("http://111.231.142.109", String.class);
        System.out.println(result);

    }

    static class ProxyCustomizer implements RestTemplateCustomizer {
        @Override
        public void customize(RestTemplate restTemplate) {
            String proxyHost = "43.255.104.179";
            int proxyPort = 8080;

            HttpHost proxy = new HttpHost(proxyHost, proxyPort);
            HttpClient httpClient = HttpClientBuilder.create().setRoutePlanner(new DefaultProxyRoutePlanner(proxy) {
                @Override
                public HttpHost determineProxy(HttpHost target, HttpRequest request, HttpContext context)
                        throws HttpException {
                    System.out.println(target.getHostName());
                    return super.determineProxy(target, request, context);
                }
            }).build();
            HttpComponentsClientHttpRequestFactory httpComponentsClientHttpRequestFactory = new HttpComponentsClientHttpRequestFactory(
                    httpClient);
            httpComponentsClientHttpRequestFactory.setConnectTimeout(10000);
            httpComponentsClientHttpRequestFactory.setReadTimeout(60000);
            restTemplate.setRequestFactory(httpComponentsClientHttpRequestFactory);
        }
    }
```

# 在线代理：
* http://ip.zdaye.com/
