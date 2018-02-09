# Lombok简介

lombok 能够减少大量的模板代码

## 生成 gettter，setter

```java
import lombok.Getter;  
import lombok.Setter;  

@Getter  
@Setter  
public class GetterSetterExample1 {  
  
    private int age = 10;  
      
    private String name ="张三丰";  
      
    private boolean registerd;  
      
    private String sex;  
  
}  
```

## @Data 
注解在类上, 为类提供读写属性, 此外还提供了 equals()、hashCode()、toString() 方法

## @Slf4j
注解在类上, 为类提供一个属性名为 log 的 log4j 的日志对象

## @NoArgsConstructor @AllArgsConstructor
提供无参构造方法、和全参数构造方法


