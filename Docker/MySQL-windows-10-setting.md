### Windows 10 pro Docker 설치 및 외부 접근하는 방법

#### Docker MySQL 설치
이전 window 버전과 windows 10 pro 설치방법과 구동방법이 달라 작성합니다.   
이전에는 Docker Toolbox, Docker Machine을 사용하여 가상환경 프로그램을 사용하여 docker-machine위에서 컨테이너를 돌렸다면, window 10 pro는 windows에 설치되어있는 Hyper-V를 사용합니다.    
정리.
 - VirtualBox VM을 생성하는 docker-machine 사용안함
 - docker-machine, toolbox 설치 X

[Docker download](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe)    

설치 후 실행하면 작업표시줄 우측하단에 아이콘 생김


#### [Kitematic] Docer GUI 프로그램 설치
 ![kitematic](/images/2019/03/kitematic.png)
 하면 kitematic 압축파일 다운가능     
 다운로드한 파일은 꼭 Docker 설치된 경로의 Kitematic 폴더 안에 있어야한다. (C:\Program Files\Docker\Kitematic)

![kitematic2](/images/2019/03/kitematic2.png)


#### MySQL container 구동

```
// docker-machine 사용 시 명령어
$docker run --name mysql3 -e MYSQL_ROOT_PASSWORD=test -p 3306:3306 mysql:5.6


// ERROR 발생
docker error response from daemon driver failed programming external connectivity on endpoint mysql....
```
3306 port 사용 중으로 사용불가       
docker-machine 사용했을 때는 가상머신을 이용하기 때문에 local에서 사용중인 포트를 이용해도 에러가 발생하지 않았다.   
Windows 내장된 Hyper-V를 사용해서인지 사용 중인 포트는 이용이 불가능했다.    
[해결방법] `net stop mysql`로 3306 포트 사용하는 mysql 서비스를 죽이거나 다른 포트를 이용하면 된다.
![mysql-service-shutdown](/images/2019/03/mysql-service-down.png)    



#### MySQL 설치 확인
```
$docker ps

// 모든 docker list ( stop된 container 포함 )
$docker ps -a
```
현재 실행 중인 docker 정보만 보여줍니다.



#### 외부에서 접근 확인
![intellij](/images/2019/03/intellij.png)
!! host 주소를 보면 이전에는 가상host주소로 연동했지만, windows 10 pro에서는 localhost(127.0.0.1)로 연결   
