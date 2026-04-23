#!/bin/sh

remote=root@web.ffh.zone
port=1337

set -e
cd "$(dirname $0)"

# this is where the path to your secret is stored (not the secret itself)
config=~/.config/ffhsite/config.sh

if ! test -f ${config}; then
	mkdir -p "$(dirname ${config})"
	echo "SECRET_PATH=" > ${config}
	echo "GLUON_PATH=$(realpath "$(pwd)/../")" >> ${config}
	echo "You did not have ${config} yet, I created one."
	echo
	echo "Please adjust SECRET_PATH inside this file to match where your secret lies."
	exit 1
fi

source ${config}
if [ "$SECRET_PATH" = "" ]; then
	echo "Error: SECRET_PATH in $config is empty."
	echo
	echo "Please adjust it to match where your secret lies."
	exit 2
fi

if ! test -f "$SECRET_PATH"; then
	echo "Error: The SECRET_PATH $SECRET_PATH specified in $config does not exist."
	echo
	echo "Please adjust it to match where your secret lies."
	exit 3
fi

SIGN="$GLUON_PATH/contrib/sign.sh"
if ! test -f "$SIGN"; then
	echo "Error: The file $SIGN does not exist."
	echo
	echo "Please adjust GLUON_PATH in $config to match where Gluon is located."
	exit 4
fi

if [ "$#" -lt 1 ]; then
	echo "ERROR: usage $0 VERSION [BRANCH]" 1>&2
	echo "" 1>&2
	echo "(BRANCH is guessed automatically, but you can specify manually also.)"
	echo
	echo "Example: $0 vH41~3" 2>&2
	exit 5
fi


version=$1

if [ "$#" -ge 2 ]; then
	branch=$2
elif [[ "$version" == *~* ]]; then
	echo Guessing branch: beta
	branch=beta
else
	echo Guessing branch: wireguard
	branch=wireguard
fi

set -e

remotepath=/var/www/domains/raw-firmware.ffh.zone/${version}/sysupgrade/${branch}.manifest
tmp=$(mktemp -d)
tmpfile=${tmp}/${branch}.manifest

echo Using remote path $remotepath
echo Using local path ${tmpfile}
echo
echo Downloading:
scp -P ${port} ${remote}:$remotepath ${tmpfile}
echo

awk '/.*/ { if (start) print $0 } /^---$/ { start=1 }' ${tmpfile} > ${tmp}/signatures.before

sh $SIGN ${SECRET_PATH} ${tmpfile}

NEWSIG=$(tail -n 1 ${tmpfile})
if grep -q "$NEWSIG" ${tmp}/signatures.before; then
	echo "Aborting: you already signed this in the past ;)"
	exit 6
fi

echo Uploading:
scp -P ${port} ${tmpfile} ${remote}:$remotepath

rm -r ${tmp}
