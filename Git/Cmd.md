Git
- VCS : Version control system
- 형상관리 시스템

---
## 기본 명령어

commit
branch
checkout
cherry-pick
reset
revert
rebase
merge

---
### branch
> 특정 커밋에 대한 참조(reference)이다.
하나의 커밋과 그 부모 커밋들을 포함하는 작업 내역

__branch 생성__
`git branch <branch name>`

__특정 branch로 이동__
`git checkout <branch name>`

__브랜치 합치기 2가지__
1. __Merge__
두 개의 부모(parent)를 합친 커밋을 만든다. 두개의 부모가 있는 커밋이라는 것은 "한 부모의 모든 작업내역과 나머지 부모의 모든 작업, 그리고 그 두 부모의 모든 부모들의 작업내역을 포함한다"
`git merge <merge 할 branch name>`
2. __Rebase__
커밋을 모아 복사한 후 다른 곳으로 이동시킨다.
rebase를 하면, 커밋의 흐름을 `한줄`로 보기좋게 만들 수 있다.

---
### Commit tree 원하는 데로 이동하는 방법
__HEAD__
- 현재 작업 중인 커밋 == 현재 체크아웃된 커밋
- 일반적으로 HEAD는 브랜치의 이름을 가르키고 있다.
ex) master를 가르키고 있음.
커밋을 하게되면 master의 상태가 변경이되고 이 변경은 HEAD를 통해 확인 가능하다.
즉, HEAD -> master(branch) -> commit hashcode를 가르키는 형태를 뜻한다.
```
$git checkout <commit_hashcode> // commit 한 위치로 이동한다
```
__상대참조__
커밋의 해시로 이동하기 귀찮다면, 상대참조를 이용하자. 상대 커밋하는 방법은 2가지가 있다.
1. __캐럿(^)__ : 현위치에서 한 커밋 위로(전으로) 이동한다
2. __틸드(~<num>)__ : 현 위치에서 여러 커밋(num) 위로 올라간다.

사용 예
```
$git checkout master^   // master 위에 있는 커밋으로 이동(체크아웃)
$git checkout master^^  // 개수는 상관없다 (하지만 귀찮다. 그럴때 ~<num>)
$git checkout HEAD~4    // HEAD기준으로 4개 커밋 이전 위치로 이동한다.
```

---
### Git에서 작업 되돌리기 (Reset, Revert)
이전 커밋 내용으로 돌아간다.
__Reset__
- 이전 커밋으로 돌아간다. 로컬 브랜치의 히스토리를 고쳐쓸 때 주로 사용한다.
- 애초에 커밋을 하지 않은 것 처럼 돌아갈 때 이전 커밋 내역을 지운다.
```
$git reset HEAD^ // 현 위치에서 이전 커밋으로 돌아간다 (전에 한 커밋은 사라지게 된다.)
```
__Revert__
- reset은 로컬 커밋은 수정이 가능하나, 다른 사람과 작업하는 remote branch에서는 사용이 불가능하다. 이런 경우에 사용되는 것이 revert!! 변경하고 되돌린 내용을 다른 사람과 공유할 수 있다. (revert시 변경된 커밋이 새로 생긴다)
```
$git revert <commit1>
```

---
### 작업을 여기저기 옮기기
현재 위치에 있는 일련의 커밋에 복사본을 만들때 사용
단, 복사할 작업의 커밋이 무엇인지 알아야 사용이 가능하다
```
$git cherry-pick <Commit1> <Commit2> <...>
```
만약, 복사할 작업이 생각이 나지 않는 경우에는?
`Git 인터렉티브 리베이스(Interactive Rebase)`를 사용하면 된다.
인터렉티브 리베이스는 `git rebase -i`을 말하는데, 베이스의 목적지가 되는 곳에 복사될 커밋들을 vim으로 보여준다.
인터렉티브 리베이스에서 우리는 3가지를 할 수 있다.
1. 적용할 커밋들의 순서 변경 가능
2. 원하지 않는 커밋 삭제 (pick)
3. 커밋 스쿼시(squash) 가능 (스쿼시: 커밋을 합친다.)

사용 예
```
$git rebase -i HEAD~4 // 현 위치 이전 4개의 커밋을 가져와 vim으로 보여준다
```
---
### 원격 저장소(remote)
로컬 저장소 아닌, github 으로 모든 사람들이 볼 수 있는 원격 저장소이다.

`git clone` : 원격 저장소에 있는 소스를 로컬로 복사할 수 있다.

원격 저장소의 브랜치는 로컬에 비해 특이한 이름을 갖는다. (ex) origin/master)
`<remote name>/<branch name>`로 원격 브랜치는 규약을 갖는다.
이는 원격 저장소에 액션을 취할 때만 변경이 된다.

`git fetch` :
원격 저장소에는 있지만 로컬에는 없는 커밋들을 다운로드 받는다. 
우리의 원격 브랜치가 가리키는 곳을 업데이트합니다
git fetch는 본질적으로 로컬에서 나타내는 원격 저장소의 상태를 실제 원격 저장소의 (지금)상태와 동기화합니다.

이제 우리의 작업을 업데이트해서 변경들을 반영하는 방법 3가지
1. `git cherry-pick origin/master`
2. `git rebase origin/master`
3. `git merge origin/master`

`git pull` : git fetch + git merge 명령어를 합친 것과 같다.
`git pull --rebase`
`git rebase <복사위치 브랜치> <작업한 branch>`로도 가능
`git rebase <복사위치 브랜치>` : 현 브랜치의 작업 내용(커밋)을 복사하여 `<복사위치 브랜치>`로 이동한다.


---
### Git 커맨드 연습 및 이해하기 좋은 사이트
https://learngitbranching.js.org/
