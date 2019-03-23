

## Monolithic Architect ( 이전 회사 구조 )
	* 모든것이 하나의 프로젝트에 묶여있는 개발
	* 문제점
1. 빌드 시간, 테스트 시간이 길어진다.
      CI / CD (지속적 통합 / 지속적 배포)가 강조       
      페이스북 같은 경우는 하루에도 수십 번을 프로덕션에 배포   
2. 개발 언어에 종속적이다.
3. 선택적으로 확장할 수 없다.
      이벤트 서비스와 주문 서비스의 사용률이 90:10더라도 원하는 서비스만 확장할 수 없다.   
      프로젝트 하나를 통째로 확장해야한다.    
4. 하나의 서비스가 모든 서비스에 영향을 준다.
    이벤트 서비스에 트래픽이 몰려 해당 서버가 죽게 되었을때, monolithic에서는 하나의 서버에 모든 서비스가 있기 때문에 하나의 서비스의 트래픽 폭주로 인해 다른 서비스도 마비되는 상황이 온다.

`Monolithic구조의 불편함을 개선한 구조가 MSA이다.`

## MSA
	* Micro Service Architecture
	* 단일 응용 프로그램을 나누어 작은 서비스의 조합으로 구축하는 방법

![msa-vs-monolithic](/images/2019/03/msa-vs-monolithic.png)

하나의 프로젝트가 프레젠테이션, 비즈니스, DB 계층으로 구분되어 있던 것을 하나의 서비스가 하나의 프로젝트로서 프레젠테이션, 비즈니스, DB 계층을 갖게된다.   
즉, 서비스별로 각 프로젝트가 생기며 한 서비스에서 장애 발생시 다른 서비스에 영향을 주지 않는다.   


#### 장점
1. 빌드 및 테스트 시간을 단축시킬 수 있다.
30개 서비스를 가진 monolithic의 구조 빌드시간이 30분이었다면, MSA경우 한 서비스 빌드 시간은 약 1분이 걸린다. CI/CD 사용하는 기업에 적합함
2. 폴리그랏 아키텍처 구성 가능
상황에 맞게 기술 유연하게 적용가능. 서비스 특성에 따라 node.js+Redis, Spring+RDB 적용가능
3. 탄력적이고 선택적 확장이 가능
MSA 작은 단위의 작업으로 특정 서비스 사용률이 높을 시  특정 이벤트 서비스만 선택적으로 확장(scale out)할 수 있다.
4. 하나의 서비스가 다른 서비스에 영향주지 않는다.
각 서버마다 서비스를 놓기 때문

#### 단점
1. 성능이슈
Monolithic은 다른 서비스 간의 상호작용이 필요할 때 method 호출 ( use memory )
MSA ( use HTTP / Network IO )
2. 트랜잭션이 불편하다
Spring @Transactional 어노테이션으로 처리 불가
해결방법 1) 서비스 간에 Global 트랜잭션 << Local 트랜잭션 사용하도록 권고
해결방법 2) 서비스 간에 트랜잭션 필요 할 때는 트랜잭션 로직 추가
3. 관리 포인트 늘어난다.
- Monolithic : Application server, DB server 두개만 관리하면 된다.   
- MSA : 서비스 수 * 인스턴스만큼의 서버 ( +DB)가 존재하며 로깅,모니터링,배포,테스트, ㅡㄹ라우드 환경에서의 관리가 필요 >> 자동화, 간단한 모니터링 환경 권장 ( spring boot admin, jenkins )    


#### MSA 경계 기준
- 자율적인 기능
- SRP
- 배포 단위의 크기
- 서브도메인
- 폴리글랏 아키텍처
- 선택적 확장
- 트랜잭션

___

# Circuit Breaker
* 정의 : 누전 차단기
* MSA 장점은 서비스가 다른 서비스에 영향을 끼치지 않는다. but, 다른 서비스를 의존하고있다면?
* 장애전파 : 한 서비스(B)가 다른 서비스(A)에 디펜던시를 갖고 있을 경우 A장애시 B도 함께 장애 발생한다.
  해결방법 1) tomcat에 max-thread 설정한다. // request 가 계속 쌓임   
  해결방법 2) timeout 설정  // timeout도 client는 호출을 기다리게 됨    
  해결방법 3) Circuite Breaker : 핸들링 방식 여러개 있으나, 일반적으로 defualt 값을 설정한다.   
![/msa-2](/images/2019/03/msa-2.png)
![msa-3](/images/2019/03/msa-3.png)
일반적인 경우 개인화 API에서 데이터 통신함   
![msa-4](/images/2019/03/msa-4.png)
장애 발생했을 경우, 개인화 API 서비스에 보내지 않고, 책 서비스로 다시 return   


Circuit Breaker 에러 핸들링 방식
	1. Default 값 설정 (많이 씀)
	2. ...  

___

#API Gateway
![msa-5](/images/2019/03/msa-5.png)
* API 서버 앞단에서 모든 API 서버들이 End-Point를 단일화 시켜준다.
* 각 서비스별로 나누는데, 공통된 로직(logging, monitering, CORS..)을 관리해야할 경우 API Gateway를 사용하여 해결한다.


#### 기능
1. API 요청을 한 곳에서 받고 해당 서비스로 라우팅(이동)시킨다.
2. 보안을 강화시켜준다.
- API Gateway만 외부 접근가능하도록 public
- 각 서비스들은 내부 IP만 접근가능하도록 private로 구축
3. 각 서비스의 공통된 로직 처리
- 공통된 로직 종류 : 로깅, CORS, 보안 및 인증, 모니터링

___

# Service Discovery

* MSA와 Cloud 환경을 밀접하게 관련이 있다.
* 서비스 : 서버 = 1:1 로 가져야하는데, 물리 서버를 많이 이용 시 비용, 관리하기 힘들다. 이런 이슈를 해결하기 위해 사용
* 장점 : 가용성

### Auto-scaling
* 트래픽에 따라 서버(인스턴스) 수를 조정한다.
* 트래픽이 낮을 경우 : 최소의 서버만을 구동
* 트래픽이 많을 경우 : 점진적으로 서버 자동 증가

`auto-scaling, update, 확장으로 인스턴스 생성,소멸, ip address 변경 될 시 알 수 있는 방법이 없다.
 service discovery은 이것을 감지하는 역할을 한다.`

![msa-6](/images/2019/03/msa-6.png)
1. 각 서비스가 실행될 때 service registry에 ip,port등 서버 정보 전달
2. client request 요청 발생
3. router 정해진 시간마다 service registry에서 서버정보 response
4. 요청이 들어온 url에 맞게 해당 서비스로 routing

### 장점
	1. 로드밸런싱이 되어 트래픽 분산
	2. Service Registry 서버에 서버정보가 있어 DNS서버 이용 X


___
