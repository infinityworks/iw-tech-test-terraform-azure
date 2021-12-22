#! /bin/bash 
sudo apt-get update /n
sudo apt-get install apache2 /n
sudo systemctl start apache2 /n
sudo systemctl enable apache2 /n
sudo ufw allow 'Apache Full'