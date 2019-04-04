#자동 설정 이해 

일반적으로 Autoconfigure모듈과 starter 모듈을 따로 분리하여 재정의하고 의존성에 추가하는 방식으로 많이 개발하고 있다.     

먼저 @SpringBootApplication의 동작원리를 간략하게 설명해보자     
        

~~~
//@SpringBootApplication
// 동일
@SpringBootConfiguration
@ComponentScan
@EnableAutoConfiguration
public class SpringBootGettingStartedApplication {


    public static void main(String[] args) {

        SpringApplication springApplication = new SpringApplication(SpringBootGettingStartedApplication.class);
        springApplication.run(args);


//        SpringApplication.run(SpringBootGettingStartedApplication.class, args);
    }
}
~~~

@SpringBootApplicaion을 타고 들어가면 아래 3가지 애노테이션이 보인다.        
* @SpringBootApplication 
    * @SpringBootConfiguration
    * @Component
    * @EnableAutoConfiguration

@SpringBootApplicaion은 Bean을 설정할 때, 2단계로 나눠서 등록을 한다.        
* 1단계 : @ComponentScan
* 2단계 : @EnableAutoConfituration

첫 번째, @ComponentScan        
* @Component
* @Comfiguration @Repository @Service @Controller @RestController       

두 번째,  @EnableAutoConfiguration
Spring-boot-autoconfigure library에  META-INF > Spring.factories(key, value로 이루어져있다)에 
    * org.springframwork.boot.autoconfigure.EableAutoConfiguration
를 보면 자동으로 autoconfiguration할 class 리스트가 나와있다.        
그 중 아무거나 클릭해서 들어가면 @Configuration 애노테이션 설정되어 있는 것을 볼 수 있다.       

결론, AutoConfiguration은 자동으로 auto할 class 리스트를 담고 있고 결론적으로는 @configuration 클래스들을 bean 설정하겠다는 것이다.     
 

!tip 보통 library configuration 설정에서 많이 발견되는 애노테이션        
@Configuration      
@ConditionalOnXxxYyyZzz     

-----

[1] @ComponentScan 후 @EnableAutoConfiguration이 돌아가면서 기존에 내가 등록한 빈설정이 @EnableAutoConfiguration에 의해 덮어지게 된다. 이 때 해결방법 무엇일까?        
@ConditionalOnMissingBean 을 사용한다.       

[2] 빈 재정의 수고 덜기 : 프로퍼티 키값으로 자동으로 설정되도록 한다.        
@ConfigurationProperties(“holoman”) 
@EnableConfigurationProperties(HolomanProperties) 

~~~
<dependency>
        <groupId>org.springframework.boot</groupId>
         <artifactId>spring-boot-configuration-processor</artifactId>
        <optional>true</optional>
</dependency>

~~~