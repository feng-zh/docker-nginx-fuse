#! /bin/bash

function enable_ssh() {

	if [ -z "${SSH_REMOTE_HOST}" ]; then
		echo "Enviromental variable SSH_REMOTE_HOST is required, exiting..."
		exit 1
	fi
	echo "SSH remote host: ${SSH_REMOTE_HOST}"

	if [ -n "${SSH_REMOTE_PORT}" ]; then
		echo "SSH remote port: ${SSH_REMOTE_PORT}"
		PLACEHOLDER_PORT="-p ${SSH_REMOTE_PORT} "
	else
		PLACEHOLDER_PORT=""
	fi

	if [ -z "${SSH_REMOTE_PATH}" ]; then
		echo "Enviromental variable SSH_REMOTE_PATH is required, exiting..."
		exit 1
	fi

	echo "SSH remote path: ${SSH_REMOTE_PATH}"

	if [ -n "${SSH_LOCAL_PATH}" ]; then
		mkdir -p /usr/share/nginx/html/${SSH_LOCAL_PATH}
	fi
	echo "SSH local path: /usr/share/nginx/html/${SSH_LOCAL_PATH}"

	echo "SSH remote user: ${SSH_REMOTE_USER}"

	if [ -f /root/.ssh/id_rsa ]; then
		echo "SSH key found at '/root/.ssh/id_rsa'"
		PLACEHOLDER_SSH_KEY="-o IdentityFile=/root/.ssh/id_rsa"
	else
		PLACEHOLDER_SSH_KEY=""
	fi

	OTHER_OPTIONS="-C -o transform_symlinks -o follow_symlinks -o allow_other -o reconnect -o StrictHostKeyChecking=no -o nonempty"

	if [ -n "${SSH_REMOTE_PASSWORD}" ]; then
		echo "Use ssh password from enviromental variable"
		OTHER_OPTIONS="${OTHER_OPTIONS} -o password_stdin"
	fi

	SSHFS_CMD="sshfs -o ro ${PLACEHOLDER_SSH_KEY} ${PLACEHOLDER_PORT} ${SSH_REMOTE_USER}@${SSH_REMOTE_HOST}:${SSH_REMOTE_PATH} /usr/share/nginx/html/${SSH_LOCAL_PATH} ${OTHER_OPTIONS}"

	if [ -z "${SSH_REMOTE_PASSWORD}" ]; then
		${SSHFS_CMD}
	else
		${SSHFS_CMD} <<-EOF
		${SSH_REMOTE_PASSWORD}
		EOF
	fi

}

function enable_ftp() {
	
	if [ -z "${FTP_REMOTE_HOST}" ]; then
		echo "Enviromental variable FTP_REMOTE_HOST is required, exiting..."
		exit 1
	fi
	echo "FTP remote host: ${FTP_REMOTE_HOST}"

	if [ -z "${FTP_REMOTE_PATH}" ]; then
		echo "Enviromental variable FTP_REMOTE_PATH is required, exiting..."
		exit 1
	fi

	echo "FTP remote path: ${FTP_REMOTE_PATH}"
	if [ -n "${FTP_LOCAL_PATH}" ]; then
		mkdir -p /usr/share/nginx/html/${FTP_LOCAL_PATH}
	fi
	echo "FTP local path: /usr/share/nginx/html/${FTP_LOCAL_PATH}"

	if [ -n "${FTP_REMOTE_USER}" ]; then
		echo "FTP remote user: ${FTP_REMOTE_USER}"
		echo "Use FTP password from enviromental variable"
		cat > ~/.netrc <<-EOF
			machine ${FTP_REMOTE_HOST}
			login ${FTP_REMOTE_USER}
			password ${FTP_REMOTE_PASSWORD}
		EOF
		chmod 600 ~/.netrc
	fi

	OTHER_OPTIONS="-o transform_symlinks -o allow_other -o nonempty"

	FTPFS_CMD="curlftpfs ftp://${FTP_REMOTE_HOST}/${FTP_REMOTE_PATH} /usr/share/nginx/html/${FTP_LOCAL_PATH} ${OTHER_OPTIONS}"

        ${FTPFS_CMD}
}

if [ -n "${SSH_REMOTE_HOST}" ]; then
	enable_ssh
	if [[ $? -ne 0 ]]; then
		echo "SSH Fuse startup error, exiting..."
		exit 1 
	fi
fi

if [ -n "${FTP_REMOTE_HOST}" ]; then
	enable_ftp
	if [[ $? -ne 0 ]]; then
		echo "FTP Fuse startup error, exiting..."
		exit 1 
	fi
fi

if [[ $? -eq 0 ]]; then
	echo "Start nginx"
	exec nginx -g "daemon off;"
fi
