function(cmake_helpers_try_value name configure_input extname)
  string(TOUPPER ${name} _name_upper)
  set(_singleton CMAKE_HELPERS_TRY_RUN_${_name_upper}_SINGLETON)
  if(NOT ${_singleton})
    set(_compile_definitions ${CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS})
    set(_configure_output ${CMAKE_CURRENT_BINARY_DIR}/_configure.c)
    configure_file(${configure_input} ${_configure_output})
    message(STATUS "Looking for ${extname}")
    try_run(
      _run_result
      _compile_result
      SOURCE_FROM_FILE _try.c ${_configure_output}
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
      message(STATUS "Looking for ${extname} gives ${_run_output}")
      set(${name} ${_run_output} CACHE STRING "${name} try_run result" FORCE)
      mark_as_advanced(${name})
      set(_found_value_ TRUE)
    else()
      message(STATUS "Looking for ${extname} failed")
      set(_found_value FALSE)
    endif()
    #
    # Put a boolean for tests - the value itself can lead to some suprising result, e.g. INFINITY
    #
    set(${name}_FOUND ${_found_value} CACHE BOOL "${name} try_run found result" FORCE)
    mark_as_advanced(${name}_FOUND)
    #
    # Set singleton to prevent multiple calls
    #
    set(${_singleton} TRUE CACHE BOOL "${name} try_run singleton" FORCE)
    mark_as_advanced(${_singleton})
    file(REMOVE ${_configure_output})
  endif()
endfunction()
