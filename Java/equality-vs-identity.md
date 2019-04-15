#Equality vs Identity
> Equality (동등성) : 객체의 내용을 비교한다 ex) equals
> Identity (동일성) : 식별이 가능한 객체    ex) ==

Equality와 Identity 공통점은 둘다 boolean 타입으로 리턴합니다.
Equality는 동등성이며, 두 객체의 내용이 같은지 확인한다.
> Two objects are different objects but contain the same data.    

Identity는 동일성이며 두 객체가 같은지 확인한다. 인스턴스 래퍼런스가 같은지 식별한다.

```
! 인스턴스의 레퍼런스(주소값)이란?
인스턴스 생성 시 메모리 할당을 받는다. 이 때 할당받은 메모리의 주소를 주소값이라고 부른다.
하지만, 사실 자바는 실제 메모리 값을 알 수 없다. JVM에서 메모리 값을 보여주지 않고 JVM 레퍼런스 형태로 JVM이 만든 값을 리턴받게된다.

* CBR(Call By reference) : 선언 시 주소가 할당된다.
* CBV(Call By Value) : 주소값을 갖지 않고, 값을 할당받는 형태
ex) int, float, double, char .. primitive type이 CBV에 해당된다.
```

---

## 객체의 동등성
두 객체의 동등성을 비교하였을 때 동등성 비교는 올바르게 나오지 않는다.
올바른 동등성으로 만들기 위해 equals()를 오버라이딩이 필요하다.
```java
public class Person {
  private int id;
  private String name;
  public int getId() { return id; }
  public void setId(int id) { this.id = id; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; } }

  Person p1 = new Person();
  p1.setId(1);
  p1.setName("Sam");
  Person p2 = new Person();
  p2.setId(1);
  p2.setName("Sam");

  System.out.print(p1.equals(p2)); // false


  ////////////////////////////////////////////////////////
  @Override
public boolean equals(Object obj) {

        if (obj == null) {
          return false;
        }
        if (this.getClass() != obj.getClass()) {
            return false;
        }
        if (this == obj) {
            return true;
        }
        Person that = (Person) obj;
        if (this.name == null && that.name != null) {
            return false;
        }
        if (this.id == that.id && this.name.equals(that.name)) {
            return true;
        }
        return false;
    }
```
---
# HashCode()
일반적으로 equals() 오버라이딩을 통해 동등성을 비교할 수 있다.
하지만, Collections(HashMap, HashSet..)등은 key로 식별을 한다.
HashCode()는 식별 가능한 key값을 결정하는데 사용한다. 즉, key는 해시코드로 만들어 리턴하기 때문에 동등성이 아닌 동일성을 갖게 됨으로 collections을 동등성 비교가 불가능하다.

Collections 동일성을 동등성으로 만들 수 있는 방법은 없을까? 답은 있다.
HashCode를 오버라이딩하여 같은 해시코드를 갖도록 만들어준다.  

>  HashMap 콜렉션을 이용하여 동일성, 동등성을 모두 만족하는 객체를 생성할 수 있다.
> 객체의 동등 비교를 위해서는 equals() 메소드만 재정의하지 말고 HashCode()도 함께 재정의 하여 논리적 동등 객체일 경우 동일한 해시코드가 리턴되도록 해야한다.


출처:
https://anster.tistory.com/160
https://minwan1.github.io/2018/07/03/2018-07-03-equals,hashcode/
https://medium.com/@NomadicAlex/java-equality-vs-identity-3b045c9f6c68
https://github.com/hongsii




---
* (Integer은 모두 동일성처럼 인식한다)
* 하나의 키를 가지고 그 키에 해당하는 인스턴스를 반환하게 된다.
* 즉, lottoNumber는 여러번 사용하는데, 항상 메모리를 생성해야 한다. 매번 메모리 생성하는 것을 방지하기 위해 한번 생성한 인스턴스를 collection에 저장하고 동일한 것을 가져다 사용한다.
* 그렇다면 동일성 동등성을 모두 만족하는 코드 작성이 가능하다.
