#!/usr/bin/env bash
set -euo pipefail

# Compile the .po catalogs into package/contents/locale/ so plasma_install_package bundles them
bash package/translate/build

rm -fr build
mkdir build
pushd build
cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" ..
make
make install
popd
