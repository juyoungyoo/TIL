# 3.Gradle로 jar파일 로컬 저장소에 설치 후 다른 프로젝트에서 사용하는 방법
[참고](https://spring.io/guides/gs/gradle)

1. 로컬 저장소에 저장 할 파일을 jar파일로 만든다.
gradle : grade install (maven : maven install)
~~~
// build.gradle
apply plugin: "maven"
group = "juyoung"
version = “1.0”
~~~
###### Maven project (참고)
~~~XML
<groupId>juyoung</groupId>
<artifactId>juyoung-spring-boot-starter</artifactId>
<version>1.0</version>
~~~

2. 사용하려는 프로젝트에서 로컬저장소와 의존성을 build.gradle 파일에서 추가해줍니다.
~~~
// build.gradle
repositories {
    mavenCentral()      // maven 중앙 리포지토리를 연결한다. (http://repo1.maven.org/maven2)
    mavenLocal()        // 로컬 캐시 저장소

		// 번외 : 사용자가 직접 리포지토리를 만들어 사용 가능
    maven {
        url "http://repo.mycompany.com/maven2"
    }
}
dependencies {
    compile "juyoung:sdk:1.0”		// gradle jar file
    compile “juyoung:juyoung-spring-boot-starter:1.0"	// maven jar file
}
~~~
> setting.xml이 존재하면 이에 따라 로컬 리토지토리를 판단한다.
> - $USER_HOME/.m2/repository 기본값
> - $USER_HOME/.m2/settings.xml 우선
> - $M2_HOME/conf/settings.xml 차선

3.Gradle을 다시 빌드해준다.
~~~
$gradle build
~~~

참고 :http://kwonnam.pe.kr/wiki/gradle/dependencies
