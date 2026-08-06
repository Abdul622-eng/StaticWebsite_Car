#!/bin/bash

apt update -y

apt install docker.io git -y

systemctl start docker

systemctl enable docker

cd /home/ubuntu

git clone https://github.com/Kphanendra/StaticWebsite_Car.git

cd StaticWebsite_Car

docker build -t website .

docker run -d -p 80:80 website