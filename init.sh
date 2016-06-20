#! /bin/bash

if [ -z "${REMOTE_URL}" ]; then
    echo "Enviromental variable REMOTE_URL is required, exiting..."
    exit 1
fi
echo "Remote url: ${REMOTE_URL}"

if [ -n "${REMOTE_PORT}" ]; then
  echo "REmote port: ${REMOTE_PORT}"
  PLACEHOLDER_PORT="-p ${REMOTE_PORT} "
else
  PLACEHOLDER_PORT=""
fi

if [ -z "${REMOTE_PATH}" ]; then
    echo "Enviromental variable REMOTE_PATH is required, exiting..."
    exit 1
fi

echo "Remote path: ${REMOTE_PATH}"
mkdir -p ${REMOTE_PATH}

echo "Remote user: ${REMOTE_USER}"

if [ -f /root/.ssh/id_rsa ]; then
  echo "Ssh key found at '/root/.ssh/id_rsa'"
  PLACEHOLDER_SSH_KEY="-o IdentityFile=/root/.ssh/id_rsa"
else
  PLACEHOLDER_SSH_KEY=""
fi

OTHER_OPTIONS="-C -o transform_symlinks -o follow_symlinks -o allow_other -o reconnect -o StrictHostKeyChecking=no -o nonempty"

if [ -n "${REMOTE_PASSWORD}" ]; then
    echo "Use password from enviromental variable"
    OTHER_OPTIONS="${OTHER_OPTIONS} -o password_stdin"
fi

SSHFS_CMD="sshfs -o ro ${PLACEHOLDER_SSH_KEY} ${PLACEHOLDER_PORT} ${REMOTE_USER}@${REMOTE_URL}:${REMOTE_PATH} /usr/share/nginx/html ${OTHER_OPTIONS}"

if [ -z "${REMOTE_PASSWORD}" ]; then
    ${SSHFS_CMD}
else
    ${SSHFS_CMD} <<EOF
${REMOTE_PASSWORD}
EOF
fi

if [[ $? -eq 0 ]]; then
  echo "Start nginx"
  nginx -g "daemon off;"
fi
