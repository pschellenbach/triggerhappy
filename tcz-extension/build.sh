#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
ROOTFS_DIR="$SCRIPT_DIR/rootfs"
OUT_DIR="${OUT_DIR:-$SCRIPT_DIR}"
PACKAGE_NAME="triggerhappy.tcz"

for file in thd th-cmd COPYING; do
    if [ ! -f "$PROJECT_ROOT/$file" ]; then
        echo "Missing $PROJECT_ROOT/$file" >&2
        echo "Build thd and th-cmd in the repository root before running this script." >&2
        exit 1
    fi
done

if ! command -v mksquashfs >/dev/null 2>&1; then
    echo "mksquashfs is required (load squashfs-tools.tcz)." >&2
    exit 1
fi

mkdir -p \
    "$ROOTFS_DIR/usr/local/sbin" \
    "$ROOTFS_DIR/usr/local/share/doc/triggerhappy" \
    "$OUT_DIR"

install -m 0755 "$PROJECT_ROOT/thd" "$ROOTFS_DIR/usr/local/sbin/thd"
install -m 0755 "$PROJECT_ROOT/th-cmd" "$ROOTFS_DIR/usr/local/sbin/th-cmd"
install -m 0644 "$PROJECT_ROOT/COPYING" \
    "$ROOTFS_DIR/usr/local/share/doc/triggerhappy/COPYING"

(
    cd "$ROOTFS_DIR"
    find usr -not -type d -print | LC_ALL=C sort
) > "$OUT_DIR/${PACKAGE_NAME}.list"

TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/triggerhappy-tcz.XXXXXX")
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM

mksquashfs "$ROOTFS_DIR" "$TMP_DIR/$PACKAGE_NAME" \
    -noappend -b 4K -no-xattrs
mv -f "$TMP_DIR/$PACKAGE_NAME" "$OUT_DIR/$PACKAGE_NAME"

(
    cd "$OUT_DIR"
    md5sum "$PACKAGE_NAME" > "${PACKAGE_NAME}.md5.txt"
)

echo "Built $OUT_DIR/$PACKAGE_NAME"
