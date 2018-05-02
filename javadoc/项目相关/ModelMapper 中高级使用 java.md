# ModelMapper 中高级使用 java

## 概述

ModelMapper是一个从对象到对象（object-to-object）的框架，能将Java Bean（Pojo）对象从一种表现形式转化为另一种表现形式。它采用“通过约定来配置”的方式，自动匹配不同的对象映射，同时具备满足某些特殊需求的高级功能。这与.NET的AutoMapper库很类似（但不是直接移植）。

ModelMapper能用更加紧凑的代码对Java对象进行映射，在更简单的情况下甚至可以实现零配置。它支持以下特性：

```
基于名称的对象属性映射
复制公开的、受保护的和私有的字段
略过某些字段
可用转换器来影响映射（如将字符串转换为小写）
在不同类型的字段间进行映射（如将字符串转换为数字）
采用不同的条件进行映射
默认条件不充分时采用松散的映射策略
对映射过程进行验证以确保所有字段都被处理
对特殊情况下的映射过程进行完全可定制化的控制
与Guice或Spring集成
```

在企业应用中，将对象从一种形式转换成另一种是非常普遍的模式。例如，某领域模型从数据库中加载，并需要在GUI上显示给用户。其原始数据库格式会包含大量用于生命周期的属性，而屏幕前的用户可能只关心其中的一两个字段。所以很多时候，用于数据库的Pojo（JPA实体）与用于GUI的Pojo是不同的。这正是ModelMapper试图解决的问题。一般来说，当信息在企业应用内的层之间发生改变时，就会发生对象转换。

其他会发生对象转换的场景包括：

```
多个对象聚合成一个
在已存在的对象中计算一些额外的元数据
转换对象以便发送到外部系统中
未定义的属性里赋予默认值
通过某种方式来转换已有的属性（对象自映射）
```


官网http://modelmapper.org/



## 例子一

```
ModelMapper modelMapper = new ModelMapper();
 modelMapper.addMappings(new PropertyMap<AnEntity, ADTO>() {
            protected void configure() {
                //属性名不一样，自己设置对应关系
                //source生成目标类，destination数据来源类，这两个单词可以理解成两个指针，代指类
                map().setText(source.getDescription());
                //不映射某些属性
                //属性是对象的可以如下
                skip().setDtoOnlyProperty(null);
                //属性非对象的
                skip(destination.getID());//可以对source中属性设置，也可以对destination的属性设置
            }
        });
 ADTO adto = modelMapper.map(entity, ADTO.class);
```

## 例子二

预定义 modelMapper bean

```
    @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();
    }
```


```
    @Autowired
    private ModelMapper modelMapper;



    @Override
    public ServiceMultiResult<SupportAddressDTO> findAllCities() {
        List<SupportAddress> addresses = supportAddressRepository.findAllByLevel(SupportAddress.Level.CITY.getValue());
        List<SupportAddressDTO> addressDTOS = new ArrayList<>();
        for (SupportAddress supportAddress : addresses) {
            SupportAddressDTO target = modelMapper.map(supportAddress, SupportAddressDTO.class);
            addressDTOS.add(target);
        }

        return new ServiceMultiResult<>(addressDTOS.size(), addressDTOS);
    }
```