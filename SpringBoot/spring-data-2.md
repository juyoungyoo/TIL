#SpringBoot가 지원하는 DBCP
1. HikariCP (기본) ○https://github.com/brettwooldridge/HikariCP#frequently-used
2. Tomcat CP
3. Commons DBCP2

##DBCP : DataBase Connection Pool
* 중요 설정
  * spring.datasource.hikari.*
  * spring.datasource.tomcat.*
  * spring.datasource.dbcp2.*

## MySQL 설정
1. MySQL 커넥터 의존성 추가 (gradle)
```runtimeOnly 'mysql:mysql-connector-java'```

2. Docker로 Local mysql 설정
```
$ docker run -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=colini -e MYSQL_USER=friday -e MYSQL_PASSWORD=pass -d mysql
$ docker exec -i -t mysql_boot bash 
$ mysql -u root -p
```
3. Application.yml 설정
```yml
spring.datasource.url=jdbc:mysql://localhost:3306/springboot
spring.datasource.username=keesun
spring.datasource.password=pass
```

##MySQL 접속시 에러
###MySQL 5.* 최신 버전 사용할 때
* 문제 Sat Jul 21 11:17:59 PDT 2018 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
* 해결 jdbc:mysql:/localhost:3306/springboot?useSSL=false
###MySQL 8.* 최신 버전 사용할 때
* 문제 com.mysql.jdbc.exceptions.jdbc4.MySQLNonTransientConnectionException : Public Key Retrieval is not allowed
* 해결 jdbc:mysql:/localhost:3306/springboot?useSSL=false&allowPublicKeyRetr ieval=true
