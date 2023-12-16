Function(cmake_helpers_exe name)
  # ============================================================================================================
  # This module can generate one export set:
  #
  # - ${PROJECT_NAME}ApplicationTargets
  #
  # This module can install one components:
  #
  # - ${PROJECT_NAME}ExeComponent
  #
  # This module depend on these ${CMAKE_CURRENT_BINARY_DIR} directory properties:
  #
  # - cmake_helpers_property_${PROJECT_NAME}_LibraryTargets
  #
  # These directory properties are generated on ${CMAKE_CURRENT_BINARY_DIR}:
  #
  # - cmake_helpers_property_${PROJECT_NAME}_HaveExeComponent             : Boolean indicating presence of COMPONENT ${PROJECT_NAME}ExeComponent
  # ============================================================================================================
  #
  # Check exe name
  #
  if(NOT name)
    message(FATAL_ERROR "name argument is missing")
  endif()
  #
  # Log prefix
  #
  set(_cmake_helpers_logprefix "cmake_helpers/${PROJECT_NAME}/exe/${name}")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
    message(STATUS "[${_cmake_helpers_logprefix}] Starting")
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
  endif()
  #
  # Constants
  #
  set(_cmake_helpers_exe_properties
    HaveExeComponent
  )
  set(_cmake_helpers_exe_array_properties
  )
  #
  # Directory properties dependencies
  #
  set(_cmake_helpers_exe_dependencies
    cmake_helpers_property_${PROJECT_NAME}_LibraryTargets
  )
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] -------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Dependencies:")
    message(STATUS "[${_cmake_helpers_logprefix}] -------------")
  endif()
  foreach(_cmake_helpers_exe_dependency ${_cmake_helpers_exe_dependencies})
    cmake_helpers_call(get_property ${_cmake_helpers_exe_dependency} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY ${_cmake_helpers_exe_dependency})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] ... ${_cmake_helpers_exe_dependency}: ${${_cmake_helpers_exe_dependency}}")
    endif()
  endforeach()
  #
  # Variables holding directory properties initialization.
  # They will be used at the end of this module.
  #
  foreach(_cmake_helpers_exe_property ${_cmake_helpers_exe_properties})
    cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_exe_property} FALSE)
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
    DEPENDS
    DEPENDS_EXT
    TARGETS_OUTVAR
  )
  #
  # Options default values
  #
  set(_cmake_helpers_exe_install                    FALSE)
  set(_cmake_helpers_exe_test                       FALSE)
  #
  # Multi-value options default values
  #
  set(_cmake_helpers_exe_sources)
  set(_cmake_helpers_exe_test_args)
  set(_cmake_helpers_exe_depends)
  set(_cmake_helpers_exe_depends_ext)
  set(_cmake_helpers_exe_targets_outvar)
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_helpers_exe "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # Add an executable using all library targets. We are not supposed to have none, but we support this case anyway.
  #
  set(_cmake_helpers_exe_targets)
  if(NOT cmake_helpers_property_${PROJECT_NAME}_LibraryTargets)
    set(cmake_helpers_property_${PROJECT_NAME}_LibraryTargets FALSE)
  endif()
  foreach(_cmake_helpers_library_target ${cmake_helpers_property_${PROJECT_NAME}_LibraryTargets})
    if(TARGET ${_cmake_helpers_library_target})
      get_target_property(_cmake_helpers_library_type ${_cmake_helpers_library_target} TYPE)
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
    set(_cmake_helpers_exe_target "${_cmake_helpers_exe_output_name}_exe")
    #
    # We do not want to include the executable in the ALL target if this is only for tests
    #
    if(_cmake_helpers_exe_test AND (NOT _cmake_helpers_exe_install))
      cmake_helpers_call(add_executable ${_cmake_helpers_exe_target} EXCLUDE_FROM_ALL ${_cmake_helpers_exe_sources})
    else()
      cmake_helpers_call(add_executable ${_cmake_helpers_exe_target} ${_cmake_helpers_exe_sources})
    endif()
    list(APPEND _cmake_helpers_exe_targets ${_cmake_helpers_exe_target})
    cmake_helpers_call(set_target_properties ${_cmake_helpers_exe_target} PROPERTIES OUTPUT_NAME ${_cmake_helpers_exe_output_name})
    if(TARGET ${_cmake_helpers_library_target})
      cmake_helpers_call(target_link_libraries ${_cmake_helpers_exe_target} ${_cmake_helpers_exe_link_type} ${_cmake_helpers_library_target})
    endif()
    #
    # Apply eventual dependencies, every item in the list must be a space separated list
    #
    if(_cmake_helpers_exe_depends)
      #
      # This must be a list of two items at every iteration: scope, lib
      #
      list(LENGTH _cmake_helpers_exe_depends _cmake_helpers_exe_depends_length)
      math(EXPR _cmake_helpers_exe_depends_length_modulo_2 "${_cmake_helpers_exe_depends_length} % 2")
      if(NOT(_cmake_helpers_exe_depends_length_modulo_2 EQUAL 0))
	message(FATAL_ERROR "DEPENDS option value must be a list of two items: scope, lib")
      endif()
      if(_cmake_helpers_exe_depends)
	math(EXPR _cmake_helpers_exe_depends_length_i_max "(${_cmake_helpers_exe_depends_length} / 2) - 1")
	set(_j -1)
	foreach(_i RANGE 0 ${_cmake_helpers_exe_depends_length_i_max})
	  math(EXPR _j "${_j} + 1")
	  list(GET _cmake_helpers_exe_depends ${_j} _cmake_helpers_exe_depend_scope)
	  math(EXPR _j "${_j} + 1")
	  list(GET _cmake_helpers_exe_depends ${_j} _cmake_helpers_exe_depend_lib)
	  cmake_helpers_call(target_link_libraries ${_cmake_helpers_exe_target} ${_cmake_helpers_exe_depend_scope} ${_cmake_helpers_exe_depend_lib})
	endforeach()
      endif()
    endif()
    if(_cmake_helpers_exe_depends_ext)
      #
      # This must be a list of three items at every iteration: scope, interface, lib
      #
      list(LENGTH _cmake_helpers_exe_depends_ext _cmake_helpers_exe_depends_ext_length)
      math(EXPR _cmake_helpers_exe_depends_ext_length_modulo_3 "${_cmake_helpers_exe_depends_ext_length} % 3")
      if(NOT(_cmake_helpers_exe_depends_ext_length_modulo_3 EQUAL 0))
	message(FATAL_ERROR "DEPENDS_EXT option value must be a list of three items: scope, interface, lib")
      endif()
      if(_cmake_helpers_exe_depends_ext)
	math(EXPR _cmake_helpers_exe_depends_ext_length_i_max "(${_cmake_helpers_exe_depends_ext_length} / 3) - 1")
	set(_j -1)
	foreach(_i RANGE 0 ${_cmake_helpers_exe_depends_ext_length_i_max})
	  math(EXPR _j "${_j} + 1")
	  list(GET _cmake_helpers_exe_depends_ext ${_j} _cmake_helpers_exe_depend_scope)
	  math(EXPR _j "${_j} + 1")
	  list(GET _cmake_helpers_exe_depends_ext ${_j} _cmake_helpers_exe_depend_interface)
	  math(EXPR _j "${_j} + 1")
	  list(GET _cmake_helpers_exe_depends_ext ${_j} _cmake_helpers_exe_depend_lib)
	  cmake_helpers_call(target_link_libraries ${_cmake_helpers_exe_target} ${_cmake_helpers_exe_depend_scope} $<${_cmake_helpers_exe_depend_interface}:${_cmake_helpers_exe_depend_lib}>)
	endforeach()
      endif()
    endif()
    #
    # Install
    #
    if(_cmake_helpers_exe_install)
      if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
	cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveExeComponent TRUE)
	cmake_helpers_call(install
	  TARGETS ${_cmake_helpers_exe_target}
	  EXPORT ${PROJECT_NAME}ApplicationTargets
	  RUNTIME DESTINATION ${CMAKE_HELPERS_INSTALL_BINDIR}
	  COMPONENT ${PROJECT_NAME}ExeComponent
	)
	cmake_helpers_call(install
	  EXPORT ${PROJECT_NAME}ApplicationTargets
	  NAMESPACE ${PROJECT_NAME}::
	  DESTINATION ${CMAKE_HELPERS_INSTALL_CMAKEDIR}
	  COMPONENT ${PROJECT_NAME}ExeComponent
	)
      endif()
    endif()
    if(_cmake_helpers_exe_test)
      enable_testing()
      cmake_helpers_call(add_test NAME ${_cmake_helpers_exe_target}_test COMMAND ${_cmake_helpers_exe_target} ${_cmake_helpers_exe_test_args})
      #
      # Search path for the dependencies
      #
      if(_cmake_helpers_exe_target_dir)
	cmake_helpers_call(set_tests_properties ${_cmake_helpers_exe_target}_test PROPERTIES ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:$<$<BOOL:${WIN32}>:${_cmake_helpers_exe_target_dir}>")
      endif()
      if(_cmake_helpers_exe_depends)
	#
	# This must be a list of two items at every iteration: scope, lib
	#
	list(LENGTH _cmake_helpers_exe_depends _cmake_helpers_exe_depends_length)
	math(EXPR _cmake_helpers_exe_depends_length_modulo_2 "${_cmake_helpers_exe_depends_length} % 2")
	if(NOT(_cmake_helpers_exe_depends_length_modulo_2 EQUAL 0))
	  message(FATAL_ERROR "DEPENDS option value must be a list of two items: scope, lib")
	endif()
	if(_cmake_helpers_exe_depends)
	  math(EXPR _cmake_helpers_exe_depends_length_i_max "(${_cmake_helpers_exe_depends_length} / 2) - 1")
	  set(_j -1)
	  foreach(_i RANGE 0 ${_cmake_helpers_exe_depends_length_i_max})
	    math(EXPR _j "${_j} + 1")
	    list(GET _cmake_helpers_exe_depends ${_j} _cmake_helpers_exe_depend_scope)
	    math(EXPR _j "${_j} + 1")
	    list(GET _cmake_helpers_exe_depends ${_j} _cmake_helpers_exe_depend_lib)
	    if(TARGET ${_cmake_helpers_exe_depend_lib})
	      get_target_property(_cmake_helpers_exe_depend_lib_type ${_cmake_helpers_exe_depend_lib} TYPE)
	      if((_cmake_helpers_exe_depend_lib_type STREQUAL "SHARED_LIBRARY") OR (_cmake_helpers_exe_depend_lib_type STREQUAL "STATIC_LIBRARY"))
		set(_cmake_helpers_exe_depend_lib_dir $<TARGET_FILE_DIR:${_cmake_helpers_exe_depend_lib}>)
	      else()
		set(_cmake_helpers_exe_depend_lib_dir)
	      endif()
	      if(_cmake_helpers_exe_depend_lib_dir)
		cmake_helpers_call(set_tests_properties ${_cmake_helpers_exe_target}_test PROPERTIES ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:$<$<BOOL:${WIN32}>:${_cmake_helpers_exe_depend_lib_dir}>")
	      endif()
	    endif()
	  endforeach()
	endif()
      endif()
      if(_cmake_helpers_exe_depends_ext)
	#
	# This must be a list of three items at every iteration: scope, interface, lib
	#
	list(LENGTH _cmake_helpers_exe_depends_ext _cmake_helpers_exe_depends_ext_length)
	math(EXPR _cmake_helpers_exe_depends_ext_length_modulo_3 "${_cmake_helpers_exe_depends_ext_length} % 3")
	if(NOT(_cmake_helpers_exe_depends_ext_length_modulo_3 EQUAL 0))
	  message(FATAL_ERROR "DEPENDS_EXT option value must be a list of three items: scope, interface, lib")
	endif()
	if(_cmake_helpers_exe_depends_ext)
	  math(EXPR _cmake_helpers_exe_depends_ext_length_i_max "(${_cmake_helpers_exe_depends_ext_length} / 3) - 1")
	  set(_j -1)
	  foreach(_i RANGE 0 ${_cmake_helpers_exe_depends_ext_length_i_max})
	    math(EXPR _j "${_j} + 1")
	    list(GET _cmake_helpers_exe_depends_ext ${_j} _cmake_helpers_exe_depend_scope)
	    math(EXPR _j "${_j} + 1")
	    list(GET _cmake_helpers_exe_depends_ext ${_j} _cmake_helpers_exe_depend_interface)
	    math(EXPR _j "${_j} + 1")
	    list(GET _cmake_helpers_exe_depends_ext ${_j} _cmake_helpers_exe_depend_lib)
	    if(TARGET ${_cmake_helpers_exe_depend_lib})
	      get_target_property(_cmake_helpers_exe_depend_lib_type ${_cmake_helpers_exe_depend_lib} TYPE)
	      if((_cmake_helpers_exe_depend_lib_type STREQUAL "SHARED_LIBRARY") OR (_cmake_helpers_exe_depend_lib_type STREQUAL "STATIC_LIBRARY"))
		set(_cmake_helpers_exe_depend_lib_dir $<TARGET_FILE_DIR:${_cmake_helpers_exe_depend_lib}>)
	      else()
		set(_cmake_helpers_exe_depend_lib_dir)
	      endif()
	      if(_cmake_helpers_exe_depend_lib_dir)
		cmake_helpers_call(set_tests_properties ${_cmake_helpers_exe_target}_test PROPERTIES ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:$<$<BOOL:${WIN32}>:${_cmake_helpers_exe_depend_lib_dir}>")
	      endif()
	    endif()
	  endforeach()
	endif()
      endif()
      #
      # A tiny hook to force ctest to build the executable
      #
      cmake_helpers_call(get_property _cmake_helpers_exe_generator_is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
      if(_cmake_helpers_exe_generator_is_multi_config)
        cmake_helpers_call(add_test NAME ${_cmake_helpers_exe_target}_build COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}" --config $<CONFIG> --target ${_cmake_helpers_exe_target})
      else()
        cmake_helpers_call(add_test NAME ${_cmake_helpers_exe_target}_build COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}" --target ${_cmake_helpers_exe_target})
      endif()
      cmake_helpers_call(set_tests_properties ${_cmake_helpers_exe_target}_test PROPERTIES DEPENDS ${_cmake_helpers_exe_target}_build)
    endif()
  endforeach()
  #
  # Send-out the targets
  #
  if(_cmake_helpers_exe_targets_outvar)
    set(${_cmake_helpers_exe_targets_outvar} ${_cmake_helpers_exe_targets} PARENT_SCOPE)
  endif()
  #
  # Save properties
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ----------------------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Setting directory properties")
    message(STATUS "[${_cmake_helpers_logprefix}] ----------------------------")
  endif()
  foreach(_cmake_helpers_exe_property ${_cmake_helpers_exe_properties})
    if(cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_exe_property})
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_exe_property} ${cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_exe_property}})
    endif()
  endforeach()
  foreach(_cmake_helpers_exe_array_property ${_cmake_helpers_exe_array_properties})
    if(cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_exe_array_property})
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} APPEND PROPERTY cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_exe_array_property} ${cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_exe_array_property}})
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
