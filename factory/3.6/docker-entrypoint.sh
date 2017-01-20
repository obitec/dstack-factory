#!/bin/bash

echo "Update env"

# If pip is outdated, rebuild the factory
# pip install -U pip wheel


# This is/was? needed because cython and numpy was required to already be
# installed for many other packages to be build, but cython/numpy's setup.py
# did not/does not specify this dependency
C_EXTENSION=${CEXT:-True}

if [ "$C_EXTENSION" = "True" ]
then
    pip wheel cython
    pip install cython
    pip wheel numpy
    pip install numpy
fi

# Either install dependencies from a requirements.txt file, or build them from a
# wheel packages's install_requires. If all dependencies are installable from pypi,
# then the latter is the prefered method.
BUILD_REQUIREMENTS=${BUILD_REQ:-True}

if [ "$BUILD_REQUIREMENTS" = "True" ]
then
    pip wheel $(cat ${RECIPE:-requirements}.txt | grep -v ^# | xargs)
else
    pip wheel /wheelhouse/${RECIPE:-*}.whl
fi

rsync -av /wheelhouse/ /archive

echo "Done!"

