#Linux(서버)에서 Mysql log 확인방법
	* Mysql 로그파일 명 : mysqld.log
	* 찾는 방법
  - find 명령어 사용 : find / -name mysqld.log
  - 환경설정에서 확인 : vi /etc/my.cnf  > log-error 파일 확인

####MySql 로그 종류 3가지
1. 에러로그
  - Mysql 구동, 모니터링, 쿼리(query) 에러에 관련된 메세지를 포함하여 표시.
  - 구동, 모니터링, 쿼리 모두 기록
2. General 로그 ( 권장 X )
  - Mysql에서 실행되는 전체쿼리에 대해서 General 로그 활성화 시켜 저장.
  - Mysql이 요청 받을 때 곧바로 General 로그에 기록
  - Mysql server를 재시작하지 않아도된다.  
3. UPDATE 로그
  - 테이블이 변경될 때마다 해당 쿼리 기록

```
!! [관리] MYSQL 사용량이 많은 사이트는 로그파일이 많이 쌓이므로 디스크 용량에 문제가 발생할 수 있음으로 서버 관리자는 수시로 점검하여 삭제필요
```

####MySQL 로그 설정
1. 에러로그 설정
1-1. 경로 설정
```
    vi my.cnf
    log-error = /var/log/mysqld.log  // 이름 변경 가능
```
1-2 권한 설정
```
    chmod 644 mysqld.log
    chown mysql:mysqld.log
```
1-3 mysql 재시작
```
    service mysqld restart
```

2. General 로그 설정
mysql 접속
2-1. Mysql 로그관련 정보 확인
```
    show variables where Variable_name in ('version','log','general_log')
    // log 상태, version 상태를 확인 할 수 있다.
    // log 값이 off라면 on으로 변경
```
2-2. 로그 파일 위치 확인방법
```
    show variables like 'general%';
    // general_log_file 필드값에서 확인
    // 여기선 /var/log/mysql/web.log
```
2-3. General 활성화
```
    >set global general_log=on;
    Query OK, 0 rows affected (0.01 sec) // 성공
```
2-4-1. General 로그 활성화 확인
```
    >show variables where variables_name in ('log','general_log');
```
2-4-2. 저장한 로그를 mysql db general_log 테이블에 저장한다.
```
    > SET GLOBAL log_output = 'TABLE';
    #slow log 설정  (option)
    > SET GLOBAL slow_query_log ='on';
```  

3. UPDATE 로그 설정
3-1.Mysql update 로그 경로 설정
```
    vi my.cnf
    log-update = /var/mysql/log/update.log
```
3-2. Mysql 재시작
```
    service mysqld restart
```

!! troubleshooting을 하는 것이 아니라면 general log 켜지말자!    
!! window general log : 로그 쌓이는 곳(윈도우10 기준)    

```
show variables like 'general%';
set global general_log='on'; or 'off';
C:\ProgramData\MySQL\MySQL Server 5.7\Data
    ref link: http://sjh836.tistory.com/7
```


참고
  - http://server-talk.tistory.com/37
  -  http://kugancity.tistory.com/entry/mysql-%EB%A1%9C%EA%B7%B8-%ED%99%95%EC%9D%B8-%EB%B0%8F-%EC%A0%80%EC%9E%A5%ED%95%98%EA%B8%B0
