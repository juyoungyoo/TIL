# 7. 서비스
> __서비스란__
__도메인 고유의 작업을 수행하는 무상태의 오퍼레이션__
도메인 서비스가 필요로 된다는 신호는? 에그리게잇, 값 객체에서 수행하는 오퍼레이션이 이질감이 느껴질 때 도메인 서비스가 필요한지 생각해보자.

## 로드맵
- 도메인 서비스란? 도메인 서비스가 필요없는 경우
- 도메인 서비스 생성 시 주의할 점
- 사스오베이션 프로젝트를 통해 도메인 서비스 적합한 사례 파악한다.

## 도메인 서비스 정의
#### 도메인 서비스란?     
일반적으로 서비스라 하면, 서비스 지향 아키텍처에서의 서비스를 떠올리기 마련이다. (적어도 필자는 그랬다.) ex) RPC(원격 프로시저 호출), MoM(메시지 지향 미들웨어) ..    
위와 같은 서비스는 현 책에서는 `애플리케이션 서비스`라고 부르고 있다. (`도메인 서비스`와 다른 것으로 혼동주의!)      
`도메인 서비스`란 비즈니스 로직을 담고 있는 서비스를 말한다.

##### 도메인 서비스와 애플리케이션 서비스의 차이점
`애플리케이션 서비스`는 `도메인 모델(엔터티, 값 객체)`의 클라이언트 또는 `도메인 서비스`의 클라이언트이다.

##### 도메인 서비스가 필요한 경우
> 도메인 모델은 일반적으로 비즈니스 특정 측면의 집중된 행위를 처리하기 한다.
도메인의 서비스와 도메인 모델은 비슷한 원칙(특징)을 고수하는 경향을 갖고 있다.

1. 중요한 비즈니스 프로세스를 수행할 경우
2. 어떤 컴포지션에서 다른 컴포지션으로 도메인 객체를 변형할 때
3. 하나 이상의 도메인 객체에서 필요로 하는 입력 값을 계산 할 때 (1번에 속하지만 자주 사용됨으로 ㄹ따로 언급)
ex) 둘 이상의 서로 다른 애그리게잇 또는 해당 에그리게잇 구성하는 일부를 입력으로 요구하는 상황.
오퍼레이션을 한 엔터티에 정의하기 어려운 경우 도메인 서비스를 사용하기에 적합하다


안티패턴 : 애너믹 도메인 모델
> 애너믹 도메인 모델?
도메인 로직이 엔터티, 값 객체에 흩어지지 않고, 서비스에 몰려있는 모델을 말한다.

#### 도메인에서 서비스를 모델링하기
도메인 서비스의 목적에 따라 도메인 내에서 서비스를 모델링하는 일은 아주 간단 할 수 있다.

서비스에 분리된 인터페이스가 필요한지 판단한다.
해당 인터페이스는 도메인 모듈에 한 모듈을 별도로 만든다.
도메인 서비스가 식별자의 개념으로 사용한다.

```
ex)
도메인 서비스 인터페이스 : AuthenticationService
- operation : authenticate() 하나의 오퍼레이션을 갖는다.
- 도메인 모듈 내 identity 모듈 내에 존재한다.
- 구현 클래스 위치 : 도메인 모델 외부 ex)인프라 계층 모듈
```

__분리된 인터페이스는 반드시 필요하지 않으며, 단일 구현 클래스로도 만들 수 있다.
여러 구현이 필요하지 않은 경우에 DefaultXXXService, XXXServiceImpl라는 네이밍보다 단일 구현 클래스로 구현하는 것을 더 추천한다.(필자는 개인적으로 impl이란 네이밍을 좋아하지 않는다.)__

#### 서비스의 테스트
> 우리는 클라이언트 관점에서 생각하는 모델링 방향이 맞는지 확인하기 위한 도구로 테스트를 사용한다.
테스트는 옵셔널로 테스트를 하면 좋지만, 저자는 절대적인 필수적인 요소가 아니라는 점을 보여주기 위해 단원의 마지막에 테스트 부분을 작성하였다.

## 마무리
- 도메인 서비스를 과잉하면, 안티 패턴인 `애너믹 도메인 모델`로 이어질 수 있다.
- 서비스를 구현하는 구체적인 방법을 단계별로 알아보았다.
- 분리된 인터페이스를 사용하는 장단점을 알아보았다.
- 사례(애자일 프로젝트 관리 컨테스트의 샘플 계산 프로세스)를 리뷰하며 예제를 통해 알아보았다.
- 모델이 제공하는 서비스를 사용하는 방법과 서비스 사용방법을 할 수 있는 `테스트`를 만드는 방법을 알아 보았다.