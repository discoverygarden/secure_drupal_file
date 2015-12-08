#/bin/bash
DRUPAL_DIR=/var/www/drupal7
APACHE_USER=www-data
DRUPAL_OWNER=root
cd $DRUPAL_DIR
mv install.php orig.install.bak
chmod 400 orig.install.bak
chown -R $DRUPAL_OWNER:$APACHE_USER .
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
cd $DRUPAL_DIR
drush cc all
