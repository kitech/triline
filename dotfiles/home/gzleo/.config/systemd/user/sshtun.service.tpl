[Unit]
Description=A special mitm with pac daemon
After=network.target

[Service]
Type=fork
# User=nobody
# Environment="DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-XXBRdFQxlY,guid=adc3d044b0c8e6fb961e747a55d7ef59"
ExecStart=/usr/bin/plink -pw abc -P 29354 -C -l gzleo -N -L 8112:127.0.0.1:8118 45.78.18.135
ExecStop=
# ExecReload=
# Restart=on-failure|on-abnormal

[Install]
# WantedBy=multi-user.target
WantedBy=default.target

