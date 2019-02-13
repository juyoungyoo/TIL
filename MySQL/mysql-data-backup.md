### MySQL DB 백업하기
1. Data 디렉토리 백업
- 정기적으로 백업하고 문제 발생시 백업 파일을 덮어쓴다.
##### mysqldump 사용법
###### mysqlhotcopy 사용법
 mysql 백업 방법 중 속도가 빠르며, db 디렉토리를 다른 위치에 copy
###### xtraback 사용하는 방법
: mysql 서버 중단하지 않고 InnoDB를 핫백업 가능
* InnoDB Hot Backup은 핫백업을 지원하나 상용이나 xtraback은 무료로 사용 가능
* hot backup : db서버가 온라인 상태에서 db를 백업하는 방법
* cold backup : db서버를 중단시키고 백업하는방법


2. mysqldump 사용하는 방법
* 지원범위
    * 전체 DB
    * 특정 DB
    * 특정 테이블 백업
* 전체 데이터베이스 백업 방법
    * 서버의 전체 데이터베이스를 alldb.sql로 백업
        * `mysqldump -uroot -p --all-databases > alldb.sql`
* 특정 데이터베이스 백업
    * g5 데이터베이스만 백업
        * `mysqldump -uggachi -p g5 > g5.sql;`
* 특정 테이블만 백업
    * g5의 g5_board 테이블만 백업
        * `mysqldump -uggachi -p g5 g5_board > g5_board.sql`
* 특정 데이타베이스 테이블 생성(schema) 정보만 백업하는 방법
    * `mysqldump -uggachi -p --no-data g5 > g5schema.sql`

* mysqldump -? : 옵션 확인
: InnoDB에서 트리거, 프로시져, 함수 포함하여 백업하는 방법
1. 트리거는 default값으로 백업이 실행되나 저장 프로시저는 저장되지 X
2. so, 저장 프로시저 백업 방법 : 옵션 --routines 추가
* 파일 구조 data, sp, trigger 모두 백업하는 방법
`mysqldump - u계정 -p비밀번호 --routines 특정DB명 > 파일이름.sql`
`mysqldump -uggachi -p --routines g5 > g5.sql`
* 트리거, 프로시저, 함수만 백업하는 방법
`mysqlemp -u계정 -p비밀번호 --no-create-info --no-data --no-create-db --skip-opt 특정 DB명 > 파일이름.sql`
`mysqldump -uggachi -p --routines --no-create-info --no-data --no-create-db --skip-opt g5 > g5_sp+_trigger_function.sql`


##### 백업 스케줄 설정 방법

* 백업에 실패한 관리자는 용서가 안된다!!
1. 백업할 디렉토리 생성 : sudo mkdir /backup
2. 백업 디렉토리 권한 설정 : sudo chmod 755 /backup
3. shell 프로그램 작성 : sudo nano /usr/local/bin/mysqldump.sh
#!/bin/sh
```
#백업 위치를 /backup 아래로 정한다.
# 백업 시간을 년-월-일 형식으로 지정한다.
Now = $(date + "%y%m%d%H%M%S")
#사용자 계정과 비밀번호
USERNAME ="mysql계정"
PASSWORD ="비밀번호"
#백업할 데이타베이스
DATABASE="g5"
```
#백업 작업
mysqldump -u$USERNAME -p$PASSWORD $DATABASE > /backup/mysql_db_back_$NOW.sql
4. 실행권한 부여 : sudo chmod +x /usr/local/bin/mysqldump.sql
5. cron 만들기 : sudo nano /etc/crontab ( 분 시 일 월 요일 명령어 )
6. cron 데몬 재실행 : sudo /etc/init.d/cron restart
7. 시스템 시작 시 스크립트 실행 : sudo vi /etc/rc.local  / usr/local/bin/mysqldump.sh 추가


* Mysql 설치 및 버전확인
    * linux : mysql --version
    * mysql 접속시 select version();
