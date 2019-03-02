### Docker MySQL 외부 접근하는 방법 (Window)

##### Docker MySQL 설치
MySQL8.0 tag로 설치 했을 때, docker는 생성되었으나 외부접근에 실패하였습니다.
workbench의 버전이 문제이며 설치 시 GA말고 develpment release로 설치하면 된다고 하였으나, 현재글 기준으로 develpment release 설치가 불가능하였습니다. 또한 workbench 문제가 아닌 윈도우에서 사용 시 별도의 설정이 필요함을 알게되었습니다.

![docker-warning](/images/2019/03/docker-warning.png)
MySQL Docker 이미지는 Linux 플랫폼 용으로 만들어졌으며, 비 Linux 플랫폼에서 작동 시 문제점을 가지고 있습니다.   
컨테이너에 MySQL 데이터 디렉토리에 마운트 하는 경우 --socket option 사용하여 서버 소켓 파일 위치를 외부로 설정해야 합니다. Docker for windows는 호스트 파일이 소켓 파일에 mount 시키지 않기 때문입니다.    
[자세한 내용](https://dev.mysql.com/doc/refman/8.0/en/deploy-mysql-nonlinux-docker.html)

위 내용은 5.6에서도 문제가 발생할 수 있다고 작성되어 있지만, 5.6을 사용했을 때 별도의 설정없이 외부접근에 성공하였습니다. 저는 테스트 용으로 사용할 것이기 때문에, MySQL5.6 버전을 사용하겠습니다.   

```
$docker run --name mysql3 -e MYSQL_ROOT_PASSWORD=test -p 3306:3306 mysql:5.6

// -e MYSQL_ROOT_PASSWORD : root 패스워드
// -p 3306:3306 : port 번호 지정 (local port : docker port)
// mysql:5.6 : ':tag'이며 5.6 tag를 사용하겠다라는 의미. 미작성시 latest로 설치됩니다.
```

###### MySQL 설치 확인
```
$docker ps

// 모든 docker list ( stop된 container 포함 )
$docker ps -a
```
현재 실행 중인 docker 정보만 보여줍니다.

###### (중요) Machine port 확인
```
$docker-machine ls | grep default
default   *        virtualbox   Running   tcp://192.168.99.100:2376           v18.09.3
```

##### [1] 외부에서 접근 확인
![1-docker-result](/images/2019/03/1-docker-result.png)
##### [2] 외부에서 접근 확인
![workbench-result](/images/2019/03/workbench-result.png)

Docker는 linux 기반으로 만들어져 있으며,  윈도우에서 실행 시 내부적으로 가상머신(docker machine : docker 설치 시 같이 설치)이 실행되어 그 안에서 docker가 실행되게 됩니다.     
그렇기에 호스트를 local이 아닌 `docker-machine 주소`로 붙어야 합니다.      
