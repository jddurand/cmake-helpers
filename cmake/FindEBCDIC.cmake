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
      LOG_DESCRIPTION "Looking for EBCDIC"
      SOURCES ${PROJECT_SOURCE_DIR}/cmake/EBCDIC.c
      COMPILE_DEFINITIONS -DHAVE_STDLIB_H=${_HAVE_STDLIB_H}
      RUN_OUTPUT_VARIABLE _run_output)
      IF (_compile_result AND (_run_result EQUAL 0))
        SET(_EBCDIC TRUE)
      ELSE ()
        SET(_EBCDIC FALSE)
      ENDIF ()
    ENDIF ()
    set(EBCDIC ${_EBCDIC} CACHE BOOL "System coding is EBCDIC")
    mark_as_advanced(EBCDIC)
    set(C_EBCDIC_SINGLETON TRUE CACHE BOOL "C EBCDIC check singleton")
    mark_as_advanced(C_EBCDIC_SINGLETON)
  endif ()
endfunction()
