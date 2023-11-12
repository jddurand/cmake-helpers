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
  option(CMAKE_HELPERS_DEBUG "CMake Helpers debug" OFF)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "${PROJECT_NAME} ${PROJECT_VERSION} loading")
  endif()
  #
  # Always start with cmake/call.cmake
  #
  file(GLOB _call ${PROJECT_SOURCE_DIR}/cmake/call.cmake)
  if(NOT _call)
    message(FATAL_ERROR "Could not find call.cmake")
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "include(${_call})")
  endif()
  include(${_call})
  #
  # Load the others
  #
  file(GLOB _files ${PROJECT_SOURCE_DIR}/cmake/*.cmake)
  foreach (_file ${_files})
    if(_file STREQUAL ${_call})
      continue()
    endif()
    cmake_helpers_call(include ${_file})
  endforeach()
  set_property(GLOBAL PROPERTY CMAKE_HELPERS_LOADED TRUE)
endif()
