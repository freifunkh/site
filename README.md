# build a current ffh gluon

``` shell
# clone gluon
git clone https://github.com/freifunk-gluon/gluon
cd gluon
git checkout master

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

mkdir logs

make update

# maybe switch here to a screen session ;)
make V=s GLUON_TARGET=ar71xx-generic GLUON_BRANCH=stable &> logs/$(date -Is)_ar71xx-generic.log

```

# build all targets

``` shell
TARGETS="ar71xx-nand mpc85xx-generic x86-generic x86-kvm_guest x86-64 x86-xen_domu"

for t in $TARGETS; do
  make V=s GLUON_TARGET=${t} GLUON_BRANCH=stable &> logs/$(date -Is)_${t}.log
done
```

# build for debugging purposes

- Debugging symbols are not stripped while building. (At least you still need to compile the package with `-g` to get the debug symbols, but they are not stripped)
- Packages `gdb`, `valgrind` and `strace` will be built in the image

``` shell
make V=s GLUON_DEBUG=1 GLUON_TARGET=x86-generic GLUON_BRANCH=stable &> logs/$(date -Is)_x86-generic.log
```
