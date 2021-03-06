사용파일 : data-volumnes-01-starting-setup

<b>Dockerfile 생성</b>
```
FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

CMD ["node", "server.js"]
```

<b>Terminal</b>
- `docker build -t feedback-node .`
- `docker run -p 3000:80 -d --name feedback-app --rm feedback-node:latest`
  - `-d` : detach mode로 실행 - terminal은 계속 사용하기 위함
  - `--name` : container name
  - `--rm` : automatically remove container

<b>인터넷</b>
- 주소창 : http://localhost:3000/
- 화면에서 title, document text 작성 - save
  - ex) title : awesome, text : this is awesome
- 주소창 : http://localhost:3000/feedback/awesome.txt
  - 화면결과 : this is awesome
  - 'server.js' 파일에 `app.use('/feedback', express.static('feedback'));` 코드 덕분
  - ★ but, Docker container에만 존재하는 것
    - local 'feedback' 폴더에서는 안 보임
    - 기존 코드를 Dockerfile `COPY . .`으로 local에 복사한 후 화면에서 작성한 내용이니 local에 연동 안 되어 있음
    - = container는 isolated 되어 있음
- title 또 'awesome' 입력하는 경우 : 이미 존재하는 이름이라고 알림 (overwritten 방지)
  - 'server.js' 파일에 `await fs.writeFile(tempFilePath, content); ~~` 

<b>container 새로 시작하는 경우</b>
- `docker stop feedback-app`
- `docker run -p 3000:80 -d --name feedback-app feedback-node:latest`
- 인터넷 주소창 : http://localhost:3000/
  - http://localhost:3000/feedback/awesome.txt : error 발생
    - Cannot GET /feedback/awesome.txt
    - `stop` 때문이 아니라 위에서 이전에 `run` 할 때 `--rm`으로 container를 삭제했기 때문
    - 지금 `run` 코드에는 `--rm` 없음
  - 다시 화면으로 돌아가서 'awesome', 'this is awesome' 입력
    - 결과확인 : http://localhost:3000/feedback/awesome.txt
- `docker stop feedback-app`
- `docker start feedback-app`
- 인터넷 주소창 : http://localhost:3000/feedback/awesome.txt 입력
  - `--rm`으로 container 제거한 적이 없으니 데이터 보존되어 있음

---

### volume
- 온라인 화면에서 입력한 데이터 persist 하게 만들기
- 방법1, 2가 실패한 이유
  - `run`에서 `--rm` 옵션으로 익명 볼륨이 자동 제거되기 때문
  - 이 옵션 사용하지 않고 `run`하면, 이후 `docker rm ...`으로 제거해도 익명 볼륨 제거X
  - 그래도 `docker run`으로 재실행하면 새 익명 볼륨이 생성됨
  - 사용하지 않는 익명 볼륨들이 쌓이게 됨
  - 삭제 : `docker volume rm [volume name]`, `docker volume prune`

<b>Dockerfile 생성</b>
- `VOLUME` : 'feedback' 내용을 inside of my container에 저장
  - 'feedback' 내용 : 인터넷 주소창 들어간 후 입력 내용
  - server.js 코드 `const finalFilePath = path.join(__dirname, 'feedback', adjTitle + '.txt');` 부분 참고

```
FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

VOLUME [ "/app/feedback" ]

CMD ["node", "server.js"]
```

<b>방법1 : 실패</b>
- Terminal
  - `docker build -t feedback-node:volumes .`
  - `docker run -d -p 3000:80 --rm --name feedback-app feedback-node:volumes`
- 인터넷 : 에러발생
  - 주소창 : http://localhost:3000/
  - 화면에서 title, document text 작성 - save
    - ex) title : awesome, text : one more time!
    - 계속 loading 중이고 작동이 안 됨

<b>방법2 : 실패</b>
- Terminal : 문제해결
  - `docker logs feedback-app` 결과로 문제 확인
    - UnhandledPromiseRejectionWarning: cross-device link not permitted, rename '/app/temp/hello.txt' -> '/app/feedback/hello.txt'
    - 'server.js' 파일에서 `await fs.rename(tempFilePath, finalFilePath);` 이 부분 때문
    - 수정 : `await fs.copyFile(tempFilePath, finalFilePath);`
      - final에 경로 복사하고 temp 경로는 삭제
    - 아랫줄 추가 : `await fs.unlink(tempFilePath);`
  - `docker stop feedback-app`
  - `docker rmi feedback-node:volumes`
  - `docker build -t feedback-node:volumes .`
  - `docker run -d -p 3000:80 --rm --name feedback-app feedback-node:volumes`
- 인터넷 주소창 : http://localhost:3000/
  - 화면에서 title, document text 작성 - save
    - ex) title : awesome, text : one more time!
  - 주소창 : http://localhost:3000/feedback/awesome.txt
    - 결과 : one more time
- container 삭제/중단 후 재실행
  - `docker stop feedback-app`
    - 앞에 코드에서 `--rm` 있었으니 중단하면 container 삭제됨
  - `docker run -d -p 3000:80 --rm --name feedback-app feedback-node:volumes`
    - 이전과 같은 image를 기반으로 하지만 새로운 container 생성
  - 주소창 : http://localhost:3000/feedback/awesome.txt
    - error 발생 : 결과 안 나옴
