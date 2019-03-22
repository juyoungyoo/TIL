### 설정과 초기화
```
// 전역 사용자명/이메일 구성
$git config --global user.name "juyoung"
$git config --global user.email "juy5790@outlook.com"

// 저장소 복제
$git clone <URL>

// 새로운 원격 저장소 추가
$git remote add <원격 저장소> <저장소URL>
```

### git 자주쓰는 명령어
* git log                       // commit 목록 확인
* git add .                    // 파일 전체 Stage 상태
* git commit -m "msg"  // commit
* git push
* git pull
* git fetch
* git checkout <branch>
* git merge


### git add 취소 ( 파일 상태 Unstage )
```
$git add .      // 모든 파일 Staged 상태
$git status    // git 파일 상태

// git add 취소방법
$git reset HEAD [file]     
```

### git commit 취소
방법 1.  commit 취소, 해당 파일 staged 상태 ( 모두 보존)    
```
$git reset --soft HEAD^
```
방법 2.  commit 취소, 해당 파일 unstaged 상태 (파일 보존)   
```   
(default) $git reset --mixed HEAD^  
= $git reset HEAD^
= $git reset HEAD~2    // 마지막 2개의 commit cancel
```   
방법 3. commit 취소, 해당 파일 unstaged 상태로 디렉터리에서 삭제 (전체 취소)   
hard 명령어 사용 시 원격 저장소에 있는 마지막 commit 이후의 디렉터리와 add했던 파일이 전부 삭제됨으로 주의! ( 작업했던 파일 전체 다 사라진다. )   
```
$git reset --hard HEAD^
```

### git push 취소
* 이 명령어 사용 시 local 내용을 remote에 강제로 override 하는 것임으로 신중히 사용하자
* 되돌아간 commit 이후의 모든 commit 정보가 삭제된다.
1. 워킹 디렉터리에서 commit 되돌린다.
방법1. 가장 최근 commit 취소 후, 워킹 디렉터리를 되돌린다.    
```
 // 가장 최근의 commit 취소
$git reset HEAD^
```
방법2. 원하는 시점으로 워킹 디렉터리 return
```
$git log - g   // 전체 목록 확인

// 원하는 시점으로 디렉터리 return
$git reset HEAD@{number}
= git reset [commit id]
```
2. 되돌아간 상태에서 다시 commit
```
$git commit -m "write commit message"
```
3. 원격 저장소에 강제로 push
```
$git push origin [branch name] -f //  -force
= $git push origin +[branch name]  //  +[brance name] : 해당 branch를 강제로 push
```

### untracked 파일 삭제 (git clean)
.gitignore에 명시한 파일은 삭제되지 않는다.
```
$git clean -f       // 디렉터리를 제외한 파일만 삭제
$git clean -f -d    // 디렉터리, 파일삭제
$git clean -f -d -x // gitignore에 명시한 무시된 파일까지 삭제

[ option ]
-n : 가상으로 실행해보고 어떤 파일이 삭제될지 알려주는 옵션
```

### commit message 변경 (git commit -amend)

참고 : https://gmlwjd9405.github.io/2018/05/25/git-add-cancle.html



