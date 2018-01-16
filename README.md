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

or specify private key file
```
docker run -it -p 80:80 --cap-add SYS_ADMIN --device=/dev/fuse -v ~/.ssh/id_rsa:/mnt/id_rsa \
       -e SSH_REMOTE_HOST=example.com -e SSH_REMOTE_PATH=/remote/path -e SSH_REMOTE_USER=example -e SSH_REMOTE_KEY=/mnt/id_rsa \
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
This image also supports multiple ssh/ftp remote folders. Combine different environments to support both.

The `TYPE_i` value is used to indicates remote type, and `i` is starting from 1. Currently, it supports `ssh` or `ftp` values.

For each remote, support following environment variables (replace _1 to other values for multiple folders):
- TYPE_1=ssh
- REMOTE_HOST_1=example.com
- REMOTE_PATH_1=/remote/path
- LOCAL_PATH_1=/local
- REMOTE_USER_1=user
- REMOTE_PASSWORD_1=password

For ssh type, the ssh key file can use following additional environment variable:
- REMOTE_KEY_1=/path/to/key

### Use docker-compose
Refer to sample [docker-compose.yml](https://github.com/feng-zh/docker-nginx-fuse/blob/master/docker-compose.yml) file, and configure relative environment variable, and ports.
