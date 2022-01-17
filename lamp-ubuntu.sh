#!/bin/bash
read -p "Enter username for your new database: " username
read -p "Enter password for your new database: " password
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
alias dbrestart='sudo service mysql restart'" >> ~/.bashrc

source ~/.bashrc

# Install php
sudo apt install php libapache2-mod-php php-mysql -y

echo "Installed php modules succesfully-----****------"

# Install phpmyadmin
sudo apt install phpmyadmin -y

echo "Include /etc/phpmyadmin/apache.conf" | sudo tee -a /etc/apache2/apache2.conf
sudo service apache2 restart




# phpmyamdin options -> apache2 -> No


