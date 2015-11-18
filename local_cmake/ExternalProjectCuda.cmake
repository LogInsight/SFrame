if (APPLE)
set(HAS_CUDA FALSE CACHE BOOL "")
elseif (WIN32)
set(HAS_CUDA FALSE CACHE BOOL "")
else()
  ExternalProject_Add(ex_cuda
    PREFIX ${CMAKE_SOURCE_DIR}/deps/cuda
    URL http://s3-us-west-2.amazonaws.com/glbin-engine/deps/cuda-7.0-minimal.tar.gz
    URL_MD5 0ef8cd613af50d7e4dc56eb93d8ea6cf
    INSTALL_DIR ${CMAKE_SOURCE_DIR}/deps/local
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND chmod 755 <SOURCE_DIR> &&
                    rsync -a <SOURCE_DIR>/ ${CMAKE_SOURCE_DIR}/deps/local/
  )
set(CUDA_TOOLKIT_ROOT_DIR ${CMAKE_SOURCE_DIR}/deps/local)
find_package(CUDA 7)

if (CUDA_FOUND)

set(CUDA_LIBRARIES 
        ${CMAKE_SOURCE_DIR}/deps/local/lib/libcudart_static.a #cudart
        ${CMAKE_SOURCE_DIR}/deps/local/lib/libcublas_static.a #cublas
        ${CMAKE_SOURCE_DIR}/deps/local/lib/libcublas_device.a #cublas
        ${CMAKE_SOURCE_DIR}/deps/local/lib/libculibos.a #culibos
        ${CMAKE_SOURCE_DIR}/deps/local/lib/libcurand_static.a #curand
        ${CMAKE_SOURCE_DIR}/deps/local/lib/libnppc_static.a # npp performance premitive core (5.5+)
        )

set(libnames "")
foreach(blib ${CUDA_LIBRARIES})
  get_filename_component(FNAME ${blib} NAME)
  add_library(${FNAME} STATIC IMPORTED)
  set_property(TARGET ${FNAME} PROPERTY IMPORTED_LOCATION ${blib})
  list(APPEND libnames ${FNAME})
endforeach()

message(STATUS "Cuda libs: " ${CUDA_LIBRARIES})

add_library(cuda INTERFACE )
target_link_libraries(cuda INTERFACE ${libnames})
target_compile_definitions(cuda INTERFACE HAS_CUDA)
set(HAS_CUDA TRUE CACHE BOOL "")
endif()
endif()
