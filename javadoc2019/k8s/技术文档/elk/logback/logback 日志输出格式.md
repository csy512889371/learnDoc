【前言】
         日志对一个系统的重要性不言而喻；日志通常是在排查问题时给人看，一个友好的输出样式让人看到后赏心悦目，排查效率通常也会随之提高；下面为大家共享一下通过设置logback日志输出格式，打印出令人欣喜的日志样式。

【搞一下日志格式】
        一、未指定日志格式，日志输出

              1、代码实现
    
                  （1）演示日志输出控制器
```
/*
 * Copyright (c) 2019. zhanghan_java@163.com All Rights Reserved.
 * 项目名称：实战SpringBoot
 * 类名称：CheckMobileController.java
 * 创建人：张晗
 * 联系方式：zhanghan_java@163.com
 * 开源地址: https://github.com/dangnianchuntian/springboot
 * 博客地址: https://zhanghan.blog.csdn.net
 */

package com.zhanghan.zhboot.controller;

import com.mysql.jdbc.StringUtils;
import com.zhanghan.zhboot.controller.request.MobileCheckRequest;
import com.zhanghan.zhboot.properties.MobilePreFixProperties;
import com.zhanghan.zhboot.util.wrapper.WrapMapper;
import com.zhanghan.zhboot.util.wrapper.Wrapper;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@Api(value = "校验手机号控制器", tags = {"校验手机号控制器"})
public class CheckMobileController {

    private static Logger logger = LoggerFactory.getLogger(CheckMobileController.class);
     
    @Autowired
    private MobilePreFixProperties mobilePreFixProperties;
     
    @ApiOperation(value = "优雅校验手机号格式方式", tags = {"校验手机号控制器"})
    @RequestMapping(value = "/good/check/mobile", method = RequestMethod.POST)
    public Wrapper goodCheckMobile(@RequestBody @Validated MobileCheckRequest mobileCheckRequest) {
     
        logger.info("good check mobile param {}", mobileCheckRequest.toString());
     
        String countryCode = mobileCheckRequest.getCountryCode();
        String proFix = mobilePreFixProperties.getPrefixs().get(countryCode);
     
        if (StringUtils.isNullOrEmpty(proFix)) {
            logger.error("good check mobile param is error; param is {}, profix is {}", mobileCheckRequest.toString(), proFix);
            return WrapMapper.error("参数错误");
        }
     
        String mobile = mobileCheckRequest.getMobile();
     
        Boolean isLegal = false;
        if (mobile.startsWith(proFix)) {
            isLegal = true;
        }

 

        Map map = new HashMap();
        map.put("mobile", mobile);
        map.put("isLegal", isLegal);
        map.put("proFix", proFix);
        return WrapMapper.ok(map);
    }
     
    @ApiOperation(value = "扩展性差校验手机号格式方式", tags = {"校验手机号控制器"})
    @RequestMapping(value = "/bad/check/mobile", method = RequestMethod.POST)
    public Wrapper badCheckMobile(@RequestBody MobileCheckRequest mobileCheckRequest) {
     
        logger.info("bad check mobile param {}", mobileCheckRequest.toString());
     
        String countryCode = mobileCheckRequest.getCountryCode();
     
        String proFix = "";
        if (countryCode.equals("CN")) {
            proFix = "86";
        } else if (countryCode.equals("US")) {
            proFix = "1";
        } else {
            logger.error("bad check mobile param is error; param is {}, profix is {}", mobileCheckRequest.toString(), proFix);
            return WrapMapper.error("参数错误");
        }
     
        String mobile = mobileCheckRequest.getMobile();
     
        Boolean isLegal = false;
        if (mobile.startsWith(proFix)) {
            isLegal = true;
        }
     
        Map map = new HashMap();
        map.put("mobile", mobile);
        map.put("isLegal", isLegal);
        map.put("proFix", proFix);
        return WrapMapper.ok(map);
    }

}
```

              2、项目部署服务器后访问打印日志的效果



        二、指定日志格式，日志输出
    
              1、代码实现
    
                  （1）演示日志输出控制器（同上）
    
                  （2）在项目的resources目录下增加logback.xml设置打印格式，logback.xml内容如下：
