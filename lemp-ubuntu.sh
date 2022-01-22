#!/bin/bash
read -p "Enter username for your new database: " -e -i 'root' username
read -p "Enter password for your new database: " -e -i 'root' password
read -p "Enter a path name for your phpmyadmin console page " -e -i 'phpmyadmin' url
read -p "Enter the name of your site directory. It must be saved in /var/www/ " -e -i 'mysite' directory

//TODO: Add option to ask to download wordpress


# Update the package manager cache
sudo apt update 

echo "Updated the package manager cache successfully-----****------"

# Install apache
sudo apt install nginx -y


# Install mariadb server
sudo apt install mariadb-server -y
echo "Installed database succesfully-----****------"

# Create user and password for database
sudo service mysql start
sudo service nginx start
sudo mariadb << dbscript
CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';
GRANT ALL PRIVILEGES ON *.* TO '$username'@'localhost';
FLUSH PRIVILEGES;

//TODO: Delete defulat root user to prevent brute force attack
dbscript

echo "Created db user and password succesfully-----****------"


# Add useful mariadb and apache aliases


echo "alias nrestart='sudo service nginx restart'
alias nstatus='sudo service nginx status'
alias nstop='sudo service nginx stop'
alias wsl='cd /mnt/c/wsl'
alias dbstatus='sudo service mysql status'
alias dbstop='sudo service mysql stop'
alias dbrestart='sudo service mysql restart'" >> ~/.bashrc



# Install php
sudo apt install php-fpm php-mysql -y

# Install Certbot for SSL/TLS certificates
sudo apt install certbot python3-certbot-nginx -y

echo "Installed php modules succesfully-----****------"

# Install phpmyadmin
sudo apt install phpmyadmin -y


#echo "Include /etc/phpmyadmin/apache.conf" | sudo tee -a /etc/apache2/apache2.conf

# Disguise phpmyadmin console page url to prevent brute force attacks
sudo ln -s /usr/share/phpmyadmin /var/www/$directory/$url

# sudo sed -i "s|Alias /phpmyadmin|Alias /$url|" /etc/phpmyadmin/apache.conf


# Restart Apache server and db server for changes to take effect
sudo service nginx restart
sudo service mysql restart

# For nginx server to be able to serve php files
sudo service php7.4-fpm start

# Update current alais cache manually after script has finished running
# cd
# source .bashrc

# Add part to automate phpmyadmin package interactive selections
# phpmyamdin options -> apache2 -> No


