# Patches

As gluon, this repo is upstream-first.
Which means, if a patch can be upstreamed to gluon, it should be.


## Patches in Gluons repo

Whenever Gluon implements changes that cannot be upstreamed to OpenWrt or related repos (yet),
Patchfiles are created and tracked in a subdir of the `patches`-folder in the gluon repo.

Patches in that repo have to be structured in a specific way.
There's a helper in the gluon repo, which reformats them accordingly,
available by calling `make refresh-patches`.

After calling it, the file is in the desired format, but uncommitted.
Commit them (if necessary using `--amend`, if the commit that created italready exists).

## Patches in this repo

Our patches are similar:

Whenever we implement changes that cannot be upstreamed to Gluon (yet),
Patchfiles are created and tracked in the `patches`-folder in this repo.

We structure these patches the very same way gluon does.
There's again a helper in this repo, which formats them as intended.
available by calling `refresh_ffh_patches.sh`.

Calling it does change the files in the patch folder if necessary, but does not commit them.
That's your task again.


## Careful

Working with these helpers is a fast and powerful workflow;
which means you can break things fast.

Make sure you have **no uncommited changes** in the respective repo, before calling either of them.
That way recovering and assessing the situation is easy using git.


## A clean patch

If the folder contains only clean patches, calling either helper does not change anything.
So calling them before pushing is a good way to make sure the GitHub actions will run through.


# Use-cases

## Updating a patch

If we want to change an exiting patch of ours, we apply the *existing* patches to the proper gluon-branch can then alter the commits appropriately.
After commiting the gluon changes using `--amend` we can then create a patch of it using `git format-patch`, and replace the old patch version with it.
Now comes the new part: call `refresh_ffh_patches.sh` to have the script reformat it appropriately.
This will minimize the differences to previous versions of the patches, regardless which OS we use to create them.

## Gluon added a patch itself

The action will fail, if tat breaks the order of existing patches.
renaming the numbers manually and then fixing the script again will do the trick.
