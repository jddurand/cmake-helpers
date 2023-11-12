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
    message(FATAL_ERROR "CMake Helpers already initialized")
  endif()
  #
  # Declare all options
  #
  cmake_helpers_option(CMAKE_HELPERS_IFACE_SUFFIX    INTERNAL "-iface" "CMake Helpers interface suffix")              # Must be set, not an option in the GUI
  cmake_helpers_option(CMAKE_HELPERS_LIBRARY_SOURCES STRING   "AUTO"   "CMake Helpers library sources" "AUTO" ON OFF) # Three choices, visibile in the GUI
  cmake_helpers_option(CMAKE_HELPERS_LIBRARY_HEADERS STRING   "AUTO"   "CMake Helpers library headers" "AUTO" ON OFF) # Three choices, visibile in the GUI
  #
  # We always create an interface library
  #
  if(NOT CMAKE_HELPERS_IFACE_SUFFIX)
    message(FATAL_ERROR "Interface suffix is not set")
  endif()
  cmake_helpers_call(add_library ${CMAKE_PROJECT_NAME}${CMAKE_HELPERS_IFACE_SUFFIX} INTERFACE)
  #
  # Remember we were initialized
  #
  set_property(GLOBAL PROPERTY CMAKE_HELPERS_INITIALIZED TRUE)
endfunction()
