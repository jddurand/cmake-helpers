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
  foreach(_variable have_application)
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
  # Add an executable using all library targets
  #
  set(_cmake_helpers_exe_targets)
  foreach(_cmake_helper_library_target ${_cmake_helpers_library_targets})
    get_target_property(_type ${_cmake_helper_library_target} TYPE)
    if(_type STREQUAL "STATIC_LIBRARY")
      set(_output_name "${name}${_cmake_helpers_library_static_suffix}")
    else()
      set(_output_name "${name}")
    endif()
    set(_target "${_output_name}_exe")
    cmake_helpers_call(add_executable ${_target} ${_cmake_helpers_exe_sources})
    list(APPEND _cmake_helpers_exe_targets ${_target})
    cmake_helpers_call(set_target_properties ${_target} PROPERTIES OUTPUT_NAME ${_output_name})
    cmake_helpers_call(target_link_libraries ${_target} ${_cmake_helper_library_target})
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
      if(NOT _cmake_helpers_have_application)
	set(_cmake_helpers_have_application TRUE)
	cmake_helpers_call(install
	  EXPORT ${_cmake_helpers_library_namespace}ApplicationTargets
	  NAMESPACE ${_cmake_helpers_library_namespace}::
	  DESTINATION ${_cmake_helpers_library_install_cmakedir}
	  COMPONENT Library)
	set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_application ${_cmake_helpers_have_application})
      endif()
    endif()
    if(_cmake_helpers_exe_test)
      include(CTest)
      cmake_helpers_call(add_test NAME ${_target}_test COMMAND ${_target} ${_cmake_helpers_exe_test_args})
      #
      # A tiny hook to force ctest to build the executable
      #
      cmake_helpers_call(add_test NAME ${_target}_build COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}" --target ${_target})
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
