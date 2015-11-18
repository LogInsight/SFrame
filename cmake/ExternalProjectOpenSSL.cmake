if(APPLE)
  # SSL seems to link fine even when compiled using the default compiler
  # The alternative to get openssl to use gcc on mac requires a patch to
  # the ./Configure script
ExternalProject_Add(ex_libssl
  PREFIX ${CMAKE_SOURCE_DIR}/deps/libssl
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/openssl-1.0.2.tar.gz
  URL_MD5 38373013fc85c790aabf8837969c5eba
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ./Configure darwin64-x86_64-cc -fPIC --prefix=<INSTALL_DIR>
  BUILD_COMMAND make -j1
  INSTALL_COMMAND make -j1 install && cp ./libcrypto.a <INSTALL_DIR>/ssl && cp ./libssl.a <INSTALL_DIR>/ssl
  )
elseif(WIN32)
ExternalProject_Add(ex_libssl
  PREFIX ${CMAKE_SOURCE_DIR}/deps/libssl
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/openssl-1.0.1j.tar.gz
  URL_MD5 f7175c9cd3c39bb1907ac8bba9df8ed3
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ./Configure mingw64 -fPIC --prefix=<INSTALL_DIR> 
  BUILD_COMMAND make -j1
  INSTALL_COMMAND make -j1 install_sw
  )
else()
ExternalProject_Add(ex_libssl
  PREFIX ${CMAKE_SOURCE_DIR}/deps/libssl
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/openssl-1.0.2.tar.gz
  URL_MD5 38373013fc85c790aabf8837969c5eba
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND CC=${CMAKE_C_COMPILER} ./config -fPIC --prefix=<INSTALL_DIR>
  BUILD_COMMAND make -j1
  INSTALL_COMMAND make -j1 install_sw
  )
endif()

if(EXISTS ${CMAKE_SOURCE_DIR}/deps/local/lib/libssl.a) 
        add_library(libssla STATIC IMPORTED)
        set_property(TARGET libssla PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libssl.a)

        add_library(libcryptoa STATIC IMPORTED)
        set_property(TARGET libcryptoa PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libcrypto.a)
else()
        add_library(libssla STATIC IMPORTED)
        set_property(TARGET libssla PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib64/libssl.a)

        add_library(libcryptoa STATIC IMPORTED)
        set_property(TARGET libcryptoa PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib64/libcrypto.a)
endif()

add_library(openssl INTERFACE )
target_link_libraries(openssl INTERFACE libssla libcryptoa)
if(NOT WIN32)
  target_link_libraries(openssl INTERFACE dl)
endif()
target_compile_definitions(openssl INTERFACE HAS_OPENSSL)
set(HAS_OPENSSL TRUE CACHE BOOL "")
