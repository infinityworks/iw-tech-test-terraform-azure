#! /bin/bash
sudo apt-get update
sudo apt-get install apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo ufw allow 'Apache Full'