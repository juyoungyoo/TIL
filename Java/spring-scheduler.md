### Spring scheduler 설정방법
- servlet.xml 설정 ( task 사용 )
~~~
xmlns:task="http://www.springframework.org/schema/task"
http://www.springframework.org/schema/task http://www.springframework.org/schema/task/spring-task.xsd

<beans:bean id="alramservice" class="efuture.util.Scheduler"/>
<task:scheduler id="scheduler" pool-size="10"/>
<task:executor id="executor" pool-size="10" queue-capacity="255"/>
<task:annotation-driven executor="executor" scheduler="scheduler"/>

또는,

<task:annotation-driven/>
 ~~~

~~~
@Component
public class Scheduler {

    @Autowired
    private SchedulerDao schedulerDao;

    @Scheduled(cron = "0 20 10 * * *")
    public void cronTest1(){
        try {
            System.out.println("value:"+value);
        } catch (Exception e) {      
            e.printStackTrace();
        }
    }
}
~~~


---
##### cron 양식

<b>초 분 시 일 월 년도</b>
```
* : 항상/모두를 의미
초 : 0-59, - *
분 : 0-59, - * /
시 : 0-23, - * /  
일 : 1-31, - * ? / L W
월 : 1-12 or JAN-DEC, - * /
요일 : 1-7, SUN-SAT, - * ? / L #
(옵션) 년 : 1970-2099, - / *
    ? : 특정 값 없음
    - : 범위 지정에 사용
    , : 여러 갑 지정 구분에 사용
    / : 초기값과 증가치 설정에 사용
    L : 지정할 수 있는 범위의 마지막 값
    W : 월~금요일 또는 가장 가까운 월/금요일
    # : 몇번째 무슨 요일 2#1 > 첫번째 월요일
```

##### 자주 사용하는 cron 식

0 0 12 * * * : 매일 12시 실행
0 0-5 14 * * * : 매일 14시 0,1,2,3,4,5분에 실행
0 0/5 14 * * * : 매일 14시에 5분간격으로 실행
0 15 10 ? * 6L : 매월 마지막 금요일 아무날이나 10시 15분에 실행
* /1 * * * * : 매 1분마다 실행
