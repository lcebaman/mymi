#!/bin/sh

#
#  uncomment the following line to enable CrayPat profiling
#  module load perftools-lite-events
#

pushd source
cp -f makefile.cce makefile
make clean
make
popd
