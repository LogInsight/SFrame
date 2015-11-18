set(EXTRA_CONFIGURE_FLAGS "")
if(WIN32 AND ${MSYS_MAKEFILES})
  set(EXTRA_CONFIGURE_FLAGS --build=x86_64-w64-mingw32)
endif()

ExternalProject_Add(ex_libxml2
  PREFIX ${CMAKE_SOURCE_DIR}/deps/libxml2
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/libxml2-2.9.1.tar.gz
  URL_MD5 9c0cfef285d5c4a5c80d00904ddab380
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  CONFIGURE_COMMAND CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} CFLAGS=-fPIC CPPFLAGS=-fPIC <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --enable-shared=no --enable-static=yes --with-python=./ --without-lzma --libdir=<INSTALL_DIR>/lib ${EXTRA_CONFIGURE_FLAGS}
  )
# the with-python=./ prevents it from trying to build/install some python stuff
# which is poorly installed (always ways to stick it in a system directory)
include_directories(${CMAKE_SOURCE_DIR}/deps/local/include/libxml2)

add_library(libxml2a STATIC IMPORTED)
set_property(TARGET libxml2a PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libxml2.a)

add_library(libxml2 INTERFACE )
target_link_libraries(libxml2 INTERFACE libxml2a z)
if(WIN32)
  target_link_libraries(libxml2 INTERFACE iconv ws2_32)
endif()
target_compile_definitions(libxml2 INTERFACE HAS_LIBXML2)
set(HAS_LIBXML2 TRUE CACHE BOOL "")
