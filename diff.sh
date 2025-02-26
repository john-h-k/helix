#!/bin/bash

set -e

diff_file="diff.md"


git log upstream..master --pretty=format:"- [%h](/../../commit/%h) %s" > "$diff_file"
gsed -i '/^-.*auto-diff$/d' $diff_file

git restore -SWs upstream/master README.md

tmp="$(mktemp)"
trap 'rm -rf -- "$tmp"' EXIT

echo -e "# Diff against \`helix/master\`:\n" >> $tmp
cat $diff_file >> $tmp
echo -e "\n\n" >> $tmp
cat README.md >> $tmp

cp $tmp README.md

git add diff.md diff.sh README.md
git commit -m "auto-diff"

echo "Commit titles saved to $diff_file, README update"
