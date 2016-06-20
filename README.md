Introduction
-----
This is the docker project to setup nginx http server over sshfs remote folder.

Install
-----
### Run with private key (~/.ssh)
```
docker run -it -p 80:80 --cap-add SYS_ADMIN --device=/dev/fuse -v ~/.ssh:/root/.ssh \
       -e REMOTE_URL=example.com -e REMOTE_PATH=/remote/path -e REMOTE_USER=example \
       fengzhou/nginx-sshfs
```
### Run with input password
```
docker run -it -p 80:80 --cap-add SYS_ADMIN --device=/dev/fuse \
       -e REMOTE_URL=example.com -e REMOTE_PATH=/remote/path -e REMOTE_USER=example \
       fengzhou/nginx-sshfs
```
The container will request password input in startup.
### Run with password from environment variable
```
docker run -it -p 80:80 --cap-add SYS_ADMIN --device=/dev/fuse \
       -e REMOTE_URL=example.com -e REMOTE_PATH=/remote/path -e REMOTE_USER=example -e REMOTE_PASSWORD=password \
       fengzhou/nginx-sshfs
```
### Use docker-compose
Refer to sample [docker-compose.yml](https://github.com/feng-zh/docker-nginx-sshfs/blob/master/docker-compose.yml) file, and configure relative environment variable, and ports.
