---
layout: post
title: "spring boot系列   1.1 为什么需要spring boot"
description: "The first 'Hello world' post for Simple Texture theme."
category: ['spring boot']
tags: ['spring boot', '教程', 'java', 'jawa']
last_updated: 2020-05-16
redirect_from:
    - /springboot/why_spring_boot.html
---
# 为什么需要spring boot

spring boot诞生的原因十分的简单, 就是一句话**天下苦spring久矣**.

spring框架无疑是一款优秀的框架, 统治了java后端绝大多数的应用场景. 但是spring也存在一个致命的问题:**配置繁重**

就算是使用spring mvc+spring开发一个hello world的web后端程序, 其配置极其繁重.

步骤如下:
1. 首先是使用`maven`创建一个web项目.
1. 然后引入对应的`spring`和`spring mvc`的依赖.
1. 在`/META-INF/web.xml`中配置前端处理器`DispatcherServlet`, 接管对应请求
1. 编写控制器类并使用注解将控制器加入到IOC容器中
1. 编写处理方法, 并使用`@RequestMapping`映射请求
1. 编写`springmvc.xml`配置文件, 配置`<context:component-scan base-package=".com.study.hello"></context:component-scan>`启动包扫描, 来扫描到控制器
1. 启动mvc的注解驱动`<mvc:annotation-driven/>`
1. 将`springmvc.xml`添加到`web.xml`的启动参数中, 来加载配置.
1. 编译程序并打war包
1. 将war包部署到tomcat等服务器中的webapps目录下
1. 启动tomcat服务器

完成了上述步骤之后, 一个hello world的程序才能够运行. 

而在实际开发中, 配置远多于这个hello world程序.


但是spring boot诞生之后, 使用spring boot开发hello world程序就简单多了. 步骤如下:

1. 创建一个spring boot项目, 导入web的starter(使用IDE创建的时候能够直接选择)
1. 创建一个控制器类, 使用注解将控制器加入到IOC容器中
    需要注意的是. spring boot默认只会扫描`Application.java`所在包及其自包下的类
1. 编写处理方法, 使用`@RequestMapping`映射请求
1. 将项目作为一个普通java项目,编译运行

可以看到这一个项目并不需要我们做任何的配置, 也不需要tomcat等服务器参与.

下面就介绍一下什么是spring boot, 他是怎么做到这一切的.

# 什么是spring boot, 以及spring boot的优缺点在哪?
下面是wiki上对spring boot的介绍.
> Spring Boot is Spring's convention-over-configuration solution for creating stand-alone, production-grade Spring-based Applications that you can "just run".[23] It is preconfigured with the Spring team's "opinionated view" of the best configuration and use of the Spring platform and third-party libraries so you can get started with minimum fuss. Most Spring Boot applications need very little Spring configuration. Features:
> * Create stand-alone Spring applications
> * Embed Tomcat or Jetty directly (no need to deploy WAR files)
> * Provide opinionated 'starter' Project Object Models (POMs) to simplify your Maven configuration
> * Automatically configure Spring whenever possible
> * Provide production-ready features such as metrics, health checks and externalized configuration
> * Absolutely no code generation and no requirement for XML configuration.


spring boot是对Spring的一个封装, spring团队预先配置了"最佳属性"的基于约定的配置解决方案.用于创建可以直接运行的,独立的,生产级别的基于spring的应用程序.(并非对wiki的翻译).

简单说, spring boot就是许多套面向不同应用场景的配置解决方案. spring团队面对不同场景做了一些预先的配置.

spring boot的特点如下:
1. 独立的spring应用程序
1. 直接嵌入了tomcat或jetty等服务器, 不需要使用war包部署
1. 提供了一些`starter`maven依赖, 来简化maven配置.
1. 尽可能的自动配置spring
1. 提供了生产功能,` metrics, health checks,externalized configuration`
1. 没有代码生成, 不需要xml配置.

简单点说spring boot就是提供了"一把梭"的解决方案. 创建项目, 编写业务逻辑, 运行项目.

spring boot的缺点也十分明显, 
1. 首先就是笨重. spring框架本来就算是一个比较笨重的框架. 而spring boot的自动配置更加加剧了这一现象.
    *spring boot的自动配置在了解了其内部机制之后, 许多不需要的组件是可以不加载的*
