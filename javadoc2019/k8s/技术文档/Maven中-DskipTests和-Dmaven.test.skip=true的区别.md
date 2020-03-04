>  在使用mvn package进行编译、打包时，Maven会执行src/test/java中的JUnit测试用例，有时为了跳过测试，会使用参数-DskipTests和-Dmaven.test.skip=true，这两个参数的主要区别是：
>
> 

* -DskipTests，不执行测试用例，但编译测试用例类生成相应的class文件至target/test-classes下。

* -Dmaven.test.skip=true，不执行测试用例，也不编译测试用例类。

