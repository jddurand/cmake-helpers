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
    message(STATUS "Looking for EBCDIC")
    set(_configure_input ${PROJECT_SOURCE_DIR}/cmake/EBCDIC.c)
    set(_configure_output ${CMAKE_CURRENT_BINARY_DIR}/configure.c)
    configure_file(${_configure_input} ${_configure_output})
    set(_compile_definitions)
    try_run(
      _run_result
      _compile_result
      SOURCE_FROM_FILE try.c ${_configure_output}
      COMPILE_DEFINITIONS ${_compile_definitions}
      COMPILE_OUTPUT_VARIABLE _compile_output
      RUN_OUTPUT_VARIABLE _run_output
    )
    if(CMAKE_HELPERS_DEBUG)
      file(READ ${_configure_output} _source)
      message(STATUS "Source:\n${_source}")
      message(STATUS "Compile definitions: ${_compile_definitions}")
      message(STATUS "Compile result: ${_compile_result}")
      message(STATUS "Compile output:\n${_compile_output}")
      message(STATUS "Run result: ${_run_result}")
      message(STATUS "Run output:\n${_run_output}")
    endif()
    if(_compile_result AND (_run_result EQUAL 0))
      message(STATUS "Looking for EBCDIC - yes")
      set(_EBCDIC TRUE)
    else()
      message(STATUS "Looking for EBCDIC - no")
      set(_EBCDIC FALSE)
    endif()
    set(EBCDIC ${_EBCDIC} CACHE BOOL "System coding is EBCDIC")
    mark_as_advanced(EBCDIC)
    set(C_EBCDIC_SINGLETON TRUE CACHE BOOL "C EBCDIC check singleton")
    mark_as_advanced(C_EBCDIC_SINGLETON)
  endif ()
endfunction()
