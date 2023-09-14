sudo ufw --force enable

sudo ufw allow 5432/tcp
sudo ufw allow 5000/tcp

sudo ufw status

sudo ufw reload