#!/bin/bash
# Runs inside the build image: the image's environment has the compiler and its FF_* settings.
set -xe
cd /ffbuild
git clone --filter=blob:none --branch=release/9.0 https://github.com/FFmpeg/FFmpeg.git ffmpeg
cd ffmpeg
git checkout "$FFMPEG_COMMIT"

./configure --prefix=/ffbuild/prefix --pkg-config-flags="--static" $FFBUILD_TARGET_FLAGS $FF_CONFIGURE $CLIPPRESS_FLAGS $EXTRA_CONFIGURE \
    --extra-cflags="$FF_CFLAGS" --extra-cxxflags="$FF_CXXFLAGS" --extra-libs="$FF_LIBS" \
    --extra-ldflags="$FF_LDFLAGS" --extra-ldexeflags="$FF_LDEXEFLAGS" \
    --cc="$CC" --cxx="$CXX" --ar="$AR" --ranlib="$RANLIB" --nm="$NM" \
    --extra-version=clippress || { cat ffbuild/config.log; exit 1; }
make -j"$(nproc)"
make install
ffbuild/version.sh . > /ffbuild/version.txt

# So the source bundle can be checked against what the image really linked.
grep -H '^Version' /opt/ffbuild/lib/pkgconfig/x264.pc /opt/ffbuild/lib/pkgconfig/x265.pc /opt/ffbuild/lib/pkgconfig/SvtAv1Enc.pc || true
