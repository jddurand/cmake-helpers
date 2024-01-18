function(cmake_helpers_global variable value)
  #
  # The globals default values that we support
  #
  set(_cmake_helpers_globals
    FETCHCONTENT_BASE_DIR
    CMAKE_HELPERS_BUILDS_PATH
    CMAKE_HELPERS_BUILDS_COUNT
    CMAKE_HELPERS_INSTALL_PATH)
  )
  #
  # The defaults
  #
  set(FETCHCONTENT_BASE_DIR_DEFAULT ${CMAKE_BINARY_DIR}/_deps)
  set(CMAKE_HELPERS_BUILDS_PATH_DEFAULT ${CMAKE_BINARY_DIR}/cmake_helpers_builds)
  set(CMAKE_HELPERS_BUILDS_COUNT_DEFAULT 0 )
  set(CMAKE_HELPERS_INSTALL_PATH_DEFAULT ${CMAKE_BINARY_DIR}/cmake_helpers_install)
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
      message(STATUS "[cmake_helpers] Loading ${CMAKE_HELPERS_GLOBALS_STORE}")
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
  if(NOT "x{$variable}" STREQUAL "x")
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[cmake_helpers] Setting ${variable} to \"${value}\"")
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
	message(STATUS "[cmake_helpers] Creating ${CMAKE_HELPERS_GLOBALS_STORE}")
      else()
	message(STATUS "[cmake_helpers] Updating ${CMAKE_HELPERS_GLOBALS_STORE}")
      endif()
    endif()
    file(WRITE ${CMAKE_HELPERS_GLOBALS_STORE} "# cmake-helpers globals")
    foreach(_cmake_helpers_global IN LISTS _cmake_helpers_globals)
      if(NOT DEFINED ${_cmake_helpers_global})
	if(CMAKE_HELPERS_DEBUG)
	  message(STATUS "[cmake_helpers] Setting ${_cmake_helpers_global} to \"${${_cmake_helpers_global}_DEFAULT}\" (default)")
	endif()
	set(${_cmake_helpers_global} ${${_cmake_helpers_global}_DEFAULT})
      endif()
      file(APPEND ${CMAKE_HELPERS_GLOBALS_STORE} "set(${_cmake_helpers_global} \"${${_cmake_helpers_global}}\" CACHE STRING \"\" FORCE)")
    endif()
  endif()
endfunction()
