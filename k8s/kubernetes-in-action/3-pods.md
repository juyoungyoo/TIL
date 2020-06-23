1.	파드: 쿠버네티스에서 컨테이너 실행 =====================================

> -	파드 생성, 실행, 정지
> -	파드와 다른 리소스르 `레이블`로 그룹화
> -	특정 레이블을 가진 파드에 작업 수행
> -	네임 스페이스를 사용하여 파드 겹치지 않도록 그룹으로 나누기
> -	특정한 형식을 가진 워커 노드에 파드 배치

### 1. 파드 소개

함께 배치된 컨테이너 그룹이다.  
쿠버네티스의 기본 빌딩 블록이다.  
파드 내에는 1개 이상의 컨테이너를 가질 수 있다.  
일반적으로는 파드는 하나의 컨테이너를 포함한다.  
모든 컨테이너는 항상 하나의 워커 노드에 실행되며, 여러 워커를 걸쳐 실행되지 않는다. (EC2 instance와 유사하게 동작한다)

### 1.1 파드의 필요한 이유

```
컨테이너를 직접 사용하지 않는 이유
여러 컨테이너를 한번에 실행해야 하는 이유
모든 프로세스를 단일 컨테이너에 넣을 수 없는가?
```

**여러 프로세스를 실행하는 단일 컨테이너보다 다중 컨테이너가 나은 이유** 컨테이너는 단일 프로세스를 실행하는 것을 목적으로 설계했다.  
단일 컨테이너에서 여러 프로세스를 실행하고 로그를 관리하는 것은 모두 사용자의 책임이다.  
단일 컨테이너에서 관련 없는 다른 프로세스를 실행할 경우 모든 프로세스를 동일한 표준 출력으로 로그를 기록하여 어떤 프로세스가 남긴 로그인지 파악하기 매우 어렵다.

*각 프로세스를 개별 컨테이너로 실행하자*

### 1.2 파드 이해하기

여러 프로세스를 단일 컨테이너로 묶지 않는다. 이에 컨테이너를 묶어 관리 할 수 있는 다른 상위 구조가 필요하다. -> 파드  
파드를 이용하여 격리된 환경에서 **연관된 프로세스를 함께 실행하여 단일 컨테이너 안에서 함께 실행하는 것처럼 환경을 제공 할 수 있다.**

**같은 파드에서 컨테이너 간 부분 격리****컨테이너가 동일한 IP와 포트 공간을 공유하는 방법****파드 간 플랫 네트워크 소개** 쿠버네티스 클러스터의 모든 파드는 하나의 플랫한 공유 네트워크 주소 공간에 상주한다.  
모든 파드는 다른 파드의 IP주소를 사용하여 접근하는 할 수 있다.  
파드 사이에서의 통신은 단순함, NAT 없이 통신이 가능하다. (워커 노드 위치 무관)

### 1.3 파드에서 컨테이너의 적절한 구성

-	다계층 애플리케이션을 여러 파드로 분할
-	개별 확장이 가능하도록 여러 파드로 분할
	-	파드는 스케일링의 기본 단위
-	파드에서 여러 컨테이너를 사용하는 경우

	-	하나의 주요 프로세스와 하나 이상의 보완 프로세스로 구성된 경우에 사용 (pod간에는 NAT도 존재하지 않음)  
		![3-3](https://i.imgur.com/Un1iFmH.png)  
		ex) 주 컨테이너: 특정 디렉터리에서 파일을 제공하는 웹 서버 추가(지원) 컨테이너: 외부 소스에서 주기적으로 콘텐츠를 받아 웹 서버의 디렉터리에 저장 ex) 로그 로테이터와 수집기, 데이터 프로세스, 통신 어댑터 등..  

-	파드에서 여러 컨테이너를 사용하는 경우 결정

### 2. yaml 또는 json 디스크립터로 파드 생성

쿠버네티스 리소스는 REST API 엔드포인트에 JSON, YAML 매니페스트를 전송해 생성  
**장점**  
1. 제한된 속성 집합만 설정 가능 2. 버전 관리 시스템 사용 가능

