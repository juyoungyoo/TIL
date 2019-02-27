Docker
* container
  - image instance
  - 실제로 실행될 이미지가 메모리에 저장된다.
  - container는 호스트 환경과 완벽하게 고립(독립)적이다. 또한 여러개 구축 가능하다.
* image
  - code, runtime, libraries, environment variables, and config 파일 등을 포함하여 s/w를 실행하는데 필요한 모든것을 포함하는 경량, 독립적 실행형 패키지이다.
* 컨테이너 앱을 실행한다. 호스트 커널에서
* 컨테이너는 기본적으로 호스트 커널에서 프로그램을 실행한다. hypervisor를 통해 호스트 리소스에 가상 엑세스만 하는 가상 머신보다 성능이 좋다
* 컨테이너는 고유한 엑세스 권한을 가지며, 각각 별도의 프로세스에서 실행되며 메모리를 적게 차지한다.


![](/images/2019/02/1-docker.png)

#### Docker 유용한 명령어
* docker run hello-world     // container start
* docker container ps - a    // 현재 실행중인 process state
*  docker images                // images check
* // container stop
  - docker stop <container_id>
  - docker container stop <container_id>
* // container start
  - docker start <container_id>
  - docker container stop <container_id>
* docker rmi <image_id>      // remove image
* docker rm <container_id>  // remove container


##### Docker MySQL Server 구축
* MySQL database는 Docker Hub에 이미 images를 제공하고 있으며, 로컬에 없다면 자동으로 install
```
docker run --name=docker-mysql --env="MYSQL_ROOT_PASSWORD=root" --env="MYSQL_PASSWORD=root" --env="MYSQL_DATABASE=test" mysql   
// name : container name
// evn  : MYSQL_ROOT_PASSWORD : root 계정 패스워드

docker run -p 6603:3306 --name=docker-mysql --env="MYSQL_ROOT_PASSWORD=root" --env="MYSQL_PASSWORD=root" --env="MYSQL_DATABASE=test" mysql
// -p 6603:3306 : 6603 local 외부 port, 3306 docker 내부 연결 port
```

____
	1. Docker 명령어 미리 작성 후 한번에 실행가능 한 방법
	2. 한번에 DB server, app server 띄우는 방법


###### Docker compose    
multi-container Docker applications   
컨테이너 여럿을 사용하는 도커 애플리케이션을 정의하고 실행하는 도구     

######도커 vs 도커 컴포즈 비교
* Dockerfile vs. Dockerfile-dev: 서버 구성을 문서화한 것(=클래스 선언이 들어 있는 파일)
* docker build vs. docker-compose build: 도커 이미지 만들기(=클래스 선언을 애플리케이션에 로드)
* docker run의 옵션들 vs. docker-compose.yml: 이미지에 붙이는 장식들(=인스턴스의 변수들)
* docker run vs. docker-compose up: 장식 붙은 이미지를 실제로 실행(=인스턴스 생성)


###### docker-compose.yaml
```
version: '3'
services: #### 컨테이너 단위 (여러 컨테이너 띄울수 있다.)
  mysql:
    container_name: guide.mysql
    image: mysql/mysql-server:5.7 # mysql에서 사용할 도커 이미지
    environment:                 # 각 환경 변수 : dockerhub 공식 이미지 참조
      MYSQL_ROOT_HOST: '%'
      MYSQL_DATABASE: "guide"
      MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
    ports:
      - "33060:3306"
    volumes:  # 데이터를 로컬의 ./volumes/mysql에 저장함
      - ./volumes/mysql:/var/lib/mysql
```
