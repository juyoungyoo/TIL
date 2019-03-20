### Windows 10에서 MySQL 5.7 수동 설치 / ERROR

#### 설치
1. [mysql-5.7.10-winx64 다운로드](http://dev.mysql.com/downloads/mysql/)
2. 원하는 위치에 압축 풀기 ( c:\MySQL )
3. my.ini 파일 생성 (my-default.ini 파일 수정)
```
[mysqld]

# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M

# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin

# These are commonly set, remove the # and set as required.
 basedir = c:/MySQL/mysql-5.6.43-winx64
 datadir = c:/MySQL/mysql-5.6.43-winx64/data
 port = 3306
# server_id = .....

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

```
3. 환경변수 설정
제어판에서 환경변수 설정

4. 관리자 권한으로 cmd 실행
```cmd
$mysqld --initialize
```
c:/MySQL/mysql-5.6.43-winx64/mysql/data 폴더에 데이터 들어갔는 지 확인 ( 도중 문제 생길 시 data폴더 내용 삭제 후 재실행)

5. mysql 서비스 등록
`mysqld --install`

6. mysql 서비스
`net start mysql` 실행
`net stop mysql`  중지

---------

### [ERROR] [MySQL] ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
1. 관리자 cmd에서 skip-grant-tables
```
$mysqld --skip-grant-tables  
```
2. 다른 cmd 오픈 후 mysql 비밀번호 없이 로그인 하고 root 비밀번호, 권한 변경
```
$mysql -u root -p   // 비밀번호 없이 로그인

$use mysql;
$update user set password=PASSWORD('test') where user='root';
$flush privileges;
$grant all on *.* to 'root'@'localhost' identified by 'test' with grant option;
$flush privileges;
$exit;
```
3. mysql 재실행
```
$mysqladmin -u root -p shutdown
$mysqladmin -u root -p reload
```
