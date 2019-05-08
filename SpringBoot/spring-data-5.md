# 데이터베이스 초기화

##1.Hibernate ddl-auto 설정
`Spring.jpa.hibernate.ddl-auto`
- update : 기존에 있는 스키마는 유지하고 추가된 스키마만 추가한다. ( 기존 데이터 유지 )
- validate : 기존 DB의 테이블과 Entity를 검증한다.
- create-drop : 스키마 생성하고, 종료 시 스키마 삭제한다.
- create : 실행 시 처음에 스키마를 모두 지운 후 스키마 생성
- None
__Updated 사용 시 _spring.jpa.generate-dll = true_ 설정 필수!! ( ddl-auto가 작동하지 않는다 )__

그 외 설정들..
spring.jpa.show-sql = true // 실행하는 sql을 보여준다.


#### 운영 시 설정
1. Spring.jpa.hibernate.ddl-auto = validate      
// Entity mapping이 relation DB에 mapping 가능한지 검증만 한다. ( if, 없을 시 error 발생 )
2. spring.jpa.generate-dll = false

---

##2.SQL 스크립트를 사용한 데이터베이스 초기화
* ${platform} 값 설정 : `spring.datasource.platform`

ex) hsqldb, h2, oracle, mysql, postgresql
Schema.sql or schema-${platform}.sql
data.sql or data-${platform}.sql

>Spring Boot automatically creates the schema of an embedded DataSource. This behaviour can be customized by using the spring.datasource.initialization-mode property. For instance, if you want to always initialize the DataSource regardless of its type:

스키마 초기 생성 시 임베디드 datasource( H2 .. )을 제외한 모든 경우에 위 설정이 필요하다
초기화 schema.sql, data.sql 사용할 시 설정 필요  : spring.datasource.initialization-mode=always
[참고](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-initialize-a-database-using-spring-jdbc)

---
개발 시 추천..
1. ddl-auto : update로 쓰다가
2. 배포할 쯤 되면, test code에서 스키마를 생성하도록 하고
3. schema.sql 사용 : drop 주의!
4. 체계적으로 관리하고 싶을 경우 migration 사용

__ddl-auto, schema.sql 같이 사용은 불가능하다__
>In a JPA-based app, you can choose to let Hibernate create the schema or use schema.sql, but you cannot do both. Make sure to disablespring.jpa.hibernate.ddl-auto if you use schema.sql
