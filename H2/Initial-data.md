
	### 초기 데이터 추가 방법

### 방법 1. data.sql 파일 생성
-  src/main/resource 폴더에 data.sql 파일 만들면 시작할 때 자동으로 실행됩니다.
-  DB가 H2 경우에만 적용시키려면 파일면 data-h2.sql로 변경

- Schema 사용하기 위해서는?
  - 생성방법 : 위와 동일한 경로에 schema.sql(or schema-h2.sql) 생성
  - 설정 : spring.jpa.hibernate.ddl-auto=none; <br/>
// spring boot 자체에서 엔티티 기반으로 스키마를 생성하도록 설정하였기 때문에 설정 안해도 무관합니다. <br/>
 schema.sql 사용한다면 application.properties에 기능을 비활성화해줘야 합니다.

'
spring boot 2 사용시, 데이터베이스 초기화는 임베디드 데이터베이스(H2, HSQLDB ..)에서만 작동합니다.
다른 데이터베이스에서도 사용하기 위해서는 spring.datasource.initialization-mode 속성을 변경해야합니다.
[spring.datasource.initialization-mode=always]
'
<hr/>

### 방법 2. ApplicationRunner 구현
- ApplicationRunner 인터페이스는 응용 프로그램 시작시 실행되며, 일부 테스트 데이터 삽입이 가능합니다.
- 즉, 일부 테스트 데이터를 삽입하는 자동 repository라 부릅니다.


```
@Component
public class DataLoader implements ApplicationRunner {

    private UserRepository userRepository;

    @Autowired
    public DataLoader(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void run(ApplicationArguments args) {
        userRepository.save(new User("lala", "lala", "lala"));
    }
}
```
