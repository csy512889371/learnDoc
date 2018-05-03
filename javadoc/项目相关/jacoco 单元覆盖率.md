# jacoco

## 一、概述


 需求覆盖：指的是测试人员对需求的了解程度，根据需求的可测试性来拆分成各个子需求点，来编写相应的测试用例，最终建立一个需求和用例的映射关系，以用例的测试结果来验证需求的实现，可以理解为黑盒覆盖。

代码覆盖：为了更加全面的覆盖，我们可能还需要理解被测程序的逻辑，需要考虑到每个函数的输入与输出，逻辑分支代码的执行情况，这个时候我们的测试执行情况就以代码覆盖率来衡量，可以理解为白盒覆盖。

市场上java主要代码覆盖率工具：EMMA、JaCoCo。

JaCoCo优势的理解：

(1) JaCoCo支持分支覆盖、引入了Agent模式。

(2) EMMA官网已经不维护了，JaCoCo是其团队开发的，可以理解为一个升级版。

(3) JaCoCo社区比较活跃，官网也在不断的维护更新。

## 二、jaCoCo简述
JaCoCo是一个开源的覆盖率工具(官网地址：http://www.eclemma.org/JaCoCo/)，它针对的开发语言是java，其使用方法很灵活，可以嵌入到Ant、Maven中；可以作为Eclipse插件，可以使用其JavaAgent技术监控Java程序等等。

很多第三方的工具提供了对JaCoCo的集成，如sonar、Jenkins等。

JaCoCo包含了多种尺度的覆盖率计数器,包含指令级覆盖(Instructions,C0coverage)，分支（Branches,C1coverage）、圈复杂度(CyclomaticComplexity)、行覆盖(Lines)、方法覆盖(non-abstract methods)、类覆盖(classes)

## 三、示例代码

```

<plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>0.7.5.201505241946</version>
                <executions>
                    <execution>
                        <id>default-prepare-agent</id>
                        <goals>
                            <goal>prepare-agent</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>default-report</id>
                        <phase>prepare-package</phase>
                        <goals>
                            <goal>report</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>default-check</id>
                        <phase>prepare-package</phase>
                        <goals>
                            <goal>check</goal>
                        </goals>
                        <configuration>
                            <rules>
                                <rule>
                                    <element>CLASS</element>
                                    <includes>
                                        <include>cn.ctoedu.service.*.*</include>
                                        <include>cn.ctoedu.repository.*</include>
                                    </includes>
                                    <limits>
                                        <limit>
                                            <counter>LINE</counter>
                                            <value>COVEREDRATIO</value>
                                            <minimum>0.00</minimum>
                                        </limit>
                                    </limits>
                                </rule>
                            </rules>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
```




