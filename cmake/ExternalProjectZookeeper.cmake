set(EXTRA_CONFIGURE_FLAGS "")

if(WIN32 AND ${MSYS_MAKEFILES})
message(STATUS "Zookeeper build not supported on Windows")
else()
ExternalProject_Add(ex_zookeeper
  PREFIX ${CMAKE_SOURCE_DIR}/deps/zookeeper
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/zookeeper-3.4.6-patch0.tar.gz
  URL_MD5 00e8300f8f3a87277ae31e6bb711e9df
  PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/patches/zookeeper/ <SOURCE_DIR>
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND CFLAGS=-fPIC CPPFLAGS=-fPIC CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} ./configure --prefix=<INSTALL_DIR> --disable-shared ${EXTRA_CONFIGURE_FLAGS}
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local)

add_library(libzookeeper_mta STATIC IMPORTED)
set_property(TARGET libzookeeper_mta PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libzookeeper_mt.a)

add_library(zookeeper INTERFACE )
target_link_libraries(zookeeper INTERFACE libzookeeper_mta)
target_compile_definitions(zookeeper INTERFACE HAS_ZOOKEEPER)
set(HAS_ZOOKEEPER TRUE CACHE BOOL "")
endif()
