cd /opt

sudo wget https://dl.grafana.com/oss/release/grafana-11.6.0.linux-amd64.tar.gz

sudo tar -zxf grafana-11.6.0.linux-amd64.tar.gz

sudo rm grafana-11.6.0.linux-amd64.tar.gz

sudo mv grafana-v11.6.0 grafana

sudo useradd -rs /bin/false grafana

sudo mkdir -p /etc/grafana

sudo cp grafana/conf/defaults.ini /etc/grafana/grafana.ini

sudo mv grafana /usr/local

sudo chown -R grafana:grafana /usr/local/grafana

sudo cat <<EOF >/etc/systemd/system/grafana.service
[Unit]
Description=Grafana Server
After=network.target

[Service]
Type=simple
User=grafana
Group=grafana
ExecStart=/usr/local/grafana/bin/grafana server --config=/etc/grafana/grafana.ini --homepath=/usr/local/grafana
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl enable grafana

sudo systemctl start grafana

# check http://localhost:3000
