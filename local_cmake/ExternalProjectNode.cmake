if (APPLE)
  ExternalProject_Add(nodejs
    PREFIX ${CMAKE_SOURCE_DIR}/deps/node
    URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/node-v0.12.0-darwin-x64.tar.gz
    URL_MD5 1d8d0e3c3c0ccfd45c055b42c26c1ca7
    INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND rm <SOURCE_DIR>/ChangeLog <SOURCE_DIR>/README.md <SOURCE_DIR>/LICENSE
    INSTALL_COMMAND chmod 755 <SOURCE_DIR> &&
                    rsync -a <SOURCE_DIR>/ ${CMAKE_SOURCE_DIR}/deps/local/
  )
elseif(WIN32)
  ExternalProject_Add(nodejs
    PREFIX ${CMAKE_SOURCE_DIR}/deps/node
    URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/node-v0.12.2-windows.tar.gz
    URL_MD5 eda54d71c532dfeb56e4cb58a9507d74
    INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND chmod 755 <SOURCE_DIR> &&
    sh -c "cp -R <SOURCE_DIR>/* ${CMAKE_SOURCE_DIR}/deps/local/bin"
  )
else()
  ExternalProject_Add(nodejs
    PREFIX ${CMAKE_SOURCE_DIR}/deps/node
    URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/node-v0.12.0-linux-x64.tar.gz
    URL_MD5 ce648d80c0167b0cfe6ec141466822b9
    INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND rm <SOURCE_DIR>/ChangeLog <SOURCE_DIR>/README.md <SOURCE_DIR>/LICENSE
    INSTALL_COMMAND chmod 755 <SOURCE_DIR> &&
                    rsync -a <SOURCE_DIR>/ ${CMAKE_SOURCE_DIR}/deps/local/
  )
endif()

