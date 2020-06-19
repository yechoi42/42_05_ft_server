## Docker

#### debian install 

1. Docker 접속 후 debian 이미지 pull

2. debian 이미지 컨테이너로 실행  
   
   ```
   docker run --name ft_server -it  -p 80:80 -p 443:443 debian /bin/bash 
   ```
   
   

#### nginx install

1. 컨테이너 업데이트  
   
   ```
   apt-get update
   ```
   
2. nginx 설치  
   
   ```
   apt-get install nginx
   ```
   
   

#### php install 

1. 컨테이너 업데이트
2. php 설치
3. 더 필요한 php  모듈 설치   
   php-curl, php-mysql, php-fpm, php-mbstring



####  nginx config

1.  config 수정을 위해 편집기 vim 없다면 설치

2.  service php7.3-fpm start

3. php  해석을 위한 nginx 설정 및 보안 설정        

   etc/nginx/sites-available/defalt에서  nginx가 처리하는 파일에 index.php를 추가

   php, deny all 부분 주석 해제하기 

   https://swiftcoding.org/installing-php7-2-fpm

4. php를 nginx에 띄워보기  
     /var/www/html 폴더 안에 index.php 파일을 만들고    

     vim 으로 <?php phpinfo(); ?> 작성  

     

####  mysql install

1. mysql 버전 확인  
   apt-cache search mysql
   
2. mysql  다운로드  
   내 경우 검색 된 것 중 default-mysql-server 를 받음
   
3. mysql 아이디 만들기  
   
   ```
   mysql -u root -p  
   create user '아이디'@'%' identified by '비밀번호';  
   grant all privileges on *.* to '아이디'@'%';  
   ```
   
   https://extrememanual.net/33257 
   https://all-record.tistory.com/96 
   
4. mysql  DB 만들어보기   
   
   ```
   create database ft_server;
   grant all privileges on ft_server.* to 'admin'@localhost identified by 'admin'; 
   ```
   
   https://sosobaba.tistory.com/218
   
   

#### phpmyadmin  install

1. phpmyadmin 설치   
   
   ```
   mkdir /var/www/html/phpmyadmin  
   apt install wget  
   wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz  
   tar -xvf phpMyAdmin-4.9.5-all-languages.tar.gz --strip-components 1 -C /var/www/html/phpmyadmin  
   ```
   
2. blowfish 설정  
   blowfish generator로 발급받아 phpmyadmin/config-sample.inc.php를 config.inc.php로 복사  
   해당 파일에 발행받은 blowfish 값 넣어주기

3. phpmyadmin에 12에서 설정한 mysql 아이디로 로그인



#### wordpress install

1. wordpress 설치  
   
   ```
   mkdir /var/www/html/wordpress  
   wget -c https://wordpress.org/latest.tar.gz  
   tar -xvf latest.tar.gz --strip-components 1 -C /var/www/html/wordpress  
   ```
   
2. wordpress conf 변경  
   
   ```
   wordpress 디렉토리에 가서, wp-config-sample.php를 복사해서 wp-config.php 파일을 새로 만든다.  
   db_name, db_user, db_password 셋팅 설정  
   ```
   
   참고 : https://skylit.tistory.com/155  
   
   

#### SSL(*과제용 사설  자가서명 SSL)

1.  키 생성

   ```
   openssl genrsa -out 키이름.key 2048 
   openssl req -new -key 키이름.key -out 키이름.csr 
   openssl x509 -req -in 키이름.csr -signkey 키이름.key -out 키이름.crt -days 3650 -sha256
   ```

2. nginx에 ssl config 설정

   etc/nginx/sites-available에 위치한 default에 아래 내용 기입

   ```
   listen 443 ssl;  
   ssl_prefer_server_ciphers on;    
   ssl_certificate /키 경로/키이름.crt;     
   ssl_certificate_key /키 경로/키이름.key;
   ```

3. https 도메인으로 접속해 보기 



#### Dockerfile 작성 준비

1. src 폴더 만들어 옮겨야 할 파일 복사 또는 이동
   - /etc/nginx/sites-available/default
   - /var/www/html/phpmyadmin/config-sample.inc.php
   - /var/www/html/wordpress/wp-config.php
2. 도커 나와 docker cp 명령어 이용해 내 os로 빼오기
