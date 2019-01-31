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

localhost:~/console에서 확인할 수 있다.

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
