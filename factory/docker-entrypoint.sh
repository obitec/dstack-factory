#!/bin/bash

echo "Update env"

pip install -U pip wheel
pip wheel cython
pip install cython
pip wheel numpy
pip install numpy
ln -s /env/bin/f2py3.5 /env/bin/f2py

while read p; do pip wheel $p; done < requirements.txt;

pip freeze > /wheelhouse/installed.txt

echo "Done!"

