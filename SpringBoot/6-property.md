# 외부설정 ( boot-features-external-config )
[참고 : spring reference ](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-external-config)

SpringBoot는 외부 설정이 가능하다.
같은 애플리케이션 코드에서 다른 환경설정이 가능하다.
`properties files`, `YAML`, `environment variables`, `커맨드라인에서 arguments`로 외부 설정을 줄 수 있다.
프로퍼티 값은 @Value 애노테이션과 동일하게 사용된다.

>Spring Boot lets you externalize your configuration so that you can work with the same application code in different environments. You can use properties files, YAML files, environment variables, and command-line arguments to externalize configuration. Property values can be injected directly into your beans by using the @Value annotation, accessed through Spring’s Environment abstraction, or be bound to structured objects through @ConfigurationProperties.

---
## 우선순위
### 1.프로퍼티 우선 순위
1. 유저 홈 디렉토리에 있는 spring-boot-dev-tools.properties  ( 사용 잘 안함 )
2. `테스트에 있는 @TestPropertySource`
3. `@SpringBootTest 애노테이션의 properties 애트리뷰트`
4. `커맨드 라인 아규먼트`
5. SPRING_APPLICATION_JSON (환경 변수 또는 시스템 프로티)에 들어있는 프로퍼티
6. ServletConfig 파라미터
7. ServletContext 파라미터
8. java:comp/env JNDI 애트리뷰트
9. System.getProperties() 자바 시스템 프로퍼티
10. OS 환경 변수
11. RandomValuePropertySource
12. `JAR 밖에 있는 특정 프로파일용 application properties`
13. `JAR 안에 있는 특정 프로파일용 application properties`
14. `JAR 밖에 있는 application properties`
15. `JAR 안에 있는 application properties`
16. @PropertySource
17. `기본 프로퍼티 (SpringApplication.setDefaultProperties)`

_우선 순위가 테스트 > 커맨드 > 프로덕션순인 것을 알 수 있다.
build 시 프로덕션을 먼저 빌드한 후 테스트 코드를 빌드하는데 이 과정에서 overwrite가 되기 때문_

### 2.application.properties 우선 순위 (높은게 낮은걸 덮어 씁니다. overwrite)
1. file:./config/
2. file:./
3. classpath:/config/
4. classpath:/

---
## application.properties 파일 작성방법

### 1.Random value 사용
```
my.secret=${random.value}
my.number=${random.int}
my.bignumber=${random.long}
my.uuid=${random.uuid}
my.number.less.than.ten=${random.int(10)}           // max close
my.number.in.range=${random.int[1024,65536]}        // open, close
```

### 2.Placeholders in properties
```
app.name=MyApp
app.description=${app.name} description     // MyApp description : 재사용 가능
```
### 3.profile-specific properties
[spring reference 참고](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-external-config-profile-specific-properties)

---

### 4. Merging Complex Types
##### - @ConfigurationProperties (타입-세이프 프로퍼티)
- 여러 프로퍼티를 묶어서 읽어온다.
- Bean으로 등록하여 다른 Bean에 주입이 가능하다.
  + @EnableConfigurationProperties를 SpringBootAplication에서 해줘야 하지만 생략가능하다.
  How? @Component, @ConfigurationProperties 이용해서

```java
@Component
@ConfigurationProperties("juyoung")
public class JuyoungProperties {

    @NotEmpty
    private String name;
    private int age;
    private String fullName;

    @DurationUnit(ChronoUnit.SECONDS)
    private Duration sessionTimeout = Duration.ofSeconds(30);

    // Getter
    // Setter
}
```
``` properties
# application.properties
spring.profiles.active=prod
juyoung.name = juyoung
juyoung.age = ${random.int[1,100]}
juyoung.fullName = ${juyoung.name} Yoo
juyoung.sessionTimeout = 25s
```
``` java
// 프로퍼티 주입하여 사용할 클래스
    //..
  Private JuyoungProperties properties;

  public SampleRunner(JuyoungProperties properties) {
      this.properties = properties;
  }
    //..
```
```java
// example
@Component
public class SampleRunner implements ApplicationRunner {

    private Logger log = LoggerFactory.getLogger(SampleRunner.class);

    private final String hello;
    JuyoungProperties properties;

    public SampleRunner(JuyoungProperties properties, String hello) {
        this.properties = properties;
        this.hello = hello;
    }

    @Override
    public void run(ApplicationArguments args) throws Exception {
        log.debug(":::::: hello ::::" + hello);
        log.debug(":::::: name ::::" + properties.getName());
        log.debug(":::::: full name ::::" + properties.getFullName());
        log.debug(":::::: age ::::" + properties.getAge());
    }

}
```

2. @Bean : Third-party configuration : jar 파일안에 properties 사용하고 싶을 때
```java
@ConfigurationProperties(prefix = “server")
@Bean
public AnotherComponent anotherComponent() {
        ...
}

// example
@Bean
@ConfigurationProperties(prefix = "server")
public ServerProperties ServerProperties(){
    return new ServerProperties();
}
```
---
##### - @DurationUnit : 프로퍼티 타입 컨버전을 자동으로 해준다.
Type: ns, us, ms, s, m, h, d ...
``` properties
juyoung.sessionTimeout=25s
```
동일함
```java
@DurationUnit(ChronoUnit.SECONDS)    // default : seconds
private Duration sessionTimeout = Duration.ofSeconds(30);    // if null : 30s
```
---
##### - @Validated : 프로퍼티 값 검증이 가능하다.
Type : @NotNull, @Size, @NotEmpty ..

```java
@Component
@ConfigurationProperties("juyoung")
@Validated
public class JuyoungProperties {
    @NotNull
    private String name;
    ...
```
