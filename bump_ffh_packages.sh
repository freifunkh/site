#!/bin/sh

packages_path=../ffh-packages/

# stop on error
set -e

new=$(git -C $packages_path rev-parse HEAD)
old=$(awk -F "=" '$1 == "PACKAGES_HANNOVER_COMMIT" { print $2 }' modules)

git pull

sed -i "s/$old/$new/" modules

if [ "$old" == "$new" ]; then
	echo nothing to do!
	exit 0;
fi

log=$(git -C $packages_path log $old..$new --oneline | sed 's_^_  _')

git add modules
git commit -m "modules: bump ffh-packages commit

Shortlog of changes in ffh-packages repo:

$log"

echo
echo "Do not forget to push! ;-)"
