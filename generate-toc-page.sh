#!/bin/bash
set -eu

fname="source/tois.rst"
nbpath="source/objects"

function generate_toc_page {
cat << EOF
List of all analysed objects
----------------------------

$(for item in "$nbpath"/toi_*.ipynb; do \
  number=$(echo "$item" | sed 's/\.ipynb//g' | sed 's/source\/objects\/toi_//g'); \
  echo "- :doc:\`TOI $number <objects/toi_$number>\`"; \
done | sort -V)

EOF
}

newtocpage=$(generate_toc_page)

if [ ! -f "$fname" ] || ! echo "$newtocpage" | diff -q "$fname" - &> /dev/null ; then
  echo "===> Writing $fname"
  echo "$newtocpage" > "$fname"
else
  echo "==> $fname has not changed"
fi
