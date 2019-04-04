# Spring Boot 개념
* JDK 8이상 사용가능
* Stand-alone 독립적인 어플리케이션을 쉽게 만들어준다.
* Opinionated view : 일반적으로 많이 사용하는 중인 것을 설정해준다. ( spring platform, third-party libraries 도 제공 // ex) tomcat )  // convention을 제공   

####Goals
* 모든 spring 개발할 때 빠르고, 폭넓은 사용성을 제공해준다.
* opinionate view : 이미 convention 으로 사용중인 것을 설정해준다. 커스텀마이징 가능
* Non-functional features 가능
    * Embedded servers, security, metrics, health checks and externalized configuration
* Code generation, no requirement for XML 

쉽고, 명확하고, 사용하기 편리하다.

#### Project make 방법 
1. IDEA 사용
2. https://start.spring.io/

#### SpringBoot 구조 참고
https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using-boot-structuring-your-code

Application.java : main application class 위치는 최상위 패키지 안

~~~
*Application.java
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
~~~
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
~~~