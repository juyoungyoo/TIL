- 가장 많이 사용하는 대표적인 웹서버 Apache(아파치), NginX (엔진엑스)
- 과거에는 apache를 많이 사용했으나 대형 포털사이트 nginX로 갈아타는 추세

## nginX(엔진엑스) 장점
1. nginX가 apache보다 설정하기 쉬움
2. 성능, 속도면에서 우세
3. apache는 기능은 많으나 속도가 떨어짐 ( 왜? 기능이 많기 때문에 프로그램이 무겁기 때문 )

## 기본구조
- conf : 실행 설정 파일  ( nginx.conf )
- logs : 로그 디렉토리
- sbin : 실행 디렉토리  

## 실행 방법
- 시작 : sbin/nginx
- 멈춤 : sbin/nginx -s stop
- 다시시작 : sbin/nginx -s reload

정적자원 html, js, css, image 등은 nginx 를 이용!!   
동적처리되는 부분은 폼캣을 이용하도록한다 이 tomcat을 이용하도록 하는것이 proxy 설정이라한다!   

## nginx.conf 주요 설정
1. Listen Port 설정
default : 80    
```
     server {
          listen     80;  // port 변경가능 ( nginx 포트 지정 )
         ...  
     }
```
2. Document Root  설정
- root 확인 ( default : html )
3. 초기 페이지 설정
- index 확인 ( default : index.html )
```   
location / {
          root html;
          index index.html index.html;
     }
```
- index 파일 존재하지 않는 경우 403 fobidden 오류 발생
4. proxy_pass 설정
- 특정 확장자 요청을 넘기는 설정
- nginx 뒷 단에 WAS가 존재하는 경우, 확장자 기반으로 요청 처리를 분리하는 것
ex) `*.do` 에대해 http://localhost:8080 으로 넘김
```
     location ~\.do${
          proxy_pass http://localhost:8080;     -- server host 주소를 작성하면 안됨( 외부로 돌아 ip 차단이 일어나기 때문, 같은 서버라면 localhost로 해주자 )
     }
```
5. sub Domain 설정
최초 설치 후의 nginx.conf 를 보면 이렇습니다.
```
server {
listen 80;
server_name localhost;

#charset koi8-r;

#access_log logs/host.access.log main;

location / {
root html;
index index.html index.htm;
}
......}
```
바로 본론부터 들어가서, 사이트에 2개의 Sub Domain 을 추가한다고 해 봅시다.
* appsroot.com
* nginx1.appsroot.com (추가!)
* nginx2.appsroot.com (추가!)
```
server {
listen 80;
server_name localhost;

#charset koi8-r;

#access_log logs/host.access.log main;

location / {
root /home/nginx;
index index.html index.htm;
}
......
}

server {
listen 80;
server_name nginx1.appsroot.com;

location / {
root /home/nginx1;
index index.html index.htm;
}
}

server {
listen 80;
server_name nginx2.appsroot.com;

location / {
root /home/nginx2;
index index.html index.htm;
}
}
```
server block 이 2개 추가되었고 각각 nginx1.appsroot.com (/home/nginx1), nginx2.appsroot.com (/home/nginx2) 의 역할을 담당하고 있습니다.    
그리고 default 값을 사용하는 경우는 명시적으로 설정하지 않아도 무관합니다. listen 의 80, index 의 index.html 등 말입니다.     
```
server {
server_name nginx2.appsroot.com;

location / {
root /home/nginx2;
}}
```
이렇게 해도 됩니다.   


## access log 설정
access_log 를 확인합니다. default 는 logs/access.log 입니다. 앞서 설명한 Sub Domain (Virtual Host) 로 분리되어 있어도 별도로 access log 설정을 하지 않으면 하나의 access.log 파일로 쌓입니다.   
```
# ls -tlr
total 136-rw-r--r--  1 nginx  staff  42485 Feb 23 03:29 access.log
-rw-r--r--  1 nginx  staff  20064 Feb 23 13:35 error.log
-rw-r--r--  1 nginx  staff      6 Feb 23 13:35 nginx.pid
```
각 server 별로 log 를 분리합니다.    
```
server {
listen 80;
server_name localhost;

#charset koi8-r;

access_log logs/host.access.log;
......
}

server {
#listen 80;
server_name nginx1.appsroot.com;

access_log logs/nginx1.access.log;
......
}

server {
#listen 80;
server_name nginx2.appsroot.com;

access_log logs/nginx2.access.log;
......
}
```
그리고 다시 NginX 를 기동한 후 logs 디렉토리를 확인합니다.    

```
# ls -tlr
total 136-rw-r--r-- 1 nginx staff 42485 Feb 23 03:29 access.log
-rw-r--r-- 1 nginx staff 20125 Feb 23 13:38 error.log
-rw-r--r-- 1 nginx staff 0 Feb 23 13:39 nginx2.access.log
-rw-r--r-- 1 nginx staff 0 Feb 23 13:39 nginx1.access.log
-rw-r--r-- 1 nginx staff 6 Feb 23 13:39 nginx.pid
-rw-r--r-- 1 nginx staff 0 Feb 23 13:39 host.access.log
```
새롭게 host.access.log, nginx1.access.log, nginx2.access.log 파일이 생성되었습니다. (물론 아직 어떤 요청도 처리하지 않은 상태여서 0 바이트로 나오고 있습니다)
