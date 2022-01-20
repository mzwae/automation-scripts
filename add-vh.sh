#!/bin/bash
read -p "Enter your site name. " -e -i 'mysite.com.conf' sitename
read -p "Enter your site directory name. It should be saved in /var/www before you run this script: " -e -i 'mysite'  directory
read -p "Enter your site domain name.  " -e -i 'mysite.com' domain
read -p "Enter site admin email.  " -e -i 'webmaster@localhost' email

#touch | sudo tee /etc/apache2/sites-available/"$sitename"

sudo chown -R www-data:www-data /var/www/$directory

echo "<VirtualHost *:80>


        ServerAdmin $email
        DocumentRoot /var/www/$directory

        ServerName $domain
        ServerAlias www.$domain


        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost> " | sudo tee  /etc/apache2/sites-available/"$sitename"


# Disable default site
sudo a2dissite 000-default.conf

# enable new site to be able to deploy it
sudo a2ensite $sitename

# Restart server for changes to take effect
sudo service apache2 restart