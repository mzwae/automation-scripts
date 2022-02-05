# This is script is to automate downloading moodle and setting up virtual host to Apache Linux server

# Download and Install moodle
cd /var/www
# sudo wget http://sourceforge.net/projects/moodle/files/Moodle/stable24/moodle-latest-24.tgz
# sudo wget https://github.com/moodleou/moodle-qtype_opaque/zipball/master
# sudo tar -zxvf moodle-latest-24.tgz
# sudo rm moodle-latest-24.tgz

# cd /var/www
# sudo chown -R www-data:www-data moodle
# sudo chmod 755 -R moodle

git clone git@github.com:moodle/moodle.git