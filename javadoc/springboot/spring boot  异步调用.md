# spring boot  异步调用

通常情况下，”同步调用”执行程序所花费的时间比较多，执行效率比较差。所以，在代码本身不存在依赖关系的话，我们可以考虑通过”异步调用”的方式来并发执行。

在 spring boot 框架中，只要提过@Async注解就能奖普通的同步任务改为异步调用任务。


## 一、开启异步处理

@EnableAsync      //开启异步处理

```java
@SpringBootApplication
@EnableAsync      //开启异步处理
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}
}
```

## 二、AsyncTask
```java
@Component
public class AsyncTask {
	//@Async所修饰的函数不要定义为static类型，这样异步调用不会生效
	//异步回调不返回数据
	@Async
	 public void dealNoReturnTask(){
		
	  System.out.println("Thread {} deal No Return Task start"+ "    "+Thread.currentThread().getName());
	  try {
	   Thread.sleep(3000);
	  } catch (InterruptedException e) {
	   e.printStackTrace();
	  }
	  System.out.println("Thread {} deal No Return Task end at {}"+"    "+Thread.currentThread().getName()+"    "+System.currentTimeMillis());
	 }
	//异步回调返回数据
	@Async
	public Future<String> dealHaveReturnTask() {
	 try {
	  Thread.sleep(3000);
	 } catch (InterruptedException e) {
	  e.printStackTrace();
	 }
	
	 return new AsyncResult<String>("异步回调返回数据！");
	}
}
```


## 三、调用

```java
		//不带返回值的异步回调
//		 asyncTask.dealNoReturnTask();
//		  try {
//	   	  System.out.println("begin to deal other Task!");
//		   Thread.sleep(10000);
//		  } catch (InterruptedException e) {
//		   e.printStackTrace();
//		  }
		//带返回值的异步回调
			//用future.get()来获取异步任务的返回结果
//			Future<String> future = asyncTask.dealHaveReturnTask();
//			System.out.println("begin to deal other Task!");
//			 while (true) {
//			  if(future.isCancelled()){
//				  System.out.println("deal async task is Cancelled");
//			      break;
//			  }
//			  if (future.isDone() ) {
//				  System.out.println("deal async task is Done");
//				  System.out.println("return result is " + future.get());
//			      break;
//			  }
//			  System.out.println("wait async task to end ...");
//			  Thread.sleep(1000);
//			 }
	}

```