function(cmake_helpers_output_to_target workingDirectory output export namespace destination exportDestination component target_outvar)
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
    if(export)
      set(_cmake_helpers_output_to_target_export_args EXPORT ${export})
    else()
      set(_cmake_helpers_output_to_target_export_args)
    endif()
    if(component)
      set(_cmake_helpers_output_to_target_component_args COMPONENT ${component})
    else()
      set(_cmake_helpers_output_to_target_component_args)
    endif()
    cmake_helpers_call(install
      TARGETS                 ${_target}
      ${_cmake_helpers_output_to_target_export_args}
      FILE_SET internal       DESTINATION ${destination} ${_cmake_helpers_output_to_target_component_args}
    )
    if(export AND exportDestination)
      if(namespace)
	set(_cmake_helpers_output_to_target_namespace_args NAMESPACE ${namespace})
      else()
	set(_cmake_helpers_output_to_target_component_args)
      endif()
      cmake_helpers_call(install
	EXPORT ${export}
	${_cmake_helpers_output_to_target_namespace_args}
	DESTINATION ${exportDestination}
	${_cmake_helpers_output_to_target_component_args}
      )
    endif()
  endif()
  #
  # Return target in output_var
  #
  set(${target_outvar} ${_target} PARENT_SCOPE)
endfunction()