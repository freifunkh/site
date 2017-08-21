# build a current ffh gluon

``` shell
# clone gluon
git clone https://github.com/freifunk-gluon/gluon
cd gluon
git checkout v2016.2.x

# clone site conf
git clone https://github.com/freifunkh/site

# apply site patches
cat site/patches/* | git am

# respondd patch from master
git cherry-pick 9a06a9865120747fa5b2d3179936e3b7b169deab

# if you want to test packages in ffh-packages, you
# need to adjust PACKAGES_HANNOVER_COMMIT to the
# lastest commit id in site/modules now
vi site/modules

mkdir logs

make update

# maybe switch here to a screen session ;)
make V=s GLUON_TARGET=ar71xx-generic > logs/$(date -Is)_ar71xx-generic.log
```
