if(APPLE)
  SET(EXTRA_CONFIGURE_FLAGS --with-darwinssl --without-ssl)
elseif(WIN32)
  SET(EXTRA_CONFIGURE_FLAGS --with-ssl=<INSTALL_DIR> --build=x86_64-w64-mingw32)
else()
  SET(EXTRA_CONFIGURE_FLAGS LIBS=-ldl --with-ssl=<INSTALL_DIR>)
endif()


ExternalProject_Add(ex_libcurl
  PREFIX ${CMAKE_SOURCE_DIR}/deps/libcurl
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/curl-7.33.0.tar.bz2 
  URL_MD5 57409d6bf0bd97053b8378dbe0cadcef
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  CONFIGURE_COMMAND CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} CFLAGS=-fPIC CPPFLAGS=-fPIC <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --without-winidn --without-libidn --without-nghttp2 --without-ca-bundle --without-polarssl --without-cyassl --without-nss --disable-crypto-auth --enable-shared=no --enable-static=yes --disable-ldap --without-librtmp --without-zlib --libdir=<INSTALL_DIR>/lib ${EXTRA_CONFIGURE_FLAGS}
  )

add_library(libcurla STATIC IMPORTED)
set_property(TARGET libcurla PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libcurl.a)

if (APPLE)
  find_library(security_framework NAMES Security)
  find_library(core_framework NAMES CoreFoundation)
  add_library(curl INTERFACE )
  target_link_libraries(curl INTERFACE ${core_framework})
  target_link_libraries(curl INTERFACE ${security_framework})
  target_link_libraries(curl INTERFACE libcurla)
  target_compile_definitions(curl INTERFACE HAS_CURL)
else()
  add_dependencies(ex_libcurl ex_libssl)
  set_property(TARGET libcurla PROPERTY INTERFACE_LINK_LIBRARIES openssl)

  add_library(curl INTERFACE )
  target_link_libraries(curl INTERFACE libcurla openssl)
  if (NOT APPLE AND NOT WIN32)
    target_link_libraries(curl INTERFACE -lrt)
  endif()
  if(WIN32)
    target_link_libraries(curl INTERFACE -lssh2 -lws2_32)
  endif()
  target_compile_definitions(curl INTERFACE HAS_CURL)
endif()
set(HAS_CURL TRUE CACHE BOOL "")
