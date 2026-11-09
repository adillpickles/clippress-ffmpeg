#!/bin/bash
# GPL corresponding source: FFmpeg, every library linked into this build at the exact commit the image used, and the
# scripts that built them. Output: dist-source/ffmpeg-clippress-source.tar.xz
set -euo pipefail
cd "$(dirname "$0")"
ROOT="$PWD"
source versions.sh

retry-tool() {
    local attempt
    for attempt in 1 2 3 4 5; do
        "$@" && return 0
        sleep $((attempt * 10))
    done
    return 1
}
git-mini-clone() {
    git init -q "$3"
    git -C "$3" remote add origin "$1"
    retry-tool git -C "$3" fetch -q --depth=1 origin "$2"
    git -C "$3" -c advice.detachedHead=false checkout -q FETCH_HEAD
}
export -f retry-tool git-mini-clone

WORK="$ROOT/source-work"
OUT="$WORK/ffmpeg-clippress-source"
rm -rf "$WORK" dist-source
mkdir -p "$OUT/libraries" dist-source

git clone -q --filter=blob:none https://github.com/BtbN/FFmpeg-Builds.git "$WORK/btbn"
git -C "$WORK/btbn" -c advice.detachedHead=false checkout -q "$BTBN_COMMIT"
mkdir "$OUT/btbn-build-scripts"
git -C "$WORK/btbn" archive HEAD | tar -x -C "$OUT/btbn-build-scripts"

git-mini-clone https://github.com/FFmpeg/FFmpeg.git "$FFMPEG_COMMIT" "$WORK/ffmpeg"
mkdir "$OUT/ffmpeg"
git -C "$WORK/ffmpeg" archive HEAD | tar -x -C "$OUT/ffmpeg"

# Every library the configure flags leave in.
for script in 20-libiconv 20-zlib 25-libxml2 25-xz 25-libogg 45-libvorbis 50-libtheora 50-amf 50-avisynth 50-dav1d \
    50-ffnvcodec 50-libmp3lame 50-libopus 50-libvpx 50-libwebp 50-onevpl 50-openapv 50-snappy 50-svtav1 50-vapoursynth \
    50-vvenc 50-x264 50-x265; do
    dest="$OUT/libraries/$script"
    mkdir -p "$dest"
    (
        cd "$dest"
        source "$WORK/btbn/util/dl_functions.sh"
        source "$WORK/btbn/scripts.d/$script.sh"
        eval "$(ffbuild_dockerdl)"
    )
    find "$dest" -name .git -prune -exec rm -rf {} +
done

cp versions.sh configure-flags.txt inside-image.sh build.sh collect-sources.sh README.md "$OUT"
tar -I 'xz -T0' -cf dist-source/ffmpeg-clippress-source.tar.xz -C "$WORK" ffmpeg-clippress-source
ls -l dist-source
du -sh "$OUT"/libraries/* | sort -h | tail -8
