# triggerhappy TinyCore extension

This directory builds a minimal TinyCore 16.1 `.tcz` extension for the
`triggerhappy` daemon on the `6.12.67-pcpCore` kernel. It installs the two
upstream binaries under `/usr/local/sbin` and includes the GPL license.

## Layout

- `build.sh` stages the files and creates the `.tcz` archive.
- `rootfs/` contains the staged filesystem for the extension.
- `triggerhappy.tcz.dep` is the dependency list for the extension.
- `triggerhappy.tcz.list` is the generated file manifest.

## Typical build flow

1. Build the upstream project in the repo root. To reduce complexity,
build on the target hardware and OS (Raspberry Pi Zero W + piCore or piCorePlayer).
   - `tce-load -iw compiletc.tcz`
   - `make PKGCONFIG=false thd th-cmd`
2. Install `squashfs-tools`. This can be on target hardware:
   - `tce-load -iw squashfs-tools.tcz`

   or under WSL2 Ubuntu:  
   - `sudo apt-get update && sudo apt-get install squashfs-tools` 
3. Build the extension:
   - `cd tcz-extension`
   - `./build.sh`
4. Review the generated `.tcz`, `.list`, and `.md5.txt` files.

## Target specifics

- TinyCore: 16.1
- Kernel: 6.12.67-pcpCore
- Install path: `/usr/local/sbin`
- Package format: SquashFS

## Dependency status

Based on the running-target inspection, `ldd` for `thd` and `th-cmd` only
shows the base C runtime and the ARM dynamic loader. There are no separate
TinyCore extension dependencies, so `triggerhappy.tcz.dep` is empty.

## Notes

- `build.sh` expects `thd` and `th-cmd` to have already been built in the
  repository root.

