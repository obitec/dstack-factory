#!/bin/bash

echo "Update env"

pip install -U pip wheel
if [ "$CEXT" = "True" ]
then
    pip wheel cython
    pip install cython
    pip wheel numpy
    pip install numpy
#    ln -s /env/bin/f2py3.5 /env/bin/f2py
fi

#while read p; do pip wheel $p; done < requirements.txt;
pip wheel $(cat requirements.txt | grep -v ^# | xargs)

rsync -av /wheelhouse/ /archive

echo "Done!"