##### kubectl get 명령어의 option

-	`-o yaml`: yaml파일 전체 정의 볼 수 있음 매니페스트 작성 시 API object 찾는 명령어: `kubectl explain`

-	metadata: name, namespace, label, pod의 관련된 기타 정보

-	spec: 파드 컨테이너, 볼륨, 기타 데이터등 파드 자체에 관련된 실제 명세

-	status: 파드 상태, 각 컨테이너 설명 상태, 파드 내부 IP, 기본 정보등 명세

```yaml
$ kubectl get po kubia-zxzij -o yaml
apiVersion: v1
kind: Pod
metadata:       # metadata 속성 : annotations, labels, name
  annotations:
    kubernetes.io/created-by: ...
  creationTimestamp: 2016-03-18T12:37:50Z
  generateName: kubia-
  labels:
    run: kubia
  name: kubia-zxzij
  namespace: default
  resourceVersion: "294"
  selfLink: /api/v1/namespaces/default/pods/kubia-zxzij
  uid: 3a564dc0-ed06-11e5-ba3b-42010af00004
spec:         # pod 정의/내용 ( 컨테이너 목록, 볼륨등의 파드의 스펙작성)
  containers:
  - image: luksa/kubia
    imagePullPolicy: IfNotPresent
    name: kubia
    ports:
    - containerPort: 8080
      protocol: TCP
    resources:
      requests:
        cpu: 100m
    terminationMessagePath: /dev/termination-log
    volumeMounts:
    - mountPath: /var/run/secrets/k8s.io/servacc
      name: default-token-kvcqa
      readOnly: true
  dnsPolicy: ClusterFirst
  nodeName: gke-kubia-e8fe08b8-node-txje
  restartPolicy: Always
  serviceAccount: default
  serviceAccountName: default
  terminationGracePeriodSeconds: 30
  volumes:
  - name: default-token-kvcqa
    secret:
      secretName: default-token-kvcqa
status:
  conditions:     # 파드와 그 안의 컨테이너의 상세한 상태 작성
  - lastProbeTime: null
    lastTransitionTime: null
    status: "True"
    type: Ready
  containerStatuses:
  - containerID: docker://f0276994322d247ba...
    image: luksa/kubia
    imageID: docker://4c325bcc6b40c110226b89fe...
    lastState: {}
    name: kubia
    ready: true
    restartCount: 0
    state:
      running:
        startedAt: 2016-03-18T12:46:05Z
  hostIP: 10.132.0.4
  phase: Running
  podIP: 10.0.2.3
  startTime: 2016-03-18T12:44:32Z
```

### 2.3 파드 생성

```bash
$ kubectl create -f kubebia-manual.yaml
```

```
$ kubectl get pod kubebia-manual -o yaml
```

### 2.5 파드에 요청 보내기

-	로컬 네트워크 포트를 파드의 포트로 포드 포워딩(port forwarding)

```
$ kubectl port-forward kubia-manual 8888:8080
...forwarding form 127.0.0.1:8888 -> 8080
$ curl localhost:8888   # local port 8888 -> pod로 포워딩
```

### 3. 레이블을 이용한 파드 구성

> 레이블: 쿠버네티스 리소스를 조직화 할 수 있는 단순하면서 강력한 쿠버네티스 기능  
> 키-값 쌍으로 이루어 짐  
> `레이블 셀렉터`를 사용하여 리소스를 다룰 수 있다.

#### 3.2 파드 생성 시 레이블 지정 방법

```
$ kubectl get pods --show-labels
$ kubectl get pods -L [label명1, label명2 ...]
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kubia-manual-v2
  # label 명세 작성 한 곳
  labels:
    creation_method: manual
    env: prod
  # /label 명세 작성 한 곳

spec:
  containers:
  - image: luksa/kubia
    name: kubia
    ports:
    - containerPort: 8080
      protocol: TCP
```

