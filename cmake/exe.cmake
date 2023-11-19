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
      targets
      static_suffix
      export_cmake_name)
    get_property(_cmake_helpers_library_${_variable} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_${_variable})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] _cmake_helpers_library_${_variable}: ${_cmake_helpers_library_${_variable}}")
    endif()
  endforeach()
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  #
  set(_options INSTALL TEST)
  set(_oneValueArgs)
  set(_multiValueArgs SOURCES TEST_ARGS)
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
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_helpers_exe "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # Add an executable using all library targets
  #
  foreach(_cmake_helper_library_target ${_cmake_helpers_library_targets})
    get_target_property(_type ${_cmake_helper_library_target} TYPE)
    if(_type STREQUAL "STATIC_LIBRARY")
      set(_output_name "${name}${_cmake_helpers_library_static_suffix}")
    else()
      set(_output_name "${name}")
    endif()
    set(_target "${_output_name}_exe")
    cmake_helpers_call(add_executable ${_target} ${_cmake_helpers_exe_sources})
    cmake_helpers_call(set_target_properties ${_target} PROPERTIES OUTPUT_NAME ${_output_name})
    cmake_helpers_call(target_link_libraries ${_target} ${_cmake_helper_library_target})
    if(_cmake_helpers_exe_install)
      cmake_helpers_call(install
	TARGETS ${_target}
	EXPORT ${_cmake_helpers_library_export_cmake_name}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	COMPONENT ApplicationComponent
      )
      set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_applicationcomponent TRUE)
    endif()
    if(_cmake_helpers_exe_test)
      include(CTest)
      cmake_helpers_call(add_test NAME ${_target}_test COMMAND ${_target} ${_cmake_helpers_exe_test_args})
    endif()
  endforeach()
  #
  # End
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
    message(STATUS "[${_cmake_helpers_logprefix}] Ending")
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
  endif()
endfunction()
