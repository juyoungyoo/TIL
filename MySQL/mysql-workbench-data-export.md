
### MySQL Workbench 데이터 백업, 복원방법

#### 데이터 백업
1. Navigator 메뉴에서 MANAGEMENT -> Data Export 클릭
![workbench](/images/2019/02/3-workbench-export.PNG)

###### Export Options 설명
- Objects to Export
  - Dump Stored Procedures and Functions : 저장 프로시저, 함수 백업
  - Dump Events : 이벤트 백업
  - Dump Triggers : 트리거 백업
- Export Options
  - Export to Dump Project Folder : 테이블 별로 백업 파일 생성
  - Export to Self-Contained file : 데이터베이스 별 백업 파일 생성
<<<<<<< HEAD
  - Create Dump in a single Transaction
=======
  - Create Dump in a single Transaction :
>>>>>>> 2fd28b6ddfb570b7e967622b433805273f426184
  - Include create schema


2. Start Export..

#### 데이터 복원
1. Navigator menu > MANAGEMENT > Data Import 클릭
![workbench-import](/images/2019/02/4-wb-import.PNG)
###### Import Options 설명
- Import Options
  - Import from Dump Project Folder : 테이블 단위 데이터 복원
  - Import from Self-Contained File : 데이터베이스 단위 데이터 복원
- Default  Schema to be Imported To
  - Default Target Schema : 복원할 데이터 존재하는 Schema 선택하거나 새로 생성한다.
2. Start Import..

<hr/>

### [ERROR] MySQL Workbench export fail
![error-msg](/images/2019/02/5-error.PNG)
MySqldump 버전이 맞지 않아 발생하는 문제로, MySqldump 실행 파일 경로를 직접 설정해줘야한다.
###### 해결방법
1. C:\Program Files\MySQL\MySQL Server 5.6\bin에 mysqldump.exe 파일 존재유무 확인
2. mysql workbench에 설정하기
(Edit > Preferences > Administrator > `Path to mysqldump Tool`에 위 경로(C:\Program Files\MySQL\MySQL Server 5.6\bin) 입력

### [ERROR] MySQL : High Severity Error 해결방법 (for Window)
Workbench 실행 시 에러발생

![error-msg](/images/2019/02/1-error.PNG)
![error-msg2](/images/2019/02/2-error.PNG)

- Notifier.config 파일 손상으로 에러 발생합니다. 이를 해결하기 위해 config 파일 삭제하면 된다.
Config file PATH : `C:\User\UserName\AppData\Roaming\Oracle\MySQL Notifier\settings.config`


<<<<<<< HEAD
=======




>>>>>>> 2fd28b6ddfb570b7e967622b433805273f426184
#### 참고
[DataBase import & export](https://m.blog.naver.com/islove8587/220954758979)
[Mysql 실행 시 에러해결](https://bitsoul.tistory.com/38 )
[Mysql export version mismatch error](https://congjava.tistory.com/285)
