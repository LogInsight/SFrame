set(SODIUM_CC "${CMAKE_C_COMPILER} -fPIC")

set(EXTRA_CONFIGURE_FLAGS "")
if(WIN32 AND ${MSYS_MAKEFILES})
  set(EXTRA_CONFIGURE_FLAGS --build=x86_64-w64-mingw32 --enable-shared=yes)
else()
  set(EXTRA_CONFIGURE_FLAGS --enable-static=yes --enable-shared=no)
endif()

ExternalProject_Add(ex_libsodium
  PREFIX ${CMAKE_SOURCE_DIR}/deps/libsodium
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/libsodium-0.7.1.tar.gz
  URL_MD5 c224fe3923d1dcfe418c65c8a7246316
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  CONFIGURE_COMMAND ${BASH_LOCATION} <SOURCE_DIR>/configure CFLAGS=-fPIC CPPFLAGS=-fPIC --enable-pie --with-pic --prefix=<INSTALL_DIR> --libdir=<INSTALL_DIR>/lib ${EXTRA_CONFIGURE_FLAGS}
  PATCH_COMMAND patch -N -p1 -i ${CMAKE_SOURCE_DIR}/patches/libsodium.patch || true
  BUILD_IN_SOURCE 1
  BUILD_COMMAND make 
  INSTALL_COMMAND make install )

add_library(libsodiuma STATIC IMPORTED)
set_property(TARGET libsodiuma PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libsodium.a)

add_library(libsodium INTERFACE )
target_link_libraries(libsodium INTERFACE libsodiuma)
target_compile_definitions(libsodium INTERFACE HAS_LIBSODIUM)
set(HAS_LIBSODIUM TRUE CACHE BOOL "")
