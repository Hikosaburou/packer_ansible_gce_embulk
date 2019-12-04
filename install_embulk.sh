#!/bin/bash -ex

sleep 5
sudo sed -e 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/' \
  -e 's/APT::Periodic::Unattended-Upgrade "1";/APT::Periodic::Unattended-Upgrade "0";/' \
  /etc/apt/apt.conf.d/20auto-upgrades -i

sudo apt-get update -y
sudo apt-get install default-jdk -y

sudo adduser --disabled-password --gecos '' embulk

sudo curl --create-dirs -o /home/embulk/.embulk/bin/embulk --silent -L "https://dl.embulk.org/embulk-latest.jar"
sudo chmod +x /home/embulk/.embulk/bin/embulk
sudo sh -c "echo 'export PATH=\"$HOME/.embulk/bin:$PATH\"' >> /home/embulk/.bashrc"
sudo chown -R embulk:embulk /home/embulk/

sudo su - embulk <<EOF
/home/embulk/.embulk/bin/embulk gem install embulk-input-sqlserver
/home/embulk/.embulk/bin/embulk gem install embulk-output-bigquery
EOF