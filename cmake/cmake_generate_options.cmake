function(cmake_generate_options outvar)
  #
  # Log prefix
  #
  set(_cmake_helpers_logprefix "cmake_helpers/${PROJECT_NAME}/cmake_generate_options")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
    message(STATUS "[${_cmake_helpers_logprefix}] Starting")
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
  endif()
  #
  # Find options so that executing CMake via execute_process() will run
  # a process with a setup compatible with the parent
  #
  set(_common_cmake_options)
  if(CMAKE_GENERATOR)
    list(APPEND _common_cmake_options "-G")
    list(APPEND _common_cmake_options ${CMAKE_GENERATOR})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] Generator: ${CMAKE_GENERATOR}")
    endif()
  endif()
  if(CMAKE_GENERATOR_TOOLSET)
    list(APPEND _common_cmake_options "-T")
    list(APPEND _common_cmake_options ${CMAKE_GENERATOR_TOOLSET})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] Generator toolset: ${CMAKE_GENERATOR_TOOLSET}")
    endif()
  endif()
  if(CMAKE_GENERATOR_PLATFORM)
    list(APPEND _common_cmake_options "-A")
    list(APPEND _common_cmake_options ${CMAKE_GENERATOR_PLATFORM})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] Generator platform: ${CMAKE_GENERATOR_PLATFORM}")
    endif()
  elseif(FALSE)
    #
    # We copy/pasted the technique used in
    # https://github.com/OpenMathLib/OpenBLAS/blob/develop/cmake/system_check.cmake
    #
    if(CMAKE_CL_64 OR MINGW64)
      if (CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64.*|AARCH64.*|arm64.*|ARM64.*)")
	set(ARM64 1)
      else()
	set(X86_64 1)
      endif()
    elseif(MINGW OR (MSVC AND NOT CMAKE_CROSSCOMPILING))
      set(X86 1)
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "ppc.*|power.*|Power.*")
      set(POWER 1)
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "mips64.*")
      set(MIPS64 1)
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "loongarch64.*")
      set(LOONGARCH64 1)
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "riscv64.*")
      set(RISCV64 1)
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "amd64.*|x86_64.*|AMD64.*" OR (CMAKE_SYSTEM_NAME MATCHES "Darwin" AND CMAKE_SYSTEM_PROCESSOR MATCHES "i686.*|i386.*|x86.*"))
      if("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
	set(X86_64 1)
      else()
	set(X86 1)
      endif()
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "i686.*|i386.*|x86.*|amd64.*|AMD64.*")
      set(X86 1)
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64.*|AARCH64.*|arm64.*|ARM64.*|armv8.*)")
      if("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
	set(ARM64 1)
      else()
	set(ARM 1)
      endif()
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(arm.*|ARM.*)")
      set(ARM 1)
    elseif (${CMAKE_CROSSCOMPILING})
      if (${TARGET} STREQUAL "CORE2")
	set(X86 1)
      elseif (${TARGET} STREQUAL "P5600" OR ${TARGET} MATCHES "MIPS.*")
	set(MIPS32 1)
      elseif (${TARGET} STREQUAL "ARMV7")
	set(ARM 1)
      else()
	set(ARM64 1)
      endif ()
    endif()

    if (X86_64)
      set(ARCH "x86_64")
    elseif(X86)
      set(ARCH "x86")
    elseif(POWER)
      set(ARCH "power")
    elseif(MIPS32)
      set(ARCH "mips")
    elseif(MIPS64)
      set(ARCH "mips64")
    elseif(ARM)
      set(ARCH "arm")
    elseif(ARM64)
      set(ARCH "arm64")
    else()
      message(WARNING "[${_cmake_helpers_logprefix}] Target ARCH could not be determined, got \"${CMAKE_SYSTEM_PROCESSOR}\"")
      set(ARCH ${CMAKE_SYSTEM_PROCESSOR} CACHE STRING "Target Architecture")
    endif ()

    #
    # Hook only for generators that support the -A option.
    # This -A option was definitely not on the command-line, and we are very
    # probably not doing cross-platform compilation (then it is highly recommended
    # to set this variable).
    #
    if(CMAKE_GENERATOR MATCHES "Visual Studio")
      if(CMAKE_VS_PLATFORM_NAME)
	if(CMAKE_HELPERS_DEBUG)
	  message(STATUS "[${_cmake_helpers_logprefix}] Using CMAKE_VS_PLATFORM_NAME: ${CMAKE_VS_PLATFORM_NAME}")
	endif()
	list(APPEND _common_cmake_options "-A" "${CMAKE_VS_PLATFORM_NAME}")
      else()
	set(_guess)
	if(ARCH STREQUAL "x86")
	  set(_guess "Win32")
	elseif(ARCH STREQUAL "x86_64")
	  set(_guess "x64")
	elseif(ARCH STREQUAL "arm")
	  set(_guess "ARM")
	elseif(ARCH STREQUAL "arm64")
	  set(_guess "ARM64")
	else()
	endif()
	if(_guess)
	  if(CMAKE_HELPERS_DEBUG)
	    message(STATUS "[${_cmake_helpers_logprefix}] Guessing architecture ${_guess}")
	  endif()
	  list(APPEND _common_cmake_options "-A" ${_guess})
	else()
	  message(WARNING "[${_cmake_helpers_logprefix}] Guess of architecture failed")
	endif()
      endif()
    endif()
  endif()
  #
  # FETCHCONTENT_BASE_DIR
  #
  # list(APPEND _common_cmake_options "-DCMAKE_HELPERS_FETCHCONTENT_BASE_DIR=${CMAKE_HELPERS_FETCHCONTENT_BASE_DIR}")
  #
  # Disable warning on non-used variables
  #
  list(APPEND _common_cmake_options "--no-warn-unused-cli")
  #
  # Save result
  #
  set(${outvar} ${_common_cmake_options} PARENT_SCOPE)
  #
  # End
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
    message(STATUS "[${_cmake_helpers_logprefix}] Ending")
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
  endif()
endfunction()
