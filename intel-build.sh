#!/bin/sh

. ${MODULESHOME}/init/sh
module swap PrgEnv-cray PrgEnv-intel

pushd source
cp -f makefile.intel makefile
make clean
make
popd
