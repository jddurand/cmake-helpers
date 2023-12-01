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
    TARGET
    #
    # pod file are usually very generic, like README.html etc... we do
    # not want to generate man/man3/README.3.gz everytime.
    #
    MAN_PREPEND
  )
  set(_multiValueArgs)
  #
  # Single-value arguments default values
  #
  set(_cmake_helpers_pod_input)
  set(_cmake_helpers_pod_name)
  set(_cmake_helpers_pod_section)
  set(_cmake_helpers_pod_version "${_cmake_helpers_library_}")
  set(_cmake_helpers_pod_target "POD")
  set(_cmake_helpers_pod_man_prepend "${_cmake_helpers_library_namespace}_")
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_helpers_pod "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # Create pod target, eventually
  #
  if(NOT TARGET ${_cmake_helpers_pod_target})
    cmake_helpers_call(add_custom_target ${_cmake_helpers_pod_target} ALL)
  endif()
  #
  # Add a dependency on this input
  #
  cmake_helpers_call(set_property TARGET ${_cmake_helpers_pod_target}
    APPEND PROPERTY SOURCES ${_cmake_helpers_pod_input}
  )
  #
  # =========
  # Man pages
  # =========
  #
  find_program(POD2MAN pod2man)
  if(POD2MAN)
    set(_cmake_helpers_pod_pod2man ${POD2MAN})
  elseif(WIN32) # Special case of WIN32
    find_program(POD2MAN_BAT pod2man.bat)
    if(POD2MAN_BAT)
      set(_cmake_helpers_pod_pod2man ${POD2MAN_BAT})
    endif()
  endif()
  if(_cmake_helpers_pod_pod2man)
    find_program(GZIP gzip)
    if(GZIP)
      set(_cmake_helpers_pod_gzip ${GZIP})
    elseif(WIN32) # Special case of WIN32
      find_program(GZIP_EXE gzip.exe)
      if(GZIP_EXE)
	set(_cmake_helpers_pod_gzip ${GZIP_EXE})
      endif()
    endif()
    if(NOT GZIP)
      #
      # Give a try with 7z
      #
      find_program(SEVENZ 7z)
      if(SEVENZ)
	set(_cmake_helpers_pod_7z ${SEVENZ})
      elseif(WIN32) # Special case of WIN32
	find_program(SEVENZ_EXE 7z.exe)
	if(SEVENZ_EXE)
	  set(_cmake_helpers_pod_7z ${SEVENZ_EXE})
	endif()
      endif()
    endif()
    if(_cmake_helpers_pod_gzip OR _cmake_helpers_pod_7z)
      #
      # pod -> man${section} -> man${section}.gz
      #
      if(_cmake_helpers_pod_man_prepend)
	set(_cmake_helpers_pod2man_output "${CMAKE_CURRENT_BINARY_DIR}/man/${_cmake_helpers_pod_man_prepend}${_cmake_helpers_pod_name}.${_cmake_helpers_pod_section}")
      else()
	set(_cmake_helpers_pod2man_output "${CMAKE_CURRENT_BINARY_DIR}/man/${_cmake_helpers_pod_name}.${_cmake_helpers_pod_section}")
      endif()
      string(TOUPPER "${_cmake_helpers_pod_name}" _cmake_helpers_pod_name_toupper)
      set(_cmake_helpers_pod2man_gzip_output "${_cmake_helpers_pod2man_output}.gz")
      if(_cmake_helpers_pod_gzip)
	cmake_helpers_call(add_custom_command
	  OUTPUT ${_cmake_helpers_pod2man_gzip_output}
	  COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod2man_output}
	  COMMAND ${_cmake_helpers_pod_pod2man} --section ${_cmake_helpers_pod_section} --center ${_cmake_helpers_library_namespace} --release ${_cmake_helpers_library_version} --stderr --name ${_cmake_helpers_pod_name_toupper} ${_cmake_helpers_pod_input} ${_cmake_helpers_pod2man_output}
	  COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod2man_gzip_output}
	  COMMAND ${_cmake_helpers_pod_gzip} ${_cmake_helpers_pod2man_output}
	  COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod2man_output}
	  DEPENDS ${_cmake_helpers_pod_input}
	  USES_TERMINAL
	)
      elseif(_cmake_helpers_pod_7z)
	cmake_helpers_call(add_custom_command
	  OUTPUT ${_cmake_helpers_pod2man_gzip_output}
	  COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod2man_output}
	  COMMAND ${_cmake_helpers_pod_pod2man} --section ${_cmake_helpers_pod_section} --center ${_cmake_helpers_library_namespace} --release ${_cmake_helpers_library_version} --stderr --name ${_cmake_helpers_pod_name_toupper} ${_cmake_helpers_pod_input} ${_cmake_helpers_pod2man_output}
	  COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod2man_gzip_output}
	  COMMAND ${_cmake_helpers_pod_7z} a -tgzip ${_cmake_helpers_pod2man_gzip_output} ${_cmake_helpers_pod2man_output}
	  COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod2man_output}
	  DEPENDS ${_cmake_helpers_pod_input}
	  USES_TERMINAL
	)
      else()
	message(FATAL_ERROR "No gzip nor 7z")
      endif()
      #
      # Add dependency
      #
      cmake_helpers_call(set_property TARGET ${_cmake_helpers_pod_target}
	APPEND PROPERTY SOURCES ${_cmake_helpers_pod2man_gzip_output}
      )
      #
      # Install rule
      #
      # cmake_helpers_call(install FILES ${_cmake_helpers_pod2man_gzip_output} DESTINATION ${_cmake_helpers_library_install_mandir} COMPONENT Man)
      #
      # Remember we have man
      #
      # cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_man_component TRUE)
      #
      # Add the generated files to the clean rule (not all generators support this)
      #
      # cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} APPEND PROPERTY ADDITIONAL_CLEAN_FILES ${_cmake_helpers_pod2man_gzip_output} ${_cmake_helpers_pod2man_output})
    endif()
  endif()
  #
  # ====
  # Html
  # ====
  #
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
  if(_cmake_helpers_pod_pod2html)
    #
    # pod -> html
    #
    set(_cmake_helpers_pod2html_output "${CMAKE_CURRENT_BINARY_DIR}/html/${_cmake_helpers_pod_name}.html")
    cmake_helpers_call(add_custom_command
      OUTPUT ${_cmake_helpers_pod2html_output}
      COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod2html_output}
      COMMAND ${_cmake_helpers_pod_pod2html} --infile ${_cmake_helpers_pod_input} --outfile ${_cmake_helpers_pod2html_output}
      DEPENDS ${_cmake_helpers_pod_input}
      USES_TERMINAL
    )
    #
    # Add dependency
    #
    cmake_helpers_call(set_property TARGET ${_cmake_helpers_pod_target}
      APPEND PROPERTY SOURCES ${_cmake_helpers_pod2html_output}
    )
    #
    # Install rule
    #
    # cmake_helpers_call(install FILES ${_cmake_helpers_pod2html_output} DESTINATION ${_cmake_helpers_library_install_htmldir} COMPONENT Html)
    #
    # Remember we have htlm
    #
    # cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_html_component TRUE)
    #
    # Add the generated files to the clean rule (not all generators support this)
    #
    # cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} APPEND PROPERTY ADDITIONAL_CLEAN_FILES ${_cmake_helpers_pod2html_output})
    #
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
