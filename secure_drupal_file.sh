#/bin/bash
DRUPAL_DIR=/var/www/drupal7
cd $DRUPAL_DIR
rm install.php
chown -R root:www-data .
find . -type d -exec chmod u=rwx,g=rx,o= '{}' \;
find . -type f -exec chmod u=rw,g=r,o= '{}' \;
cd $DRUPAL_DIR/sites
find . -type d -name files -exec chmod ug=rwx,o= '{}' \;
for d in ./*/files
do
   find $d -type d -exec chmod ug=rwx,o= '{}' \;
   find $d -type f -exec chmod ug=rw,o= '{}' \;
done
chmod 440 ./*/settings.php
cd /var/www/drupal7
drush cc all
