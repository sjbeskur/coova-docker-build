#/bin/bash
TARGET_DIR=target

if [ ! -d $TARGET_DIR ] ; then
    mkdir $TARGET_DIR
fi
docker build -t coova .
docker run -it --rm -v /$(pwd)/$TARGET_DIR:/target coova

echo "build complete."
ls $TARGET_DIR

