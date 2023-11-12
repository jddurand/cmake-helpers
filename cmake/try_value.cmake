function(cmake_helpers_try_value name configure_input extname)
  string(TOUPPER ${name} _name_upper)
  set(_singleton CMAKE_HELPERS_TRY_RUN_${_name_upper}_SINGLETON)
  if(NOT ${_singleton})
    set(_configure_output ${CMAKE_CURRENT_BINARY_DIR}/_configure.c)
    configure_file(${configure_input} ${_configure_output})
    message(STATUS "Looking for ${extname}")
    try_run(
      _run_result
      _compile_result
      SOURCE_FROM_FILE _try.c ${_configure_output}
      COMPILE_OUTPUT_VARIABLE _compile_output
      RUN_OUTPUT_VARIABLE _run_output
    )
    if(CMAKE_HELPERS_DEBUG)
      file(READ ${_configure_output} _source)
      message(STATUS "Source:\n${_source}")
      message(STATUS "Compile result: ${_compile_result}")
      message(STATUS "Compile output:\n${_compile_output}")
      message(STATUS "Run result: ${_run_result}")
      message(STATUS "Run output:\n${_run_output}")
    endif()
    if(_compile_result AND (_run_result EQUAL 0))
      message(STATUS "Looking for ${name} gives ${_run_output}")
      set(${name} ${_run_output} CACHE STRING "${name} try_run result")
      mark_as_advanced(${name})
    else()
      message(STATUS "Looking for ${name} failed")
    endif()
    set(${_singleton} TRUE CACHE BOOL "${name} try_run singleton")
    mark_as_advanced(${_singleton})
    file(REMOVE ${_configure_output})
  endif()
endfunction()
