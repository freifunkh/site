#!/bin/bash

set -e
shopt -s nullglob

# create patchdir
PATCHDIR=patching
mkdir -p "$PATCHDIR"
trap 'rm -rf "$PATCHDIR"' EXIT

# clone gluon
git clone --depth 1 --single-branch https://github.com/freifunk-gluon/gluon.git $PATCHDIR

cd $PATCHDIR

# apply all site patches
for patch in "../patches"/*.patch; do
	git -c user.name='Freifunkh Patch Manager' -c user.email='freifunkh@void.example.com' -c commit.gpgsign=false am --whitespace=nowarn --committer-date-is-author-date "$patch"
done

git checkout -B patched >/dev/null

# recreate site patches from just created commits
n=0
for commit in $(git rev-list --reverse --no-merges origin/HEAD..patched); do
	(( ++n ))
	echo "Updating: $(git log --format=%s -n 1 "$commit")"
	git -c core.abbrev=40 show --pretty=format:'From: %an <%ae>%nDate: %aD%nSubject: %B' --no-renames --binary "$commit" > "../patches/$(printf '%04u' "$n")-$(git show -s --pretty=format:%f "$commit").patch"
done

cd ..

rm -rf "$PATCHDIR"