- `docker volume ls`
- `docker stop feedback-app`

<b>방법3 : 성공!</b>
- Terminal
  - `docker build -t feedback-node:volumes .`
  - named volume 생성 : `docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback feedback-node:volumes`
- 인터넷 주소창 : http://localhost:3000/
  - 화면에서 title, document text 작성 - save
    - ex) title : awesome, text : awesome!
  - 주소창 : http://localhost:3000/feedback/awesome.txt
    - 결과 : awesome!
- Terminal
  - `docker stop feedback-app`
    - `run` 할 때 `--rm` 옵션 사용했으니 container 삭제됨
  - `docker volume ls` : container 없어졌지만 여전히 'feedback' volume 존재
  - 같은 volume name과 경로 사용해서 다시 `run`
    - `docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback feedback-node:volumes`
- 인터넷 주소창 : http://localhost:3000/
  - 주소창 : http://localhost:3000/feedback/awesome.txt
  - 아까 입력했던 'awesome!' 그대로 있음

---

### Anonymous volume 활용하기

<b>Dockerfile</b>
-`CMD` 코드 위에 `VOLUME ["/temp"]` 코드 추가
  - temp 폴더를 익명 볼륨에 mapping 하는 것
  - docker container에서 데이터를 관리하지 않고 host file system에 data outsourcing
  - container 자체에서 관리하지 않기 때문에 성능 향상

---

### Bind Mounts

<b>방법1 : 실패</b>
- volume 실행 코드에 `-v "[absolute project folder path]:/app"` 부분만 추가
  - `/app`은 Dockerfile의 WORKDIR
  - absolute project folder path : source code가 있는 'server.js' 우클릭 - 'Copy Path' 클릭 - 붙여넣기 - 가장 마지막 '/server.js' 부분 삭제
    - 경로 폴더명 중 space, 특수문자 있으면 안됨
    - 경로 폴더는 무조건 Docker Parent folder에 있어야 함
      - Parent folder : 상단 Docker 아이콘 클릭 - Resources - File sharing 에 있는 폴더들
      - 없으면 추가하기
    - ex) `docker run -d -p 3000:80 --rm --name feedback-app -v feedback:/app/feedback -v "/Users/reasonmii/udemy_docker/data-volumes-01-starting-setup:/app" feedback-node:volumes`
- 에러발생
  - `docker ps`, `docker ps -a` 모두 결과 없음
  - `run` 코드에서 `--rm` 부분만 빼고 다시 실행해 보기
  - ★ 에러 확인 : `docker logs feedback-app`
    - 결과 : Error: Cannot find module 'express'
    - 'Dockerfile'의 `RUN npm install`이 실행되기 전에 npm을 사용하는 코드가 사용되기 때문에 발생 

<b>방법2 : 성공</b>
- 해결방법 : anonymous volume 활용하기
- `-v /app/node_modules` 코드 추가
  - 'Dockerfile'에서 `EXPOSE 80`와 `CMD` 코드 사이에 `VOLUME ["/app/node_modules"]` 코드 작성하는 것과 같은 역할
    - 단, 이렇게 하면 데이터 바뀔 때마다 image rebuild 과정 필요
  - cf) node_modules 폴더 : 'Dockerfile'에서 `RUN npm install` 명령어로 생성된 default 폴더

```
docker stop feedback-app

docker rm feedback-app

docker run -d --rm  -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "/Users/reasonmii/udemy_docker/data-volumes-01-starting-setup:/app" -v /app/node_modules  feedback-node:volumes
```

<b>방법2가 도움되는 이유</b>
- docker는 항상 container에 setting한 모든 volume을 평가
- 그러다 충돌이 발생하면 더 구체적이고 longer internal path wins!
- 예를 들어 위 코드에서 `-v "/Users/reasonmii/udemy_docker/data-volumes-01-starting-setup:/app`의 경로는 ① `/app`이고 `-v /app/node_modules`의 경로는 ② `/app/node_modules`
- 더 긴 path가 이기니까 ② `/app/node_modules` 폴더에 바인딩 됨
- 결론 : `RUN npm install` 과정에서 만들어진 ② 폴더가 살아 남아 ① bind mount와 공존하게 되는 것

<b>결론</b>
- container 삭제해도 이전 데이터 삭제 X
  - 인터넷 주소창 : http://localhost:3000/
    - 화면에서 title (test), document text (this is test!) 작성 - save
  - 인터넷 주소창 : http://localhost:3000/feedback/awesome.txt
    - container 삭제했고 awesome 입력한 적 없는데 이전 결과 여전히 남아 있음
- source file 변경하고 image rebuild 안 해도 인터넷 페이지에 바로 반영 됨
  - 'pages' - 'feedback.html' 에서 제목인 'Your Feedback'을 'Your Feedback!'으로 변경 - 저장
  - 인터넷 주소창 : http://localhost:3000/ 새로고침 해서 결과 확인
