cmake_minimum_required(VERSION 3.26.0 FATAL_ERROR) # We require BUILD_LOCAL_INTERFACE
project(cmake-helpers VERSION 1.0.0 LANGUAGES C CXX)
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
  option(CMAKE_HELPERS_GENERATE_STDINT_H "CMake Helpers stdint.h generation if not found" ON)
  option(CMAKE_HELPERS_GENERATE_INTTYPES_H "CMake Helpers inttypes.h generation if not found" ON)

  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[cmake_helpers] Loading version ${PROJECT_VERSION}")
  endif()
  #
  # Load all cmake file
  #
  file(GLOB _files ${PROJECT_SOURCE_DIR}/cmake/*.cmake)
  foreach (_file ${_files})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[cmake_helpers] include(${_file})")
    endif()
    include(${_file})
  endforeach()
  #
  # Initialize
  #
  cmake_helpers_init()
  #
  # Avoid repeating ourself
  #
  set_property(GLOBAL PROPERTY CMAKE_HELPERS_LOADED TRUE)
endif()
