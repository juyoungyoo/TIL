
# 스프링 데이터 -1
- 인메모리 데이터베이스 지원

##스프링부트가 지원하는 인메모리
* H2 ( __추천!__ ) :jdbc:h2:mem:~/testDB
* HSQL
* Derby

Spring-JDBC가 클래스패스에 있으면 자동 설정이 필요한 빈을 설정 해줍니다.

## H2 인메모리 설정하기
1. 의존성 추가 (gradle)
```
implementation 'org.springframework.boot:spring-boot-starter-data-jdbc'
compile('com.h2database:h2')
```
__Spring JDBC 의존성__
* HikariCP
* Spring-jdbc
가장 핵심이 되는 설정 //  autoconfigure 확인가능
```java
org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.JdbcTemplateAutoConfiguration
```

스프링부트는 H2, JDBC 의존성 설정하고, 별도로 DB설정을 하지 않을 경우 스프링부트는 자동으로 인메모리 데이터베이스 설정을 하여 애플리케이션이 동작한다.

## 인-메모리 데이터베이스 기본 연결 정보 확인하는 방법
* URL: “testdb”
* username: “sa”
* password: “”

## H2 콘솔 사용하는 방법
* spring-boot-devtools를 추가하거나...
* spring.h2.console.enabled=true 만 추가.
* /h2-console로 접속 (이 path도 바꿀 수 있음)

```java
@Component
public class H2Runner implements ApplicationRunner {
    @Autowired
    DataSource dataSource;
    @Autowired
    JdbcTemplate jdbcTemplate;

    // application 실행하여 DB정보, 데이터 추가할 수 있다.
    @Override
    public void run(ApplicationArguments args) throws Exception {
        try( Connection connection = dataSource.getConnection()) {
            System.out.println(connection.getMetaData().getURL());
            System.out.println(connection.getMetaData().getUserName());

            // table
            Statement statement = connection.createStatement();
            String sql = "CREATE TABLE USER (ID INTEGER NOT NULL, name VARCHAR(255), PRIMARY KEY (id))";
            statement.executeUpdate(sql);
        }
        jdbcTemplate.execute("INSERT INTO USER VALUES (1, 'juyoung')");
    }
}
```
---

#SpringBoot H2 DB client로 IntelliJ 사용방법
* [Jojoldu 블로그 참고](https://jojoldu.tistory.com/234)
1. 의존성 변경
H2 runtime -> compile로 변경
// spring boot는 JVM내에 있는 임베디드 H2 DB를 설정하게 되는데 이를 우회 접근하기위해 H2 library에서 제공하는 TcpServer 사용
```
implementation 'org.springframework.boot:spring-boot-starter-data-jdbc'
compile('org.springframework.boot:spring-boot-starter-web')
compile('com.h2database:h2’)
```
2. H2 TcpServer 설정방법
```java
@Component
public class H2ServerConfiguration {
    @Bean
    public Server h2TcpServer() throws Exception{
        return Server.createTcpServer().start();
    }
}
```
3. application 설정 변경 (yml)
url설정을 위에처럼 안하면? 웹 콘솔로 띄울 JVM내의 H2 DB로 JPA가 접근한다
``` yml
datasource:
    platform: h2
    url: jdbc:h2:tcp://localhost:9092/mem:testdb;MVCC=TRUE
    username: sa
    password:
    driver-class-name: org.h2.Driver

```
4. 이후, IntelliJ database 연동
```
Host : localhost
Port : 9092
Database : mem
User : sa
URL 접근 타입 : Remote
URL : jdbc:h2:tcp://localhost:9092/mem:testdb
```
