#!/bin/bash
# Builds ClipPress's FFmpeg (Windows x64, shared). Output: dist/ffmpeg-<version>-win64-gpl-shared.zip
# Usage: ./build.sh ["extra configure flags"], for size experiments. Needs Docker.
set -euo pipefail
cd "$(dirname "$0")"
source versions.sh

rm -rf ffbuild dist
mkdir -p ffbuild dist
docker pull "$IMAGE"
docker run --rm -u "$(id -u):$(id -g)" \
    -e FFMPEG_COMMIT="$FFMPEG_COMMIT" \
    -e CLIPPRESS_FLAGS="$(grep -v '^#' configure-flags.txt | tr '\n' ' ')" \
    -e EXTRA_CONFIGURE="${1:-}" \
    -v "$PWD/ffbuild:/ffbuild" -v "$PWD/inside-image.sh:/inside-image.sh:ro" \
    "$IMAGE" bash /inside-image.sh

VERSION="$(cat ffbuild/version.txt)"
NAME="ffmpeg-${VERSION}-win64-gpl-shared"
mkdir -p "dist/$NAME/bin"
cp ffbuild/prefix/bin/ffmpeg.exe ffbuild/prefix/bin/ffprobe.exe ffbuild/prefix/bin/*.dll "dist/$NAME/bin"
cp ffbuild/ffmpeg/COPYING.GPLv2 "dist/$NAME/LICENSE.txt"
(cd dist && zip -9 -q -r "$NAME.zip" "$NAME" && rm -rf "$NAME")
ls -l dist
