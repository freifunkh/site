# build a current ffh gluon

``` shell
# clone gluon
git clone https://github.com/freifunk-gluon/gluon
cd gluon
git checkout v2016.2.x

# clone site conf
git clone https://github.com/freifunkh/site

# apply site patches
git am site/patches/*

# if you want to test packages in ffh-packages, you
# need to adjust PACKAGES_HANNOVER_COMMIT to the
# lastest commit id in site/modules now
vi site/modules

mkdir logs

make update

# maybe switch here to a screen session ;)
make V=s GLUON_TARGET=ar71xx-generic GLUON_BRANCH=stable > logs/$(date -Is)_ar71xx-generic.log

```

# build all targets

``` shell
TARGETS="ar71xx-nand mpc85xx-generic x86-generic x86-kvm_guest x86-64 x86-xen_domu"

for t in $TARGETS; do
  make V=s GLUON_TARGET=${t} GLUON_BRANCH=stable > logs/$(date -Is)_${t}.log
done
```