- 이 두 가지는 익명볼륨을 추가한 경우에만 작동
  - 'bind mount' 폴더가 'node_modules' 폴더를 덮어쓰지 않기 때문에 가능 

<b>주의점</b>
- bind mounts `run` 코드를 사용하면 Dockerfile에서 `COPY . .` 코드 부분을 지워도 됨
- but, 컨테이너가 일단 빌드되면 온라인에서 데이터 추가/수정 후에는 bind mounts가 아닌 다른 volume 사용하게 됨
- 이떄 `COPY . .` 부분이 없으면 connection이 끊어지게 됨
- = Dockerfile에 `COPY . .` 코드 필요

---

### js 파일 수정사항이 온라인에도 바로 반영되도록 하기
- server.js 파일이 수정되어도 rebuild 등 할 필요없음

<b>기존 방법</b>
- rebuild 할 필요는 없지만 여전히 `stop`, `start`, `run` 해야 하고 불편
```
docker stop feedback-app
docker start feedback-app

docker run -d --rm  -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "/Users/reasonmii/udemy_docker/data-volumes-01-starting-setup:/app" -v /app/node_modules  feedback-node:volumes

docker logs feedback-app
```

<b>해결</b>
- extra package 'nodemon' 사용하기
  - 'package.json' 파일에서 `scripts`, `devDependencies` 코드 추가
  - `node` 대신 `nodemon`으로 js 파일 실행하는 것
  - nodemon : file system을 감시하다가 source 파일에 변경이 있을 때마다 자동으로 노드 서버 재시작
```
{
  "name": "data-volume-example",
  "version": "1.0.0",
  "description": "",
  "main": "server.js",
  "author": "Maximilian Schwarzmüller / Academind GmbH",
  "license": "ISC",
  "scripts": {
    "start": "nodemon server.js"
  },
  "dependencies": {
    "body-parser": "^1.19.0",
    "express": "^4.17.1"
  },
  "devDependencies": {
    "nodemon": "2.0.4"
  }
}
```

- 'Dockerfile' `CMD` 부분도 수정
  - 내부적으로 nodemon을 사용하도록 
```
FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

# VOLUME ["/app/node_modules"]

CMD ["npm", "start"]
```

- Terminal

```
docker rmi feedback-node:volumes
docker stop feedback-app
docker build -t feedback-node:volumes .

docker run -d --rm  -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "/Users/reasonmii/udemy_docker/data-volumes-01-starting-setup:/app" -v /app/node_modules  feedback-node:volumes
```

- 'server.js' : `await fs.writeFile(tempFilePath, content);` 코드 위에 `console.log('TEST!!!!');` 추가 - 
- 인터넷 주소창 : http://localhost:3000/ - 아무거나 입력
- Terminal `docker logs feedback-app` 결과 : TEST!!!! 출력됨

---

### 읽기 전용 volume 만들기
- volume : read-write (default)
- 변경되면 안 되는 부분은 읽기 전용으로 해줘야 안전

```
docker run -d --rm  -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "/Users/reasonmii/udemy_docker/data-volumes-01-starting-setup:/app:ro" -v /app/temp -v /app/node_modules  feedback-node:volumes
```
- `:ro` 추가하면 Docker가 해당 폴더나 그 하위 폴더에 write 불가능
  - `ro` : read only
  - 이렇게 해도 온라인에서 title, text는 여전히 입력 (쓰기) 가능
  - 해당 data는 `/app/feedback` 경로에 저장되는데 `ro`를 적용한 `/app`보다 `/app/feedback`이 더 longer path니까 이겨서 여기에는 read only가 적용되지 않기 때문
- `-v /app/temp` : 익명 볼륨 추가
  - 컨테이너가 임시 데이터를 host file system에 저장
  - 더 효율적으로 작업 가능
  - Dockerfile에서 `VOLUME ["/temp"]` 코드는 삭제

---

### Docker volume 관리하기
- `docker volume --help`
- 전체
  - `docker volume ls`
    - 결과 : 익명볼륨 2개, named volume 1개 있음
    - bind mount는 표시X (host machine이 관리하고 Docker가 관리하는 것 아니기 때문)
- 생성
  - `docker volume create --help` : volume 생성
  - `docker volume create feedback-files` - `docker volume ls`
- 상세
  - `docker volume inspect feedback`
    - host machine이 volume을 자동으로 생성하는 경로 알 수 있음
- 삭제
  - `docker volume rm feedback-files`
    - 사용 중이면 삭제 불가 : `docker stop feedback-app` - `docker volume rm feedback`
    - 컨테이너 `stop` 하는 순간 모든 익명 볼륨도 동시에 삭제됨
  - `docker volume prune` : 모두 삭제

---

### .dockerignore file
- '.dockerignore' file 추가
- Dockerfile `COPY . .` 코드에서 복사하지 않고 무시할 폴더/파일 지정

```
node_modules
```

- `node_modules` 폴더
  - 이걸 쓰면 'Dockerfile'의 `RUN npm install` 대신 local에 있는 npm install 사용하게 됨
  - maybe outdated or `COPY . .` 시간 더 오래걸리게 함


