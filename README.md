## well-known branches

|    Branch Name   |       Description      |                Builds Against the Following Gluon Version                |            Used For           |
|:----------------:|:----------------------:|:------------------------------------------------------------------------:|:-----------------------------:|
| master-wireguard |                        |                                  main| nightly builds, manual builds |
| stable-wireguard |  mostly latest release | [See here](https://hannover.freifunk.net/wiki/Freifunk/FirmwareReleases) |    manual builds, releases    |
|       next       | currently not used yet |                                   next                                   |         manual builds         |

## prerequisites

- You need to have docker installed on your system.

## build a current ffh gluon

``` shell
# clone gluon
git clone https://github.com/freifunk-gluon/gluon
cd gluon
git checkout main

# clone site conf
git clone https://github.com/freifunkh/site

# apply site patches
git am site/patches/*

# if you want to test packages in ffh-packages, you
# need to adjust PACKAGES_HANNOVER_COMMIT to the
# lastest commit id in site/modules now
vi site/modules

# if you want to bump up the version number
vi site/site.mk

# Enter the container, which includes all build dependencies
./scripts/container.sh

# Obtain all "submodules" of gluon
make update

# List targets and pick your favorite one.
make list-targets

# maybe switch here to a screen session, if
# you are building on a remote system ;)

make -j $(nproc) GLUON_TARGET=ath79-generic
```

## build all targets

``` shell
TARGETS=$(make list-targets)

for t in $TARGETS; do
  make -j $(nproc) GLUON_TARGET=${t}
done
```

## build for debugging purposes

- Debugging symbols are not stripped while building. (At least you still need to compile the package with `-g` to get the debug symbols, but they are not stripped)
- Packages `gdb`, `valgrind` and `strace` will be built in the image

``` shell
make V=s GLUON_DEBUG=1 GLUON_TARGET=x86-generic &> logs/$(date -Is)_x86-generic.log
```