#### 3.3 파드 레이블 수정

1.	레이블 추가

```sh
$ kubectl label pod jubia-manual creation_method=manual
```

1.	레이블 수정

```
$ kubectl label pod jubia-manual env=debug --overwrite
```

### 4. 레이블 셀렉터를 이용한 파드 부분 집합 나열

레이블은 레이블 셀렉터와 함께 사용됨  
- 특정한 키를 가지고 있거나, 없는 경우 - 특정한 키와 값을 가진 레이블 - 특정한 키를 갖고 있지만 다른 값을 가진 레이블

#### 4.1 레이블 셀렉트로 검색

```sh
# creation_method의 값이 manual인 파드 검색
$ kubectl get pod -l creation_method=manual
$ kubectl get pod -l creation_method!=manual

# env 레이블을 가지고 있는 모든 파드 검색 (value 값 무관)
$ kubectl get pods -l env

# env 레이블 가지고 있지 않은 파드 검색
$ kubectl get pods -l '!env'

# env이 prod or dev1 인 파드
$ kubectl get pods env in(prod, dev1)
# env이 prod or dev1 이 아닌 파드
$ kubectl get pods env notin(prod, dev1)
```

### 5. 레이블 셀렉터를 이용하여 파드 스케줄링 제한

#### 5.1 워커 노드 분류에 레이블 사용

#### 5.2 특정 노드에 파드 스케줄링

노드에 레이블을 추가 한 경우, 파드 생성 시 특정 노드에 파드를 스케줄링 할 수 있다.  
파드의 yaml에 노드 셀렉터를 추가

```yaml
spec:
  nodeSelector:
    gpu: "true"   # node label 키-값
```

### 6. 어노테이션

> 쿠버네티스 오브젝트는 어노테이션을 가질 수 있다. 키-값의 쌍의 형태  
> 레이블과 차이점 : 식별 정보를 갖지 않는다. (오브젝트 그룹핑하는 용도로 사용 불가), 많은 정보를 넣을 수 있음

```sh
$ kubectl annotate pod kubia-manual [추가할 내용 or 수정할 내용]
```

### 7 네임스페이스르 사용한 리소스 그룹화

네임스페이스를 사용하여 개발 그룹으로 분리 할 수 있다.  
**네임스페이스 안에 속하지 않는 리소스**  
- 노드 리소스 (global resource)

```sh
# get namespaces
$ kubectl get ns
NAME LABELS STATUS AGE
default <none>  active 1h
kube-system <none>  active 1h
kube-public <none>  active 1h

# kube-system namespace에 속한 파드 리스트
$ kubectl get pod -n kube-system
```

#### 7.3 네임스페이스 생성

-	yaml 파일로 생성

```yaml
apiVersion: v1
kind: Namespace
metadata:
    name: custom-namespace
```

-	kubectl create namespace 명령어로 생성

```sh
$ kubectl create namespace custom-space
```

#### 7.5 네임스페이스가 제공하는 격리 이해

실행 중인 오브젝트에 대한 격리는 제공하지 않음

### 8. 파드 중지/제거

#### 8.1 이름으로 파드 삭제

```sh
$ kubectl delete pod kubia-gpu kubia-gpu2 ...
```

#### 8.2 레이블 셀렉터를 이용한 삭제

```sh
# label creation_method=manual인 파드 삭제
$ kubectl delete pod -l creation_method=manual
```

#### 8.3 네임스페이스를 삭제한 파드 삭제

```sh
$ kubectl delete ns custom-namespace
```

#### 8.4 네임스페이스 안에 있는 모든 파드 삭제

```sh
$ kubectl delete pod --all
```

#### 8.4 네임스페이스 안에 있는 (거의) 모든 리소스 삭제

현 네임스페이스에 있는 모든 리소스 (레플리케이션컨트롤러, 파드, 생성한 모든 서비스) 삭제  
(secret은 삭제 X) (kubernetes service 삭제 후 자동으로 다시 생성됨?)

```
$ kubectl delete all --all
```
