#!/bin/bash

set -xeuo pipefail

# NOTE: CXXFLAGS carry GCC-only flags; clang warns about -fno-merge-constants,
# which makes CMake's check_cxx_compiler_flag treat every --offload-arch test as failed
export CXXFLAGS="${CXXFLAGS//-fno-merge-constants/}"

GPU_LIST="gfx900;gfx906;gfx908;gfx90a;gfx942;gfx950;gfx1030;gfx1100;gfx1101;gfx1102;gfx1150;gfx1151;gfx1152;gfx1153;gfx1200;gfx1201;gfx1250"

cmake -GNinja ${CMAKE_ARGS} \
    -DCMAKE_CXX_COMPILER=${BUILD_PREFIX}/bin/hipcc \
    -DROCFFT_KERNEL_CACHE_ENABLE:BOOL=OFF \
    -DSQLITE_USE_SYSTEM_PACKAGE:BOOL=ON \
    -DGPU_TARGETS=${GPU_LIST} \
    -DAMDGPU_TARGETS=${GPU_LIST} \
    -Bbuild -S.

cmake --build ./build
cmake --install ./build
