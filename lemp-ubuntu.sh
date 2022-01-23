#!/bin/bash
read -p "Enter username for your new database: " -e -i 'admin' username
read -p "Enter password for your new database: " -e -i 'admin' password
read -p "Enter a path name for your phpmyadmin console page " -e -i 'phpmyadmin' url
read -p "Enter the name of your site directory. It must be saved in /var/www/ " -e -i 'mysite' directory




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

dbscript

echo "Created db user and password succesfully-----****------"

# Disabling Root Login through phpmyadmin for more security to prevent brute force attacks
# Install password generator to set a value for belowfish_secret
# sudo apt install pwgen
# Generate a single -1 random string with a length of 32 characters
#  pwgen -s 32 1
echo '
<?php

    # PhpMyAdmin Settings
    # This should be set to a random string of at least 32 chars
    $cfg['blowfish_secret'] = "Ab59C4mkdrUkO2HljvBf6i1iwo43Ujvd";

    $i=0;
    $i++;

    $cfg['Servers'][$i]['auth_type'] = 'cookie';
    $cfg['Servers'][$i]['AllowNoPassword'] = false;
    $cfg['Servers'][$i]['AllowRoot'] = false;

?>

' | sudo tee -a /etc/phpmyadmin/conf.d/pma_secure.php



# Add useful mariadb and apache aliases


echo "alias nrestart='sudo service nginx restart'
alias nstart='sudo service nginx start'
alias nstatus='sudo service nginx status'
alias nstop='sudo service nginx stop'
alias pstart='sudo service php7.4-fpm start'
alias pstatus='sudo service php7.4-fpm status'
alias pstop='sudo service php7.4-fpm stop'
alias prestart='sudo service php7.4-fpm restart'
alias wsl='cd /mnt/c/wsl'
alias dbstatus='sudo service mysql status'
alias dbstop='sudo service mysql stop'
alias dbstart='sudo service mysql start'
alias restartall='sudo service mysql restart; sudo service php7.4-fpm restart; sudo service nginx restart'
alias startall='sudo service mysql start; sudo service php7.4-fpm start; sudo service nginx start'
alias dbrestart='sudo service mysql restart'" >> ~/.bashrc

source ./bashrc



# Install php
sudo apt install php-fpm php-mysql -y

# Install Certbot for SSL/TLS certificates
sudo apt install certbot python3-certbot-nginx -y

echo "Installed php modules succesfully-----****------"

# Install phpmyadmin
sudo apt install phpmyadmin -y

# Download and Install Wordpress
cd /var/www/html
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -zxvf latest.tar.gz

cd /var/www
sudo chown -R www-data:www-data html
sudo chmod 755 -R html


# Configure Virtual Host for Wordpress site

echo '

# cd /etc/nginx/sites-available
# cat wordpress.conf
server {
            listen 80;
            root /var/www/html/wordpress;
            index index.php index.html;
            server_name mywordpress.local;

	    access_log /var/log/nginx/wordpress.access.log;
    	    error_log /var/log/nginx/wordpress.error.log;

            location / {
                         try_files $uri $uri/ =404;
            }

            location ~ \.php$ {
                         include snippets/fastcgi-php.conf;
                         fastcgi_pass unix:/run/php/php7.4-fpm.sock;
            }
            
            location ~ /\.ht {
                         deny all;
            }

            location = /favicon.ico {
                         log_not_found off;
                         access_log off;
            }

            location = /robots.txt {
                         allow all;
                         log_not_found off;
                         access_log off;
           }
       
            location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                         expires max;
                         log_not_found off;
           }
}


' | sudo tee /etc/nginx/sites-available/wordpress.conf


# Enable new wordpress site

cd /etc/nginx/sites-enabled
sudo ln -s ../sites-available/wordpress.conf .


#echo "Include /etc/phpmyadmin/apache.conf" | sudo tee -a /etc/apache2/apache2.conf

# Disguise phpmyadmin console page url to prevent brute force attacks
sudo ln -s /usr/share/phpmyadmin /var/www/html/$url

# sudo sed -i "s|Alias /phpmyadmin|Alias /$url|" /etc/phpmyadmin/apache.conf


# Restart Apache server and db server for changes to take effect
sudo service nginx restart
sudo service mysql restart

# For nginx server to be able to serve php files
sudo service php7.4-fpm start

# Check the correctness of above configuration file only:
sudo nginx -t

# Check cofiguration and dump configuration files
sudo nginx -T

# Start tracking server error log
sudo tail -f /var/log/nginx/error.log
# echo "Secure your database by answering yes to all and choosing a root password."

# mysql_secure_installation

# Update current alais cache manually after script has finished running
# cd
# source .bashrc

# Add part to automate phpmyadmin package interactive selections
# phpmyamdin options -> apache2 -> No


