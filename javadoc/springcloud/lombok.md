# lombok

> lombok 提供了简单的注解的形式来帮助我们简化消除一些必须有但显得很臃肿的 java 代码。


## lombok 注解：
>* lombok 提供的注解不多，可以参考官方视频的讲解和官方文档。
>* Lombok 注解在线帮助文档：http://projectlombok.org/features/index.

下面介绍几个我常用的 lombok 注解：
>* @Data   ：注解在类上；提供类所有属性的 getting 和 setting 方法，此外还提供了equals、canEqual、hashCode、toString 方法
>* @Setter：注解在属性上；为属性提供 setting 方法
>* @Getter：注解在属性上；为属性提供 getting 方法
>* @Log4j ：注解在类上；为类提供一个 属性名为log 的 log4j 日志对象
>* @NoArgsConstructor：注解在类上；为类提供一个无参的构造方法
>* @AllArgsConstructor：注解在类上；为类提供一个全参的构造方法

## lombok 安装
> 使用 lombok 是需要安装的，如果不安装，IDE 则无法解析 lombok 注解。先在官网下载最新版本的 JAR 包


## 例子
```java
@Data
public class CartInfo implements Serializable{

    private Long id;
    private String name;
    private String imageUrl;
    private String colour;
    private String size;
    private Long price;
    private Long weight;
    private Integer num;
    @Setter(value = AccessLevel.PRIVATE)
    private Long sum;

    public Long getSum() {
        return price * num;
    }
}
```