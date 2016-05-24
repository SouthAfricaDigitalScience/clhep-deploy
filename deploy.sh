#!/bin/bash -e
# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
module add deploy
module add cmake
module add  gcc/${GCC_VERSION}
cd ${WORKSPACE}/${VERSION}/build-${BUILD_NUMBER}
echo "All tests have passed, will now build into ${SOFT_DIR}"
rm -rf *
cmake ${WORKSPACE}/${VERSION}/${NAME} -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${SOFT_DIR}
make -j2

echo "Creating the modules file directory ${LIBRARIES_MODULES}"
mkdir -p ${LIBRARIES_MODULES}/${NAME}
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION : See https://github.com/SouthAfricaDigitalScience/clhep-deploy"
setenv CLHEP_VERSION       $VERSION
setenv CLHEP_DIR           $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION-gcc-${GCC_VERSION}
prepend-path LD_LIBRARY_PATH   $::env(CLHEP_DIR)/lib
prepend-path CFLAGS            "-I${CLHEP_DIR}/include"
prepend-path LDFLAGS           "-L${CLHEP_DIR}/lib"
prepend-path PATH              $::env(CLHEP_DIR)/bin
MODULE_FILE
) > modules/$VERSION-gcc-${GCC_VERSION}

mkdir -p ${HEP_MODULES}/${NAME}
cp modules/$VERSION ${HEP_MODULES}/${NAME}-gcc-${GCC_VERSION}


module add ${NAME}-gcc-${GCC_VERSION}
which clhep-config
