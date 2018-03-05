# springboot 多数据源配置

## 一、配置文件

```xml
spring.datasource.url=jdbc:mysql://10.211.55.8/ctoedu?useUnicode=true&characterEncoding=utf-8
spring.datasource.username=root
spring.datasource.password=ctoedu
spring.datasource.driver-class=com.mysql.jdbc.Driver


spring.datasource.primary.url=jdbc:mysql://10.211.55.8/ctoedu?useUnicode=true&characterEncoding=utf-8
spring.datasource.primary.username=root
spring.datasource.primary.password=ctoedu
spring.datasource.primary.driver-class=com.mysql.jdbc.Driver

spring.datasource.secondary.url=jdbc:mysql://10.211.55.8/ctoedu?useUnicode=true&characterEncoding=utf-8
spring.datasource.secondary.username=root
spring.datasource.secondary.password=ctoedu
spring.datasource.secondary.driver-class=com.mysql.jdbc.Driver
```

## 二、JDBC多数据源

DataSourceConfig

```java
@Configuration
public class DataSourceConfig {

   @Bean(name="primaryDataSource")
   @Qualifier("primaryDataSource")
   @ConfigurationProperties(prefix="spring.datasource.primary")
   public DataSource primaryDataSource(){
	   return DataSourceBuilder.create().build();
   }
   
   @Bean(name="seoncodaryDataSource")
   @Qualifier("secondaryDataSource")
   @Primary
   @ConfigurationProperties(prefix="spring.datasource.secondary")
   public DataSource secoundaryDataSource(){
	   return DataSourceBuilder.create().build();
   }
   
   //支持JdbcTemplate实现多数据源
   @Bean(name="primaryJdbcTemplate")
   public JdbcTemplate primaryJdbcTemplate(
		   @Qualifier("primaryDataSource") DataSource dataSource){
	   return new JdbcTemplate(dataSource);
	   }
   @Bean(name="secondaryJdbcTemplate")
   public JdbcTemplate secondaryJdbcTemplate(
		   @Qualifier("secondaryDataSource") DataSource dataSource){
	   return new JdbcTemplate(dataSource);
	   }
   }
```

## 三、Jpa data 多数据源

```java
@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(
		   entityManagerFactoryRef="entityManagerFactoryPrimary",
	        transactionManagerRef="transactionManagerPrimary",
	        basePackages= { "com.ctoedu.service.Domain.Primary" } //设置Repository所在位置
)
public class PrimaryConfig {
	  @Autowired
	  @Qualifier("primaryDataSource") 
	  private DataSource primaryDataSource;
	  
	    @Primary
	    @Bean(name = "entityManagerFactoryPrimary")
	    public LocalContainerEntityManagerFactoryBean entityManagerFactoryPrimary (EntityManagerFactoryBuilder builder) {
	        return builder
	                .dataSource(primaryDataSource)
	                .properties(getVendorProperties(primaryDataSource))
	                .packages("com.ctoedu.service.Domain.Primary") //设置实体类所在位置
	                .persistenceUnit("primaryPersistenceUnit")
	                .build();
	    }
	    @Autowired
	    private JpaProperties jpaProperties;
	    private Map<String, String> getVendorProperties(DataSource dataSource) {
	        return jpaProperties.getHibernateProperties(dataSource);
	    }
	    @Primary
	    @Bean(name = "transactionManagerPrimary")
	    public PlatformTransactionManager transactionManagerPrimary(EntityManagerFactoryBuilder builder) {
	        return new JpaTransactionManager(entityManagerFactoryPrimary(builder).getObject());
	    }
}
```
