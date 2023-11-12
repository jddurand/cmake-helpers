function(cmake_helpers_init)
  #
  # Alike the CMakeLists.txt, we should not have been called more than once
  #
  get_property(_cmake_helpers_initialized_set GLOBAL PROPERTY CMAKE_HELPERS_INITIALIZED SET)
  if(_cmake_helpers_initialized_set)
    get_property(_cmake_helpers_initialized GLOBAL PROPERTY CMAKE_HELPERS_INITIALIZED)
  else()
    set(_cmake_helpers_initialized FALSE)
  endif()
  if(_cmake_helpers_initialized)
    message(FATAL_ERROR "CMake Helpers initialized already called")
  endif()
  #
  # We always create an interface library
  #
  cmake_helpers_option(CMAKE_HELPERS_IFACE_SUFFIX "-iface" "CMake Helpers interface suffix")
  if(NOT CMAKE_HELPERS_IFACE_SUFFIX)
    message(FATAL_ERROR "Interface suffix is not set")
  endif()
  cmake_helpers_call(add_library ${CMAKE_PROJECT_NAME}${CMAKE_HELPERS_IFACE_SUFFIX} INTERFACE)

  set_property(GLOBAL PROPERTY CMAKE_HELPERS_INITIALIZED TRUE)
endfunction()
