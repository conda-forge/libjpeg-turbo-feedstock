#!/bin/bash

mkdir "$SRC_DIR/stage"

mkdir build_libjpeg && cd  build_libjpeg

cmake ${CMAKE_ARGS} -D CMAKE_INSTALL_PREFIX="$SRC_DIR/stage" \
      -D CMAKE_INSTALL_LIBDIR="$SRC_DIR/stage/lib" \
      -D CMAKE_BUILD_TYPE=Release \
      -D ENABLE_STATIC=0 \
      -D ENABLE_SHARED=1 \
      -D WITH_JPEG8=1 \
      -D CMAKE_ASM_NASM_COMPILER=yasm \
      $SRC_DIR

make -j$CPU_COUNT
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
ctest
fi
make install -j$CPU_COUNT

# We can remove this when we start using the new conda-build.
find $SRC_DIR/stage -name '*.la' -delete

sed -i.bak "s,$SRC_DIR/stage,/opt/anaconda1anaconda2anaconda3,g" $SRC_DIR/stage/lib/pkgconfig/*.pc
rm $SRC_DIR/stage/lib/pkgconfig/*.bak
