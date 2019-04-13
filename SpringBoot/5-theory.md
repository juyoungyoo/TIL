https://docs.spring.io/spring-boot/docs/current/reference/html/executable-jar.html

과거 ‘uber’ jar 사용할 때는 모든 클래스(의존성,애플리케이션)를 하나로 압축하여 jar 파일로 만듬

단점
	* 무슨 라이브러리를 사용하는지 알 수 없다.

Spring Boot 전략
내장 JAR를 사용한다. 
애플리케이션과  library 위치를 구분하여 만든다. 그리고 자바에서는 내장 JAR를 로딩하는 표준적인 방법이 없기때문에 JAR파일을 읽는 loader를 만들어서 내장 JAR 파일을 읽어낸다.

```
내장 JAR 파일 읽는 파일 : org.springframework.boot.loader.jar.JarFile
Main class 실행하는 파일 : org.springframework.boot.loader.Launcher

// jarLauncher, propertiesLoauncher 등 메인 클래스를 실행하는 방법은 다양하다.
```

