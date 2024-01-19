function(cmake_helpers_global variable value)
  #
  # Log prefix
  #
  set(_cmake_helpers_logprefix "cmake_helpers/global")
  #
  # The globals default values that we support
  #
  set(_cmake_helpers_globals
    FETCHCONTENT_BASE_DIR
    CMAKE_HELPERS_BUILDS_PATH
    CMAKE_HELPERS_INSTALL_PATH
    CMAKE_HELPERS_DEBUG
    CMAKE_HELPERS_GENERATE_STDINT_H
    CMAKE_HELPERS_GENERATE_INTTYPES_H
    CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO
  )
  #
  # The defaults
  #
  set(FETCHCONTENT_BASE_DIR_DEFAULT ${CMAKE_BINARY_DIR}/_deps)
  set(CMAKE_HELPERS_BUILDS_PATH_DEFAULT ${CMAKE_BINARY_DIR}/cmake_helpers_builds)
  set(CMAKE_HELPERS_INSTALL_PATH_DEFAULT ${CMAKE_BINARY_DIR}/cmake_helpers_install)
  set(CMAKE_HELPERS_DEBUG_DEFAULT OFF)
  set(CMAKE_HELPERS_GENERATE_STDINT_H_DEFAULT ON)
  set(CMAKE_HELPERS_GENERATE_INTTYPES_H_DEFAULT ON)
  set(CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO_DEFAULT ON)
  #
  # Calling this function on an unsupported global is more than meaningless, this is an error
  #
  if(NOT "x${variable}" STREQUAL "x")
    if(NOT ${variable} IN LISTS _cmake_helpers_globals)
      message(FATAL_ERROR "Function called on unsupported global ${variable}")
    endif()
  endif()
  #
  # We use the environment to propagate where are stored the "globals" to eventual child processes
  #
  set(CMAKE_HELPERS_GLOBALS_STORE $ENV{CMAKE_HELPERS_GLOBALS_STORE})
  if("x${CMAKE_HELPERS_GLOBALS_STORE}" STREQUAL "x")
    #
    # First time: this is in CMAKE_BINARY_DIR to hit the top-level CMake build tree
    #
    set(CMAKE_HELPERS_GLOBALS_STORE ${CMAKE_BINARY_DIR}/cmake_helpers_globals.cmake)
    set(ENV{CMAKE_HELPERS_GLOBALS_STORE} ${CMAKE_HELPERS_GLOBALS_STORE})
  endif()
  #
  # Default is to not update or create the cache
  #
  set(_cmake_helpers_global_create FALSE)
  set(_cmake_helpers_global_update FALSE)
  #
  # Load the content if it already exist
  #
  if(EXISTS ${CMAKE_HELPERS_GLOBALS_STORE})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] Loading ${CMAKE_HELPERS_GLOBALS_STORE}")
    endif()
    include(${CMAKE_HELPERS_GLOBALS_STORE})
  else()
    #
    # No cache yet, we will create it
    #
    set(_cmake_helpers_global_create TRUE)
  endif()
  #
  # If variable is set, then we want to update the corresponding global
  #
  if(NOT "x${variable}" STREQUAL "x")
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] Setting ${variable} to \"${value}\"")
    endif()
    set(${variable} "${value}" CACHE STRING "" FORCE)
    #
    # Force cache write
    #
    set(_cmake_helpers_global_update TRUE)
  endif()
  #
  # Crate/update if needed
  #
  if(_cmake_helpers_global_create OR _cmake_helpers_global_update)
    if(CMAKE_HELPERS_DEBUG)
      if(_cmake_helpers_global_create)
	message(STATUS "[${_cmake_helpers_logprefix}] ${CMAKE_HELPERS_GLOBALS_STORE}")
      else()
	message(STATUS "[${_cmake_helpers_logprefix}] Updating ${CMAKE_HELPERS_GLOBALS_STORE}")
      endif()
    endif()
    file(WRITE ${CMAKE_HELPERS_GLOBALS_STORE} "# cmake-helpers globals\n")
    foreach(_cmake_helpers_global IN LISTS _cmake_helpers_globals)
      if(NOT DEFINED ${_cmake_helpers_global})
	set(${_cmake_helpers_global} ${${_cmake_helpers_global}_DEFAULT})
      endif()
      file(APPEND ${CMAKE_HELPERS_GLOBALS_STORE} "set(${_cmake_helpers_global} \"${${_cmake_helpers_global}}\" CACHE STRING \"\" FORCE)\n")
    endforeach()
  endif()
  #
  # Dump globals
  #
  if(CMAKE_HELPERS_DEBUG)
    foreach(_cmake_helpers_global IN LISTS _cmake_helpers_globals)
      message(STATUS "[${_cmake_helpers_logprefix}] ${_cmake_helpers_global}: \"${${_cmake_helpers_global}}\"")
    endforeach()
  endif()
endfunction()
