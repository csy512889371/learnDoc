# springboot定时任务
定时任务一般会存在中大型企业级项目中，为了减少服务器、数据库的压力往往会采用时间段性的去完成某些业务逻辑。比较常见的就是金融服务系统推送回调，一般支付系统订单在没有收到成功的回调返回内容时会持续性的回调，这种回调一般都是定时任务来完成的。还有就是报表的生成，我们一般会在客户访问量过小的时候来完成这个操作，那往往都是在凌晨。这时我们也可以采用定时任务来完成逻辑。SpringBoot为我们内置了定时任务，我们只需要一个注解就可以开启定时为我们所用了。


* @EnableScheduling

```java

@EnableScheduling   //开始定时任务
@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}
}
```

```java
@Component
public class ScheduledTasks {
    
    private static final SimpleDateFormat dataFormat=new SimpleDateFormat("HH:mm:ss");
//	 @Scheduled(fixedRate = 5000) ：上一次开始执行时间点之后5秒再执行
//  @Scheduled(fixedDelay = 5000) ：上一次执行完毕时间点之后5秒再执行
// @Scheduled(initialDelay=1000, fixedRate=5000) ：第一次延迟1秒后执行，之后按fixedRate的规则每5秒执行一次
//  @Scheduled(cron="*/5 * * * * *") 通过cron表达式定义规则
//https://spring.io/guides/gs/scheduling-tasks/
    @Scheduled(fixedRate=1000)
    public void showCurrentTime(){
    	//System.out.println("时间为："+dataFormat.format(new Date()));
    }
}
```

## cron属性
这是一个时间表达式，可以通过简单的配置就能完成各种时间的配置，我们通过CRON表达式几乎可以完成任意的时间搭配，它包含了六或七个域：

* Seconds : 可出现", - * /"四个字符，有效范围为0-59的整数
* Minutes : 可出现", - * /"四个字符，有效范围为0-59的整数
* Hours : 可出现", - * /"四个字符，有效范围为0-23的整数
* DayofMonth : 可出现", - * / ? L W C"八个字符，有效范围为0-31的整数
* Month : 可出现", - * /"四个字符，有效范围为1-12的整数或JAN-DEc
* DayofWeek : 可出现", - * / ? L C #"四个字符，有效范围为1-7的整数或SUN-SAT两个范围。1表示星期天，2表示星期一， 依次类推
* Year : 可出现", - * /"四个字符，有效范围为1970-2099年

## fixedRate属性

该属性的含义是上一个调用开始后再次调用的延时（不用等待上一次调用完成），这样就会存在重复执行的问题，所以不是建议使用，但数据量如果不大时在配置的间隔时间内可以执行完也是可以使用的。


## fixedDelay属性

该属性的功效与上面的fixedRate则是相反的，配置了该属性后会等到方法执行完成后延迟配置的时间再次执行该方法。配置示例如下图7所示

## initialDelay属性

该属性跟上面的fixedDelay、fixedRate有着密切的关系，为什么这么说呢？该属性的作用是第一次执行延迟时间，只是做延迟的设定，并不会控制其他逻辑，所以要配合fixedDelay或者fixedRate来使用

