function(cmake_helpers_exe name)
  #
  # Log prefix
  #
  set(_cmake_helpers_logprefix "cmake_helpers/${PROJECT_NAME}/exe")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
    message(STATUS "[${_cmake_helpers_logprefix}] Starting")
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
  endif()
  #
  # Check exe name
  #
  if(NOT name)
    message(FATAL_ERROR "name argument is missing")
  endif()
  #
  # Recuperate directory library properties
  #
  foreach(_variable
      namespace
      targets
      install_bindir
      install_cmakedir)
    get_property(_cmake_helpers_library_${_variable} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_${_variable})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] _cmake_helpers_library_${_variable}: ${_cmake_helpers_library_${_variable}}")
    endif()
  endforeach()
  #
  # Recuperate directory have properties
  #
  foreach(_variable have_application_component)
    get_property(_cmake_helpers_${_variable} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_${_variable})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] _cmake_helpers_${_variable}: ${_cmake_helpers_${_variable}}")
    endif()
  endforeach()
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  #
  set(_options)
  set(_oneValueArgs
    INSTALL
    TEST
    EXPORT_CMAKE_NAME
  )
  set(_multiValueArgs
    SOURCES
    TEST_ARGS
    DEPENDS
    TARGETS_OUTVAR
  )
  #
  # Options default values
  #
  set(_cmake_helpers_exe_install           FALSE)
  set(_cmake_helpers_exe_test              FALSE)
  set(_cmake_helpers_exe_export_cmake_name ${_cmake_helpers_library_namespace}ApplicationTargets)
  #
  # Multi-value options default values
  #
  set(_cmake_helpers_exe_sources)
  set(_cmake_helpers_exe_test_args)
  set(_cmake_helpers_exe_depends)
  set(_cmake_helpers_exe_targets_outvar)
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_helpers_exe "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # Add an executable using all library targets. We are not supposed to have none, but we support this case anyway.
  #
  set(_cmake_helpers_exe_targets)
  if(NOT _cmake_helpers_library_targets)
    set(_cmake_helpers_library_targets FALSE)
  endif()
  foreach(_cmake_helpers_library_target ${_cmake_helpers_library_targets})
    if(TARGET ${_cmake_helpers_library_target})
      cmake_helpers_call(get_target_property _cmake_helpers_library_type ${_cmake_helpers_library_target} TYPE)
      if(_cmake_helpers_library_type STREQUAL "SHARED_LIBRARY")
        set(_cmake_helpers_exe_output_name "${name}_shared")
	set(_cmake_helpers_exe_link_type PUBLIC)
	set(_cmake_helpers_exe_target_dir $<TARGET_FILE_DIR:${_cmake_helpers_library_target}>)
      elseif(_cmake_helpers_library_type STREQUAL "STATIC_LIBRARY")
        set(_cmake_helpers_exe_output_name "${name}_static")
	set(_cmake_helpers_exe_link_type PUBLIC)
	set(_cmake_helpers_exe_target_dir $<TARGET_FILE_DIR:${_cmake_helpers_library_target}>)
      elseif(_cmake_helpers_library_type STREQUAL "MODULE_LIBRARY")
        #
        # One cannot link with a module library
        #
        continue()
      elseif(_cmake_helpers_library_type STREQUAL "INTERFACE_LIBRARY")
        set(_cmake_helpers_exe_output_name "${name}_iface")
	set(_cmake_helpers_exe_link_type PUBLIC)
	set(_cmake_helpers_exe_target_dir)
      elseif(_cmake_helpers_library_type STREQUAL "OBJECT_LIBRARY")
        set(_cmake_helpers_exe_output_name "${name}_objs")
	set(_cmake_helpers_exe_target_dir)
      else()
        message(FATAL_ERROR "Unsupported library type ${_cmake_helpers_library_type}")
      endif()
    else()
      set(_cmake_helpers_exe_output_name "${name}")
    endif()
    set(_target "${_cmake_helpers_exe_output_name}_exe")
    #
    # We do not want to include the executable in the ALL target if this is only for tests
    #
    if(_cmake_helpers_exe_test AND (NOT _cmake_helpers_exe_install))
      cmake_helpers_call(add_executable ${_target} EXCLUDE_FROM_ALL ${_cmake_helpers_exe_sources})
    else()
      cmake_helpers_call(add_executable ${_target} ${_cmake_helpers_exe_sources})
    endif()
    list(APPEND _cmake_helpers_exe_targets ${_target})
    cmake_helpers_call(set_target_properties ${_target} PROPERTIES OUTPUT_NAME ${_cmake_helpers_exe_output_name})
    if(TARGET ${_cmake_helpers_library_target})
      cmake_helpers_call(target_link_libraries ${_target} ${_cmake_helpers_exe_link_type} ${_cmake_helpers_library_target})
    endif()
    #
    # Apply eventual dependencies, every item in the list must be a space separated list
    #
    if(_cmake_helpers_exe_depends)
      foreach(_cmake_helpers_exe_depend ${_cmake_helpers_exe_depends})
	separate_arguments(_args UNIX_COMMAND "${_cmake_helpers_exe_depend}")
	cmake_helpers_call(target_link_libraries ${_target} ${_args})
      endforeach()
    endif()
    if(_cmake_helpers_exe_install)
      cmake_helpers_call(install
	TARGETS ${_target}
	EXPORT ${_cmake_helpers_exe_export_cmake_name}
	RUNTIME DESTINATION ${_cmake_helpers_library_install_bindir}
	COMPONENT Application
      )
      #
      ## Call for install of the export once
      #
      if(NOT _cmake_helpers_have_application_component)
	set(_cmake_helpers_have_application_component TRUE)
	cmake_helpers_call(install
	  EXPORT ${_cmake_helpers_exe_export_cmake_name}
	  NAMESPACE ${_cmake_helpers_library_namespace}::
	  DESTINATION ${_cmake_helpers_library_install_cmakedir}
	  COMPONENT Library)
	set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_application_component ${_cmake_helpers_have_application_component})
      endif()
    endif()
    if(_cmake_helpers_exe_test)
      enable_testing()
      cmake_helpers_call(add_test NAME ${_target}_test COMMAND ${_target} ${_cmake_helpers_exe_test_args})
      #
      # Search path for the dependencies
      #
      if(_cmake_helpers_exe_target_dir)
	cmake_helpers_call(set_tests_properties ${_target}_test PROPERTIES ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:$<$<BOOL:${WIN32}>:${_cmake_helpers_exe_target_dir}>")
      endif()
      if(_cmake_helpers_exe_depends)
	foreach(_cmake_helpers_exe_depend ${_cmake_helpers_exe_depends})
	  separate_arguments(_args UNIX_COMMAND "${_cmake_helpers_exe_depend}")
	  message(STATUS "=========> ${_cmake_helpers_exe_depend} => ${_args}")
	  foreach (_arg ${_args})
	    message(STATUS "=========> Testing target ${_arg}")
	    if(TARGET ${_arg}) # This will skip natively PUBLIC/PRIVATE/INTERFACE ;)
	      cmake_helpers_call(get_target_property _arg_type ${_arg} TYPE)
	      message(STATUS "=========> Target type is ${_arg_type}")
	      if(_arg_type STREQUAL "SHARED_LIBRARY")
		set(_arg_dir $<TARGET_FILE_DIR:${_arg}>)
	      elseif(_cmake_helpers_library_type STREQUAL "STATIC_LIBRARY")
		set(_arg_dir $<TARGET_FILE_DIR:${_arg}>)
	      else()
		set(_arg_dir)
	      endif()
	      if(_arg_dir)
		cmake_helpers_call(set_tests_properties ${_target}_test PROPERTIES ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:$<$<BOOL:${WIN32}>:${_arg_dir}>")
	      endif()
	    endif()
	  endforeach()
	  cmake_helpers_call(target_link_libraries ${_target} ${_args})
	endforeach()
      endif()
      #
      # A tiny hook to force ctest to build the executable
      #
      set(_cmake_helpers_exe_config $<CONFIG>)
      if(_cmake_helpers_exe_config)
	set(_cmake_helpers_exe_config_args --config "${_cmake_helpers_exe_config}")
      else()
	set(_cmake_helpers_exe_config_args)
      endif()
      cmake_helpers_call(add_test NAME ${_target}_build COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}" ${_cmake_helpers_exe_config_args} --target ${_target})
      cmake_helpers_call(set_tests_properties ${_target}_test PROPERTIES DEPENDS ${_target}_build)
    endif()
  endforeach()
  #
  # Send-out the targets
  #
  if(_cmake_helpers_exe_targets_outvar)
    set(${_cmake_helpers_exe_targets_outvar} ${_cmake_helpers_exe_targets} PARENT_SCOPE)
  endif()
  #
  # End
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
    message(STATUS "[${_cmake_helpers_logprefix}] Ending")
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
  endif()
endfunction()
