## Spring Boot + H2 설정방법

### 1.application.yml 또는 application.properties 파일에 설정
[application.yml 설정]
```
spring:
  h2:
    console:
      enabled: true
      path: /console
```

<hr/>

### 2. Configuration에 설정 [실패/확인필요]
```
@Configuration
public class H2Configuration {

    static final String h2WebConsoleUrl = "/console/*";
    // H2 console setting
    @Bean
    public ServletRegistrationBean h2servletRegistration(){
        ServletRegistrationBean registration = new ServletRegistrationBean(new WebdavServlet());
        registration.addUrlMappings(h2WebConsoleUrl);
        return registration;
    }

}
```

localhost:~/console에서 확인 가능


___

# Spring Boot version 2.+ 부터 변경된 사항
이전 버전에서는 tomcat-jdbc을 이용하여 연동하였으나, Spring Boot 2.1.3의 spring-boot-starter-jpa에 jdbc라이브러리가 포함되어있는 것으로 변경.
전 tomcat-jdbc 연동이 불가능해졌으며 많이 사용하는 HikariCP가 기본설정으로 변경됨

![h2-hikari-library](/images/2019/03/h2-hikari-library.png)


H2 연동은 시켰으나, JPA는 내장DB로 연결되어 database client기능 사용가능한지 확인중
