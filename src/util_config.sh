#!/usr/bin/env bash

DIRECTORIES=(
    "data/ref"
    "data/asm"
    "src"
    "output"
)

FA_KEY="data/fa_keyfile.csv"

SOURCE_USER="bm646"
SOURCE_SERVER_IP="cbsublfs1.biohpc.cornell.edu"
SOURCE_SERVER="$SOURCE_USER@$SOURCE_SERVER_IP:/data4/users/wiese/common-bean/vanessa"

DESTINATION_DIRECTORY="data"
REF_DESTINATION_DIRECTORY="$DESTINATION_DIRECTORY/ref"
ASM_DESTINATION_DIRECTORY="$DESTINATION_DIRECTORY/asm"