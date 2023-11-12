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
  cmake_helpers_option(CMAKE_HELPERS_IFACE_SUFFIX    STRING _iface  "CMake Helpers interface library suffix") # Must be set, not an option in the GUI
  cmake_helpers_option(CMAKE_HELPERS_STATIC_SUFFIX   STRING _static "CMake Helpers static library suffix")    # Must be set, not an option in the GUI
  cmake_helpers_option(CMAKE_HELPERS_SHARED_SUFFIX   STRING _shared "CMake Helpers shared library suffix")    # Must be set, not an option in the GUI
  cmake_helpers_option(CMAKE_HELPERS_OUTPUT_DIR_NAME STRING output  "CMake Helpers output directory name")    # Must be set, not an option in the GUI
  #
  # We use GNU standard for installation
  #
  include(GNUInstallDirs)
  #
  # Common include files
  #
  include(CheckIncludeFile)
  check_include_file("stdio.h"        HAVE_STDIO_H)
  check_include_file("stddef.h"       HAVE_STDDEF_H)
  check_include_file("stdlib.h"       HAVE_STDLIB_H)
  check_include_file("stdarg.h"       HAVE_STDARG_H)
  check_include_file("stdint.h"       HAVE_STDINT_H)
  check_include_file("sys/stdint.h"   HAVE_SYS_STDINT_H)
  check_include_file("inttypes.h"     HAVE_INTTYPES_H)
  check_include_file("sys/inttypes.h" HAVE_SYS_INTTYPES_H)
  check_include_file("sys/time.h"     HAVE_SYS_TIME_H)
  check_include_file("sys/types.h"    HAVE_SYS_TYPES_H)
  check_include_file("sys/stat.h"     HAVE_SYS_STAT_H)
  check_include_file("errno.h"        HAVE_ERRNO_H)
  check_include_file("string.h"       HAVE_STRING_H)
  check_include_file("unistd.h"       HAVE_UNISTD_H)
  check_include_file("io.h"           HAVE_IO_H)
  check_include_file("time.h"         HAVE_TIME_H)
  check_include_file("fcntl.h"        HAVE_FCNTL_H)
  check_include_file("math.h"         HAVE_MATH_H)
  check_include_file("float.h"        HAVE_FLOAT_H)
  check_include_file("locale.h"       HAVE_LOCALE_H)
  #
  # Common checks
  #
  cmake_helpers_init_value(EBCDIC [[
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

int main() {
  if ('M'==0xd4) {
    exit(0);
  }
  exit(1);
}
]])
  #
  # Check math library
  #
  include(CheckSymbolExists)
  check_symbol_exists(log "math.h" HAVE_LOG)
  check_symbol_exists(exp "math.h" HAVE_EXP)
  if(NOT (HAVE_LOG AND HAVE_EXP))
    unset(HAVE_LOG CACHE)
    unset(HAVE_EXP CACHE)
    list(APPEND CMAKE_REQUIRED_LIBRARIES "m")
    check_symbol_exists(log "math.h" HAVE_LOG)
    check_symbol_exists(exp "math.h" HAVE_EXP)
    if(HAVE_LOG AND HAVE_EXP)
      set(CMAKE_MATH_LIBS "m" CACHE STRING "Math library")
      mark_as_advanced(CMAKE_MATH_LIBS)
    endif()
  endif()
  #
  # Check GNU features
  #
  check_symbol_exists(__GNU_LIBRARY__ "features.h" _GNU_SOURCE)
  #
  # Remember we were initialized
  #
  set_property(GLOBAL PROPERTY CMAKE_HELPERS_INITIALIZED TRUE)
endfunction()

function(cmake_helpers_init_value value source)
  set(_argn ${ARGN})
  get_property(_cmake_helpers_initialized_${value}_set GLOBAL PROPERTY CMAKE_HELPERS_INITIALIZED_${value} SET)
  if(_cmake_helpers_initialized_${value}_set)
    get_property(_cmake_helpers_initialized_${value} GLOBAL PROPERTY CMAKE_HELPERS_INITIALIZED_${value})
  else()
    set(_cmake_helpers_initialized_${value} FALSE)
  endif()

  if(NOT _cmake_helpers_initialized_${value})
    set(_compile_definitions)
    foreach(_arg ${_argn})
      if(${${_arg}})
	list(APPEND _compile_definitions -D${_arg})
      endif()
    endforeach()
    message(STATUS "Looking for ${value}")
    try_run(_run _compile SOURCE_FROM_VAR ${value}.c source COMPILE_DEFINITIONS ${_compile_definitions} RUN_OUTPUT_VARIABLE _output)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS ${_output})
    endif()
    if(_compile AND (_run EQUAL 0))
      set(_value TRUE)
      message(STATUS "Looking for ${value} - yes")
    else()
      set(_value FALSE)
      message(STATUS "Looking for ${value} - no")
    endif()
    set(${value} ${_value} CACHE BOOL ${value})
    mark_as_advanced(${value})
    set_property(GLOBAL PROPERTY CMAKE_HELPERS_INITIALIZED_${value} TRUE)
  endif()
endfunction()
