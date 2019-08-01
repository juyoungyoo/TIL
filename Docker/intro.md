# Docker

오픈소스 플랫폼

컨테이너형 가상화 기술 사용 

Docker =  dockerd + 관리하는 명령형 도구 



# 가상화 (Virtualization)  

> easy : 컴퓨터 안에 독립적인 컴퓨터를 만드는 것
>
> 컴퓨터에서 컴퓨터 리소스를 추상화 시킨다 
>
> 왜? 물리적 리소스를 여러 사용자 또는 환경에 배포해서 제한된 리소스를 최대한으로 활용하기 위해서
>
> 

####  호스트 운영체제형 가상화 vs 컨테이너 가상화

- 호스트 운영체제 가상화

OS에서 가상화 SW를 이용하여 게스트 OS 작동시킨다. ex) OracleVirtualBox,  VMware

많은 자원(커널, 라이브러리 모두 설치 필요)이 소비되고 느리다. 

- 컨테이너 가상화

가상화 SW 사용하는 것이 아닌 운영체제에 내장된 가상화도구를 사용하여 운영체제의 리소스를 격리해 가상 운영체제를 만듬

이 가상 운영체제 __컨테이너__ 라고 부름 ( 컨테이너 = 운영체제 + 애플리케이션)

오버헤드를 최소화하기 위한 방법 ex) Docker

Host OS에 독립적이 공간을 만들고 별도의 서버처럼 사용

각 컨테이너는 같은 호스트 OS를 공유하여 __오버헤드가 적으며, 속도가 빠름__



####  장점

- 애플리케이션 배포 및 운영에 특화 : 애플리케이션 + 환경 구성
- 개발 환경 구축 + 운영환경  배포 / 애플리케이션 플랫폼으로 사용 가능
- 기존 가상화보다 가볍다
- 이식성 Good  : 운영체제에 종속적이지 X 
-  재현성 Good :  DSL(Dockerfile)을 이용한 컨테이너 구성 및 애플리케이션 배포 정의
- 차분 빌드 가능 : image version별로 관리가능

```
내부가 리눅스 계열 운영체제와 유사하지만 완전히 재현하지 못함
엄밀한 리눅스 운영체제의 동작이 필요할 경우 또는 비리눅스 환경은 도커보다 가상환경을 사용하는 것이 좋다.
```



#### 사용 이유

- 인프라 환경 문제 방지 : 변화하지 않는 실행 환경으로 멱등성 확보
- DSL을 이용한 실행 환경 구축 및 애플리케이션 구성 
- 실행 환경 + 애플리케이션 일체화로 이식성 향상 

```
docker-compose : 여러 컨테이너 관리 (의존관계, 실행순서), 단일서버
docker warm : 멀티 서버, 여러 컨테이너 관리
```



---

# Dockerfile

#### 인스트럭션 

- `FROM` : dockerHub에서 이미지 다운 (dockerHub 레지스트리에 공개된 것만 가능)

- `RUN` : Docker 이미지 실행 시 컨테이너 안에서 실행 할 명령을 정의

- `COPY` : 호스트 머신에서 도커 컨테이너 안으로 복사

- `CMD` : 도커 컨테이너 실행할 때 컨테이너 안에서 실행할 프로세스 지정 (컨테이너 시작 시 한번만 실행!)

  배열로 작성

- `ENTRYPOINT` : 컨테ㅔ이너 안에서 실행할 프로세스 지정 (CMD와 유사)

  docker run으로 실행시 command를 입력하면 entrypoint 인자값으로 인식

- `LABEL` : description 작성

- `ENV` : 도커 컨테이너 환경변수 지정

- `ARG` : 이미지 빌드 시 인자값으로 사용

```dockerfile
FROM golang:1.9
LABEL maintainer="juyoung@gmail.com"

ARG builddate
ENV BUILDDTAE = ${builddate}
ENV BUILDFROM = "from golang"

RUN mkdir /echo     // 컨테이너 내부에 /echo 폴더 생성
COPY main.go /echo

CMD ["go", "run", "/echo/main.go"]
```

---



# Docker image 

> 아카이브 = 애플리케이션 + 의존 라이브러리, 도구 +  실행 환경 설정 정보 

##### 검색 (search)

````bash
docker search 
docker search --limit 5 mysql
````

#####다운 (pull)

```bash
docker image pull [option] 리포지토리명
docker image pull jenkins
```

##### 배포 (push)

- dockerHub 회원가입 및 로그인 (`docker login` ) 필요
- 자신 레포지토리에만 이미지 등록 가능 (namespace/repository_name)

