#!/bin/bash -e
. /etc/profile.d/modules.sh

module add ci
module add cmake
SOURCE_FILE=${NAME}-${VERSION}.tgz

echo "${SOFT_DIR}"
mkdir -p ${WORKSPACE}
mkdir -p ${SRC_DIR}
mkdir -p ${SOFT_DIR}

#  Download the source file
if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "seems like this is the first build - let's geet the source"
  wget http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
else
  echo "continuing from previous builds, using source at " ${SRC_DIR}/${SOURCE_FILE}
fi
tar xzf  ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
mkdir -p ${WORKSPACE}/${VERSION}/build-${BUILD_NUMBER}
cd ${WORKSPACE}/${VERSION}/build-${BUILD_NUMBER}
# This CMake doesn't allow in-source build
cmake ${WORKSPACE}/${VERSION}/$(echo ${NAME}| tr '[:lower:]' '[:upper:]') -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${SOFT_DIR}
make
