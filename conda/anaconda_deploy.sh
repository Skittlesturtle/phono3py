#!/bin/bash

export LBL=$1
export TKN=$2
export GIT_BRANCH=$3

cd conda
sed s/version_from_shell/`git describe --tags --dirty | sed -e 's/-\(.*\)-g.*/+\1/' -e 's/^[vr]//g' -e 's/rc-/rc./' -e 's/dirty/0/'`/ meta.yaml 
sed s/version_from_shell/`git describe --tags --dirty | sed -e 's/-\(.*\)-g.*/+\1/' -e 's/^[vr]//g' -e 's/rc-/rc./' -e 's/dirty/0/'`/ meta.yaml > meta.tmp.yaml
mv meta.tmp.yaml meta.yaml
head -n 3 meta.yaml
cd ..
conda install conda-build anaconda-client --yes
conda config --add channels atztogo
conda build conda --no-anaconda-upload
TRG=`conda build conda --output |sed -e 's/--/-*-/'`
echo "Uploading: $TRG"
anaconda --token $TKN upload --label $LBL $TRG
