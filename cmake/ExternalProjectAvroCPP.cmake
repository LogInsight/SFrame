if(WIN32 AND MSYS_MAKEFILES)
  # Avro's build system uses CMake, but has Unix Makefiles hardcoded as the
  # generator.  This variable goes along with a patch to set the right
  # generator.
  SET(PLATFORM_ENV_VARS AVRO_SET_MSYS=1)
endif()

ExternalProject_Add(ex_avrocpp
  PREFIX ${CMAKE_SOURCE_DIR}/deps/avrocpp
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/avro-cpp-1.7.6.tar.gz
  URL_MD5 4dbcfc48abf8feab7ea9d7f8ec8766c9
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND cp ${CMAKE_SOURCE_DIR}/patches/avro-CMakeLists.txt <SOURCE_DIR>/CMakeLists.txt
  PATCH_COMMAND patch -N -p1 -i ${CMAKE_SOURCE_DIR}/patches/libavro.patch || true
  BUILD_COMMAND env CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} CFLAGS=-fPIC CPPFLAGS=-fPIC CXXFLAGS=-fPIC BOOST_ROOT=${CMAKE_SOURCE_DIR}/deps/local ${PLATFORM_ENV_VARS} <SOURCE_DIR>/build.sh clean && cd build && make avrocpp_s
  INSTALL_COMMAND chmod 755 <SOURCE_DIR>/api &&
                  cp -r <SOURCE_DIR>/api ${CMAKE_SOURCE_DIR}/deps/local/include/avro &&
		  cp <SOURCE_DIR>/build/libavrocpp_s.a ${CMAKE_SOURCE_DIR}/deps/local/lib
)

add_dependencies(ex_avrocpp ex_boost)

add_library(libavrocpp_sa STATIC IMPORTED)
set_property(TARGET libavrocpp_sa PROPERTY IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/deps/local/lib/libavrocpp_s.a)
set_property(TARGET libavrocpp_sa PROPERTY INTERFACE_LINK_LIBRARIES boost)


add_library(avrocpp INTERFACE)
target_link_libraries(avrocpp INTERFACE libavrocpp_sa)
target_compile_definitions(avrocpp INTERFACE HAS_AVROCPP)
set(HAS_AVROCPP TRUE CACHE BOOL "")
