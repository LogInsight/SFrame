if(WIN32 AND ${MSYS_MAKEFILES})
  set(EXTRA_CONFIGURE_FLAGS --host=x86_64-w64-mingw32 --build=x86_64-w64-mingw32 --with-libsodium-lib-dir=<INSTALL_DIR>/bin --libdir=<INSTALL_DIR>/lib --enable-static=no)
else()
  set(EXTRA_CONFIGURE_FLAGS --enable-static=yes)
endif()

if(CLANG)
  SET(ZEROMQ_C_COMPILER clang)
  SET(ZEROMQ_CXX_COMPILER clang++)
  SET(ZEROMQ_C_FLAGS "-fPIC -DHAVE_LIBSODIUM")
  SET(ZEROMQ_CPP_FLAGS "-stdlib=libc++ -fPIC -DHAVE_LIBSODIUM")
  SET(ZEROMQ_LD_FLAGS "-stdlib=libc++ -L${CMAKE_SOURCE_DIR}/deps/local/lib -lsodium -lm -lsodium")
else()
  SET(ZEROMQ_C_COMPILER ${CMAKE_C_COMPILER})
  SET(ZEROMQ_CXX_COMPILER ${CMAKE_CXX_COMPILER})
  SET(ZEROMQ_C_FLAGS "-fPIC -DHAVE_LIBSODIUM")
  SET(ZEROMQ_CPP_FLAGS "-fPIC -DHAVE_LIBSODIUM")
  SET(ZEROMQ_LD_FLAGS "-L${CMAKE_SOURCE_DIR}/deps/local/lib -lsodium")
endif()

ExternalProject_Add(ex_zeromq
  PREFIX ${CMAKE_SOURCE_DIR}/deps/zeromq
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/zeromq-4.0.3.tar.gz
  URL_MD5 8348341a0ea577ff311630da0d624d45
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  PATCH_COMMAND patch -N -p0 -i ${CMAKE_SOURCE_DIR}/patches/zeroMq.patch || true
  CONFIGURE_COMMAND <SOURCE_DIR>/autogen.sh && <SOURCE_DIR>/configure CC=${ZEROMQ_C_COMPILER} CXX=${ZEROMQ_CXX_COMPILER} CFLAGS=${ZEROMQ_C_FLAGS} CXXFLAGS=${ZEROMQ_CPP_FLAGS} LDFLAGS=${ZEROMQ_LD_FLAGS} LIBS=-lm --prefix=<INSTALL_DIR> --enable-shared=yes --with-libsodium=<INSTALL_DIR> --with-libsodium-include-dir=<INSTALL_DIR>/include --with-pic ${EXTRA_CONFIGURE_FLAGS}
  BUILD_IN_SOURCE 1
  BUILD_COMMAND make -j4
  INSTALL_COMMAND make install && ${CMAKE_SOURCE_DIR}/patches/zeromq_del_so.sh <INSTALL_DIR>/lib
  )

add_library(libzmqa STATIC IMPORTED)
if(WIN32)
set_property(TARGET libzmqa PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/bin/libzmq.dll)
else()
set_property(TARGET libzmqa PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libzmq.a)
endif()
set_property(TARGET libzmqa PROPERTY INTERFACE_LINK_LIBRARIES libsodium)

add_dependencies(ex_zeromq ex_libsodium)

add_library(zeromq INTERFACE )
target_link_libraries(zeromq INTERFACE libzmqa libsodium)
if(WIN32)
  target_link_libraries(zeromq INTERFACE ws2_32 iphlpapi)
endif()
target_compile_definitions(zeromq INTERFACE HAS_ZEROMQ)

