#!/usr/bin/bash
set -e

URL=`curl https://quicksync.io/crypto.json | jq -r '.[] | select(.file=="crypto-org-chain-mainnet-1-pruned") | .url'`

echo -e "-= Move to ~/.chain-maind/ =-"
cd ~/.chain-maind/

echo -e "-= Download latest CDC QuickSync from ${URL} =-"
echo -e "-= This will take a long time, and require 50+ GB of disk space =-"
aria2c -x5 $URL

echo -e "-= Extract QuickSync =-"
lz4 -d `basename $URL` | tar xf -
