cd /opt

sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz

sudo tar -xzf node_exporter-1.9.1.linux-amd64.tar.gz

sudo mv node_exporter-1.9.1.linux-amd64 node_exporter

sudo rm node_exporter-1.9.1.linux-amd64.tar.gz

sudo mv node_exporter /usr/local/bin/

sudo useradd -rs /bin/false node_exporter

cat <<EOF >/etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl start node_exporter

sudo systemctl enable node_exporter
