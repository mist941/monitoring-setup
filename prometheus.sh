cd /opt

sudo wget https://github.com/prometheus/prometheus/releases/download/v3.2.1/prometheus-3.2.1.linux-amd64.tar.gz

sudo tar -xzf prometheus-3.2.1.linux-amd64.tar.gz

sudo rm prometheus-3.2.1.linux-amd64.tar.gz

sudo mv prometheus-3.2.1.linux-amd64 prometheus

sudo useradd -rs /bin/false prometheus

sudo mkdir -p /etc/prometheus /var/lib/prometheus

cd prometheus

sudo cp prometheus.yml /etc/prometheus/

sudo cp prometheus /usr/local/bin/

sudo cp promtool /usr/local/bin/

cd /opt

sudo mv prometheus /usr/local
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

sudo cat <<EOF >/etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/ \
  --web.console.templates=/opt/prometheus/consoles \
  --web.console.libraries=/opt/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl enable prometheus

sudo systemctl start prometheus

# check http://localhost:9090
