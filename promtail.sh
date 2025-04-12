cd /opt

wget https://github.com/grafana/loki/releases/latest/download/promtail-linux-amd64.zip

unzip promtail-linux-amd64.zip

sudo rm promtail-linux-amd64.zip

sudo mv promtail-linux-amd64 /usr/local/bin/promtail

sudo useradd -rs /bin/false promtail

sudo mkdir -p /etc/promtail

cat <<EOF >/etc/promtail/config.yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0
positions:
  filename: /tmp/positions.yaml
clients:
  - url: http://localhost:3100/api/v1/push
scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
      - labels:
          job: varlogs
          __path__: /var/log/*.log
EOF

cat <<EOF >/etc/systemd/system/promtail.service
[Unit]
Description=Promtail service
After=network.target

[Service]
User=promtail
Group=promtail
Type=simple
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail/config.yaml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
