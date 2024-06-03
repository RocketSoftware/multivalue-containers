#!/bin/sh

#################################
# Install UniVerse in Container #
#################################

# Get the Universe install file from RBC and place in the shared-data/universe-install-file
# in the project

filetouse=""
BUILD_URL=""

for file in /shared-data/universe-install-file/*
do
    echo "Looking at ${file}"
    if [ "${file: -4}" == ".zip" ]
    then
        echo "Setting BUILDURL to ${file}\n"
        BUILD_URL=$file
    fi
done

echo "BUILD_URL set to ${BUILD_URL}"

if [ "${BUILD_URL: -4}" == ".zip" ]
then
   echo "Good install found."
else
   echo "No install file found in /shared-data/universe-install-file"
   exit 1
fi


TMP_DIR=/data/tmp_dir
mkdir -p $TMP_DIR
cp $BUILD_URL $TMP_DIR
cd $TMP_DIR

# Check UVHOME is set
if [ "$UVHOME" == "" ]; then
  script_name=$(basename "$0")
  echo "$script_name: ERROR - UVHOME is not set. Please set UVHOME and PATH before invoking this script."
  exit 1
fi

build_name=$(basename $BUILD_URL)

case "$build_name" in 
    *Linux*)    echo "build_pack=0 unpack linux build"; build_pack=0 ;;
    *LINUXX86*) echo "build_pack=1 packed linux build"; build_pack=1 ;;
    *)          echo "$build_name is not Linux bulid, exit!"; exit 1 ;;
esac

if [ $build_pack -eq 0 ]; then
    gzip -d  $build_name
    tar -xvf $(basename $build_name .gz)
    cd cdrom
elif [ $build_pack -eq 1 ]; then
    unzip $build_name
fi

cpio -ivcBdum uv.load < STARTUP

cat /dev/null > install.input
echo "1" > install.input
echo "1" >> install.input

sh uv.load < install.input

if [ $? -eq 0 ]; then
    echo "Install UniVerse successful."
    cd $UVHOME
    chmod +x sample/uv.rc
    rm -rf $TMP_DIR
    touch /usr/uv/goodinstall.txt
    exit 0
else
    echo "Install UniVerse failed."
    exit 1
fi
