#!/bin/bash
sudo su - 
cd ~
version="${VERSION:-0.16.0}"
arch="${ARCH:-linux-amd64}"

mkdir -p node_exporter
cd node_exporter || { echo "ERROR! No node_exporter found.."; exit 1; }

wget "https://github.com/prometheus/node_exporter/releases/download/v$version/node_exporter-$version.$arch.tar.gz"

tar xfz node_exporter-$version.$arch.tar.gz || { echo "ERROR! Extracting the node_exporter tar"; exit 1; }

ln -s node_exporter-$version.$arch node_exporter

mv node_exporter-$version.$arch/node_exporter /usr/local/bin/

cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=root
Restart=on-failure
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter.service
systemctl start node_exporter.service

echo "SUCCESS! Installation succeeded!"
