#!/bin/bash -e
. /etc/profile.d/modules.sh
module add ci
module add cmake
cd ${WORKSPACE}/${VERSION}/build-${BUILD_NUMBER}
make test

echo $?

make install
mkdir -p ${REPO_DIR}
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}
module add gcc/${GCC_VERSION}
module-whatis   "$NAME $VERSION."
setenv       CLHEP_VERSION       $VERSION
setenv       CLHEP_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION-gcc-${GCC_VERSION}
prepend-path LD_LIBRARY_PATH   $::env(CLHEP_DIR)/lib
prepend-path CFLAGS            "-I${CLHEP_DIR}/include"
prepend-path LDFLAGS           "-L${CLHEP_DIR}/lib"
prepend-path PATH              $::env(CLHEP_DIR)/bin
MODULE_FILE
) > modules/$VERSION-gcc-${GCC_VERSION}

mkdir -p ${HEP_MODULES}/${NAME}
cp modules/$VERSION ${HEP_MODULES}/${NAME}-gcc-${GCC_VERSION}
