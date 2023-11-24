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
  foreach(_variable
      namespace
      targets
      version
      install_mandir
      install_cmakedir
      install_htmldir)
    get_property(_cmake_helpers_library_${_variable} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_${_variable})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] _cmake_helpers_library_${_variable}: ${_cmake_helpers_library_${_variable}}")
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
  cmake_helpers_parse_arguments(package _cmake_helpers_pod "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # Look for pre-requesites: pod2man/pod2html and gzip
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
  find_program(POD2HTML pod2html)
  if(POD2HTML)
    set(_cmake_helpers_pod_pod2html ${POD2HTML})
  elseif(WIN32)
    #
    # Special case of WIN32
    #
    find_program(POD2HTML_BAT pod2html.bat)
    if(POD2HTML_BAT)
      set(_cmake_helpers_pod_pod2html ${POD2HTML_BAT})
    endif()
  endif()
  if(_cmake_helpers_pod_pod2man)
    find_program(GZIP gzip)
    if(GZIP)
      #
      # Create tuples of custom command/targets.
      # Doing so automaticalled flaggs output files as GENERATED and add them to the clean target.
      #
      # pod > man
      # Dependency is on the pod file
      #
      set(_cmake_helpers_pod2man_output "${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_pod_name}.${_cmake_helpers_pod_section}")
      cmake_helpers_call(add_custom_command
	OUTPUT ${_cmake_helpers_pod2man_output}
	COMMAND ${_cmake_helpers_pod_pod2man} --section ${_cmake_helpers_pod_section} --center ${_cmake_helpers_library_namespace} -r ${_cmake_helpers_library_version} --stderr --name ${_cmake_helpers_pod_name} ${_cmake_helpers_pod_input} > ${_cmake_helpers_pod2man_output}
	DEPENDS ${_cmake_helpers_pod_input}
      )
      set(_cmake_helpers_pod2man_target cmake_helpers_pod2man_${_cmake_helpers_pod_name})
      add_custom_target(${_cmake_helpers_pod2man_target} DEPENDS ${_cmake_helpers_pod2man_output})
      #
      # man > man.gz
      # Dependency is on the pod > man target
      #
      set(_cmake_helpers_pod2man_gzip_output "${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_pod_name}.${_cmake_helpers_pod_section}.gz")
      cmake_helpers_call(add_custom_command
	OUTPUT ${_cmake_helpers_pod2man_gzip_output}
	COMMAND ${GZIP} -c ${_cmake_helpers_pod2man_output} > ${_cmake_helpers_pod2man_gzip_output}
	DEPENDS ${_cmake_helpers_pod2man_target}
      )
      set(_cmake_helpers_pod2man_gzip_target cmake_helpers_pod2man_${_cmake_helpers_pod_name}_gz)
      add_custom_target(${_cmake_helpers_pod2man_gzip_target} DEPENDS ${_cmake_helpers_pod2man_gzip_output})
      #
      # In order to have EXPORT mechanism working we need something that supports this keyword, an INTERFACE library will do it
      #
      set(_cmake_helpers_pod2man_iface_target cmake_helpers_pod2man_${_cmake_helpers_pod_name}_iface)
      cmake_helpers_call(add_library ${_cmake_helpers_pod2man_iface_target} INTERFACE)
      #
      # Add generated files as dependencies to the target. This will make them candidates for clean automatically.
      #
      cmake_helpers_call(add_dependencies ${_cmake_helpers_pod2man_iface_target} ${_cmake_helpers_pod2man_gzip_target})
      #
      # Add this iface as a dependency to all library targets so that it is always triggered
      #
      foreach(_cmake_helper_library_target ${_cmake_helpers_library_targets})
	cmake_helpers_call(add_dependencies ${_cmake_helper_library_target} ${_cmake_helpers_pod2man_iface_target})
      endforeach()
      #
      # Add the generated files to the clean rule (not all generators support this)
      #
      cmake_helpers_call(set_property TARGET ${_cmake_helpers_pod2man_iface_target} APPEND PROPERTY ADDITIONAL_CLEAN_FILES ${_cmake_helpers_pod2man_gzip_output} ${_cmake_helpers_pod2man_output})
      #
      # We fake the gzip as beeing of type HEADERS
      #
      cmake_helpers_call(target_sources ${_cmake_helpers_pod2man_iface_target} INTERFACE FILE_SET manpage BASE_DIRS ${CMAKE_CURRENT_BINARY_DIR} TYPE HEADERS FILES ${_cmake_helpers_pod2man_gzip_output})
      #
      # Target install
      #
      cmake_helpers_call(install
	TARGETS  ${_cmake_helpers_pod2man_iface_target}
	EXPORT   ${_cmake_helpers_library_namespace}DocumentationTargets
	FILE_SET manpage DESTINATION ${_cmake_helpers_library_install_mandir}/man${_cmake_helpers_pod_section} COMPONENT Man
      )
      #
      # Set the property _cmake_helpers_have_man
      #
      if(NOT _cmake_helpers_have_man)
	#
	# Export install
	#
	cmake_helpers_call(install
	  EXPORT ${_cmake_helpers_library_namespace}DocumentationTargets
	  NAMESPACE ${_cmake_helpers_library_namespace}::
	  DESTINATION ${_cmake_helpers_library_install_cmakedir}/${_cmake_helpers_library_namespace}
	  COMPONENT Man
	)
	set(_cmake_helpers_have_man TRUE)
	set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_man ${_cmake_helpers_have_man})
      endif()
    endif()
  endif()
  if(_cmake_helpers_pod_pod2html)
    #
    # Create tuples of custom command/targets.
    # Doing so automaticalled flaggs output files as GENERATED and add them to the clean target.
    #
    # pod > html
    # Dependency is on the pod file
    #
    set(_cmake_helpers_pod2html_output "${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_pod_name}.html")
    cmake_helpers_call(add_custom_command
      OUTPUT ${_cmake_helpers_pod2html_output}
      COMMAND ${_cmake_helpers_pod_pod2html} --infile ${_cmake_helpers_pod_input} --outfile ${_cmake_helpers_pod2html_output}
      DEPENDS ${_cmake_helpers_pod_input}
    )
    set(_cmake_helpers_pod2html_target cmake_helpers_pod2html_${_cmake_helpers_pod_name})
    add_custom_target(${_cmake_helpers_pod2html_target} DEPENDS ${_cmake_helpers_pod2html_output})
    #
    # In order to have EXPORT mechanism working we need something that supports this keyword, an INTERFACE library will do it
    #
    set(_cmake_helpers_pod2html_iface_target cmake_helpers_pod2html_${_cmake_helpers_pod_name}_iface)
    cmake_helpers_call(add_library ${_cmake_helpers_pod2html_iface_target} INTERFACE)
    #
    # Add generated files as dependencies to the target. This will make them candidates for clean automatically.
    #
    cmake_helpers_call(add_dependencies ${_cmake_helpers_pod2html_iface_target} ${_cmake_helpers_pod2html_target})
    #
    # Add this iface as a dependency to all library targets so that it is always triggered
    #
    foreach(_cmake_helper_library_target ${_cmake_helpers_library_targets})
      cmake_helpers_call(add_dependencies ${_cmake_helper_library_target} ${_cmake_helpers_pod2html_iface_target})
    endforeach()
    #
    # Add the generated files to the clean rule (not all generators support this)
    #
    cmake_helpers_call(set_property TARGET ${_cmake_helpers_pod2html_iface_target} APPEND PROPERTY ADDITIONAL_CLEAN_FILES ${_cmake_helpers_pod2html_output})
    #
    # We fake the html as beeing of type HEADERS
    #
    cmake_helpers_call(target_sources ${_cmake_helpers_pod2html_iface_target} INTERFACE FILE_SET html BASE_DIRS ${CMAKE_CURRENT_BINARY_DIR} TYPE HEADERS FILES ${_cmake_helpers_pod2html_output})
    #
    # Target install
    #
    cmake_helpers_call(install
      TARGETS  ${_cmake_helpers_pod2html_iface_target}
      EXPORT   ${_cmake_helpers_library_namespace}DocumentationTargets
      FILE_SET html DESTINATION ${_cmake_helpers_library_install_htmldir} COMPONENT Html
    )
    #
    # Set the property _cmake_helpers_have_html
    #
    if(NOT _cmake_helpers_have_html)
      #
      # Export install
      #
      cmake_helpers_call(install
	EXPORT ${_cmake_helpers_library_namespace}DocumentationTargets
	NAMESPACE ${_cmake_helpers_library_namespace}::
	DESTINATION ${_cmake_helpers_library_install_cmakedir}/${_cmake_helpers_library_namespace}
	COMPONENT Html
      )
      set(_cmake_helpers_have_html TRUE)
      set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_html ${_cmake_helpers_have_html})
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
