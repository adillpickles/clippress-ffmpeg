# What every build is made from. Change these together, on purpose.
# BtbN's public image with the libraries and compiler. Its "latest" changes, so it's pinned by digest.
IMAGE=ghcr.io/btbn/ffmpeg-builds/win64-gpl-shared-9.0@sha256:ba54e4fbc11c41879b156b02ec498610b40b080ffde42637af0aec781b0d3b7b
# The BtbN/FFmpeg-Builds commit that image was made from: its scripts name each library's exact source.
BTBN_COMMIT=5ece62897c650b863c1ddda7b6964845344aef2d
# FFmpeg release/9.0, the same commit ClipPress shipped in Beta 6.7.
FFMPEG_COMMIT=ae19868753c5bcc2044e331d7a64187e58dde619
