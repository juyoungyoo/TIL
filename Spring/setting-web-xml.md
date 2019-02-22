
##### web.xml
* Deployment Descriptor (배포 서술자) 라고하며 tomcat의 DD는 web.xml 로 환경설정 부분을 담당함
* Deployment Descriptor
- DD는 java EE 스펙으로 웹 애플리케이션의 기본설정을 위해 작성하는 파일
- 보통 WEB-INF/web.xml
- 이외에도 EJB를 위한 ejb-jar.xml / 웹서비스 webservices.xml 등이 있다
- JSP와 서블릿만으로 구성된 경우 WEB.XML파일만 사용하면 된다



* 장점
1. 작성한 소스코드를 수정하지 않고 웹 애플리케이션을 '커스터마이징' 할 수 있다
2. 이미 테스트 된 소스코드의 수정을 최소화 한다.
3. 소스코드가 없어도 수정 가능
4. 재 컴파일 하지 않고 서버의 자원 변경가능
5. 접근제한, 보안, 오류페이지 설정하고 초기화 값의 구성등이 가능

WEB.XML의 구조 및 설정
1. web-app
- <web-app> 태그는 web.xml의 루트 엘리먼트
- 모든 웹 애플리케이션 설정은 <web-app></web-app> 태그 사이에 위치
```
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://java.sun.com/xml/ns/javaee"
xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd" id="WebApp_ID" version="3.0">
```
2. display-name
- DD파일의 title 이라 생각하면됨
- 기본적인 프로젝트명으로 설정되며 수정가능
```
<display-name>webStudy</display-name>
```
3. description
- 어떤 프로젝트를 윈한 배포서술자인지 상세히 기록
```
<description>webStudy sample project</description>
```
4. ContextLoaderListener
- spring MVC는 web.xml - dispather.xml로 1개 이상의 스프링 설정 정보를 읽을 수 있다.
- 한개만 사용 시 : dispatcher에 지정
- 2개 이상일 경우 contextConfigLocation 초기화 파라미터에 설정파일 목록 지정
```
<listener>
<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
<context-param>
     <param-name>contextConfigLocation</param-name>
     <param-value>
          /WEB-INF/spring/application-context.xml
          /WEB-INF/spring/application-context-security.xml
     </param-value>
</context-param>
```
5. servlet
- DispatcherServlet 클래스 초기화 하여 spring의 servlet context 생성
- 초기화 param으로 bean 메타설정 파일의 위치 넘겨준다
- servlet-mapping은 url pattern으로 지정된 값으로 웹 요청이 들어왔을때 servlet-name에 지정되어 있는 이름의 servlet 호출하겠다는 의미
- spring에서는 dispatcherservlet이 모든 요청을 받고, 요청의 url과 맵핑하는 controller에 전달
ex) controller class에 @requestmapping("/list") annotation으로 지정되어 있는 method가 존재한다면 http://localhost:8080/list.do 요청 시 dispatcherservlet이 해당하는 url과 ampping되는 정보를 찾은 후 연결되는 method에 요청을 전달
```
servlet>
<servlet-name>dispatcher</servlet-name>
<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
<init-param>
<param-name>contextConfigLocation</param-name>
<param-value>/WEB-INF/spring/dispatcher-servlet.xml</param-value>
</init-param>
<load-on-startup>1</load-on-startup> // servlet 최초 요청시 우선순위 지정옵션
</servlet>

<servlet-mapping>
<servlet-name>dispatcher</servlet-name>
<url-pattern>*.do</url-pattern>
</servlet-mapping>
```
  - <url-pattern>/</url-pattern> : 모든 url 요청 전송

6. filter
- 웹 애플리케이션 전반에 걸쳐 특정 url이나, 파일 요청 시 먼저 로딩되어 사전에 처리할 작업을 수행(필터링)하고 해당 요청을 처리하는 웹 애플리케이션 유형중 하나이다.
- <filter-mapping> 에서는 해당 필터를 적용할 URL 패턴이나 Servlet 등록한다.
```
<filter>
<filter-name>encodingFilter</filter-name>
<filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
<init-param>
<param-name>encoding</param-name>
<param-value>UTF-8</param-value>
</init-param>
</filter>

<filter-mapping>
<filter-name>encodingFilter</filter-name>
<url-pattern>/＊</url-pattern>
</filter-mapping>
```
7. session-config : 세션설정
```
<session-config>
<session-timeout>30</session-timeout>
</session-config>
```
8. error-page
- 각 error-code별 페이지 설정
```
<error-page>
<error-code>401</error-code>
     <location>/resources/commons/error/serverError.jsp</location>
</error-page>

<error-page>
     <error-code>403</error-code>
     <location>/resources/commons/error/serverError.jsp</location>
</error-page>

<error-page>
    <error-code>404</error-code>
    <location>/resources/commons/error/notFound.jsp</location>
</error-page>

<error-page>

<error-code>500</error-code>
<location>/resources/commons/error/serverError.jsp</location>
</error-page>
```
9. welcome-file-list
- 웹 애플리케이션 요청 시 시작파일을 지정한다.
```
<welcome-file-list>
<welcome-file>index.html</welcome-file>
<welcome-file>index.jsp</welcome-file>
<welcome-file-list>
```
10. ContextLoaderListener
- 서블릿에서 제공하는 SErvletContextListener 확장하여 만든것으로 웹 어플리케이션이 서블릿 컨테이너에 로딩될 때 실행되는 리스너
- 웹 어플리케이션이 로딩될 때 WEbapplicationContext를 생성함. 생성한 WebapplicationContext는 contextConfigLocation에 설정한 bean 설정 파일을 사용하여 웹 어플리케이션에서 사용할 객체를 관리해 주는 역할을 한다
- ContextLoaderListener : 어플리케이션 전체에 사용할 WAC를 만들고, DispatcherServlet 해당 서블릿에서만 사용할 MAC만든다.
-WebApplicationContext는 상속구조를 가진다

자식 WAC에서 부모 WAC의 빈을 참조할 수 있다.   
부모 WAC에서는 자식 WAC의 빈을 참조할 수 없다.    
자식 WAC에서 어떤 빈을 참조할 때, 먼저 자기 자신 내부에 있는 빈을 참조한다. 만약 자기 자신 내부에 없다면 부조 쪽에서 찾아보고,    
부모쪽에도 원하는 빈이 없다면 예외를 발생시킨다. 그래서 보통 WAC(CLL)과 WAC(DS)로 다음과 같이 빈을 나눠서 관리합니다.    
WAC(CLL) : 웹에 종속적이지 않은 빈 ex) 서비스, DAO   
WAC(DS) : 웹에 종속적인 빈 ex) 컨트롤러, 스프링, MVC관련 빈    
