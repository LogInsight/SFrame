if (CLANG)
  SET(TMP "-c -O3 -DNDEBUG -stdlib=libc++ -fPIC")
  SET(TMP2 "")
  SET (JSON_COMPILER_OPTIONS CXX=clang++ EXTRA_FLAGS=${TMP})
  UNSET(TMP2)
  UNSET(TMP)
else()
  SET(TMP2 "")
  SET(JSON_COMPILER_OPTIONS EXTRA_FLAGS=-fPIC)
  UNSET(TMP2)
endif()

# libjson ====================================================================
# Lib Json is used to support json serialization for long term storage of
# graph data.
ExternalProject_Add(ex_libjson
  PREFIX ${CMAKE_SOURCE_DIR}/deps/libjson
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/libjson_7.6.0.zip
  URL_MD5 dcb326038bd9b710b8f717580c647833
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  PATCH_COMMAND patch -N -p1 -i ${CMAKE_SOURCE_DIR}/patches/libjson.patch  && patch -N -p1 -i ${CMAKE_SOURCE_DIR}/patches/libjson_long_type.patch || true
  BUILD_COMMAND CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} make ${JSON_COMPILER_OPTIONS}
  INSTALL_COMMAND CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} make install ${JSON_COMPILER_OPTIONS} prefix=<INSTALL_DIR>/ 
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
  )


add_library(libjsona STATIC IMPORTED)
set_property(TARGET libjsona PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libjson.a)

add_library(libjson INTERFACE )
target_link_libraries(libjson INTERFACE libjsona)
target_compile_definitions(libjson INTERFACE HAS_LIBJSON)
set(HAS_LIBJSON TRUE CACHE BOOL "")
