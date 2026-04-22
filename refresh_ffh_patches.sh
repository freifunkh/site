#!/bin/bash

set -e
shopt -s nullglob

# create patchdir
PATCHDIR=patching
mkdir -p "$PATCHDIR"
trap 'rm -rf "$PATCHDIR"' EXIT

prefixfilename() {
	prefix="$1"
	file="$2"
	mv $(dirname "$file")/$(basename "$file") $(dirname "$file")/${prefix}$(basename "$file")
}

# clone gluon
git clone --depth 1 --single-branch https://github.com/freifunk-gluon/gluon.git $PATCHDIR

cd $PATCHDIR

git branch base >/dev/null
git checkout -B patched >/dev/null

# apply all site patches
for patch in "../patches"/*.patch; do
	git -c user.name='Freifunkh Patch Manager' -c user.email='freifunkh@void.example.com' -c commit.gpgsign=false am --whitespace=nowarn --committer-date-is-author-date "$patch"
	# we prefix all of the patches in our patches, such
	# that order of gluons upstream patches does not get
	# disturbed by our patches...
	for file in $(git diff --cached --name-only --diff-filter=A -z HEAD^ -- 'patches/*' | strings); do
		prefixfilename "zzz-" "$file"
	done
	make refresh-patches GLUON_SITEDIR=../
	git add patches/
	git commit --amend --no-edit
done


# recreate site patches from just created commits
n=0
for commit in $(git rev-list --reverse --no-merges base..patched); do
	(( ++n ))
	echo "Updating: $(git log --format=%s -n 1 "$commit")"
	git -c core.abbrev=40 show --pretty=format:'From: %an <%ae>%nDate: %aD%nSubject: %B' --no-renames --binary "$commit" > "../patches/$(printf '%04u' "$n")-$(git show -s --pretty=format:%f "$commit").patch"
done

cd ..

rm -rf "$PATCHDIR"