1. 其二就是黑盒, 由于一切都自动化了, 新手在遇到框架出了问题的时候很难找到问题取修复. 
    众所周知, 目前的代码的结构都在趋向于小函数的调用, 这无疑加深了调用栈, 让理解代码变得弯弯绕绕.

上述缺点是我从一个初学者出发的思考, 也参考了一些网络上的看法.


spring boot是什么, 重点关注starter即可. 这些starter就是spring boot提供的预先配置的场景. 下图是`spring-boot-web-starter`的依赖图:
![](/images/springboot-webstarter.png)
图中从左往有的依赖分别是:
1. 嵌入式`tomcat`服务器
1. 处理json的依赖库
1. spring-boot-stater
    其中包含了对日志的依赖`spring-boot-starter-logging`和处理yaml文件的`snakeyaml`, 以及spring boot的自动配置包
1. 数据校验的依赖
1. `spring web`和`spring webmvc`以及`spring`框架本身的依赖.

 其中spring boot的所有的自动化都是源于一个注解,`@SpringBootApplication`, 详细内容这里不做叙述. 需要注意的是, 所有的自动配置的操作, 全部在这个包中可以找到.
```java
package org.springframework.boot.autoconfigure;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import org.springframework.boot.SpringBootConfiguration;
import org.springframework.boot.context.TypeExcludeFilter;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.core.annotation.AliasFor;

@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan(
    excludeFilters = {@Filter(
    type = FilterType.CUSTOM,
    classes = {TypeExcludeFilter.class}
), @Filter(
    type = FilterType.CUSTOM,
    classes = {AutoConfigurationExcludeFilter.class}
)}
)
public @interface SpringBootApplication {

```

至于spring boot的可配置内容, 建议在文档中查找, 而不是翻阅源码, [文档地址](https://docs.spring.io/spring-boot/docs/2.3.0.RELEASE/reference/html/appendix-application-properties.html)


# 3. 如何使用spring boot
**注意: spring boot只是简化了spring的配置, 如果需要使用spring boot开发web系统, 那么spring和spring mvc的知识一样需要掌握**
> 耦合只能从一个地方移动到另一个地方, 并不能完全消除
> spring boot的自动配置只是为一些配置项提供了常见的值, 并没有消除这些配置.

本章介绍的内容有:
1. spring boot项目的创建, 基于IDEA
1. 如何编写一个简单的Hello  World程序.

## 3.1 IDEA中spring boot项目的创建.

首先启动IDEA, 并点击新建项目,如下图所示:

![](/images/springboot-create1.png)

在左侧选中`spring Initializr`, 在右侧选择对应的jdk版本, 初始化服务器url选择默认的`start.spring.io`即可, 点击next, 如下图所示:

![](/images/springboot-create2.png)

然后就是创建maven项目的一些id的输入. 这里自己设置即可. 我这里暂时不设置. 然后点击next, 如下图所示:

![](/images/springboot-create3.png)

这里就是勾选spring boot的依赖项, 这里选中的依赖会自动的导入`pom.xml`中

最上方有一个搜索框用于搜索依赖, 右边是spring boot的版本选择,

左边的框中是spring boot的依赖分类, 中间是对应分类中的依赖.

最右边显示的是选中的依赖. 依赖选择完毕之后,点击next, 结果如下图所示:

![](/images/springboot-create4.png)

填写项目的名称和项目的地址, 然后点击finish就完成了项目的创建.
下面有一些高级设置, 一般不建议修改.

创建好的项目如下图所示:

![](/images/springboot-create5.png)

创建了两个文件, 
1. `DemoApplication.java`
    这是spring boot的主配置类文件
1. `application.properties`
    spring boot的配置文件

目前项目就能够直接运行了, IDEA中运行项目这里就不介绍了. 但是项目运行之后什么都没有, 就是一个空壳, 下面我们编写一个控制器, 写一个`localhost:8080/hello`接口.代码如下:
```java
package com.example.demo;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HelloController {

    @ResponseBody
    @RequestMapping("hello")
    public String hello(){
        return "hello";
    }
}
```

至此, 使用spring boot开发一个项目的内容就全部结束了