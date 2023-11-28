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
      static_suffix
      export_cmake_name
      install_bindir
      install_libdir
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
  )
  set(_multiValueArgs
    SOURCES
    TEST_ARGS
    TARGETS_OUTVAR
  )
  #
  # Options default values
  #
  set(_cmake_helpers_exe_install FALSE)
  set(_cmake_helpers_exe_test    FALSE)
  #
  # Multi-value options default values
  #
  set(_cmake_helpers_exe_sources)
  set(_cmake_helpers_exe_test_args)
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
  foreach(_cmake_helper_library_target ${_cmake_helpers_library_targets})
    if(TARGET ${_cmake_helper_library_target})
      get_target_property(_cmake_helper_library_type ${_cmake_helper_library_target} TYPE)
      if(_cmake_helper_library_type STREQUAL "SHARED_LIBRARY")
        set(_output_name "${name}_shared")
      elseif(_cmake_helper_library_type STREQUAL "STATIC_LIBRARY")
        set(_output_name "${name}_static")
      elseif(_cmake_helper_library_type STREQUAL "MODULE_LIBRARY")
        #
        # One cannot link with a module library
        #
        continue()
      elseif(_cmake_helper_library_type STREQUAL "INTERFACE_LIBRARY")
        set(_output_name "${name}_iface")
      elseif(_cmake_helper_library_type STREQUAL "OBJECT_LIBRARY")
        set(_output_name "${name}_objs")
      else()
        message(FATAL_ERROR "Unsupported library type ${_cmake_helper_library_type}")
      endif()
    else()
      set(_output_name "${name}")
    endif()
    set(_target "${_output_name}_exe")
    #
    # We do not want to include the executable in the ALL target if this is only for tests
    #
    if(_cmake_helpers_exe_test AND (NOT _cmake_helpers_exe_install))
      cmake_helpers_call(add_executable ${_target} EXCLUDE_FROM_ALL ${_cmake_helpers_exe_sources})
    else()
      cmake_helpers_call(add_executable ${_target} ${_cmake_helpers_exe_sources})
    endif()
    list(APPEND _cmake_helpers_exe_targets ${_target})
    cmake_helpers_call(set_target_properties ${_target} PROPERTIES OUTPUT_NAME ${_output_name})
    if(TARGET ${_cmake_helper_library_target})
      cmake_helpers_call(target_link_libraries ${_target} ${_cmake_helper_library_target})
    endif()
    if(_cmake_helpers_exe_install)
      cmake_helpers_call(install
	TARGETS ${_target}
	EXPORT ${_cmake_helpers_library_namespace}ApplicationTargets
	RUNTIME DESTINATION ${_cmake_helpers_library_install_bindir}
	COMPONENT Application
      )
      #
      ## Call for install of the export once
      #
      if(NOT _cmake_helpers_have_application_component)
	set(_cmake_helpers_have_application_component TRUE)
	cmake_helpers_call(install
	  EXPORT ${_cmake_helpers_library_namespace}ApplicationTargets
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
      # A tiny hook to force ctest to build the executable
      #
      set(_cmake_helpers_exe_config $<CONFIG>)
      if(_cmake_helpers_exe_config)
	cmake_helpers_call(add_test NAME ${_target}_build COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}" --config "${_cmake_helpers_exe_config}" --target ${_target})
      else()
	cmake_helpers_call(add_test NAME ${_target}_build COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}" --target ${_target})
      endif()
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
