
https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-spring-application.html#boot-features-spring-application

* 기본 로그 레벨 : INFO 
* FailuerAnalyzer : Error를 이쁘게 출력해주는 기능

SpringApplication 
1. 실행방법

실행방법 1.  SpringApplication 이용
```
@SpringBootApplication
public class SpringBootInitApplication {
    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(SpringBootInitApplication.class);
        application.run(args);
    }
}
```
실행방법 2. SpringApplicationBuilder 사용
```
new SpringApplicationBuilder()
              .sources(SpringBootInitApplication.class)
                .bannerMode(Banner.Mode.OFF)
                .run(args);
```

2. Application Events and Listener 사용방법 
* https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-spring-application.html#boot-features-application-events-and-listeners
* @Bean으로 등록하여 사용하는 방법
```
@Component
public class SampleListener2 implements ApplicationListener<ApplicationStartedEvent> {

    @Override
    public void onApplicationEvent(ApplicationStartedEvent event) {
        System.out.println("=======================");
        System.out.println("Application is starting");
        System.out.println("=======================");
    }
}
```
* SpringApplication.addListeners() 에 추가하는 방법 ( ApplicationContext 만들기 전에 사용하는 리스너에 해당, @bean으로 등록할 수 없다.) 
```
// ApplicationContext 만들기 전에 사용되는 리스너 
public class SampleListener implements ApplicationListener<ApplicationStartingEvent> {
    @Override
    public void onApplicationEvent(ApplicationStartingEvent event) {
        System.out.println("=======================");
        System.out.println("Application is starting");
        System.out.println("=======================");
    }
}
```
—————
// SpringApplication에 리스너를 별로로 추가 필요하다  
application.addListeners(new SampleListener());

3. WebApplication Type 
* 종류 : SERVLET, REACTIVE, NONE
* Server 타입에 따라 자동으로 설정된다. 
* SERVLET  : Web MVC
* REACTIVE : WebFlux
* 이 외, NONE
```
        // …
        application.setWebApplicationType(WebApplicationType.SERVLET);   // servlet web MVC : servlet이 있으면 무조건 servlet
        application.setWebApplicationType(WebApplicationType.REACTIVE);  // Spring webFlux  
        application.setWebApplicationType(WebApplicationType.NONE);
        // ...
```
4. Application Arguments 사용하기  ( -VM option X )
* Project argument option :  - - 인 것만 사용가능
* Bean으로 설정하여 사용하는 방법 
```
@Component
public class MyBean {
    public MyBean(ApplicationArguments arguments) {
        System.out.println(arguments.containsOption("bar"));
    }
}
```
* ApplicationRunner를 implement 하여 사용가능하다. 
    * 애플리케이션 실행 후 다른 것을 실행하고 싶을 때
    * ApplicationRunner가 여러개라면 @Order로 순서 지정이 가능하다.  
```
@Component
@Order(1)            // 숫자 낮을수록 먼저 실행
public class MyBean implements ApplicationRunner {

   @Override
    public void run(ApplicationArguments args) throws Exception {
        System.out.println(args.containsOption("bar"));
    }
}
```

배너 설정방법
1. Main Application
```
@SpringBootApplication
public class SpringBootInitApplication {

    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(SpringBootInitApplication.class);
        application.setBanner((environment, sourceClass, out) -> {
            out.println("===================");
            out.println("Console Banner");
            out.println("===================");
        });
        application.setBannerMode(Banner.Mode.OFF);
        application.run(args);
    }
}
```

2.  Classpath 에 banner.txt 파일 만든다.
* 위치를 설정하고 싶다면? application.properties에 spring.banner.location  설정가능하다.
* 이 외 설정하고 싶다면? https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-spring-application.html#boot-features-banner
