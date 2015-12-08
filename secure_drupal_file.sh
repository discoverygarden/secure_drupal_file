#/bin/bash
DRUPAL_DIR=/test/directory
APACHE_USER=www-data
DRUPAL_OWNER=root
if [ ! -d $DRUPAL_DIR ]; then
   echo "DRUPAL_DIR not set properly recheck before running script"
   exit 1
fi
mv $DRUPAL_DIR/install.php $DRUPAL_DIR/orig.install.bak
chown -R $DRUPAL_OWNER:$APACHE_USER $DRUPAL_DIR
find $DRUPAL_DIR -type d -exec chmod u=rwx,g=rx,o= '{}' \;
find $DRUPAL_DIR -type f -exec chmod u=rw,g=r,o= '{}' \;
chmod 400 $DRUPAL_DIR/orig.install.bak
find $DRUPAL_DIR/sites -type d -name files -exec chmod ug=rwx,o= '{}' \;
for d in $DRUPAL_DIR/sites/*/files
do
   find $d -type d -exec chmod ug=rwx,o= '{}' \;
   find $d -type f -exec chmod ug=rw,o= '{}' \;
done
chmod 440 $DRUPAL_DIR/sites/*/settings.php
drush -r $DRUPAL_DIR cc all