```
<?xml version="1.0" encoding="UTF-8"?>
<!-- 说明： 1、日志级别及文件 日志记录采用分级记录，级别与日志文件名相对应，不同级别的日志信息记录到不同的日志文件中 例如：error级别记录到log_error_xxx.log或log_error.log（该文件为当前记录的日志文件），而log_error_xxx.log为归档日志，
	日志文件按日期记录，同一天内，若日志文件大小等于或大于2M，则按0、1、2...顺序分别命名 例如log-level-2013-12-21.0.log
	其它级别的日志也是如此。 2、文件路径 若开发、测试用，在Eclipse中运行项目，则到Eclipse的安装路径查找logs文件夹，以相对路径../logs。
	若部署到Tomcat下，则在Tomcat下的logs文件中 3、Appender FILEERROR对应error级别，文件名以log-error-xxx.log形式命名
	FILEWARN对应warn级别，文件名以log-warn-xxx.log形式命名 FILEINFO对应info级别，文件名以log-info-xxx.log形式命名
	FILEDEBUG对应debug级别，文件名以log-debug-xxx.log形式命名 stdout将日志信息输出到控制上，为方便开发测试使用 -->
<configuration>
    <springProperty scope="context" name="LOG_HOME" source="spring.application.name"/>

    <springProfile name="local">
        <property name="LOG_PATH" value="D:/www/logs/common"/> <!-- 日志保存目录 -->
    </springProfile>
    <springProfile name="dev">
        <property name="LOG_PATH" value="/data/logs/common" /> <!-- 日志保存目录 -->
    </springProfile>
     
    <property name="appName" value="common"/>
    <property name="maxSaveDays" value="365"/><!-- 日志最大保存天数 -->
    <property name="maxFileSize" value="200MB"/><!-- 单个文件最大大小 -->
    <appender name="stdout" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} %highlight(%-5level) %green([${LOG_HOME},%X{X-B3-TraceId:-},%X{X-B3-SpanId:-},%X{X-Span-Export:-}]) %magenta(${PID:-}) %white(---) %-20(%yellow([%20.20thread])) %-55(%cyan(%.32logger{30}:%L)) %highlight(- %msg%n)</pattern>
            <charset>UTF-8</charset>
        </encoder>
    </appender>
     
    <appender name="rollingFileConsole" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_PATH}/${appName}-log-console-%d{yyyy-MM-dd}.%i.log.zip</fileNamePattern>
            <maxHistory>${maxSaveDays}</maxHistory> <!--max save days -->
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>${maxFileSize}</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} %highlight(%-5level) %green([${LOG_HOME},%X{X-B3-TraceId:-},%X{X-B3-SpanId:-},%X{X-Span-Export:-}]) %magenta(${PID:-}) %white(---) %-20(%yellow([%20.20thread])) %-55(%cyan(%.32logger{30}:%L)) %highlight(- %msg%n)</pattern>
            <charset>UTF-8</charset>
        </encoder>
    </appender>
     
    <appender name="rollingFileInfo" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_PATH}/${appName}-log-info-%d{yyyy-MM-dd}.%i.log.zip</fileNamePattern>
            <maxHistory>${maxSaveDays}</maxHistory> <!--max save days -->
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>${maxFileSize}</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
        <encoder>
            <pattern>%d{"yyyy-MM-dd HH:mm:ss,SSS"}[%X{userId}|%X{sessionId}][%p][%c{0}-%M]-%m%n</pattern>
            <charset>UTF-8</charset>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>ERROR</level>
            <onMatch>DENY</onMatch>
            <onMismatch>ACCEPT</onMismatch>
        </filter>
    </appender>
     
    <appender name="rollingFileError" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_PATH}/${appName}-log-error-%d{yyyy-MM-dd}.%i.log.zip</fileNamePattern>
            <maxHistory>${maxSaveDays}</maxHistory> <!--max save days -->
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>${maxFileSize}</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
        <encoder>
            <pattern>%d{"yyyy-MM-dd HH:mm:ss,SSS"}[%X{userId}|%X{sessionId}][%p][%c{0}-%M]-%m%n</pattern>
            <charset>UTF-8</charset>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>ERROR</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>    
     
    <!-- 为单独的包配置日志级别，若root的级别大于此级别， 此处级别也会输出 应用场景：生产环境一般不会将日志级别设置为trace或debug，但是为详细的记录SQL语句的情况，
        可将hibernate的级别设置为debug，如此一来，日志文件中就会出现hibernate的debug级别日志， 而其它包则会按root的级别输出日志 -->
    <!-- <logger name="org.springframework" level="DEBUG" /> -->
    <logger name="com.ibatis" level="DEBUG"/>
    <logger name="com.ibatis.common.jdbc.SimpleDataSource" level="DEBUG"/>
    <logger name="com.ibatis.common.jdbc.ScriptRunner" level="DEBUG"/>
    <logger name="com.ibatis.sqlmap.engine.impl.SqlMapClientDelegate"
            level="INFO"/>
    <logger name="java.sql.Connection" level="DEBUG"/>
    <logger name="java.sql.Statement" level="DEBUG"/>
    <logger name="java.sql.PreparedStatement" level="DEBUG"/>
    <logger name="com.netflix.discovery" additivity="true" level="ERROR"/>
    <!-- 生产环境，将此级别配置为适合的级别，以名日志文件太多或影响程序性能 -->
    <root level="INFO">
        <appender-ref ref="rollingFileConsole"/>
        <appender-ref ref="rollingFileInfo"/>
        <appender-ref ref="rollingFileError"/>
        <appender-ref ref="stdout"/>
    </root>
</configuration>
```

              3、项目部署服务器后访问打印日志的效果

              4、查看日志记录文件，效果也一样，效果图：

        三、项目地址
    
                 1、地址：https://github.com/dangnianchuntian/springboot
    
                 2、代码版本：1.5.0-Release

【总结】
        1、通过设定日志格式，输出的样式更加人性化，错误也更加明显；

        2、这个小小的改变，使得在排查程序时更加的赏心悦目，心情上的开心将在无形中增加排错的效率；
