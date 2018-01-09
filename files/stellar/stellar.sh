#!/bin/bash

# setup Stellar PATH
export PATH=/net/pipeline/bin:/usr/lib64/qt-3.3/bin:/opt/puppetlabs/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# Install rv handlers
if [ ! -e $HOME/.local/share/applications/rv.desktop ]
then
   ${RV_LOCATION}/rv.install_handler
   ${RV_LOCATION}/rv.install_handler_rvpush
   echo "RV handlers installed"
fi
