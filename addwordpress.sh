# This is script is to automate downloading wordpress and setting up virtual host to Apache Linux server

# Download and Install Wordpress
cd /var/www
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -zxvf latest.tar.gz
sudo rm latest.tar.gz

cd /var/www
sudo chown -R www-data:www-data wordpress
sudo chmod 755 -R wordpress

