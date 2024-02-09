#!/usr/bin/env bash

DIRS=(
    "data/asm"
    "data/ref"
    "data/ref_gff"
    "data/vcf_dbs"
    "output"
    "output/logging"
    "src"
)

FA_KEY="data/fa_keyfile.csv"

INIT_LOG="output/logging/init.log"

SRC_USR="bm646"
SRC_SRV_IP="cbsublfs1.biohpc.cornell.edu"
SRC_SRV="$SRC_USR@$SRC_SRV_IP:/data4/users/wiese/common-bean/vanessa"

DEST_DIR="data"
DEST_ASM_DIR="$DEST_DIR/asm"
DEST_REF_DIR="$DEST_DIR/ref"
DEST_REF_GFF_DIR="$DEST_DIR/ref_gff"

PHG_SRC="src/phg/bin/phg"
PHG_DB_DIR="data/vcf_dbs"