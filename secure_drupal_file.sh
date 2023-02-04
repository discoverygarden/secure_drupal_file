#!/bin/bash

# This script will lock down the drupal dirs and make them secure

# {{{ set defaults

DRUPAL_DIR=/var/www/drupal7
ROOT_DIR_PERM=750
ROOT_FILE_PERM=640

FILE_DIR_PERM=770
FILE_FILE_PERM=660

# }}}
# {{{ setupUsers()

setupUsers()
{
  # set apache user
  getent passwd www-data > /dev/null
  if [ $? -eq "0" ]; then
    APACHE_USER="www-data"
  else
  getent passwd apache > /dev/null
  if [ $? -eq "0" ]; then
    APACHE_USER="apache"
  fi
  fi

  #set owner
  if [ -n "$1" ]; then
    DRUPAL_OWNER="$1"
  else
    DRUPAL_OWNER=root
  fi
}

# }}}
# {{{ sanityCheck()

sanityCheck()
{
  if [ ! -d $DRUPAL_DIR ]; then
   echo "DRUPAL_DIR not set properly recheck before running script"
   exit 1
  fi

  if [ -z $APACHE_USER ]; then
    echo "APACHE_USER not set properly"
  exit 1
  fi

  getent passwd $DRUPAL_OWNER > /dev/null
  if [ $? -ne "0" ]; then
    echo "DRUPAL_OWNER does not exist on this server"
    exit 1
  fi
}

# }}}
# {{{ lockItDown()

lockItDown()
{
  test -f $DRUPAL_DIR/install.php && mv $DRUPAL_DIR/install.php $DRUPAL_DIR/orig.install.bak
  chown -RL $DRUPAL_OWNER:$APACHE_USER $DRUPAL_DIR
  find $DRUPAL_DIR -type d -not -perm $ROOT_DIR_PERM -not -path '*/sites/*/files/*' -exec chmod $ROOT_DIR_PERM '{}' \;
  find $DRUPAL_DIR -type f -not -perm $ROOT_FILE_PERM -not -path '*/sites/*/files/*' -exec chmod $ROOT_FILE_PERM '{}' \;
  chmod 400 $DRUPAL_DIR/orig.install.bak
  find $DRUPAL_DIR/sites -type d -name files -exec chmod $FILE_DIR_PERM '{}' \;
  for d in $DRUPAL_DIR/sites/*/files
  do
    find $d -type d -not -perm $FILE_DIR_PERM -exec chmod $FILE_DIR_PERM '{}' \;
    find $d -type f -not -perm $FILE_FILE_PERM -exec chmod $FILE_FILE_PERM '{}' \;
  done
  chmod 440 $DRUPAL_DIR/sites/*/settings.php
  drush -r $DRUPAL_DIR cc all
}

# }}}

setupUsers $1
sanityCheck
lockItDown

