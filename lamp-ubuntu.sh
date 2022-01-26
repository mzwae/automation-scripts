#!/bin/bash
read -p "Enter username for your new database: " -e -i 'root' username
read -p "Enter password for your new database: " -e -i 'root' password
read -p "Enter a path name for your phpmyadmin console page " -e -i 'phpmyadmin' url


# Reboot automatically after 20 seconds if kernel panic occurs
echo "kernel.panic = 20" | sudo tee -a /etc/sysctl.conf 

# Rereads configuration without rebooting
sysctl -p

# Update the package manager cache
sudo apt update 

echo "Updated the package manager cache successfully-----****------"

# Install apache
sudo apt install apache2 -y

echo "Installed apache server succesfully-----****------"

# Install apache security module to be able to hide server type
sudo apt install libapache2-mod-security2 -y
sudo a2enmod security2

echo "Installed apache security module succesfully-----****------"


echo "
<IfModule security2_module>
    SecRuleEngine on
    ServerTokens Full
    SecServerSignature 'Microsoft-IIS/10.0'
</IfModule>

" | sudo tee -a /etc/apache2/apache2.conf

echo "Changed server type for security successfully-----****------"

# Install mariadb server
sudo apt install mariadb-server -y
echo "Installed database succesfully-----****------"

# Create user and password for database
sudo service mysql start
sudo service apache2 start
sudo mariadb << dbscript
CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';
GRANT ALL PRIVILEGES ON *.* TO '$username'@'localhost';
FLUSH PRIVILEGES;
dbscript

echo "Created db user and password succesfully-----****------"

# Add useful mariadb and apache aliases


echo "alias a2restart='sudo service apache2 restart'
alias a2status='sudo service apache2 status'
alias a2stop='sudo service apache2 stop'
alias wsl='cd /mnt/c/wsl'
alias dbstatus='sudo service mysql status'
alias dbstop='sudo service mysql stop'
alias restartall='sudo service mysql restart; sudo service apache2 restart'
alias startall='sudo service mysql start; sudo service apache2 start'
alias stopall='sudo service mysql stop; sudo service apache2 stop'
alias statusall='sudo service mysql status; sudo service apache2 status'
alias sslrenew='sudo certbot renew --force-renewal'
alias sslshow='sudo certbot certificates'
alias dbrestart='sudo service mysql restart'" >> ~/.bashrc



# Install php
sudo apt install php libapache2-mod-php php-mysql -y

# Install Certbot for SSL/TLS certificates
sudo apt install certbot python3-certbot-apache -y

echo "Installed php modules succesfully-----****------"

# Install phpmyadmin
sudo apt install phpmyadmin -y

echo "Include /etc/phpmyadmin/apache.conf" | sudo tee -a /etc/apache2/apache2.conf

# Disguise phpmyadmin console page url to annoy hackers
sudo sed -i "s|Alias /phpmyadmin|Alias /$url|" /etc/phpmyadmin/apache.conf

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


# Download and Install Wordpress
cd /var/www
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -zxvf latest.tar.gz
sudo rm latest.tar.gz

cd /var/www
sudo chown -R www-data:www-data wordpress
sudo chmod 755 -R wordpress

# Restart Apache server and db server for changes to take effect
sudo service apache2 restart
sudo service mysql restart

# Check apache2 server configuration
sudo apache2 -t

# Follow the server error log
sudo tail -f /var/log/apache2/error.log

# Update current alais cache manually after script has finished running
# cd
# source .bashrc

# Add part to automate phpmyadmin package interactive selections
# phpmyamdin options -> apache2 -> No


