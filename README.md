# secure_drupal_file
script to secure drupal filesystem

Edit script and ensure you have the appropriate values:

e.g.
DRUPAL_DIR=/var/www/drupal7
APACHE_USER=www-data
DRUPAL_OWNER=root

It is recommended that you run this in a stage/dev system before in production.

Note after running this script you will no longer be able to install modules through the drupal interface. This is due to more restrictive file level permissions.
