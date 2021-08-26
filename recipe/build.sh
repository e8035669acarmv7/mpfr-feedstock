#!/bin/bash

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* . || true

if [[ "$target_platform" == "win-64" ]]; then
  export CPPFLAGS="$CPPFLAGS -DMSC_USE_DLL"
  sed -i.bak "s@-Wl,--output-def,.libs/libmpfr-6.dll.def@@g" configure
  sed -i.bak "s@ -version-info [0-9\:]\+@ -avoid-version@g" src/Makefile.in
fi

./configure --prefix=$PREFIX \
            --with-gmp=$PREFIX \
            --disable-static

[[ "$target_platform" == "win-64" ]] && patch_libtool

make -j${CPU_COUNT}
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != 1 ]]; then
  make check
fi
make install

if [[ "$target_platform" == "win-64" ]]; then
  cp $PREFIX/bin/mpfr.dll $PREFIX/bin/mpfr-6.dll
fi
