#!/bin/bash
# build_test.sh — Assemble ένα .S αρχείο, μετέτρεψέ το σε .hex,
# και φόρτωσέ το (με backup) στο src/program.hex.
#
# Χρήση:
#   ./build_test.sh test/test.S
#
# Τρέξε το από το root του repo (risk-pipelined-core/).

set -e  # σταμάτα αμέσως αν κάποιο βήμα αποτύχει

if [ -z "$1" ]; then
    echo "Χρήση: $0 <path-to-.S-file>"
    exit 1
fi

SRC_FILE="$1"
BASENAME=$(basename "$SRC_FILE" .S)
DIR=$(dirname "$SRC_FILE")

OBJ_FILE="$DIR/$BASENAME.o"
ELF_FILE="$DIR/$BASENAME.elf"
BIN_FILE="$DIR/$BASENAME.bin"
HEX_FILE="$DIR/$BASENAME.hex"

INSTR_MEM_HEX="src/program.hex"
BACKUP_HEX="src/program.hex.bak"

echo "==> Assembling $SRC_FILE"
riscv-none-elf-as -march=rv32i -mabi=ilp32 -o "$OBJ_FILE" "$SRC_FILE"

echo "==> Linking"
riscv-none-elf-ld -m elf32lriscv -o "$ELF_FILE" "$OBJ_FILE"

echo "==> Converting to raw binary"
riscv-none-elf-objcopy -O binary "$ELF_FILE" "$BIN_FILE"

echo "==> Converting to flat hex ($HEX_FILE)"
xxd -e -g4 -c4 "$BIN_FILE" | awk '{print $2}' > "$HEX_FILE"

echo "==> Backing up current $INSTR_MEM_HEX -> $BACKUP_HEX"
if [ ! -f "$BACKUP_HEX" ]; then
    cp "$INSTR_MEM_HEX" "$BACKUP_HEX"
else
    echo "    (backup already exists, δεν το ξαναγράφω)"
fi

echo "==> Loading $HEX_FILE -> $INSTR_MEM_HEX"
cp "$HEX_FILE" "$INSTR_MEM_HEX"

echo ""
echo "Έτοιμο. Disassembly για έλεγχο:"
riscv-none-elf-objdump -d "$ELF_FILE"

echo ""
echo "Τώρα τρέξε το sim σου κανονικά."
echo "Όταν τελειώσεις, επανάφερε το αρχικό πρόγραμμα με:"
echo "    cp $BACKUP_HEX $INSTR_MEM_HEX"
