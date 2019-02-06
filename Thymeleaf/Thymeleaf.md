### Thymeleaf (타임리프)
- 타임리프는 text-template-engine 이다.
- spring boot + thymeleaf + mvc를 많이 사용 ( spring boot 추후 학습 필요 )

##### 장점
- 코드 간결화
- 많은 util 사용가능
- layout 으로 디자인과 분리 및 중복 코드르 줄일 수 있다.

##### 단점
- onclick, href 에서 값을 넘기기 어려움

###### 참고 파일
  - pom.xml
  - servlet-context.xml
	- TymeleafController
  - messages.properties
  - template folder

#### 설정
pom.xml
```
<!-- thymeleaf -->
<dependency>
<groupId>org.thymeleaf</groupId>
<artifactId>thymeleaf-spring4</artifactId>
<version>3.0.7.RELEASE</version>
<scope>compile</scope>
</dependency>
<dependency>
<groupId>org.thymeleaf</groupId>
<artifactId>thymeleaf</artifactId>
<version>3.0.7.RELEASE</version>
<scope>compile</scope>
</dependency>
<!-- thymeleaf :: layout-->
<dependency>
<groupId>nz.net.ultraq.thymeleaf</groupId>
<artifactId>thymeleaf-layout-dialect</artifactId>
<version>2.0.5</version>
</dependency>
<!-- /thymeleaf :: layout-->
<!-- /thymeleaf -->
```

servlet-context.xml
```
<!-- **************************************************************** -->
<!-- THYMELEAF-SPECIFIC ARTIFACTS -->
<!-- TemplateResolver <- TemplateEngine <- ViewResolver -->
<!-- **************************************************************** -->
<!-- thymeleaf view 설정 -->
<beans:bean id ="templateResolver" class="org.thymeleaf.spring4.templateresolver.SpringResourceTemplateResolver">
<beans:property name="prefix" value="/WEB-INF/views/template/"/> <!-- HTML 파일위치 -->
<beans:property name="suffix" value=".html" /> <!--HTML 확장명 사용-->
<beans:property name="templateMode" value="HTML5"/> <!-- ? HTML5 값은 비권장 됨 ( TemplateMode.HTML )-->
<beans:property name="characterEncoding" value="UTF-8" /> <!-- 한글 깨짐 방지 -->
<beans:property name="cacheable" value="false" /> <!--캐시 사용안함 : true : html 수정 시 서버 재기동 필요 -->
</beans:bean>
<!--thymeleaf layout을 사용하기 위한 3rd party 추가-->
<beans:bean id="templateEngine" class="org.thymeleaf.spring4.SpringTemplateEngine">
<beans:property name="templateResolver" ref="templateResolver" />
<beans:property name="additionalDialects">
<beans:set>
<beans:bean class="nz.net.ultraq.thymeleaf.LayoutDialect"/>
</beans:set>
</beans:property>
</beans:bean>

<!--thymeleaf layout viewresolver 설정-->
<beans:bean class="org.thymeleaf.spring4.view.ThymeleafViewResolver">
<beans:property name="characterEncoding" value="UTF-8" /> <!-- 한글 깨짐 방지 -->
<beans:property name="templateEngine" ref="templateEngine" />
<beans:property name="order" value="3" />
</beans:bean>

------------------------------------------------------------------------------------------------------

*프로퍼티 설정 ( property 파일명 고정 )
<!-- **************************************************************** -->
<!-- MESSAGE EXTERNALIZATION/INTERNATIONALIZATION -->
<!-- Standard Spring MessageSource implementation -->
<!-- messages_ko_US. :: propertiy 변수 및 class, thymeleaf expression 설정 -->
<!-- messages.properties, messages_en_US.properties, messages_pl_PL.properties : locale indicator : 각 언어에 맞게 변경 가능-->
<!-- **************************************************************** -->
<beans:bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
<beans:property name="basename" value="properties.messages" />
<beans:property name="defaultEncoding" value="UTF-8"/>
</beans:bean>
```

#### 기본 문법
- <html xmlns:th="http://www.thymeleaf.org";xmlns:layout="http://www.ultraq.net.nz/thymeleaf/layout";> 필수!
- 입력 방법 2가지
  `<div th:text="____"></div>`
  `th:inline="text" 태그 사용  ( [[ ____ ]] )`
```
			* ${ .. }  : 기본 값
			* #{ .. } :  util method 사용, 또는 properties 파일의 값 or util 사용
			* *{ .. } : th:object 사용 시 선언된 값을 편리하게 사용 가능
```
```
예1) for (each) 문 사용
<select name="ST_CODE" id="ST_CODE" class="form-control input-sm wdauto">     
<option value="">개발상황</option>     
<option th:each = "prod:${stateList}"
        th:value="${prod.get('detail_code')}"
        th:text="${prod.get('code_val')}"/>
</select>
```
```
예2) th:text 사용
  <td th:text="${vo.project_short_name}"/>
  <td th:text="${vo.state}"/>
  <td th:text="${#dates.format(vo.regdate, 'YYYY-MM-dd HH:mm:ss')}"/>
```
```
예3) th:inline="text", object 사용
  <h2>Session </h2>
  <dl th:object="${session.login}">
    <dt>session map : [[${session.login}]]</dt>
    <dt>userid : [[*{userid}]]</dt>
    <dt>name : [[*{name}]]</dt>
  </dl>
```

##### javascript 에서 사용방법
```javascript
<script th:inline="javascript">
  // script 태그에 th:inline="javascript" 속성 정의하면 포함된 스크립트에서 [[ .. ]] 표현식으로 서버 데이터를 스크립트 영역에 표현 가능
  /*<![CDATA[*/
  var username = /*[[${session.user.name}]]*/ 'chloe';
  // thymeleaf 처리 결과 : 주석 뒤 모든 코드('chloe') 가 삭제되고 session.user.name 값만을 가져온다.
  // 유용하게 사용 됨 : String, beans, maps, collections, arrays 등

  var user = /*[[${session.user}]*/ null;
  // 결과 : var user = { 'userid' : 'chloe', ..};
  /*[-*/
  var remove = '삭제하고 싶은 변수';
  /*-]*/
  /* [+ */
  var add = ' 추가하고 싶은 변수 ';
  /* +] */
  /*]]>*/
</script>
```
##### onclick, href  
```html
<a class="btn btn-primary pull-right mgr2p" th:href="@{/param(param1='value1',listparam=${list[0]})}"> GET 이동</a>
<a class="btn btn-default pull-right mgr2p" th:href="@{/first}"> TEST page 이동</a>
<a class="btn btn-default pull-right mgr2p" th:onclick ="${'onclickFn(sdf);'}">onclick 사용법</a>
```
##### layout
```
- fragment, replace, include, insert ..
* fragment로 조각(파트)를 나눔
<header th:fragment="mainFragment"></header>
*replace, include, insert로 불러오기
<head th:replace = "fragments/config :: configFragment"/>

layout 페이지 만든 후 적용 : layout:decorator="layout/default"
참고 페이지fragment/cofig, header, footer.htmllayout/default.htmlfirst.html
```

###### 참고
[thymeleaf 영문 api](https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#difference-between-thinsert-and-threplace-and-thinclude)
[thymeleaf dialect 영문 api](http://www.thymeleaf.org/doc/tutorials/3.0/thymeleafspring.html#the-springstandard-dialect)
