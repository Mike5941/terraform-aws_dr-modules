#!/bin/bash

DB_NAME=${db_name}
DB_USERNAME=${db_username}
DB_PASSWORD=${db_password}
DB_HOST=${db_host}

yum update -y

# Install Apache server
yum install -y httpd

# Install PHP
amazon-linux-extras enable php7.4
yum clean metadata
yum install php php-devel
yum install php-xml -y
sudo yum install php-gd

amazon-linux-extras install -y php7.4
systemctl start httpd
systemctl enable httpd

# Install WordPress
cd /var/www
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php

# Change wp-config with DB details
cp -r wordpress/* /var/www/html/
sed -i "s/database_name_here/$DB_NAME/g" /var/www/html/wp-config.php
sed -i "s/username_here/$DB_USERNAME/g" /var/www/html/wp-config.php
sed -i "s/password_here/$DB_PASSWORD/g" /var/www/html/wp-config.php
sed -i "s/localhost/$DB_HOST/g" /var/www/html/wp-config.php

# Add WP_HOME and WP_SITEURL settings
echo "define('WP_HOME','http://www.wonsoong.cloud');" >> /var/www/html/wp-config.php
echo "define('WP_SITEURL','http://www.wonsoong.cloud');" >> /var/www/html/wp-config.php

# Change httpd.conf file to allow override
sudo sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# Change OWNER and permission of directory /var/www
chown -R apache /var/www
chgrp -R apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.


# User Password

systemctl restart sshd
systemctl restart httpd
systemctl enable httpd
systemctl start httpd
systemctl restart sshd
