if (APPLE)
        ExternalProject_Add(ex_cblas
                PREFIX ${CMAKE_SOURCE_DIR}/deps/cblas
                URL http://s3-us-west-2.amazonaws.com/glbin-engine/gl_libblas_201505042044.tar.gz
                URL_MD5 b810124b36937214a2e6bf5faab12279
                BUILD_IN_SOURCE 1
                INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
                CONFIGURE_COMMAND ""
                UPDATE_COMMAND ""
                BUILD_COMMAND ""
                INSTALL_COMMAND bash -c "mkdir -p <INSTALL_DIR>/include && cp <SOURCE_DIR>/include/cblas.h <INSTALL_DIR>/include && cp <SOURCE_DIR>/lib/OSX/*.a <INSTALL_DIR>/lib")
        set(CBLAS_FOUND 1)
        set(CBLAS_LIBRARIES ${CMAKE_SOURCE_DIR}/deps/local/lib/libblas.a)
elseif(WIN32 AND MSYS_MAKEFILES)
        ExternalProject_Add(ex_cblas
                PREFIX ${CMAKE_SOURCE_DIR}/deps/cblas
                URL http://s3-us-west-2.amazonaws.com/glbin-engine/OpenBLAS-v0.2.14-Win64-int64.zip
                URL_MD5 9f2d41076857a514b921bf0bf03b5d39
                BUILD_IN_SOURCE 1
                INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
                CONFIGURE_COMMAND ""
                UPDATE_COMMAND ""
                BUILD_COMMAND ""
                INSTALL_COMMAND bash -c "mkdir -p <INSTALL_DIR>/include && cp <SOURCE_DIR>/include/cblas.h <INSTALL_DIR>/include && cp <SOURCE_DIR>/include/openblas_config.h <INSTALL_DIR>/include && cp <SOURCE_DIR>/lib/libopenblas.a <INSTALL_DIR>/lib")
        set(CBLAS_FOUND 1)
        set(CBLAS_LIBRARIES ${CMAKE_SOURCE_DIR}/deps/local/lib/libopenblas.a)
else()
        ExternalProject_Add(ex_cblas
                PREFIX ${CMAKE_SOURCE_DIR}/deps/cblas
                URL http://s3-us-west-2.amazonaws.com/glbin-engine/gl_libblas_201505042044.tar.gz
                URL_MD5 b810124b36937214a2e6bf5faab12279
                BUILD_IN_SOURCE 1
                INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
                CONFIGURE_COMMAND ""
                UPDATE_COMMAND ""
                BUILD_COMMAND ""
                INSTALL_COMMAND bash -c "mkdir -p <INSTALL_DIR>/include && cp <SOURCE_DIR>/include/cblas.h <INSTALL_DIR>/include && cp <SOURCE_DIR>/lib/LINUX/*.a <INSTALL_DIR>/lib")
        set(CBLAS_LIBRARIES ${CMAKE_SOURCE_DIR}/deps/local/lib/libblas.a)
endif()

add_library(libcblasa STATIC IMPORTED)
set_property(TARGET libcblasa PROPERTY IMPORTED_LOCATION ${CBLAS_LIBRARIES})

add_library(cblas INTERFACE )
target_link_libraries(cblas INTERFACE libcblasa)
target_compile_definitions(cblas INTERFACE HAS_CBLAS)
set(HAS_CBLAS TRUE CACHE BOOL "")
