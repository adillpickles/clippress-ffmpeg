# FFmpeg for ClipPress

The FFmpeg that [ClipPress](https://github.com/adillpickles/ClipPress) ships on Windows: FFmpeg 9.0 with every native
codec, format and filter, and only the external libraries ClipPress can reach.

Each release has the build and its complete source: FFmpeg, every library linked into it at the exact commit used, and
the scripts that built them. That archive is the GPL source offer for the FFmpeg in ClipPress.

- `configure-flags.txt`: what's left out, and why.
- `versions.sh`: the pinned build image and FFmpeg commit. The image is
  [BtbN's FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds), unchanged. Only FFmpeg's configure flags differ.
- `build.sh` makes the zip (needs Docker). `collect-sources.sh` makes the source archive.

To publish, run the "Build FFmpeg" workflow with a release tag.

FFmpeg in these builds is licensed under the GNU GPL version 2 or later. These scripts are under the same licence.
