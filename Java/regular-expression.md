## 정규식 표현(Regular expression)

### Character class
>문자의 집합이나 범위를 나타내며, 두 문자 사이는 `-` 기호로 범위를 나타낸다.
[ ]내에서 `^`가 선행하여 존재하면 not 을 나타낸다.
`|`는 패턴 안에서 or 연산으로 사용
`*`는 앞 문자가 없거나 많을 수 있다.
`+` 앞문자 하나 이상
`?` 앞문자가 없거나 하나있다.


- character set
  - [ABC]
  - [ ]안의 문자만 사용
  - ex) [snfksl]
- negated set
  - [^ABC]
  - [ ]안의 문자는 사용하지 않는다.
  - [^snfksl]
- range
  - [a-z]
  - 범위
  - ex) [a-zA-Z]
- dot
  - .
  - 임의의 문자 [‘'는 제외]
  - ex) [^\n]. : 줄바꿈 제외하고 모두 가능
- word
  - \w
  - 알파벳(소문자,대문자),숫자, 언더스코어`_` 지원
  - == [a-zA-Z0-9_]
- not word
  - \W
  - 알파벳, 언더스코어`_`가 아니다
  - == [^A-Za-z0-9]
- digit
  - \d
  - 한 자릿수
  - == [0-9]
  - != ([^0-9] or \D)
- whitespace
  - \s
  - spaces, tabs, line breaks
  - != \S

----
### Anchors (고정시키다)
- beginning
  - ^
  - 문자열 시작
  - ex) ^\w+ : word로 시작해야한다 (+는 한글자)
- end
  - $
  - 문자열 종료
  - ex) \w+$ : word로 끝난다.
- word boundary

### Escaped character
- null : \0
- tab : \t
- 특수문자 백슬래쉬(\) 확장문자: \+ \/ \[ \.

### Groups & Reference
- group
  - (ABC)
  - 소괄호 안의 문자를 하나의 문자로 인식
  - ex) (ha)+ : ha 하나이상
-non-capturing group
  - (?:ABC)
  - 해당 그룹 없어도 무관하다
  - ex) (?:ha)+
- positive lookhead
  - (?=ABC)
  - ex) \d(?=px)
- negative lookhead
  - (?!ABC)
  - ex) \d(?!px)


[정규표현식(Pattern Matching) 완전 정리!](https://highcode.tistory.com/6)
[정규식 작성하기 좋은 사이트](https://regexr.com/)
