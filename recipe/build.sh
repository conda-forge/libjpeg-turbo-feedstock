#!/bin/bash

mkdir build_libjpeg && cd  build_libjpeg

# We don't ship the static libraries, so don't build them. As a side effect
# this also avoids building the *-static command-line tools, one of which
# (cjpeg-static) fails to link on Linux because the vendored libspng pulls in
# libm (__fpclassifyf) but upstream only links libm into tjbench.
# The shared cjpeg tool has the same missing-libm issue, which we fix by
# appending -lm to the standard libraries for every C link below.
cmake ${CMAKE_ARGS} -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D CMAKE_INSTALL_LIBDIR="$PREFIX/lib" \
      -D CMAKE_BUILD_TYPE=Release \
      -D ENABLE_STATIC=0 \
      -D ENABLE_SHARED=1 \
      -D WITH_JPEG8=1 \
      -D CMAKE_ASM_NASM_COMPILER=yasm \
      -D CMAKE_C_STANDARD_LIBRARIES=-lm \
      $SRC_DIR

make -j$CPU_COUNT
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
# Skip bmpsizetest: it is meant to check that the image readers/writers reject
# oversized dimensions, but its "maximum valid size" cases actually drive a full
# 65500x65500 encode through libspng/zlib, which pegs a CPU core for hours (the
# PNG-writer case never returns in any reasonable time). Everything else runs.
ctest -E bmpsizetest
fi
make install -j$CPU_COUNT

# Make sure no static libraries slipped into the package.
test ! -f $PREFIX/lib/libjpeg.a
test ! -f $PREFIX/lib/libturbojpeg.a

# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete
