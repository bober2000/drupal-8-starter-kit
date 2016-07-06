#!/bin/sh

#install backdrop
sh $ZENCI_DEPLOY_DIR/scripts/drupal_install.sh

echo "Full site path: $DOCROOT"

# Go to domain directory.
cd $DOCROOT


echo "Linking modules from $ZENCI_DEPLOY_DIR"

mkdir -p $DOCROOT/modules/contrib
mkdir -p $DOCROOT/themes/contrib
mkdir -p $DOCROOT/libraries

cd $DOCROOT/modules
ln -s $ZENCI_DEPLOY_DIR/modules ./custom

cd $DOCROOT/themes
ln -s $ZENCI_DEPLOY_DIR/themes ./custom

cd $DOCROOT/libraries
ln -s $ZENCI_DEPLOY_DIR/libraries ./custom


echo "Enable Modules & themes"
cd $DOCROOT

for project in `cat $ZENCI_DEPLOY_DIR/settings/enable.list`; do
  drush -y en $project
done

if [ "$DEFAULT_THEME" != "" ]; then
  echo "Set default theme"
  drush -y en $DEFAULT_THEME
  drush -y cset system.theme default $DEFAULT_THEME
fi

if [ "$ENABLE_DEVEL" != "" ]; then
  drush dl devel
  drush -y en devel devel_generate
  drush generate-content 100
  drush generate-users 100
fi
