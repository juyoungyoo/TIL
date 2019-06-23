

## 중간 처리 메소드
- 필터링
  - distinct
  - filter
- 매핑
  - flatMap
  - flatMapToDouble
  - flatMapToInt
  - flatMaptoLong
  - map
  - mapTodouble
  - mapToInt
  - mapToLong
  - mapToObj
  - asDoubleStream
  - asLongStream
  - boxed
- 정렬
  - sorted
- 루핑
  - peek
---
### 필터링(distinct, filter)
> 모든 스트림 가지고 있는 공통 메소드

- __distinct()__
중복 제거
판단 기준 : equals(동등 비교)
- __filter(Predicate)__
매개값으로 주어진 Predicate가 true인 요소만 반환

#### 매핑(flatMapXXX, mapXXX, asXXXStream, boxed
> 스트림 요소를 다른 요소로 대체한다.

- flatMapXXX()
복수 개의 요소들로 구성된 새로운 스트림 리턴     
- __mapXXX()__
요소를 대체하는 요소로 구성된 새로운 스트림 리턴     
  - Stream<R> map(Function<T,R>) : T -> R 으로 대체
  - DoubleStream mapToDouble(T) : T -> double
  - IntStream mapToInt(T) : T -> int
  - LongStream mapToLong(T) : T -> long
  ... (모두 가능)
- asDoubleStream(), asLongStream(), boxed()
asDoubleStream : intStream, LongStream의 요소를 double요소로 타입변환 (return DoubleStream)      
asLongStream : intStream 요소를 long 요소로 타입변환 (return LongStream)    
boxed : int, long, double요소를 Integer, Long, Double 요소로 boxing (return stream)   

#### 정렬 (sorted)
공통 메소드
- __sorted()__
객체를 Comparable 구현 방법에 따라 정렬 (return : Stream<T>)      
Comparable 미구현 시 ClassCastException 발생
- sorted(Comparable<T>)
객체를 주어진 Comparable에 따라 정렬

> Tip! Interface Comparator
정렬 가능한 클래스(Comparable 인터페이스를 구현한 클래스)들의 기본 정렬 기준과 다르게 정렬 하고 싶을 때 사용하는 인터페이스
추천 메소드 2가지 : Comparator.naturalOrder(), Comparator.reverseOrder()

#### 루핑 (peek, forEach)
looping은 요소 전체를 반복한다.
peek과 forEach 차이점 : peek 중간 처리 메소드, forEach 최종 처리 메소드
peek은 중간 처리 메소드이기 때문에 최종 처리 메소드가 호출이 되어야 동작함에 주의해야 한다.
(즉, peek을 마지막에 호출 시 스트림은 동작하지 않는다.)

---
## 최종 처리 메소드
#### 매칭(allMatch, anyMatch, noneMatch)
> 특정 조건에 만족하는지 확인하는 매칭 메소드 ( 공통 메소드 )
AllMatch() : 모든 요소들이 매개값으로 주어진 Predicate를 만족하면 true
AnyMatch() : 최소한 한개의 요소가 Predicate를 만족할 시 true
noneMatch() : 모든 요소들이 Predicate를 만족하지 않을 시 true

#### 기본 집계(sum, count, average, max, min)
> 집계 : 대량의 데이터를 가공해서 축소하는 리덕션(Reduction)

- count() : 요소 개수 ( return Long )
- average() : 요소 평균 ( return OptionalDouble )
- sum() : 요소 총합 ( return int, long, double )
- findFirst() : 첫 번째 요소 ( return OptionalXXX )
- max(Comparator<T>), max() : 최대 요소 ( return Optional<T>, OptionalXXX)
- min(Comparator<T>), min() : 최소 요소 ( return Optional<T>, OptionalXXX)

## 커스텀 집계(reduce)
## 수집 (collect)
> 요소들을 수집하여 컬렉션으로 담거나, 요소를 그룹핑하여 집계(리덕션) 할 수 있다.
collect(Collector<T,A,R> collector) : return R
T : type parameter
A : Accumulator (누적기)
R : 요소가 저장될 컬렉션
= T 요소를 A 누적기가 R에 저장한다.

__Collectors 클래스의 유용한 static method__
- __Collectors.toList()__ : T를 List에 저장
- __Collectors.toSet()__ : T를 Set에 저장
- toCollection(Supplier<Collection<T>>) : T를 Supplier가 제공한 Collection에 저장
- toMap(
    Function<T,K> keyMapper,
    Function<T,U> valueMapper
  ) : T를 K, U로 mapping하여 map에 저장
- toConcurrentMap


---
## Optional Class
> Optional, OptionalDouble, OptionalInt, OptionalDouble, OptionalLong
집계 값이 존재하지 않을 경우 default 값 설정 가능
집계 값을 처리하는 Consumer 등록 가능

__Optional 메소드__
- isPresent() : 값 저장되어 있는지 여부 (return boolean)
- ifPresent(Consumer, DoubleConsumer, IntConsumer, LongConsumer) : 값이 저장되어 있을 경우 Consumer에서 처리 (Return void)
- orElse(T or int or double or long) : 값 없을 경우 default 값 저장 (exception 객체도 가능)

> Collection 요소를 동적으로 받아서 stream으로 처리할 때, 저장된 요소가 없을 경우 처리 하는 방법 3가지
1. isPresent() 메소드로 값 유무 확인 후 값 리턴
2. orElse() 메소드로 default 값 지정
3. ifPresent() 이용

---

1. 요소를 그룹핑해서 수집
> 컬렉션의 요소를 그룹핑하여 Map객체로 생성
Collectors.groupingBy()
Collectores.groupingByConcurrent()
차이점? Thread safe (groupingByConcurrent가 thread safe한 concurrentMap 생성)

- Coolectors.groupingBy(Function<T,K>) : T를 K로 매핑하고 K키에 저장된 List에 T를 저장한 Map 생성
