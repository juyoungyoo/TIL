# 다국어 적용

## 주요파일
- 스크립트에서 사용 세팅 : jQuery.i18n.properties
- 스프링 세팅
  - message-context.xml
  - message_언어코드.properties ex) messages_en.properties, messages_ko.properties

## Spring setting
1. message-context.xml 파일 만들기
2. web.xml 에 message-context.xml 파일 로딩하도록 수정
3. servlet-context.xml 인터셉터 추가
```xml
* message-context.xml
<bean id="messageSource" class="org.springframework.context.support.ReloadableResourceBundleMessageSource">
    <property name="basenames">
        <list>
            <!-- 메세지 파일의 위치를 지정합니다. message_언어.properties 파일을 찾습니다. -->
            <value>/WEB-INF/messages/messages</value>
        </list>
    </property>

    <!-- 파일의 기본 인코딩을 지정합니다. -->
    <property name="defaultEncoding" value="UTF-8" />

    <!-- properties 파일이 변경되었는지 확인하는 주기를 지정합니다. 60초 간격으로 지정했습니다. -->
    <property name="cacheSeconds" value="60" />
</bean>

<!-- 언어 정보를 세션에 저장하여 사용합니다. -->
<bean id="localeResolver" class="org.springframework.web.servlet.i18n.SessionLocaleResolver" />
```
* messageSource
  - basenames : 경로/파일명앞부분까지 적어준다
* localResolver : header 정보 사용가능, 쿠키, 세션 저장하여 사용 가능 (방법 3가지)
  - AceeptHeaderLocaleResolver (default): 브라우저의 설정된 언어값으로 읽어들여 처리  (변경불가)
  - SessionLocaleresolver : session으로 부터 locale정보 가져온다. default값 지정가능 (defaultLocale 이용)
  - CookieLocaleResolver : 쿠키에 값을 저장
```xml
  ex) 쿠키 사용 예시
  <beans:bean id="localeResolver"
      class="org.springframework.web.servlet.i18n.CookieLocaleResolver" >    
      <beans:property name="cookieName" value="clientlanguage"/>   // 저장할 쿠키명 (default : classname + locale)
      <beans:property name="cookieMaxAge" value="100000"/>         // default -1 : 브라우저를 닫으면 지움
      <beans:property name="cookiePath" value="web/cookie"/>       // default / : 경로지정가능
  </beans:bean>
```
```xml
* web.xml
<context-param>
  <param-name>contextConfigLocation</param-name>
  <param-value>
    /WEB-INF/spring/root-context.xml
    /WEB-INF/spring/message-context.xml
  </param-value>
</context-param>
```
```xml
* servlet-context.xml
<interceptors>
    <beans:bean id="localeChangeInterceptor" class="org.springframework.web.servlet.i18n.LocaleChangeInterceptor">
        <beans:property name="paramName" value="lang" />
    </beans:bean>
</interceptors>
```

1. Controller에서 사용방법
```java
@Autowired SessionLocalResolver localeResolver;
@Autowired MessageSource messageSource;
@RequestMapping(value = "/i18n.do", method = RequestMethod.GET)
public String i18n(Locale locale, HttpServletRequest request, Model model) {

// RequestMapingHandler로 부터 받은 Locale 객체를 출력해 봅니다.
logger.info("Welcome i18n! The client locale is {}.", locale);

// localeResolver 로부터 Locale 을 출력해 봅니다.
logger.info("Session locale is {}.", localeResolver.resolveLocale(request));

logger.info("site.title : {}", messageSource.getMessage("site.title", null, "default text", locale));
logger.info("site.count : {}", messageSource.getMessage("site.count", new String[] {"첫번째"}, "default text", locale));
logger.info("not.exist : {}", messageSource.getMessage("not.exist", null, "default text", locale));
//logger.info("not.exist 기본값 없음 : {}", messageSource.getMessage("not.exist", null, locale));

// JSP 페이지에서 EL 을 사용해서 arguments 를 넣을 수 있도록 값을 보낸다.

model.addAttribute("siteCount", messageSource.getMessage("msg.first", null, locale));

return "i18n";
```

2. Controller에서 사용방법 (Utils)
```java
@Component
public class MessageUtils implements ApplicationContextAware {

    private static ApplicationContext context;
    private static MessageSource resources;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        if (context == null) {
            this.context = applicationContext;
            this.resources= context.getBean(MessageSource.class); // 설정된 bean 불러오기
        }
        else {
            throw new IllegalStateException("The application context provider was already initialized.");
        }
    }
    // 파라미터 없는 경우 default
    public static String getMessage(String code){
        return resources.getMessage(code, null, LocaleContextHolder.getLocale()); // LocaleContextHolder.getLocale : 스프링에 설정되어 있는 Locale의 값에 맞게 메세지 출력
    }
    // 파라미터 있는 경우
    public static String getMessage(String code, String[] args){
        return resources.getMessage(code, args, LocaleContextHolder.getLocale());
    }
}
```

3. JSP 사용방법
```html

<a href="<c:url value="/i18n.do?lang=ko" />">한국어</a>
<a href="<c:url value="/i18n.do?lang=en" />">English</a>

<p>site.title : <spring:message code="site.title" text="default text" /></p>
<p>site.count : <spring:message code="site.count" arguments="첫번째" text="default text" /></p>
<p>site.count using EL : <spring:message code="site.count" arguments="${siteCount}" text="default text" /></p>

	1. site.title : default
	2. site.count : paramter있을 경우
	3. site.countusging EL : el 사용

```
4. Javascript 사용방법
- jquery-i18n.properties.js 사용
```Javascript
<script src="/lms/resources/plugins/jquery-i18n-properties/jquery.i18n.properties.js"></script>
// MESSAGE CONNECT
    var self = this;
    this.setLanguage = function (language) {
        $.i18n.properties({
            name: 'messages',
            path: '/lms/messages/', //  messages_*.properties 경로에 맞게 지정 ( resource mappging 설정, interceptor 확인)
            mode: 'map',
            language: language,
            callback: function () {
                self.language = language;
//                $.i18n.prop("alert.success");    // 사용방법 1
//               alert($.i18n.prop("alert.fail", data.RESULT_CODE, data.RESULT_MSG)));    
                /** 사용방법2 Param
                * ex) messages_ko.properties
                * alert.fail = 실패하였습니다.<br/> CODE : {0}, MSG : {1}
                            */
//                console.log($.i18n.prop("alert.success"));
            }
        });
    };
    this.setLanguage('${pageContext.response.locale}');
```
