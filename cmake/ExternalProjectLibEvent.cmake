if (APPLE)
  ExternalProject_Add(ex_libevent
    PREFIX ${CMAKE_SOURCE_DIR}/deps/libevent
    URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/libevent-2.0.18-stable.tar.gz
    URL_MD5 aa1ce9bc0dee7b8084f6855765f2c86a
    CONFIGURE_COMMAND CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} CFLAGS=-fPIC CPPFLAGS=-fPIC <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --disable-openssl --enable-shared=no
    INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  )
else()
  ExternalProject_Add(ex_libevent
    PREFIX ${CMAKE_SOURCE_DIR}/deps/libevent
    URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/libevent-2.0.18-stable.tar.gz
    URL_MD5 aa1ce9bc0dee7b8084f6855765f2c86a
    CONFIGURE_COMMAND CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} CFLAGS=-fPIC CPPFLAGS=-fPIC <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --disable-openssl --enable-shared=no 
    INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
    INSTALL_COMMAND prefix=<INSTALL_DIR>/ make install && ${CMAKE_SOURCE_DIR}/patches/libevent_clean_and_remap.sh <INSTALL_DIR>/lib
  )
endif()

add_library(libeventa STATIC IMPORTED)
set_property(TARGET libeventa PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libevent.a)
add_library(libevent_pthreadsa STATIC IMPORTED)
set_property(TARGET libevent_pthreadsa PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libevent_pthreads.a)

add_library(libevent INTERFACE )
target_link_libraries(libevent INTERFACE libeventa libevent_pthreadsa)
target_compile_definitions(libevent INTERFACE HAS_LIBEVENT)
set(HAS_LIBEVENT TRUE CACHE BOOL "")

