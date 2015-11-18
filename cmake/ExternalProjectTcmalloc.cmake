# TCMalloc  ===================================================================
# We use tcmalloc for improved memory allocation performance
if(CLANG)
  SET(TCMALLOC_COMPILE_FLAGS "-stdlib=libc++ -fPIC")
  SET(TCMALLOC_C_FLAGS "-fPIC")
  ExternalProject_Add(ex_tcmalloc
    PREFIX ${CMAKE_SOURCE_DIR}/deps/tcmalloc
    URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/gperftools-2.4.tar.gz
    URL_MD5 2171cea3bbe053036fb5d5d25176a160 
    PATCH_COMMAND patch -N -p1 -i ${CMAKE_SOURCE_DIR}/patches/tcmalloc.patch || true
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --enable-frame-pointers --disable-libunwind --prefix=<INSTALL_DIR> --enable-shared=no CFLAGS=${TCMALLOC_C_FLAGS} CXXFLAGS=${TCMALLOC_COMPILE_FLAGS} CC=clang CXX=clang++  LDFLAGS=-stdlib=libc++
    INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local)
  unset(TCMALLOC_COMPILE_FLAGS)
  unset(TCMALLOC_C_FLAGS)
else()
  ExternalProject_Add(ex_tcmalloc
    PREFIX ${CMAKE_SOURCE_DIR}/deps/tcmalloc
    URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/gperftools-2.4.tar.gz
    URL_MD5 2171cea3bbe053036fb5d5d25176a160 
    PATCH_COMMAND patch -N -p1 -i ${CMAKE_SOURCE_DIR}/patches/tcmalloc.patch || true
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --enable-frame-pointers --disable-libunwind --prefix=<INSTALL_DIR> --enable-shared=no CXXFLAGS=-fPIC CFLAGS=-fPIC CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} 
    BUILD_IN_SOURCE 1
    INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local)
endif()

if (WIN32)
        # disable TCmalloc for now, 
        # some linking oddities
        add_library(tcmalloc INTERFACE )
        set(HAS_TCMALLOC FALSE CACHE BOOL "")

else()
set(TCMALLOC-FOUND 1)

add_library(libtcmalloca STATIC IMPORTED)
if (WIN32)
set_property(TARGET libtcmalloca PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libtcmalloc_minimal.a)
else()
set_property(TARGET libtcmalloca PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libtcmalloc.a)
endif()

add_library(tcmalloc INTERFACE )
target_link_libraries(tcmalloc INTERFACE libtcmalloca pthread)
target_compile_definitions(tcmalloc INTERFACE HAS_TCMALLOC)
set(HAS_TCMALLOC TRUE CACHE BOOL "")
endif()
