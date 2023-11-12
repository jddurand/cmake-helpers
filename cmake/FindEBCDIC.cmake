function(FindEBCDIC)
  if(NOT C_EBCDIC_SINGLETON)
    #
    # We depend on stdlib.h
    #
    if(HAVE_STDLIB_H)
      set(_HAVE_STDLIB_H 1)
    else()
      set(_HAVE_STDLIB_H 0)
    endif()
    #
    # Test
    #
    try_run(
      _run_result
      _compile_result
      SOURCE_FROM_FILE try ${PROJECT_SOURCE_DIR}/cmake/EBCDIC.c
      LOG_DESCRIPTION "Looking for EBCDIC"
      COMPILE_DEFINITIONS -DHAVE_STDLIB_H=${_HAVE_STDLIB_H}
      COMPILE_OUTPUT_VARIABLE _compile_output
      RUN_OUTPUT_VARIABLE _run_output
    )
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "Compile result: ${_compile_result}")
      message(STATUS "Compile output: ${_compile_output}")
      message(STATUS "Run result: ${_run_result}")
      message(STATUS "Run output: ${_run_output}")
    endif()
    if(_compile_result AND (_run_result EQUAL 0))
      set(_EBCDIC TRUE)
    else()
      set(_EBCDIC FALSE)
    endif()
    set(EBCDIC ${_EBCDIC} CACHE BOOL "System coding is EBCDIC")
    mark_as_advanced(EBCDIC)
    set(C_EBCDIC_SINGLETON TRUE CACHE BOOL "C EBCDIC check singleton")
    mark_as_advanced(C_EBCDIC_SINGLETON)
  endif ()
endfunction()
