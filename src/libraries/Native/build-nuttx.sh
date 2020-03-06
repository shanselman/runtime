set -xe

scriptdir="$( cd "$(dirname "$0")" ; pwd -P )"

mkdir -p $scriptdir/build
cd $scriptdir/build

# Generate version.c
__versionSourceLine="static char sccsid[] __attribute__((used)) = \"@(#)No version information produced\";"
__versionSourceFile=$scriptdir/build/version.c
echo $__versionSourceLine > $__versionSourceFile

export CC=/usr/local/bin/arm-none-eabi-gcc
export CXX=/usr/local/bin/arm-none-eabi-g++
export VERSION_FILE_PATH=$scriptdir/build/version.c
export CLR_ENG_NATIVE_DIR=$scriptdir/../../../eng/native
SRC_NATIVE_UNIX_PATH=$scriptdir/Unix
NUTTX_PATH=$scriptdir/../../../../nuttx
cmake \
    -DCMAKE_BUILD_TYPE=DEBUG -DCMAKE_STATIC_LIB_LINK=1 -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
    -DCLR_CMAKE_HOST_OS=NuttX -DCLR_CMAKE_TARGET_OS=NuttX -DCLR_CMAKE_TARGET_ARCH=arm \
    -DCLR_ENG_NATIVE_DIR=$CLR_ENG_NATIVE_DIR \
    -DCMAKE_C_COMPILER_WORKS=1 \
    -DCMAKE_TOOLCHAIN_FILE=$scriptdir/arm-gcc-toolchain.cmake \
    -DNUTTX_PATH=$NUTTX_PATH \
    -DFEATURE_DISTRO_AGNOSTIC_SSL=0  \
    $SRC_NATIVE_UNIX_PATH
VERBOSE=1 make -j8
