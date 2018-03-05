# Spring boot Redis 实体对象类型支持

## 一、序列号和反序列化
```java
public class RedisObjectSerializer implements RedisSerializer<Object> {
  private Converter<Object, byte[]> serializer = new SerializingConverter();
  private Converter<byte[], Object> deserializer = new DeserializingConverter();
  static final byte[] EMPTY_ARRAY = new byte[0];
  public Object deserialize(byte[] bytes) {
    if (isEmpty(bytes)) {
      return null;
    }
    try {
      return deserializer.convert(bytes);
    } catch (Exception ex) {
      throw new SerializationException("Cannot deserialize", ex);
    }
  }
  public byte[] serialize(Object object) {
    if (object == null) {
      return EMPTY_ARRAY;
    }
    try {
      return serializer.convert(object);
    } catch (Exception ex) {
      return EMPTY_ARRAY;
    }
  }
  private boolean isEmpty(byte[] data) {
    return (data == null || data.length == 0);
  }
}
```

## 二、RedisConfig

```java
@Configuration
public class RedisConfig {
//    @Bean
//    JedisConnectionFactory jedisConnectionFactory() {
//        return new JedisConnectionFactory();
//    }
    @Bean
    public RedisTemplate<String, User1> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, User1> template = new RedisTemplate<String, User1>();
        template.setConnectionFactory(factory);
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new RedisObjectSerializer());
        return template;
    }
}
```