```
docker image push dockerHub_id/repository_name
docker image push juy5790/echo
```

##### 리스트 (ls)

```bash
docker image ls
```

##### 빌드 (build)

- -t : 이미지 명  
- -f : Dockerfile명이 다른 경우 사용
- —pull : 새로 이미지 다운 (—pull=true)

```
docker image build -t 이미지명 Dockerfile_PATH 
docker image build -f Dokcerfile2 -t example/echo .
```

----

#### 

# Docker container

> 파일 시스템 + 애플리케이션
>
> 도커 이미지를 기반으로 생성.

- RUN, STOP, RM 

##### 실행 (run)

- __-d__ : 백그라운드 컨테이너를 실행
- __-p__ : 포트 포워딩 (host port : container port)
- --name : container 명
- __-it__ : i (표준입력), t (tty) 같이 많이 사용
- -v : volumn
- __—rm__ : stop 시 자동 삭제 (—name과 함께 많이 사용)

> 포트 포워딩 ?
>
> 호스트 머신의 포트를 컨테이너 포트와 연결해 컨테이너 밖에서 온 통신을 컨테이너 포트로 전달하도록 연결
>
> 외부에서 봤을 때 독립된 하나의 머신처럼 다룰 수 있다.

```bash
docker container run [options] 이미지명 [명령] [명령인자...]
docker container run -p 9000:8080 example/echo 
```

#####  리스트 (ls)

- __-q__ : container ID만 추출 
- —filter 
- -a : 모든 컨테이너 보기 (stop, run)

```bash
docker container ls
docker container ls -q
docker container ls --filter "name=echo"
docker container ls --filter "status=exited"
...
```

##### 정지 (stop)

```bash
docker container stop container_name or id
```

##### 재시작 (restart)

```bash
docker container restart container_name or id
```

##### 삭제 (rm)

- -f : 실행 중 인 컨테이너 강제 삭제 

```bash
docker container rm container_name or id
```

##### 표준출력 연결 (logs)

- 디버깅 용도로 사용

```bash
docker container logs [options] container_name or id
```

##### 실행중인 컨테이너 명령 실행 (exec)

```bash
docker container exec -it -u root example/echo bash
$root&contianer_id bash로 들어감
```

##### 파일 복사 (cp)

```bash
docker container cp [options] container_name:원본파일 대상파일
docker container cp [options] 호스트원본파일 container_id:대상파일
```



#### 이외

- __prune__ : 사용하지 않는 컨테이너 및 이미지 삭제

```bash
docker container prune
docker image prune
docker system prune // docker img, container, volumn, network ...
```

- __stats__ : 사용 현황 확인

```bash
docker container stats
CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
212e7712cb6a        master              0.06%               661.6MiB / 1.952GiB   33.11%              315kB / 588kB       49.7MB / 9.72MB     50
0ff0df37285a        slave01             0.00%               1.531MiB / 1.952GiB   0.08%               7.23kB / 0B         6.58MB / 0B         1
59270f532aca        echo2               0.00%               7.277MiB / 1.952GiB   0.36%               1.81kB / 0B         229kB / 8.19kB      19
```



---

# Docker Compose

작성중







### 쿠버네티스 Kubernetes

실제 애플리케이션은 여러 컨테이너에 걸쳐 있고 이러한 컨테이너는 여러 서버에 배포되어 있을 경우

여러 대의 서버나 하드웨어를 모아서 한 대처럼 보이게 하는 기술을 클러스터링(*clustering*)이라고 한다. 

이를 통해서 가용성과 확장성을 향상가능

이런 멀티호스트 환경에서 __컨테이너를 클러스터링하기 위한 툴을 컨테이너 오케스트레이션 툴__이라고 합니다. 오케스트레이션 툴은 컨테이너들을 클러스터링하기 위해 __컨테이너 시작 및 정지와 같은 조작, 호스트 간 네트워크 연결, 스토리지 관리, 컨테이너를 어떤 호스트에서 가동시킬지와 같은 스케줄링 기능을 제공__



https://futurecreator.github.io/2018/11/09/it-infrastructure-basics/

[구글이 만든 Docker Container Orchestration 툴, Kubernetes 소개](https://www.popit.kr/kubernetes-introduction/)

[Docker 개발환경 구축방법](http://raccoonyy.github.io/docker-usages-for-dev-environment-setup/)

[Docker (Compose) 활용법 - 개발 환경 구성하기](http://raccoonyy.github.io/docker-usages-for-dev-environment-setup/)



#####  [참고]

- 도커/쿠버네이스를 활용한 컨테이너 개발 실전 입문