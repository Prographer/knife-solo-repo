# Knife Solo를 이용한 서버 구성
### 1. Vagrant
Vagrant 실행
```
$ vagrant up
```
### 2. Prepare
원격으로 Knife solo를 설치한다.
```
$ knife solo prepare [호스트]
```

### 3. Cook
서버를 생성한다.
```
$ knife solo cook [호스트]
```

### 4. Cookbook 설명
 - java: Oracle Java 1.8 버전을 설치한다.
 - hadoop: Apache Hadoop 2.7.3 버전을 설치한다.
