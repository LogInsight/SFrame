
# libbz  =================================================================
if (WIN32 AND ${MINGW_MAKEFILES})
ExternalProject_Add(ex_libbz2
  PREFIX ${CMAKE_SOURCE_DIR}/deps/libbz2
  URL http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
  URL_MD5 00b516f4704d4a7cb50a1d97e6e8e15b
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  CONFIGURE_COMMAND ""
  PATCH_COMMAND patch -N -p0 -i ${CMAKE_SOURCE_DIR}/patches/libbz2_fpic.patch || true
  BUILD_IN_SOURCE 1
  BUILD_COMMAND SET CC=${CMAKE_C_COMPILER} & SET CXX=${CMAKE_CXX_COMPILER} & mingw32-make install PREFIX=<INSTALL_DIR>
  INSTALL_COMMAND "" )
else()
ExternalProject_Add(ex_libbz2
  PREFIX ${CMAKE_SOURCE_DIR}/deps/libbz2
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/bzip2-1.0.6.tar.gz
  URL_MD5 00b516f4704d4a7cb50a1d97e6e8e15b
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  CONFIGURE_COMMAND ""
  PATCH_COMMAND patch -N -p0 -i ${CMAKE_SOURCE_DIR}/patches/libbz2_fpic.patch || true
  BUILD_IN_SOURCE 1
  BUILD_COMMAND CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} make install PREFIX=<INSTALL_DIR>
  INSTALL_COMMAND "" )
endif()

add_library(libbz2a STATIC IMPORTED)
set_property(TARGET libbz2a PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libbz2.a)

add_library(libbz2 INTERFACE )
target_link_libraries(libbz2 INTERFACE libbz2a)
target_compile_definitions(libbz2 INTERFACE HAS_LIBBZ2)
set(HAS_LIBBZ2 TRUE CACHE BOOL "")

