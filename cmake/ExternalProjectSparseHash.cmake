if (APPLE)
ExternalProject_Add(ex_sparsehash
  PREFIX ${CMAKE_SOURCE_DIR}/deps/sparsehash
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/sparsehash-2.0.2.tar.gz
  URL_MD5 1db92ed7f257d9b5f14a309d75e8a1d4
  BUILD_IN_SOURCE 1
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  PATCH_COMMAND patch -N -p1 -i ${CMAKE_SOURCE_DIR}/patches/sparsehash.osx.patch || true
  CONFIGURE_COMMAND ./configure --prefix=<INSTALL_DIR>
  BUILD_COMMAND make -j4
  INSTALL_COMMAND make install)
else()
ExternalProject_Add(ex_sparsehash
  PREFIX ${CMAKE_SOURCE_DIR}/deps/sparsehash
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/sparsehash-2.0.2.tar.gz
  URL_MD5 1db92ed7f257d9b5f14a309d75e8a1d4
  BUILD_IN_SOURCE 1
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  CONFIGURE_COMMAND ./configure --prefix=<INSTALL_DIR>
  BUILD_COMMAND make -j4
  INSTALL_COMMAND make install)
endif()

add_library(sparsehash INTERFACE )
target_compile_definitions(sparsehash INTERFACE HAS_SPARSEHASH)
set(HAS_SPARSEHASH TRUE CACHE BOOL "")
