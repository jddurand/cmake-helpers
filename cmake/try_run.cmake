function(cmake_helpers_try_run name configure_input)
  set(_values ${ARGN})
  string(TOUPPER ${name} _name_upper)
  set(_singleton CMAKE_HELPERS_TRY_RUN_${_name_upper}_SINGLETON)
  if(NOT ${_singleton})
    set(_compile_definitions ${CMAKE_HELPERS_TRY_RUN_COMPILE_DEFINITIONS})
    set(_configure_output ${CMAKE_CURRENT_BINARY_DIR}/_configure.c)
    configure_file(${configure_input} ${_configure_output})
    unset(_forced_value)
    set(_found_value FALSE)
    if (_values)
      foreach(_value ${_values})
	set(_compile_and_value_definitions ${_compile_definitions} -D${name}=${_value})
	message(STATUS "Looking for ${_value}")
	try_run(
	  _run_result
	  _compile_result
	  SOURCE_FROM_FILE _try.c ${_configure_output}
	  COMPILE_DEFINITIONS ${_compile_and_value_definitions}
	  COMPILE_OUTPUT_VARIABLE _compile_output
	  RUN_OUTPUT_VARIABLE _run_output
	)
	if(CMAKE_HELPERS_DEBUG)
	  file(READ ${_configure_output} _source)
	  message(STATUS "Source:\n${_source}")
	  message(STATUS "Compile definitions: ${_compile_and_value_definitions}")
	  message(STATUS "Compile result: ${_compile_result}")
	  message(STATUS "Compile output:\n${_compile_output}")
	  message(STATUS "Run result: ${_run_result}")
	  message(STATUS "Run output:\n${_run_output}")
	endif()
	if(_compile_result AND (_run_result EQUAL 0))
	  message(STATUS "Looking for ${_value} - yes")
	  set(_forced_value ${_value})
	  set(_found_value TRUE)
	  break()
	else()
	  message(STATUS "Looking for ${_value} - no")
	endif()
      endforeach()
    else()
      message(STATUS "Looking for ${name}")
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
	message(STATUS "Looking for ${name} - yes")
	set(_found_value TRUE)
      else()
	message(STATUS "Looking for ${name} - no")
      endif()
    endif()
    if(DEFINED _forced_value)
      set(${name} ${_forced_value} CACHE STRING "${name} try_run result" FORCE)
    else()
      set(${name} ${_found_value} CACHE BOOL "${name} try_run result" FORCE)
    endif()
    mark_as_advanced(${name})
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
