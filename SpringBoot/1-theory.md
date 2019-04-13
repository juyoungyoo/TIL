# Spring Boot
### Concept
1. JDK 8이상에서 사용가능하다.
2. stand-alone : 독립적인 어플리케이션을 쉽게 만들어준다.
>Create stand-alone Spring applications
3. Opinionate view : 일반적으로 많이 사용중인 것을 설정해준다.
//  convention을 제공한다.
- spring platform, 3rd-party libraries 설정을 자동으로 설정해준다.
- tomcat, jetty, undertow를 WAR files없이 내장된 서버로 즉시 이용가능하다.
>Provide opinionated 'starter' dependencies to simplify your build configuration
>Automatically configure Spring and 3rd party libraries whenever possible
>Embed Tomcat, Jetty or Undertow directly (no need to deploy WAR files)

### Goals
* 모든 spring 개발할 때 빠르고, 폭넓은 사용성을 제공해준다.
* opinionate view : 이미 convention으로 사용중인 것을 설정해준다. (커스텀마이징 가능 )
* Non-functional features 가능
>Embedded servers, security, metrics, health checks and externalized configuration
* Code generation, no requirement for XML

`쉽고, 명확하고, 사용하기 편리하다.`

---
### Project 생성 방법
1. IDEA 사용
2. https://start.spring.io/

---
### Structuring
#### 전체 구조 [(참고)](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using-boot-structuring-your-code)
```
com
 +- example
     +- myapplication
         +- Application.java
         |
         +- customer
         |   +- Customer.java
         |   +- CustomerController.java
         |   +- CustomerService.java
         |   +- CustomerRepository.java
         |
         +- order
             +- Order.java
             +- OrderController.java
             +- OrderService.java
             +- OrderRepository.java
```

#### Main Application Class
- Application.java : 메인 애플리케이션 클래스로 위치는 최상위 패키치 안에 위치한다.
~~~ java
package com.example.myapplication;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
@SpringBootApplication
public class Application {
        public static void main(String[] args) {
                SpringApplication.run(Application.class, args);
        }
}
~~~
