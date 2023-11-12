function(cmake_helpers_library)
  set(_srcs ${ARGN})
  #
  # We always create an interface library if not already done
  #
  if(NOT CMAKE_HELPERS_IFACE_SUFFIX)
    message(FATAL_ERROR "Interface suffix is not set")
  endif()
  set(_iface_target ${CMAKE_PROJECT_NAME}${CMAKE_HELPERS_IFACE_SUFFIX})
  if(NOT TARGET ${_iface_target})
    cmake_helpers_call(add_library ${_iface_target} INTERFACE)
  endif()

endfunction()
