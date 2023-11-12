function(cmake_helpers_init)
  #
  # We always create an interface library
  #
  set(CMAKE_HELPERS_IFACE_SUFFIX "-iface" CACHE STRING "CMake Helpers interface suffix")
  set_property(CACHE CMAKE_HELPERS_IFACE_SUFFIX PROPERTY STRINGS ${CMAKE_HELPERS_IFACE_SUFFIX})

  if(NOT CMAKE_HELPERS_IFACE_SUFFIX)
    message(FATAL_ERROR "Interface suffix is not set")
  endif()
  cmake_helpers_call(add_library ${CMAKE_PROJECT_NAME}-${CMAKE_HELPERS_IFACE_SUFFIX} INTERFACE)
  cmake_helpers_call(include GNUInstallDirs)
  cmake_helpers_call(include CheckSymbolExists)
  cmake_helpers_call(check_symbol_exists __GNU_LIBRARY__ features.h _GNU_SOURCE)
endfunction()
