# This script is to automate downloading moodle and setting up virtual host to Apache Linux server

# Install required php modules
sudo apt install php-intl php-xmlrpc php-soap -y

cd /var/www

sudo mkdir moodledata

sudo git clone git@github.com:moodle/moodle.git

sudo chown -R www-data:www-data moodle moodledata