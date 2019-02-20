### Unit Test
특정 모듈이 의도대로 정확히 작동하는지 검증하는 절차   
모든 함수, 메소드에 대한 테스트 케이스를 작성하는 절차를 말함   
이를 위해 각 테스트 케이스는  모두 분리하여 동작해야 하며, 다른 컴포넌트를 의존할 경우 mock(가짜 객체)를 생성하여 코드를 작성한다. ( 의존성을 줄이기 위함 )

###### 장점
- 유지보수로 코드 변경 시 문제가 발생할 경우, 단시간 내에 문제를 파악하고 해결할 수 있다.
- 회귀 테스트(Regression testing)이 가능하다. // 유닛 테스트를 믿고 리팩토링을 할 수 있다.
- 통합이 가능하다.

___
#### Testfixture
@Test   
단위 테스트 메소드    
@Test(timeout=5000) 테스트 코드 5s초과 시 실패    
@Test(expected=RuntimeException.class) RuntimeException 발생 못할 경우 실패

@Before @After    
각 테스트 케이스 실행 전, 후에 실행된다.

@BeforeClass @AfterClass    
해당 테스트 클래스에서 전, 후 (최초) 한번씩만 수행된다.

___
#### Hamcrest
`tip! Hamcrest는 matchers 철자 순서를 변경하여 창조된 단어`
- Java unit testing에 사용되는 jUnit, JMock 처럼 framework이다.
- jUnit 4 이후 Hamcrest Library 포함하고 있다.
- Hamcrest는 java 이외의 언어 C++, Python, Javascript, R등에서 지원하고 있다.
- Point !! assertThat  :  assertThat이 hamcrest의 전부라 표현할 정도로 assertions의 기능을 향상 시킴

___
#### Test Double
- SUT  :  테스트 대상 시스템
- DOC : 테스트 대상 시스템에서 의존하는 컴포넌트 ( ex) repository, service .. )
- 테스트 대상이 의존하는 모듈은 의존성을 줄이기 위해 단위 테스트 작성시 테스트 더블  으로 작성
- 종류 : SPY, Mock, Stub
![](/images/2019/02/8-junit.PNG)
___

#### Test Coverage
: 단위테스트 또는 통합 테스트 수행 시 테스트 대상 시스템에 대해 얼마나 점검되었는지 확인
: 테스트코드가 테스트 대상의 로직들에 대해 커버하는지 테스트 커버러지 비율로 확인

`!단순히 수치만을 기준으로 충분히 테스트 되었다고 단언하면 안된다.`

###### Intellij 기준
:Corverage Runner 측정 도구로 Intellij IDEA, JaCoCo, Emma 3가지 사용가능
1. [Run/Debug Configurations] > Code Coverage 설정 ( Tracing 체크 )
2. Coverage 색상변경
- Full line coverage Background : #177D24
- Partial line Coverage Background : #F0FF1E
- Uncovered line Background : #830505



###### 참고   
[위키 unit test 정의](https://ko.wikipedia.org/wiki/%EC%9C%A0%EB%8B%9B_%ED%85%8C%EC%8A%A4%ED%8A%B8)   
[위키 hamcrest]( https://en.wikipedia.org/wiki/Hamcrest )   
[assertThat](https://objectpartners.com/2013/09/18/the-benefits-of-using-assertthat-over-other-assert-methods-in-unit-tests/)   
[jUnit과 Mockito를 이용한 단위 테스트 기초 1-5일차](https://redskelt.github.io/junit/mockito/2017/06/19/junit01.html)   
[Test Coverage tool](https://redskelt.github.io/junit/mockito/2017/06/23/junit05.html)    

이 후 봐야 할 링크
[JUnit 5 Guide](https://junit.org/junit5/docs/current/user-guide/#writing-tests-annotations)    
