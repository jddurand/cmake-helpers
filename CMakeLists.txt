cmake_minimum_required(VERSION 3.26.0 FATAL_ERROR) # We require BUILD_LOCAL_INTERFACE
project(cmake-helpers VERSION 1.0.0)
#
# Load our includes, once
#
get_property(_cmake_helpers_loaded_set GLOBAL PROPERTY CMAKE_HELPERS_LOADED SET)
if(_cmake_helpers_loaded_set)
  get_property(_cmake_helpers_loaded GLOBAL PROPERTY CMAKE_HELPERS_LOADED)
else()
  set(_cmake_helpers_loaded FALSE)
endif()

if(NOT _cmake_helpers_loaded)
  message(STATUS "Loading ${PROJECT_NAME} files")
  file(GLOB _cmakes ${PROJECT_SOURCE_DIR}/cmake/*.cmake)
  foreach (_cmake ${_cmakes})
    include(${_cmake})
  endforeach()
  set_property(GLOBAL PROPERTY CMAKE_HELPERS_LOADED TRUE)
endif()
