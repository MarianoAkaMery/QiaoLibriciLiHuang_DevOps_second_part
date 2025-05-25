#!/usr/bin/env bash
###############################################################################
# build.sh – one-shot local build helper
#   • out-of-source CMake build in ./build
#   • puts the final binary (convert_grayscale) back in the repo root
###############################################################################
set -euo pipefail

log () { printf '\033[1;34m[%s] %s\033[0m\n' "$(date +'%F %T')" "$*"; }
[[ "${DEBUG_PIPE:-0}" == "1" ]] && set -x

log "🔧  Configuring with CMake …"
mkdir -p build
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release

log "🏗️   Compiling …"
cmake --build build -- -j"$(nproc)"

# copy the freshly-built artefacts where the container expects them
log "📦  Staging binaries …"
cp -v build/convert_grayscale  .

log "✅  Build complete – binary is now at ./convert_grayscale"
