# Spring Boot中使用Swagger2构建强大的RESTful API文档

由于Spring Boot能够快速开发、便捷部署等特性，相信有很大一部分Spring Boot的用户会用来构建RESTful API。而我们构建RESTful API的目的通常都是由于多终端的原因，这些终端会共用很多底层业务逻辑，因此我们会抽象出这样一层来同时服务于多个移动端或者Web前端。

## 问题
这样一来，我们的RESTful API就有可能要面对多个开发人员或多个开发团队：IOS开发、Android开发或是Web开发等。为了减少与其他团队平时开发期间的频繁沟通成本，传统做法我们会创建一份RESTful API文档来记录所有接口细节，然而这样的做法有以下几个问题：

* 由于接口众多，并且细节复杂（需要考虑不同的HTTP请求类型、HTTP头部信息、HTTP请求内容等），高质量地创建这份文档本身就是件非常吃力的事，下游的抱怨声不绝于耳。
* 随着时间推移，不断修改接口实现的时候都必须同步修改接口文档，而文档与代码又处于两个不同的媒介，除非有严格的管理机制，不然很容易导致不一致现象
* Swagger2，它可以轻松的整合到Spring Boot中，并与Spring MVC程序配合组织出强大RESTful API文档。它既可以减少我们创建文档的工作量，同时说明内容又整合入实现代码中，让维护文档和修改代码整合为一体，可以让我们在修改代码逻辑的同时方便的修改文档说明。另外Swagger2也提供了强大的页面测试功能来调试每个RESTful API。
  
## 构建Swagger2

添加Swagger2依赖
```xml
		<springfox-swagger2.version>2.2.2</springfox-swagger2.version>
		
		<dependency>
			<groupId>io.springfox</groupId>
			<artifactId>springfox-swagger2</artifactId>
			<version>${springfox-swagger2.version}</version>
		</dependency>
		<dependency>
			<groupId>io.springfox</groupId>
			<artifactId>springfox-swagger-ui</artifactId>
			<version>${springfox-swagger2.version}</version>
		</dependency>
```
## 创建Swagger2配置类
   
在Application.java同级创建Swagger2的配置类Swagger2。
```xml
@Configuration
@EnableSwagger2
public class Swagger2 {

    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.cto.edu"))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("架构师的成长之路RESTful APIs")
                .description("官网 http://111.231.142.109/")
                .termsOfServiceUrl("http://localhost:8081/")
                .contact("ctoDev")
                .version("1.0")
                .build();
    }

}
```

## 添加文档内容

通过@ApiOperation注解来给API增加说明、通过@ApiImplicitParams、@ApiImplicitParam注解来给参数增加说明

```java
@RestController
@RequestMapping("/api/blog/topic")
public class BlogTopicController {

    private static final Logger LOG = LoggerFactory.getLogger(BlogTopicController.class);

    @Resource
    private BlogTopicFacade blogTopicFacade;

    @ApiOperation(value = "分页获取主题列表", notes = "根据类别获取类别下的主题列表")
    @ApiImplicitParam(name = "obj", value = "{\"categoryIds\":[],\"number\":0,\"size\":1}", required = true, dataType = "JSONObject")
    @SuppressWarnings("unchecked")
    @PostMapping(value = "/findForPage")
    public ViewerResult findForPage(@RequestBody JSONObject obj) {

        ViewerResult result = new ViewerResult();
        try {
            List<String> categoryIds = (List<String>) obj.get("categoryIds");
            int number = obj.getInteger("number");
            int size = obj.getInteger("size");
            Pageable page = PageRequest.of(number, size);
            Searchable searchable = Searchable.newSearchable();
            searchable.setPage(page);

            if (categoryIds == null || categoryIds.isEmpty()) {
                Page<BlogTopic> topicPage = blogTopicFacade.listPage(searchable);
                result.setData(topicPage);
            } else {
                Page<BlogTopic> topicList = blogTopicFacade.findTopicByCategoryIds(categoryIds, page);
                result.setData(topicList);
            }

            result.setSuccess(true);
        } catch (Exception e) {
            result.setSuccess(false);
            result.setErrMessage("查找主题失败");
            LOG.error(e.getMessage(), e);
        }
        return result;
    }

    @ApiOperation(value = "获取主题信息", notes = "根据Id获取主题信息")
    @ApiImplicitParam(name = "obj", value = "{\"id\":\"1\"}", required = true, dataType = "JSONObject")
    @PostMapping(value = "/findById")
    public ViewerResult findById(@RequestBody JSONObject obj) {
        ViewerResult result = new ViewerResult();
        BlogTopic topic = null;
        try {
            String id = obj.getString("id");
            topic = blogTopicFacade.getById(id);
            result.setSuccess(true);
            result.setData(topic);
        } catch (Exception e) {
            result.setSuccess(false);
            result.setErrMessage(e.getMessage());
            LOG.error(e.getMessage(), e);
        }
        return result;
    }

}

```

### API详细说明

| 作用范围   | API   |  使用位置  |
| --------   | :-----  | :----:  |
| 对象属性	 | @ApiModelProperty |	用在出入参数对象的字段上|
| 协议集描述 | @Api| 用于controller类上|
| 协议描述	 | @ApiOperation |	用在controller的方法上|
| Response集 | @ApiResponses |	用在controller的方法上|
| Response	 | @ApiResponse	| 用在 @ApiResponses里边|
| 非对象参数集	 | @ApiImplicitParams |	用在controller的方法上|
| 非对象参数描述	 | @ApiImplicitParam |	用在@ApiImplicitParams的方法里边|
| 描述返回对象的意义	 | @ApiModel | 用在返回对象类上|

### @ApiImplicitParam 
* paramType 查询参数类型
* dataType 参数的数据类型 只作为标志说明，并没有实际验证
* name 接收参数名
* value 接收参数的意义描述
* required 参数是否必填
* defaultValue 默认值

### paramType 示例详解

query 直接跟参数完成自动映射赋值
```java
    @GetMapping(value = "/sayParam")
    @ApiOperation(value = "信息应答", notes = "返回基本信息")
    @ApiImplicitParams({
            @ApiImplicitParam(paramType = "query", name = "info", value = "应答内容", dataType = "String")
    })
    
    @RequestParam(value = "info", required = false, defaultValue = "架构师的成长之路") String myInfo
```

path 以地址的形式提交数据
```java
@RequestMapping(value = "/findById1/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
@PathVariable(name = "id") Long id
```
body 以流的形式提交 仅支持POST
```java
  @ApiImplicitParams({ @ApiImplicitParam(paramType = "body", dataType = "MessageParam", name = "param", value = "信息参数", required = true) })
  @RequestMapping(value = "/findById3", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
  @RequestBody MessageParam param
提交的参数是这个对象的一个json，然后会自动解析到对应的字段上去，也可以通过流的形式接收当前的请求数据，但是这个和上面的接收方式仅能使用一个（用@RequestBody之后流就会关闭了）
```
header 参数在request headers 里边提交
```java

@ApiImplicitParams({ @ApiImplicitParam(paramType = "header", dataType = "Long", name = "id", value = "信息id", required = true) }) 

    String idstr = request.getHeader("id");
    if (StringUtils.isNumeric(idstr)) {
        id = Long.parseLong(idstr);
    }
```

Form 以form表单的形式提交 仅支持POST
```java
@ApiImplicitParams({ @ApiImplicitParam(paramType = "form", dataType = "Long", name = "id", value = "信息id", required = true) })
 @RequestMapping(value = "/findById5", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE, consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
```


## 访问

启动Spring Boot程序，访问：http://localhost:8081/swagger-ui.html



