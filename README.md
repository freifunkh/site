# build a current ffh gluon

``` shell
# clone gluon
git clone https://github.com/freifunk-gluon/gluon
cd gluon
git checkout v2016.2.x

# respondd patches
git cherry-pick 9a06a9865120747fa5b2d3179936e3b7b169deab
curl https://paste.irrelefant.net/Eet3Uoth.txt | git am

# clone site conf
git clone https://github.com/freifunkh/site

# if you want to test packages in ffh-packages, you
# need to adjust PACKAGES_HANNOVER_COMMIT in site/modules here
vi site/modules

mkdir logs

make update

make V=s GLUON_TARGET=ar71xx-generic > logs/$(date -Is)_ar71xx-generic.log
```
