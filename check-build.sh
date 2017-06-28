#!/bin/bash -e
. /etc/profile.d/modules.sh
module add ci
module add cmake
module add  gcc/${GCC_VERSION}
cd ${WORKSPACE}/${VERSION}/build-${BUILD_NUMBER}
make test

echo $?

echo "Making install"
make install
echo "Making module"
mkdir -vp modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}
module-whatis   "$NAME $VERSION."
setenv       CLHEP_VERSION       $VERSION
setenv       CLHEP_DIR           /data/ci-build/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(CLHEP_DIR)/lib
prepend-path CFLAGS            "-I${CLHEP_DIR}/include"
prepend-path LDFLAGS           "-L${CLHEP_DIR}/lib"
prepend-path PATH              $::env(CLHEP_DIR)/bin
MODULE_FILE
) > modules/${VERSION}-gcc-${GCC_VERSION}

echo "HEP/NAME is ${HEP}/${NAME}"
mkdir -p ${HEP}/${NAME}-gcc-${GCC_VERSION}
cp -v modules/$VERSION-gcc-${GCC_VERSION} ${HEP}/${NAME}
module avail ${NAME}
module add  ${NAME}/${VERSION}-gcc-${GCC_VERSION}
