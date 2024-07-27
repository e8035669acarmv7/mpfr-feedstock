#!/bin/bash

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* . || true

if [[ "$target_platform" == "win-64" ]]; then
  export PREFIX=${PREFIX}/Library
fi

./configure --prefix=$PREFIX \
            --with-gmp=$PREFIX \
            --disable-static \
            --enable-thread-safe

make -j${CPU_COUNT}
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != 1 ]]; then
  make check
fi
make install
