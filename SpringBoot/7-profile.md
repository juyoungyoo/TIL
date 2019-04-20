# Profile

@Profile 사용가능한 위치
* @Configuration
* @Component

@Configuration
@Profile("production")    // or @Profile(“test")
public class ProductionConfiguration {
        // ...
}

실행방법
실행방법 1. application.properties 파일에 설정한다.
spring.profiles.active=dev,hsqldb

실행방법 2. Command line으로 실행시킨다.
spring.profiles.active=dev,hsqldb
 // 여러개 가능


Profile용 프로퍼티 파일 생성
Application-{profile}.properties
application-prod.properties
application-dev.properties
application-${profile}.properties
———————————————————————————

Property 우선 순위가
Applciation-${profile}(특정 프로파일)이 Application.properties (default) 보다 높기 때문에 default 파일에서 오버라이드된다.

Ex) profile = prod라면
application.properties 실행 후,
Application-prod.properties 가 오버라이드 된다.

다른 프로파일을 추가하고 싶을때
Spring.profiles.include=proddb      // application-proddb.properties file을 include 한다.
