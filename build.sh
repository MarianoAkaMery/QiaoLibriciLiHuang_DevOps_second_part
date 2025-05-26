#!/bin/bash
set -e

# Start from a clean slate so CMake never points to host paths
rm -rf build

mkdir -p build && cd build
cmake ..
cmake --build .
cd ..

echo "Build complete; binaries are in build/"
