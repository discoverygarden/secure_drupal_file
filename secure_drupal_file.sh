#!/bin/bash

# This script will lock down the drupal dirs and make them secure

# {{{ set defaults

if [ -f "env.sh" ]
then
  source env.sh
else
  echo -e "${red}Copy default.env.sh to env.sh and set accordingly${NC}"
  exit 1
fi

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
  echo -e "${green}User set to $DRUPAL_OWNER and Group set to $APACHE_USER${NC}"
}

# }}}
# {{{ lockItDown()

lockItDown()
{
  test -f $DRUPAL_DIR/install.php && mv $DRUPAL_DIR/install.php $DRUPAL_DIR/orig.install.bak
  echo -e "${green}Setting ownership to $DRUPAL_OWNER:$APACHE_USER${NC}"
  chown -RL $DRUPAL_OWNER:$APACHE_USER $DRUPAL_DIR
  echo -e "${green}Setting base permissions to dir $ROOT_DIR_PERM and file $ROOT_FILE_PERM${NC}"
  find $DRUPAL_DIR -type d -not -perm $ROOT_DIR_PERM -not -path '*/sites/*/files/*' -exec chmod $ROOT_DIR_PERM '{}' \;
  find $DRUPAL_DIR -type f -not -perm $ROOT_FILE_PERM -not -path '*/sites/*/files/*' -exec chmod $ROOT_FILE_PERM '{}' \;
  chmod 400 $DRUPAL_DIR/orig.install.bak
  find $DRUPAL_DIR/sites -type d -name files -exec chmod $FILE_DIR_PERM '{}' \;
  echo -e "${green}Setting sites/*/files permissions to dir $FILE_DIR_PERM and file $FILE_FILE_PERM${NC}"
  for d in $DRUPAL_DIR/sites/*/files
  do
    find $d -type d -not -perm $FILE_DIR_PERM -exec chmod $FILE_DIR_PERM '{}' \;
    find $d -type f -not -perm $FILE_FILE_PERM -exec chmod $FILE_FILE_PERM '{}' \;
  done
  chmod 440 $DRUPAL_DIR/sites/*/settings.php
  drush -r $DRUPAL_DIR cc all
  echo -e "${green}Complete${NC}"
}

# }}}

setupUsers $1
sanityCheck
lockItDown

