
### 단위 테스트 (update)

##### Junit  
 java 5 annotaion 지원
- @BeforeClass : 처음으로 한번만 실행  // DB 드라이버 로딩 정보
- @AfterClass : 마지막으로 실행            // DB 해제
- @Before : 매 테스트케이스 실행 전     //DB 로그인 정보
- @after : 매 테스트 케이스 실행 후      // DB 로그인 정보 해제
- @Test(timeout=1000) : 시간 제한
- @Test(excepted=NmberFormatException.class) : 예외 테스트 지원
` 테스트 클래스 명 : 테스트 대상 클래스 이름 + Test `

##### 테스트 더블
: 테스트시에 의존하는 컴포넌트를 대신하는 객체를 의미 (Stub, Mock, Spy)
- 테스트 대상 컴포넌트(SUT)가 의존하는 컴포넌트를 테스트 환경에 맞는 컴포넌트로 대체하는것
- 테스트 시점에 테스트 더블을 생성해서 SUT에 주입
- 테스트 더블은 테스트 환경 내에서 의존 컴포넌트와 동일하게 동작하도록 구성
- Interface를 통한 주입으로 테스트 컴포넌트와의 연결을 소스변경없이 runtme환경에서도 실행

##### Mock
- 의존 관계가 깊어질수록 많은 테스트 환경이 필요하게 되는데, mock은 의존관계를 덜어준다.
###### Mockito : 자바 단위테스트에서 가짜 객체를 지원해주는 프레임워크
1. mock 객체 생성
주입방식은 Constructor, Setter parameter Injection 2가지를 사용
```
@Test
public void findProjectListByMock(){
    ProjectEntity mock = mock(ProjectEntity.class);    // mock객체 생성
    userProcess.setProjectEntity(mock);                    // 가상객체를 주입
}
```
2. Stub 만들기
- When 메소드를 통해 하나의 메소드가 호출되었을 때 임의 값을 반환하라고 설정
- 메소드 파라미터 값까지 지정하고, 호출 지점에서 지정한 파라미터까지 동일해야 지정한 임의 값을 반환
```
@Testpublic void findProjectListByMock() {
  //1. 가상객체(목객체)를 생성
  ProjectEntity mock = mock(ProjectEntity.class);
  userProcess.setProjectEntity(mock);
  //2. 결과값(예상값)을 녹화
  List<String> projects = new ArrayList<>(); //가짜 객체에서 반환 할 값 생성
  projects.add("정보원 프로젝트");
  projects.add("직능원 프로젝트");
  projects.add("인천공항 프로젝트");

  when(mock.findProjectList("hjkwon")).thenReturn(projects); //(stub) 가짜 객체에서 frndProjectList메소드의 파라미터로 ‘hjkwon’이 호출되면 위에저 지정한 값을 반환 하라고 설정
  List<String> projectList = userProcess.findProjectList("hjkwon"); //Stub으로 지정 한 값 리턴 받음

  assertNotNull(projectList);
  assertEquals(3, projectList.size());

  verify(mock, times(1)).findProjectList("hjkwon");}
```
