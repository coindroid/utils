#!/bin/bash
# wget -qO- https://raw.githubusercontent.com/coindroid/utils/main/autostart.sh | bash
SERVICE_NAME=${PWD##*/}
SERVICE_SLUG=${SERVICE_NAME// /_}

function systemd_file() {
cat <<EOF > /etc/systemd/system/${SERVICE_SLUG}.service 
[Unit]
Description=${SERVICE_NAME}
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=${PWD}
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF
echo created file /etc/systemd/system/${SERVICE_SLUG}.service
}


if [[ -d /run/systemd/system ]]
then
    systemd_file
    systemctl start ${SERVICE_SLUG}
    systemctl enable ${SERVICE_SLUG}
else
    echo 2
fi
