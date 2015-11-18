if(WIN32 AND ${MSYS_MAKEFILES})
  set(EXTRA_CONFIGURE_FLAGS --build=x86_64-w64-mingw32)
endif()

ExternalProject_Add(ex_odbc
    PREFIX ${CMAKE_SOURCE_DIR}/deps/odbc
    URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/unixODBC-2.3.2.tar.gz
    URL_MD5 5e4528851eda5d3d4aed249b669bd05b
    # If you want a more liberal license but less stability, use this instead
    #URL http://downloads.sourceforge.net/project/iodbc/iodbc/3.52.9/libiodbc-3.52.9.tar.gz
    #URL_MD5 98a681e06a1df809af9ff9a16951b8b6
    INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
    CONFIGURE_COMMAND <SOURCE_DIR>/configure ${EXTRA_CONFIGURE_FLAGS}
    PATCH_COMMAND patch -N -p1 -i ${CMAKE_SOURCE_DIR}/patches/odbc.patch || true
    BUILD_IN_SOURCE 1
    BUILD_COMMAND ""
    INSTALL_COMMAND cp <SOURCE_DIR>/include/autotest.h <SOURCE_DIR>/include/odbcinstext.h <SOURCE_DIR>/include/odbcinst.h <SOURCE_DIR>/include/sqlext.h <SOURCE_DIR>/include/sql.h <SOURCE_DIR>/include/sqltypes.h <SOURCE_DIR>/include/sqlucode.h <SOURCE_DIR>/include/uodbc_extras.h <SOURCE_DIR>/include/uodbc_stats.h <SOURCE_DIR>/unixodbc_conf.h <INSTALL_DIR>/include
    )

add_library(odbc INTERFACE )
target_compile_definitions(odbc INTERFACE HAS_ODBC)
set(HAS_ODBC TRUE CACHE BOOL "")
