function(cmake_helpers_output_to_target workingDirectory output exportSet destination component target_outvar)
  #
  # Save argn
  #
  set(_argn ${ARGN})
  #
  # Custom command
  #
  cmake_helpers_call(add_custom_command OUTPUT ${workingDirectory}/${output} ${_argn} WORKING_DIRECTORY ${workingDirectory})
  #
  # Custom target
  #
  set(_target ${output})
  string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" _target ${_target})
  cmake_helpers_call(add_library ${_target} INTERFACE)
  cmake_helpers_call(target_sources ${_target} PUBLIC FILE_SET internal BASE_DIRS ${workingDirectory} TYPE HEADERS FILES ${workingDirectory}/${output})
  if(destination)
    #
    # Target install rule
    #
    if(exportSet)
      set(_cmake_helpers_output_to_target_exportSet_args EXPORT ${exportSet})
    else()
      set(_cmake_helpers_output_to_target_exportSet_args)
    endif()
    if(component)
      set(_cmake_helpers_output_to_target_component_args COMPONENT ${component})
    else()
      set(_cmake_helpers_output_to_target_component_args)
    endif()
    if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
      install(
	TARGETS                 ${_target}
	${_cmake_helpers_output_to_target_exportSet_args}
	FILE_SET internal       DESTINATION ${destination} ${_cmake_helpers_output_to_target_component_args}
      )
    endif()
    if(exportSet)
      if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
	install(
	  EXPORT ${exportSet}
	  NAMESPACE ${PROJECT_NAME}::
	  DESTINATION ${CMAKE_HELPERS_INSTALL_CMAKEDIR}
	  ${_cmake_helpers_output_to_target_component_args}
	)
      endif()
    endif()
  endif()
  #
  # Return target in output_var
  #
  set(${target_outvar} ${_target} PARENT_SCOPE)
endfunction()
