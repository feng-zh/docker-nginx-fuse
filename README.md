Introduction
-----
This is the docker project to setup nginx http server over sshfs or/and ftp remote folder.

Install
-----
### SSH/SFTP
#### Run with private key (~/.ssh)
```
docker run -it -p 80:80 --cap-add SYS_ADMIN --device=/dev/fuse -v ~/.ssh:/root/.ssh \
       -e SSH_REMOTE_HOST=example.com -e SSH_REMOTE_PATH=/remote/path -e SSH_REMOTE_USER=example \
       fengzhou/nginx-fuse
```
#### Run with input password
```
docker run -it -p 80:80 --cap-add SYS_ADMIN --device=/dev/fuse \
       -e SSH_REMOTE_HOST=example.com -e SSH_REMOTE_PATH=/remote/path -e SSH_REMOTE_USER=example \
       fengzhou/nginx-fuse
```
The container will request password input in startup.
#### Run with password from environment variable
```
docker run -it -p 80:80 --cap-add SYS_ADMIN --device=/dev/fuse \
       -e SSH_REMOTE_HOST=example.com -e SSH_REMOTE_PATH=/remote/path -e SSH_REMOTE_USER=example -e SSH_REMOTE_PASSWORD=password \
       fengzhou/nginx-fuse
```

### FTP
#### Run with anonymous
```
docker run -it -p 80:80 --cap-add SYS_ADMIN --device=/dev/fuse \
       -e FTP_REMOTE_HOST=example.com -e FTP_REMOTE_PATH=/remote/path \
       fengzhou/nginx-fuse
```
#### Run with user/password from environment variable
```
docker run -it -p 80:80 --cap-add SYS_ADMIN --device=/dev/fuse \
       -e FTP_REMOTE_HOST=example.com -e FTP_REMOTE_PATH=/remote/path -e FTP_REMOTE_USER=example -e FTP_REMOTE_PASSWORD=password \
       fengzhou/nginx-fuse
```

### Multiple remote folder
Currently, this image only support 0-1 ssh/sftp, and 0-1 ftp remote folders. Combine different environments to support both.

To indicate different remote folders, two additional environment variable can support:
- SSH_LOCAL_PATH=/local_ssh_path
- FTP_LOCAL_PATH=/local_ftp_path

### Use docker-compose
Refer to sample [docker-compose.yml](https://github.com/feng-zh/docker-nginx-fuse/blob/master/docker-compose.yml) file, and configure relative environment variable, and ports.
