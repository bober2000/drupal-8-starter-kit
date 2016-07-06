#!/bin/sh

echo "Disable devel"
#remove devel module

drush -y pm-uninstall devel
