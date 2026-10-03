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

1. Build the upstream project in the repo root:
   - `make`
2. Run:
   - `./build.sh`
3. Review the generated `.tcz`, `.list`, and `.md5.txt` files.

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
- Load `squashfs-tools.tcz` before running the packaging script.
