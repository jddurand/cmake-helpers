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
  check_include_file("limits.h"       HAVE_LIMITS_H)
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
      #
      # Use the math library for the try_run tests
      #
      list(APPEND CMAKE_REQUIRED_LIBRARIES ${CMAKE_MATH_LIBS})
    endif()
  endif()
  #
  # Common checks
  #
  cmake_helpers_try_run(EBCDIC ${PROJECT_SOURCE_DIR}/cmake/EBCDIC.c)
  cmake_helpers_try_run(C_INLINE ${PROJECT_SOURCE_DIR}/cmake/inline.c inline __inline__ inline__ __inline)
  IF (C_INLINE)
    if(C_INLINE STREQUAL inline)
      set(_c_inline_is_inline TRUE)
    else()
      set(_c_inline_is_inline FALSE)
    endif()
    set(C_INLINE_IS_INLINE ${_c_inline_is_inline} CACHE BOOL "C inline keyword is inline")
    mark_as_advanced(C_INLINE_IS_INLINE)
  endif()
  cmake_helpers_try_run(C_FORCEINLINE ${PROJECT_SOURCE_DIR}/cmake/forceinline.c forceinline __forceinline__ forceinline__ __forceinline)
  cmake_helpers_try_run(C_VA_COPY ${PROJECT_SOURCE_DIR}/cmake/va_copy.c va_copy _va_copy __va_copy)
  cmake_helpers_try_run(C_VSNPRINTF ${PROJECT_SOURCE_DIR}/cmake/vsnprintf.c vsnprintf _vsnprintf __vsnprintf)
  cmake_helpers_try_run(C_FILENO ${PROJECT_SOURCE_DIR}/cmake/fileno.c fileno _fileno __fileno)
  cmake_helpers_try_run(C_LOCALTIME_R ${PROJECT_SOURCE_DIR}/cmake/localtime_r.c localtime_r _localtime_r __localtime_r)
  cmake_helpers_try_run(C_WRITE ${PROJECT_SOURCE_DIR}/cmake/write.c write _write __write)
  cmake_helpers_try_run(C_LOG2 ${PROJECT_SOURCE_DIR}/cmake/log2.c log2)
  cmake_helpers_try_run(C_LOG2F ${PROJECT_SOURCE_DIR}/cmake/log2f.c log2f)
  cmake_helpers_try_value(C_CHAR_BIT ${PROJECT_SOURCE_DIR}/cmake/CHAR_BIT.c CHAR_BIT)
  cmake_helpers_try_run(C_STRTOLD ${PROJECT_SOURCE_DIR}/cmake/strtold.c strtold _strtold __strtold)
  cmake_helpers_try_run(C_STRTOD ${PROJECT_SOURCE_DIR}/cmake/strtod.c strtod _strtod __strtod)
  cmake_helpers_try_run(C_STRTOF ${PROJECT_SOURCE_DIR}/cmake/strtof.c strtof _strtof __strtof)

  cmake_helpers_try_run(C_HUGE_VAL ${PROJECT_SOURCE_DIR}/cmake/HUGE_VAL.c HUGE_VAL)
  if(NOT C_HUGE_VAL_FOUND)
    block()
      set(CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS -DHAVE_HUGE_VAL_REPLACEMENT)
      cmake_helpers_try_run(C_HUGE_VAL_REPLACEMENT ${PROJECT_SOURCE_DIR}/cmake/HUGE_VAL.c)
    endblock()
  endif()

  cmake_helpers_try_run(C_HUGE_VALF ${PROJECT_SOURCE_DIR}/cmake/HUGE_VALF.c HUGE_VALF)
  if(NOT C_HUGE_VALF_FOUND)
    block()
      set(CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS -DHAVE_HUGE_VALF_REPLACEMENT)
      cmake_helpers_try_run(C_HUGE_VALF_REPLACEMENT ${PROJECT_SOURCE_DIR}/cmake/HUGE_VALF.c)
    endblock()
  endif()

  cmake_helpers_try_run(C_HUGE_VALL ${PROJECT_SOURCE_DIR}/cmake/HUGE_VALL.c HUGE_VALL)
  if(NOT C_HUGE_VALL_FOUND)
    block()
      set(CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS -DHAVE_HUGE_VALL_REPLACEMENT)
      cmake_helpers_try_run(C_HUGE_VALL_REPLACEMENT ${PROJECT_SOURCE_DIR}/cmake/HUGE_VALL.c)
    endblock()
  endif()

  cmake_helpers_try_run(C_INFINITY ${PROJECT_SOURCE_DIR}/cmake/INFINITY.c INFINITY)
  if(NOT C_INFINITY_FOUND)
    block()
      set(CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS -DHAVE_INFINITY_REPLACEMENT)
      cmake_helpers_try_run(C_INFINITY_REPLACEMENT ${PROJECT_SOURCE_DIR}/cmake/INFINITY.c)
      if(NOT C_INFINITY_REPLACEMENT_FOUND)
	block()
	  set(CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS -DHAVE_INFINITY_REPLACEMENT_USING_DIVISION)
	  cmake_helpers_try_run(C_INFINITY_REPLACEMENT_USING_DIVISION ${PROJECT_SOURCE_DIR}/cmake/INFINITY.c)
	endblock()
      endif()
    endblock()
  endif()

  cmake_helpers_try_run(C_NAN ${PROJECT_SOURCE_DIR}/cmake/NAN.c NAN)
  if(NOT C_NAN_FOUND)
    block()
      set(CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS -DHAVE_NAN_REPLACEMENT)
      cmake_helpers_try_run(C_NAN_REPLACEMENT ${PROJECT_SOURCE_DIR}/cmake/NAN.c)
      if(NOT C_NAN_REPLACEMENT_FOUND)
	block()
	  set(CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS -DHAVE_NAN_REPLACEMENT_USING_DIVISION)
	  cmake_helpers_try_run(C_NAN_REPLACEMENT_USING_DIVISION ${PROJECT_SOURCE_DIR}/cmake/NAN.c)
	endblock()
      endif()
    endblock()
  endif()

  cmake_helpers_try_run(C_ISINF ${PROJECT_SOURCE_DIR}/cmake/isinf.c isinf _isinf __isinf)
  if(NOT C_ISINF_FOUND)
    block()
      set(CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS -DHAVE_ISINF_REPLACEMENT)
      cmake_helpers_try_run(C_ISINF_REPLACEMENT ${PROJECT_SOURCE_DIR}/cmake/isinf.c)
    endblock()
  endif()

  cmake_helpers_try_run(C_ISNAN ${PROJECT_SOURCE_DIR}/cmake/isnan.c isnan _isnan __isnan)
  if(NOT C_ISNAN_FOUND)
    block()
      set(CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS -DHAVE_ISNAN_REPLACEMENT)
      cmake_helpers_try_run(C_ISNAN_REPLACEMENT ${PROJECT_SOURCE_DIR}/cmake/isnan.c)
    endblock()
  endif()

  cmake_helpers_try_run(C_STRTOLL ${PROJECT_SOURCE_DIR}/cmake/strtoll.c strtoll _strtoll __strtoll strtoi64 _strtoi64 __strtoi64)
  cmake_helpers_try_run(C_STRTOULL ${PROJECT_SOURCE_DIR}/cmake/strtoull.c strtoull _strtoull __strtoull strtou64 _strtou64 __strtou64)
  cmake_helpers_try_run(C_FPCLASSIFY ${PROJECT_SOURCE_DIR}/cmake/fpclassify.c fpclassify _fpclassify __fpclassify fpclass _fpclass __fpclass)
  cmake_helpers_try_run(C_CONST ${PROJECT_SOURCE_DIR}/cmake/const.c const)
  cmake_helpers_try_run(HAVE_C99MODIFIERS ${PROJECT_SOURCE_DIR}/cmake/c99modifiers.c)
  cmake_helpers_try_run(C_RESTRICT ${PROJECT_SOURCE_DIR}/cmake/restrict.c __restrict __restrict__ _Restrict restrict)
  cmake_helpers_try_run(C___BUILTIN_EXPECT ${PROJECT_SOURCE_DIR}/cmake/__builtin_expect.c __builtin_expect)
  cmake_helpers_try_run(C_SIGNBIT ${PROJECT_SOURCE_DIR}/cmake/signbit.c signbit _signbit __signbit)
  cmake_helpers_try_run(C_COPYSIGN ${PROJECT_SOURCE_DIR}/cmake/copysign.c copysign _copysign __copysign)
  cmake_helpers_try_run(C_COPYSIGNF ${PROJECT_SOURCE_DIR}/cmake/copysignf.c copysignf _copysignf __copysignf)
  cmake_helpers_try_run(C_COPYSIGNL ${PROJECT_SOURCE_DIR}/cmake/copysignl.c copysignl _copysignl __copysignl)
  #
  # Check GNU features
  #
  check_symbol_exists(__GNU_LIBRARY__ "features.h" _GNU_SOURCE)
  #
  # Remember we were initialized
  #
  set_property(GLOBAL PROPERTY CMAKE_HELPERS_INITIALIZED TRUE)
endfunction()
