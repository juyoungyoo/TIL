#싱글톤 패턴
단 하나의 객체만을 만들도록 보장해야 하는 경우에 사용    
의미 : 단 하나의 객체만이 생성된다    

##방법
* New 연산자로 객체를 새로 생성할 수 없도록 생성자 호출을 막는다. ( private 생성자 )
* 자신의 타입인 정적 필드를 하나 선언하고 자신의 객체를 생성해 초기화 한다.
* 정적 필드도 외부 호출이 불가능하도록 호출을 막는다. ( private 정적필드 )
* 외부 호출 방법
    * 정적 메소드(getInstance())를 선언하고 정적 필드에서 참조하고 있는 자신의 객체를 return

```java
Public class 클래스{
    // 정적 필드
    Private static 클래스 singleton = new 클래스();
    // 정적 생성자
    Private 클래스(){}
    // 정적 메소드
    Static 클래스 getInstance(){
        Return singleton;
    }
}
```
