#현상
mysql 에서 dbcp, c3p0같은 connection pool 사용시 com.mysql.jdbc.exceptions.jdbc4.CommunicationsException: Communications link failure 에러발생

##원인
- 메세지 해석 : pool에서 가져온 connection이 이미 끊겨 사용할 수 없다
- 확인 : variables - `SHOW VARIABLES` 확인가능    
    ![val](/images/2019/03/val.png)   
초기에 connection 생성된 후 query 문 실행을 종료하면 다시 pool로 저장이 되어있다가 또 다른 클라이언트가 pool에서 connection을 재사용하기 위해 할당 받는다. 그 과정중 재사용 간격(wait-timeout) 이상이면 connection은 mysql에 의해 끊어져 버린다.    
mysql은 `wait_timeout`으로 `connection 개수를 관리`하는데 그 값이 적을 경우 발생

##해결방법
####일반적인 경우   
1. wait_timeout 값 넉넉하게 잡기
2. test query를 wait_timeout보다 짧은 주기로 일정히 날려주면, pool 안에있는 connection 은 계속 살아있게됨 ( dbcp, c3p0 경우 test query 주기 설정가능)
####project를 여러곳에서 사용할 때, 다른 project는 connection pool 사용하지 않는 경우
1. wait_timeout 짧은 주기로 설정 : sessionVariable   
sessionVariable이란? connection에 대해서만 적용될 수 있는 variable설정하는 기능으로, pool에서 connection을 생성할 대 참조하는 값인 url에 `sessionVariable` 설정하면 pool의 connection에 대해서만 긴 주기의 wait_timeout설정가능하다.   

____

## mysql variable 변경
* mysql 중단없이 variable 변경방법
1. 현재 설정값 확인
```
show variables;
```
2.variable 변경
```
set global [변경값]; set global max_connections=200;
```
