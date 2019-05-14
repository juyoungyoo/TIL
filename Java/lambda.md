# 람다

##람다식
병렬 처리와 이벤트 지향 프로그래밍에 적합하다.
익명함수를 생성하기 위한 식으로 함수지향 언어에 가깝다.
이를 사용하면서 가장 큰 장점은 컬렉션인데 필터링, 매핑, 결과 집계가 수월하다.

람다식 형태는 매개변수를 가진 코드 블록이지만, 런타임 시 `익명 구현 객체`를 생성한다.
```
람다식 -> 매개변수를 가진 코드 블록 -> 익명구현객체
인터페이스 변수 = 람다식; // 인터페이스 타입을 타겟타입이라 부른다.
```
람다식은 인터페이스 변수에 대입된다. 인터페이스는 객체를 직접 생성할 수 없어 구현 클래스가 필요하다.
람다식은 익명 클래스를 생성하고 객체화한다.

###기본 문법
```
(타입 매개변수, ...) -> {실행문; ...}
```
1. 람다식 실행 블록에서 클래스의 필드와 로컬변수 사용가능하다. ( 로컬 변수는 final로만 사용가능하다 )
주의해 할 키워드 `this`이다.
람다식에서 this는 자신이 생성한 익명객체를 참조하는게 아니라 람다식을 실행한 객체이다.
__즉, 람다식 바깥 클래스 필드나 메소드를 사용 할 수 있다.__
2. 로컬변수
로컬 변수 사용할 때는 final 특성을 가져야 한다. 왜? 익명 객체는 메소드 종료이후에도 힙 메모리에 저장되어 있다.
메소드 재사용 시 매개변수가 없을 때 에러가 발생하기 때문에 자바에서는 사용한 매개변수를 final 로컬변수로 저장하기 때문이다.
그럼으로, 매개변수, 로컬변수는 람다식에서 읽는 것은 허용되나 람다식 내,외부에서 변경할 수 없다.

###함수적 인터페이스(@FunctionalInterface)
하나의 추상메소드가 선언된 인터페이스만 타겟타입으로 사용가능하다. 이러한 인터페이스를 `함수적 인터페이스`라 한다.
- @FunctionalInterface  : 두개이상 추상메소드를 선언하지 못하도록 컴파일 에러 발생시킴
####표준 API의 함수적 인터페이스
ex) Runnable, Thread
자주 사용되는 인터페이스 java.util.function 패키지로 제공한다.
[종류]
- Consumer : 매개값 o, return x : 소비자
- Supplier : 매개값 x, return o : 공급자
- Function : 매개값 o, return o : 주로 매핑(타입변환) 리턴
- Operator : 매개값 o, return o : 주로 결과값 리턴
- Predicate : 매개값 o, return boolean : 단정하다

1. Consumer functional interface
- method : accept()
- ex) Consumer, BiConsumer, IntConsumer, ObjIntConsumer<T> ...

2. Supplier functional interface
- method : getXXX()
- ex) Supplier<T>, BooleanSupplier,IntSupplier ...

3. Function functional interface
- method :  applyXXX()
ex) apply(), applyAsInt()
- ex) Function<T,R>, BiFunction<T,U,R>, IntFunction<R>, IntToDoubleFunction

4. Operator functional interface
- method : applyXXX
- ex) BinaryOperator<T>, UnaryOperator<T>, DoubleBinaryOperator, IntBinaryOperator ...
- BinaryOperator<T> : BiFunction<T,R,U>의 하위 인터페이스
- UnaryOperator<T>  : Function<T,R>의 하위 인터페이스

5. Predicate functional interface
- method : testXXX()
- ex) Predicate<T>, BiPredicate<T,U>, IntPredicate

6. andThen(), compose() 디폴트 메소드
java.util.function 패키지의 함수적 인터페이스는 1개이상의 디폴트 및 정적 메소드를 갖는다.
위 5가지 종류의 함수적 인터페이스는 andThen(), compose() 디폴트 메소드를 갖는다.
- 공통점 : 두개의 함수적 인터페이스를 순차적으로 연결하고, 첫번째 매개값을 두번째 값으로 제공하여 최종 결과값 반환
- 차이점 1 : 순서  
A.andThen(B) : A > B
A.compose(B) : B > A
- 차이점 2 : andThen은 모두 지원, compose는 일부지원 ( function<T,R>, UnaryOperator 종류)
- Consumer 순차적 연결
