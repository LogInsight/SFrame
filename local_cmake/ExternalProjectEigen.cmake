ExternalProject_Add(ex_eigen
  PREFIX ${CMAKE_SOURCE_DIR}/deps/eigen
  URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/eigen_3.1.2.tar.bz2
  URL_MD5 e9c081360dde5e7dcb8eba3c8430fde2
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  BUILD_IN_SOURCE 1
  INSTALL_COMMAND cp -r Eigen unsupported <INSTALL_DIR>/
  INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local/include)

add_library(eigen INTERFACE )
target_link_libraries(eigen INTERFACE ${eigen_LIBRARIES})
target_compile_definitions(eigen INTERFACE HAS_EIGEN EIGEN_DONT_PARALLELIZE)
set(HAS_EIGEN TRUE CACHE BOOL "")
