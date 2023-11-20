function(cmake_helpers_pod)
  #
  # Log prefix
  #
  set(_cmake_helpers_logprefix "cmake_helpers/${PROJECT_NAME}/pod")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
    message(STATUS "[${_cmake_helpers_logprefix}] Starting")
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
  endif()
  #
  # Recuperate directory library properties
  #
  foreach(_variable namespace version)
    get_property(_cmake_helpers_library_${_variable} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_${_variable})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] _cmake_helpers_library_${_variable}: ${_cmake_helpers_library_${_variable}}")
    endif()
  endforeach()
  #
  # Recuperate directory have properties
  #
  foreach(_variable have_manpage)
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
    INPUT
    NAME
    SECTION
    VERSION
  )
  set(_multiValueArgs)
  #
  # Single-value arguments default values
  #
  set(_cmake_helpers_pod_input)
  set(_cmake_helpers_pod_name)
  set(_cmake_helpers_pod_section)
  set(_cmake_helpers_pod_version "${_cmake_helpers_library_}")
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_pod_package "" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # Look for pre-requesites: pod2man and gzip
  #
  find_program(POD2MAN pod2man)
  if(POD2MAN)
    set(_cmake_helpers_pod_pod2man ${POD2MAN})
  elseif(WIN32)
    #
    # Special case of WIN32
    #
    find_program(POD2MAN_BAT pod2man.bat)
    if(POD2MAN_BAT)
      set(_cmake_helpers_pod_pod2man ${POD2MAN_BAT})
    endif()
  endif()
  if(_cmake_helpers_pod_pod2man)
    find_program(GZIP gzip)
    if(GZIP)
      if(NOT (TARGET cmake_helpers_pod))
	cmake_helpers_call(add_custom_target cmake_helpers_pod)
      endif()
      set(_cmake_helpers_pod_output "${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_pod_name}.${_cmake_helpers_pod_section}")
      cmake_helpers_call(add_custom_command
	OUTPUT ${_cmake_helpers_pod_output}
	DEPENDS ${_cmake_helpers_pod_input}
	USES_TERMINAL
	COMMAND ${${_cmake_helpers_pod_pod2man}}
	ARGS --section ${_cmake_helpers_pod_section} --center ${_cmake_helpers_library_namespace} -r ${_cmake_helpers_library_version} --stderr --name ${_cmake_helpers_pod_name} ${_cmake_helpers_pod_input} > ${_cmake_helpers_pod_output}
      )
      set(_cmake_helpers_man_output "${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_pod_name}.${_cmake_helpers_pod_section}.gz")
      cmake_helpers_call(add_custom_command
	OUTPUT ${_cmake_helpers_man_output}
	DEPENDS ${_cmake_helpers_pod_output}
	COMMAND ${GZIP} -c ${_cmake_helpers_pod_output} > ${_cmake_helpers_man_output}
	)
      set(_cmake_helpers_pod_target "man_${_cmake_helpers_pod_name}")
      cmake_helpers_call(add_custom_target ${_cmake_helpers_pod_target}	DEPENDS ${_cmake_helpers_man_output})
      cmake_helpers_call(install
	FILES ${_cmake_helpers_man_output}
	DESTINATION ${CMAKE_INSTALL_MANDIR}/man${_cmake_helpers_pod_section}
        COMPONENT Man
      )
      if(NOT _cmake_helpers_have_manpage)
	set(_cmake_helpers_have_manpage TRUE)
	cmake_helpers_call(install
	  EXPORT ${_cmake_helpers_library_namespace}DocumentationTargets
	  NAMESPACE ${_cmake_helpers_library_namespace}::
	  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${_cmake_helpers_library_namespace}
	  COMPONENT Documentation)
	set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_manpage ${_cmake_helpers_have_manpage})
      endif()
    endif()
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
