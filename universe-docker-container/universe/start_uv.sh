#!/bin/sh

##################################
# Start UniVerse in Docker Image #
##################################

# Check that UVHOME is set
if [ "$UVHOME" == "" ]; then
  script_name=$(basename "$0")
  echo "$script_name: ERROR - UVHOME is not set. Please set UVHOME and PATH before invoking this script."
  exit 1
fi

export PATH=$PATH:$UVHOME/bin

# Check for /data.  This is where accounts should be.  You should have mounted some persistant storage
# for this.  Otherwise your account information is in the container.  

if [ ! -d "/data" ]
then
   mkdir /data
fi

# The following script will only run on a new container.  It writes out the dockersetup.txt file and therefore
# it will only run once.

if [ ! -f "/usr/uv/dockersetup.txt" ]
then
   chmod u+x /usr/local/bin/*uv.sh
   install_uv.sh "$BUILD_URL"
   if [ ! -f "/usr/uv/goodinstall.txt" ]
   then
      echo "Universe not installed"
      exit 1
   fi
   touch /usr/uv/dockersetup.txt
   echo "*** Checking for auto-install directory ***"

   # The following area is an example on how to setup new accounts
   # or move/link items from UVHOME.  This example only runs
   # once in a new container.

   if [ -d "/shared-data/auto-install" ]
   then
      echo "auto install items"
      cd /data
      tar xvzf /shared-data/auto-install/accuterm.tgz -C /
      # This is a option for dynamic items in /usr/uv.  Move them
      # to your persistent data location or copy your own
      # version from your repository.  In this case a UV.ACCOUNT
      # was modified to have the accuterm account.  This was
      # saved in the repository and this script will move it
      # to /data/universe, remove the one in /usr/uv and
      # replace it with a soft link to our version.
      mkdir /data/universe
      cp /shared-data/auto-install/UV.ACCOUNT /data/universe
      rm /usr/uv/UV.ACCOUNT
      ln -s /data/universe/UV.ACCOUNT /usr/uv/UV.ACCOUNT
   fi

fi

# This is an example to automatically create accounts
# By looking for a directory you can build new accounts
# on existing containers without a rebuild of the container
# This logic looks for the directory vs above where it
# it is only done if dockersetup.txt has not been done.

#if [ ! -d "/data/myaccount" ]
#then
#   mkdir /data/myaccount
#   Untar the backup from /shared-data/auto-install directory
#fi

cd $UVHOME
mkdir /tmp/uvcs
# This line will setup debug logging for Unirpc.
echo "uvcs 10 /tmp/uvcs/uvcs.log" > /usr/uv/serverdebug

bin/uv -revno

#This is an example of how you can automate installing the license.  You will
#have 10 days to authorize the account

#bin/uvregen -s licenseno -e expdate -u #users -p CONNPL:# -p UVNET:# -d #Devices -p AUDIT:1 or 0

# The following lines will restart Universe.  This is required with new uvregen work
uv -admin -stop -force
uv -admin -start

# Some installs are not allowing ssh logins by default.  The following line will
# remove the nologin script.
rm -rf /run/nologin
/usr/sbin/sshd -D
