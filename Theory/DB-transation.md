# Transation

> 질의를 하나의 묶음으로 처리한다
>
> 다수 사용자가 동시에 사용하더라도 정확한 데이터를 유지해야한다.
>
> 데이터베이스가 항상 정확하고 일관성있는 데이터를 유지할 수 있도록 하는데 트랜잭션이 중심에 있다.
>
> 트랜잭션이란? 하나의 작업을 수행하기 위해 모아놓은 연산으로 __데이터베이스에서 논리적인 작업 단위__ 이다.
>
> 트랜잭션에 대해 4까지를 보장

#### 목적
- 사용자가 데이터베이스 완전성 유지를 확신하게 한다


## 4가지 특성 (ACID)
1. 원자성 (Automicity)

   - 트랜잭션 작이 모두 정상 실행되거나 모두 실행되지 않아야 한다. (All or nothing)
   - Rollback segment : 이전 데이터 임시로 저장하는 영역
   - Database table : 새롭게 변경되는 내역
     - 트랜잭션 연산이 많을 경우에는? savepoint로 중간 저장 지점 설정한다

2. 일관성 (Consistency)

   - 트랜잭션이 성공적으로 완료했을 시 DB상태가 일관성 있는 상태를 유지해야 한다.
   - 즉, 트랜잭션 수행 전에 DB상태가 일관된 상태였다면, 트랜잭션 수행 완료 후에 반영한 DB도 일관성이있어야한다. (트랜잭션 전 DB 일관성 == 트랜잭션 후 DB 일관성)
     - Trigger

3. 격리성, 고립성 (Isolation)

   - 트랜잭션 수행 시 다른 트랜잭션(작업)이 관여할 수 없다
   - 트랜잭션이 완료되기 전에 공통된 데이터를 변경할 경우 일관성을 보장하기 어렵다. 이러한 문제를 해결하기 위해, 트랜잭션 수행과정 다른 트랜잭션이 접근할 수 없도록 하여 격리성을 보장해야한다.
   - 병행처리(concurrent processing) 시 공통된 데이터를 조작 할 경우 데이터의 일관성을 보장하기 어렵다.
     - 보장 방법) lock & excute unlock
     - shared_lock / 공유락 : only read (여러 트랜잭션이 읽을 수 있도록 허용)
     - exclusive_lock / 배타락 : no read/write (작업이 끝날 때까지 lock, 작업 끝나면 unlock)
     - 잘못 사용 시 데드락(deadlock) 상태 발생
     - 결론 : 성능을 위해 병행처리를 해야하는 데 고립성을 보장하기 위해서 2PL(2 phase locking protocol)을 사용해야한다 (type : growing phase, shrinking phase)

4. 지속성, 영속성 (Durability)

   - 성공적으로 수행된 트랜잭션은 영원히(영구적으로) 반영되어야 한다.

-----
##격리성 관련 문제

격리성을 보장하기 위해 모든 트랜잭션을 순차적으로 실행 시 동시성 이슈 발생
동시성을 높이기 위해 여러 트랜잭션을 병렬처리 할 시 데이터 무결성이 깨질 수 있다.

   1. Dirty read
   2. Non-Repeatable read
   3. Phantom read  

##### 트랜잭션 격리수준
- 격리성에서 발생하는 문제를 해결을 위해 ANSI 표준에서 4단꼐 격리수준을 나눔
- 내려갈수록 격리 수준이 높아져서 언급된 이슈는 적게 발생하지만 동시 처리 성능은 떨어진다.

   1. Read uncommitted
      - Dirty read, Non-repeatable read, Phantom read
   2. Read commmited (default)
      - Non-repeatable read, Phantom read
   3. Repeatable read
      - Phantom read
   4. Serializable



[DB 트랜잭션 격리수준](https://www.letmecompile.com/database-transaction-isolation-level/)
[(DB이론) 트랜잭션(transaction)과 ACID 특성을 보장하는 방법](https://victorydntmd.tistory.com/129)
[트랜잭션, 트랜잭션 격리수준](https://feco.tistory.com/45)
