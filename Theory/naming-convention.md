# 자바 명명 규칙
#### 타입 매개변수 이름
> T, E, K, V, X, R
- T : Type
- E : Element (컬렉션)
- K : map Key
- V : map Value
- X : eXception
- R : Return
etc.. T1, T2, U ..

---
#### 문법 규칙
1. 객체 생성 클래스   
단수 명사, 명사구 ex) Thread, PriorityQueue    
2. 객체를 생성할 수 없는 클래스    
복수형 명사 ex) Collectors, Collections       
3. 인터페이스     
XXXable, XXXible ex) Runnable, Iterable       
4. 메서드     
동사, 목적어 + 동사구 ex) append, drawImage   
- boolean 타입을 반환하는 경우   
  명사, 명사구, __isXXX__, hasXXX ex) isDigit, isProbablePrime, isEmpty, isEnabled, hasSiblings   
- 해당 인스턴스 속성 반환하는 경우
  명사, 명사구, getXXX ex) size, hashCode, getTime

  > get으로 시작하는 형태는 주로 JavaBeans 명세에 뿌리를 두고 있다.
  자바빈즈는 재사용을 위한 컴포넌트 아키텍처의 초기 버전 중 하나로 최근 도구 중에도 이 명명 규칙을 따르는 경우가 많다.

- 객체의 타입을 바꿔서 다른 타입, 객체를 반환하는 경우
  toType 형태로 주로 지음 ex) asList
- 객체의 값을 기본 타입 값으로 반환하는 경우
  TypeValue 형태로 주로 지음 ex) IntValue
- 정적 팩터리 이름
  from : 매개변수 하나 받아 해당 타입의 인스턴스를 반환하는 `형변환 메서드`   
  of : 여러 매개변수를 받아 적합한 타입의 인스턴스 반환
  valueOf : from, of의 자세한 버전
  instance, getInstance : 매개변수로 명시한 인스턴스 반환 (같은 인스턴스임을 보장하지 않는다.)
  newInstance : instance와 동일, 매버 새로운 인스턴스를 생성하여 반환
  get<i>Type</i> : getInstance와 같다. 생성할 클래스가 아닌 다른 클래스에 팩터리 메서드를 정의할 때 사용한다. <i>`Type`</i> 은 팩터리 메서드가 반환할 객체의 타입
  new<i>Type</i> : newInstance와 동일. 생성할 클래스가 아닌 다른 클래스에 팩터리 메서드를 정의할 때 사용
  <i>Type</i> : get<i>Type</i>, new<i>Type</i> 의 간결한 버전
