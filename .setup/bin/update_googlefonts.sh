#!/usr/bin/env bash

# Updates dependencies from Google APIs/fonts

set -e

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
DEST=${THIS_DIR}/../../site/public/vendor/google

rm -rf ${DEST}
mkdir -p ${DEST}

wget https://fonts.googleapis.com/css?family=Inconsolata -O ${DEST}/inconsolata.css
wget https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic,700italic -O ${DEST}/source_sans_pro.css
wget https://fonts.googleapis.com/css?family=PT+Sans:700,700italic -O ${DEST}/pt_sans.css

# Prepend quick line so people know how to update these
files=( inconsolata pt_sans source_sans_pro )
for i in "${files[@]}"; do
echo "/* Generated by .setup/bin/update_googlefonts.sh */" | cat - ${DEST}/${i}.css > /tmp/out && mv /tmp/out ${DEST}/${i}.css
    grep -o 'url(https://.*.ttf)' ${DEST}/${i}.css | while read -r line; do
        line=${line:4:-1}
        short=$(echo ${line} | egrep -o '[0-9a-zA-Z\_\-]+\.ttf')
        wget -P ${DEST} ${line}
        sed -i "s ${line} ${short} " ${DEST}/${i}.css
    done    
done
