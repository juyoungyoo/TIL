# IoC, AOP, PSA 정리
스프링 트라이앵글 요소 3가지
## IoC/DI
#### IoC (Inversion of Control)
#### IoC 컨테이너
#### DI(Dependency Injection)
- 의존성 주입
- 방법 : @Autowired / @Inject
- 사용가능 한 지점 : field, constructor, setter

>spring version 4.3부터 생성자가 하나면서, 해당 타입이 빈으로 등록되어 있다면 @Autowired를 생략할 수 있다.
setter에 의존성 주입을 하면 인스턴스 생성 후, 의존성을 주입한다

Spring framework에서는 생성자에 @Autowired 붙이는 것을 권장한다.(현재 @Autowired 생략가능)
Why? 필수적으로 사용해야하는 레퍼런스 없이는 클래스를 만들지 못하도록 강제시키는 데 가장 좋은 방법이기 때문이다.
하지만, 경우에 따라서 순환참조가 발생 할 수 있다.
a(b)를 의존하고 b(a)를 서로 의존하는 관계일 경우 `setter`나 `field` 인젝션을 사용하여 해결 가능하지만 지양하는 방식이다.

---
## AOP (Aspect Oriented Programming)
- 관점 지향적인 프로그래밍
객체 지향 소프트웨어 개발에서 다른 관심사에 영향을 미치는 프로그램의 애스펙트이다.
핵심 관심사와 횡단 관심사 즉, 관심사에 대한 관점으로 프로그래밍을 분해하여 객체지향 방식으로 모듈을 분리하는 프로그래밍 기법이다.
AOP는 중복 코드를 모듈화하는 방법을 제시한다. 중복을 제거하고 이해하기 쉽도록 유지보수를 편리하게 할 수 있다.
대표적인 예) 로깅, 보안, 트랜잭션 처리, 메모리 관리, 모니터링..
스프링이 직접 제공하는 대표적인 AOP : 트랜잭션(@Tranctional)

>
핵심 관심사와 횡단 관심사, 크로스커팅 관심사
- 핵심 관심사 : 단일 모듈이 가지는 주된 요구사항
- 횡단 관심사 : 여러 모듈에 공통적 사용되는 부가적 요구사항

__[다양한 AOP 구현 방법]__
- 컴파일
  A.java --(AOP)--> A.class (AspectJ)
- 바이트코드 조작
A.java -> A.class ---(AOP)--> 메모리
  // 클래스 로더가 이 파일을 읽어옴 (AspectJ) (리플릭션)
- 프록시 패턴 (Spring AOP가 사용하는 방법)
https://refactoring.guru/design-patterns/proxy

__[AOP Tool]__
AspectJ, Spring AOP
[AspectJ 설정 및 사용방법](https://araikuma.tistory.com/309#recentEntries)

__[프록시 패턴]__
기존 코드를 변경하지 않는다. 대부분 자동으로 이루어진다.
가장 대표적인 예는 트랜잭션이다.
@Tranctional 어노테이션을 붙이면 해당 클래스 프록시가 새로 만들어진다.
tranction은 기본적으로 auto commit 설정을 false로 해주고 결과값을 commit하거나 rollback을 해준다.
프록시한 클래스에 위 코드가 포함되어 있다.

이러한 코드를 숨기는 이유는 무엇일까?  비즈니스 로직에만 집중할 수 있도록 도와준다 (AOP)

- 예제
```java
  public interface Payment{
      void pay(int amount);
  }
  public class Store{
    Payment payment;

    public Store(Payment payment){
      this.payment = payment;
    }

    void buySomething(){
        payment.pay(100);
    }
  }

  public class Cash implement Payment{
    @override
    public void pay(int payment){

    }
  }

  public class CreditCard implement Payment{
      Payment cash = new Cash();

      @override
      public void pay(int amount){
        System.out.printf(amount + "신용카드");
        if(amount > 100){
            System.out.println(amount + "신용카드");
        }else{
          cash.pay(amount);  
        }
      }
    }  
```

## 리플렉션 (Reflection)
- 구체적인 클래스 타입을 알지 못해도 그 클래스의 매소드, 타입, 변수에 접근가능하
도록 해주는 자바 API

- 리플랙션 구동 원리
자바 클래스 파일은 바이트 코드로 컴파일되어 static 영역에 저장이 된다. 이에 클래스 이름만 알고 있다면 이 영역을 조회하여 클래스 관련 정보를 가져올 수 있다.
클래스 이름으로 객체에 접근,조회 조작이 가능하다.

- 가져올 수 있는 정보
_ClassName_
_Class Modifiers (public, private, synchronized ..)_
Package Info
SuperClass
_Implemented interfaces_
Constructors
MethodsFields
_Annotations_

### Spring AOP 적용 예제  (proxy 기반)
활용 예) 성능 측정
- @LogExecutionTime
- @LogExecution

```java
@Target(ElementType.Method)
@Retention(RetentionPolicy.RUNTIME)
public @interface LogExecutionTime{}

@Component
@Aspect
public class LogAspect{
  Logger logger = LoggerFactory.getLogger(LogAspect.class);

  @Arouond("@annotation(LogExecutionTime)")
}
```

---
## PSA (Portable) Service Abstraction
여러가지 다양한 기술로 바꿔 사용할 수 있는 PSA에 해당된다
SA : 편리한 인터페이스를 제공해주기 때문에
### PSA란?
서비스의 추상화
편리한 서비스의 추상화
특정 환경이나 구현방식에 종속적이지 않는다.
스프링은 다양한 기술에 대한 서비스 추상화 기능을 제공한다

환경과 세부 기술의 변화에 관계없이 일관된 방식으로 접근할 수 있게 해준다.
그렇기 때문에 코드 변화는 거의 없이 기술변경이 가능하다.
예) tomcat, netty, underflow, jetty.. webFlux로 변경해도 잘 작동한다.


```
여러가지 기술로 바꿀 수 있다.
톰캣, 제티, 네티, 언더토우...
WebFlux로 변경가능함. 추상화 계층을 사용해서 실제로 네티를 사용하고 있지만 코드 변화는 거의 없다. 왜? 추상화 계층이 역할을 해준다. (앗! ModelAndView는 사용 불가능하다.)
```

__[스프링 트랜잭션]__
트랜잭션이란?
Jdbc transaction일 경우 예
```java
public void updateService(){
dbConnection.setAutoCommit(false);
try{
  dbConnection.commit();
}catch(Exception e){
  dbConnection.rollback();
}
}
```
- PlatformTransactionManager :
JpaTransactionManager | datasourceTransactionManager | HibernateTransactionManager

__[스프링 캐시(CacheManager)]__
@Cacheable
JCacheManager | ConcurrentMapCacheManager | En..
__[웹 MVC]__


> 다양한 편의성 인터페이스 덕에 코드는 더욱 견고해지고 기술이 바뀌더라도 코드를 거의 변경하지 않게 된다.
