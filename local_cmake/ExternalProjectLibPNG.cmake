set(EXTRA_CONFIGURE_FLAGS "")
if(WIN32 AND ${MSYS_MAKEFILES})
  set(EXTRA_CONFIGURE_FLAGS --build=x86_64-w64-mingw32)
endif()

ExternalProject_Add(ex_libpng
  PREFIX ${CMAKE_SOURCE_DIR}/deps/libpng
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/libpng-1.6.14.tar.gz
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  CONFIGURE_COMMAND CFLAGS=-fPIC CPPFLAGS=-fPIC <SOURCE_DIR>/configure --enable-shared=no --prefix=<INSTALL_DIR> ${EXTRA_CONFIGURE_FLAGS}
  INSTALL_COMMAND make install
  BUILD_IN_SOURCE 1)

add_library(libpnga STATIC IMPORTED)
set_property(TARGET libpnga PROPERTY INTERFACE_LINK_LIBRARIES z)
set_property(TARGET libpnga PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libpng.a)

add_library(libpng INTERFACE )
target_link_libraries(libpng INTERFACE libpnga)
target_compile_definitions(libpng INTERFACE HAS_LIBPNG)
set(HAS_LIBPNG TRUE CACHE BOOL "")
