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
  check_include_file("features.h"     HAVE_FEATURES_H)
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
  # Common features checks
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
  if(NOT C_CHAR_BIT_FOUND)
    #
    # We must have a value for CHAR_BIT...
    #
    message(WARNING "Unable to find CHAR_BIT - Assuming 8")
    set(C_CHAR_BIT "8" CACHE STRING "C_CHAR_BIT forced value")
    mark_as_advanced(C_CHAR_BIT)
  endif()
  #
  # It is impossible to have less then 8
  #
  if(C_CHAR_BIT LESS 8)
    message(FATAL_ERROR "CHAR_BIT size is ${C_CHAR_BIT} < 8")
  endif()
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
  # We reserve the next lines to clang or gcc family
  #
  if(CMAKE_C_COMPILER_ID MATCHES "Clang|GNU")
    include(CheckCCompilerFlag)
    check_c_compiler_flag(-Werror C_COMPILER_HAS_WERROR_OPTION)
    block()
      list(APPEND CMAKE_C_FLAGS -Werror)
      foreach(_attribute alias aligned alloc_size always_inline artificial cold const constructor_priority constructor deprecated destructor dllexport dllimport error externally_visible fallthrough flatten format gnu_format format_arg gnu_inline hot ifunc leaf malloc noclone noinline nonnull noreturn nothrow optimize pure sentinel sentinel_position returns_nonnull unused used visibility warning warn_unused_result weak weakref)
	string(TOUPPER ${_attribute} _attribute_topupper)
	cmake_helpers_try_run(C_GCC_FUNC_ATTRIBUTE_${_attribute_topupper} ${PROJECT_SOURCE_DIR}/cmake/gccfuncattribute.c)
        FINDGCCFUNCATTRIBUTE(${_attribute})
      endforeach()
    endblock()
  endif()
  #
  # Common sizes checks
  #
  include(CheckTypeSize)
  block()
    if(HAVE_STDINT_H)
      list(APPEND CMAKE_EXTRA_INCLUDE_FILES stdint.h)
    endif()
    if(HAVE_INTTYPES_H)
      list(APPEND CMAKE_EXTRA_INCLUDE_FILES inttypes.h)
    endif()
    if(HAVE_SYS_INTTYPES_H)
      list(APPEND CMAKE_EXTRA_INCLUDE_FILES sys/inttypes.h)
    endif()
    if(HAVE_STDDEF_H)
      list(APPEND CMAKE_EXTRA_INCLUDE_FILES stddef.h)
    endif()
    check_type_size("char" SIZEOF_CHAR)
    check_type_size("short" SIZEOF_SHORT)
    check_type_size("int" SIZEOF_INT)
    check_type_size("long" SIZEOF_LONG)
    check_type_size("long long" SIZEOF_LONG_LONG)
    check_type_size("float" SIZEOF_FLOAT)
    check_type_size("double" SIZEOF_DOUBLE)
    check_type_size("long double" SIZEOF_LONG_DOUBLE)
    check_type_size("unsigned char" SIZEOF_UNSIGNED_CHAR)
    check_type_size("unsigned short" SIZEOF_UNSIGNED_SHORT)
    check_type_size("unsigned int" SIZEOF_UNSIGNED_INT)
    check_type_size("unsigned long" SIZEOF_UNSIGNED_LONG)
    check_type_size("unsigned long long" SIZEOF_UNSIGNED_LONG_LONG)
    check_type_size("size_t" SIZEOF_SIZE_T)
    check_type_size("void *" SIZEOF_VOID_STAR)
    check_type_size("ptrdiff_t" SIZEOF_PTRDIFF_T)
    #
    # Integer types
    #
    foreach(_sign "" "u")
      #
      # Remember that CHAR_BIT minimum value is 8 -;
      #
      foreach(_size 8 16 32 64)
	math(EXPR _sizeof "${_size} / ${C_CHAR_BIT}")
	#
	# Speciying a MIN for unsigned case is meaningless (it is always zero) and not in the standard.
	# We neverthless set it, well, to zero.
	#
	set(_mytypemin CMAKE_HELPERS_${_sign}int${_size}_MIN)
	string(TOUPPER ${_mytypemin} _MYTYPEMIN)
	set(_mytypemax CMAKE_HELPERS_${_sign}int${_size}_MAX)
	string(TOUPPER ${_mytypemax} _MYTYPEMAX)
	#
	# Always define the CMAKE_HELPERS_XXX_MIN and CMAKE_HELPERS_XXX_MAX
	#
	foreach(_c "char" "short" "int" "long" "long long")
          #
          # Without an extension, integer literal is always int,
          # so we have to handle the case of "long" and "long long"
          #
          if(_c STREQUAL "char")
            set(_extension "")
          elseif(_c STREQUAL "short")
            set(_extension "")
          elseif (_c STREQUAL "int")
            set(_extension "")
          elseif(_c STREQUAL "long")
            if("x${_sign}" STREQUAL "x")
              set(_extension "L")
            elseif(_sign STREQUAL "u")
              set(_extension "UL")
            else()
              message(FATAL_ERROR "Unsupported size ${_size}")
            endif()
          elseif(_c STREQUAL "long long")
            #
            # By definition, this C supports "long long", so it must support the "LL" suffix
	    #
            if("x${_sign}" STREQUAL "x")
              set(_extension "LL")
            elseif(_sign STREQUAL "u")
              set(_extension "ULL")
            else()
              message(FATAL_ERROR "Unsupported size ${_size}")
            endif()
          else()
            message(FATAL_ERROR "Unsupported c ${_c}")
          endif()
          string(TOUPPER ${_c} _C)
          string(REPLACE " " "_" _C "${_C}")
          if(HAVE_SIZEOF_${_C})
            if(${SIZEOF_${_C}} EQUAL ${_sizeof})
              #
              # In C language, a decimal constant without a u/U is always signed,
              # but an hexadecimal constant is signed or unsigned, depending on value and integer type range
	      #
              if(_size EQUAL 8)
		if("x${_sign}" STREQUAL "x")
                  set(${_MYTYPEMIN} "(-127${_extension} - 1${_extension})")
                  set(${_MYTYPEMAX} "127${_extension}")
		elseif(_sign STREQUAL "u")
		  set(${_MYTYPEMIN} "0x00${_extension}")
                  set(${_MYTYPEMAX} "0xFF${_extension}")
		else()
                  message(FATAL_ERROR "Unsupported size ${_size}")
		endif()
              elseif(_size EQUAL 16)
		if("x${_sign}" STREQUAL "x")
                  set(${_MYTYPEMIN} "(-32767${_extension} - 1${_extension})")
                  set(${_MYTYPEMAX} "32767${_extension}")
		elseif(_sign STREQUAL "u")
                  set(${_MYTYPEMIN} "0x0000${_extension}")
                  set(${_MYTYPEMAX} "0xFFFF${_extension}")
		else()
                  message(FATAL_ERROR "Unsupported size ${_size}")
		endif()
              elseif(_size EQUAL 32)
		if("x${_sign}" STREQUAL "x")
                  set(${_MYTYPEMIN} "(-2147483647${_extension} - 1${_extension})")
                  set(${_MYTYPEMAX} "2147483647${_extension}")
		elseif(_sign STREQUAL "u")
                  set(${_MYTYPEMIN} "0x00000000${_extension}")
                  set(${_MYTYPEMAX} "0xFFFFFFFF${_extension}")
		else()
                  message(FATAL_ERROR "Unsupported size ${_size}")
		endif()
              elseif(_size EQUAL 64)
		if("x${_sign}" STREQUAL "x")
                  set(${_MYTYPEMIN} "(-9223372036854775807${_extension} - 1${_extension})")
                  set(${_MYTYPEMAX} "9223372036854775807${_extension}")
		elseif(_sign STREQUAL "u")
                  set(${_MYTYPEMIN} "0x0000000000000000${_extension}")
                  set(${_MYTYPEMAX} "0xFFFFFFFFFFFFFFFF${_extension}")
		else()
                  message(FATAL_ERROR "Unsupported size ${_size}")
		endif()
              else()
		MESSAGE(FATAL_ERROR "Unsupported size ${_size}")
              endif()
            endif()
          endif()
	endforeach()
	#
	# We handle the _least and _fast variations
	#
	foreach(_variation "" "_least" "_fast")

          set(_ctype    ${_sign}int${_variation}${_size}_t)
          string(TOUPPER ${_ctype} _CTYPE)

          set(_mytype    CMAKE_HELPERS_${_sign}int${_variation}${_size})
          string(TOUPPER ${_mytype} _MYTYPE)

          set(_MYTYPEDEF ${_MYTYPE}_TYPEDEF)

          set(HAVE_${_MYTYPE} FALSE)
          set(${_MYTYPE} "")
          set(${_MYTYPEDEF} "")

          #
          # Try with C types
          #
          set(_found_type FALSE)
          foreach(_c "char" "short" "int" "long" "long long")
            if(_sign STREQUAL "u")
	      set(_c "unsigned ${_c}")
            endif()
            string(TOUPPER ${_c} _C)
            string(REPLACE " " "_" _C "${_C}")
            if(HAVE_SIZEOF_${_C})
	      if("x${_variation}" STREQUAL "x")
                if(${SIZEOF_${_C}} EQUAL ${_sizeof})
                  set(HAVE_${_MYTYPE} TRUE)
                  set(SIZEOF_${_MYTYPE} ${${_TYPE}})
                  set(${_MYTYPEDEF} ${_c})
                  break()
                endif()
	      elseif(_variation STREQUAL "_least")
                if(NOT (${SIZEOF_${_C}} LESS ${_sizeof}))
                  set(HAVE_${_MYTYPE} TRUE)
                  set(SIZEOF_${_MYTYPE} ${${_TYPE}})
                  set(${_MYTYPEDEF} ${_c})
                  break()
                endif()
	      elseif(_variation STREQUAL "_fast")
                #
                # We give the same result as _least
                #
                if(NOT (${SIZEOF_${_C}} LESS ${_sizeof}))
                  set(HAVE_${_MYTYPE} TRUE)
                  set(SIZEOF_${_MYTYPE} ${${_TYPE}})
                  set(${_MYTYPEDEF} ${_c})
                  break()
                endif()
	      else()
                message(FATAL_ERROR "Unsupported variation ${_variation}")
	      endif()
            endif()
          endforeach()
          mark_as_advanced(
            HAVE_${_MYTYPE}
            SIZEOF_${_MYTYPE}
            HAVE_${_CTYPE}
            ${_MYTYPEDEF}
            ${_MYTYPEMIN}
            ${_MYTYPEMAX}
	  )
	endforeach()
      endforeach()
    endforeach()
    #
    # Integer type capable of holding object pointers
    #
    foreach(_sign "" "u")
      set(_sizeof ${SIZEOF_VOID_STAR})
      set(_ctype    ${_sign}intptr_t)
      string(TOUPPER ${_ctype} _CTYPE)
      set(_mytype    CMAKE_HELPERS_${_sign}intptr)
      string(TOUPPER ${_mytype} _MYTYPE)
      set(_MYTYPEDEF ${_MYTYPE}_TYPEDEF)

      set(HAVE_${_MYTYPE} FALSE)
      set(${_MYTYPE} "")
      set(${_MYTYPEDEF} "")

      set(_type ${_sign}intptr_t)
      string(TOUPPER ${_type} _TYPE)
      check_type_size(${_type} ${_TYPE})
      if(HAVE_${_TYPE})
	set(HAVE_${_MYTYPE} TRUE)
	set(SIZEOF_${_MYTYPE} ${${_TYPE}})
	set(${_MYTYPEDEF} ${_type})
	if(${_type} STREQUAL ${_ctype})
          set(HAVE_${_CTYPE} TRUE)
	else()
          set(HAVE_${_CTYPE} FALSE)
	endif()
      endif()
      IF (NOT HAVE_${_MYTYPE})
	#
	# Try with C types
	#
	foreach(_c "char" "short" "int" "long" "long long")
          if("${_sign}" STREQUAL "u")
            set(_c "unsigned ${_c}")
          endif()
          string(TOUPPER ${_c} _C)
          string(REPLACE " " "_" _C "${_C}")
          if(HAVE_SIZEOF_${_C})
            if(${SIZEOF_${_C}} EQUAL ${_sizeof})
              set(HAVE_${_MYTYPE} TRUE)
              set(SIZEOF_${_MYTYPE} ${${_TYPE}})
              set(${_MYTYPEDEF} ${_c})
              break()
            endif()
          endif()
          mark_as_advanced(
            HAVE_${_MYTYPE}
            SIZEOF_${_MYTYPE}
            HAVE_${_CTYPE}
            ${_MYTYPEDEF}
	  )
	endforeach()
      endif()
    endforeach()
    #
    # Header files generation
    #
    set(_header_files_generated FALSE)
    if((NOT HAVE_STDINT_H) AND CMAKE_HELPERS_GENERATE_STDINT_H AND CMAKE_HELPERS_INCLUDE_GENDIR)
      set(_output_file "${CMAKE_HELPERS_INCLUDE_GENDIR}/${CMAKE_HELPERS_STDINT_H_PATH}")
      message(STATUS "Generating ${_output_file}")
      configure_file(${PROJECT_SOURCE_DIR}/cmake/stdint.h.in ${_output_file})
      get_filename_component(_cmake_helpers_stdint_h_directory ${_output_file} DIRECTORY)
      set(_header_files_generated TRUE)
    endif()
    if((NOT HAVE_INTTYPES_H) AND CMAKE_HELPERS_GENERATE_INTTYPES_H AND CMAKE_HELPERS_INCLUDE_GENDIR)
      set(_output_file "${CMAKE_HELPERS_INCLUDE_GENDIR}/${CMAKE_HELPERS_INTTYPES_H_PATH}")
      message(STATUS "Generating ${_output_file}")
      configure_file(${PROJECT_SOURCE_DIR}/cmake/inttypes.h.in ${_output_file})
      get_filename_component(_cmake_helpers_inttypes_h_directory ${_output_file} DIRECTORY)
      set(_header_files_generated TRUE)
    endif()
    if(_header_files_generated)
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "${CMAKE_HELPERS_INCLUDE_GENDIR} should be added by caller to its include path")
      endif()
    endif()
  endblock()
  #
  # Check GNU features
  #
  check_symbol_exists(__GNU_LIBRARY__ "features.h" _GNU_SOURCE)
  #
  # Remember we were initialized
  #
  set_property(GLOBAL PROPERTY CMAKE_HELPERS_INITIALIZED TRUE)
endfunction()
