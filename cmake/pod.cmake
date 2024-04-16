function(cmake_helpers_pod)
  # ============================================================================================================
  # This module can generate one export set:
  #
  # - ${PROJECT_NAME}DocumentationTargets
  #
  # This module can install two components:
  #
  # - ${PROJECT_NAME}ManComponent
  # - ${PROJECT_NAME}HtmlComponent
  #
  # These directory properties are generated on ${CMAKE_CURRENT_BINARY_DIR}:
  #
  # - cmake_helpers_property_${PROJECT_NAME}_HaveManComponent           : Boolean indicating presence of COMPONENT ${PROJECT_NAME}ManComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveHtmlComponent          : Boolean indicating presence of COMPONENT ${PROJECT_NAME}HtmlComponent
  # ============================================================================================================
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
  # Constants
  #
  set(_cmake_helpers_pod_properties
    HaveManComponent
    HaveHtmlComponent
  )
  set(_cmake_helpers_pod_array_properties
  )
  #
  # Variables holding directory properties initialization.
  # They will be used at the end of this module.
  #
  foreach(_cmake_helpers_pod_property IN LISTS _cmake_helpers_pod_properties)
    cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_pod_property} FALSE)
  endforeach()
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  #
  set(_options)
  set(_oneValueArgs
    INPUT
    NAME
    SECTION
    TARGET
    COPY_MAN_TO_SOURCE_AUTO
    COPY_HTML_TO_SOURCE_AUTO
    COPY_MD_TO_SOURCE_AUTO
  )
  set(_multiValueArgs)
  #
  # Single-value arguments default values
  #
  set(_cmake_helpers_pod_input)
  set(_cmake_helpers_pod_name)
  set(_cmake_helpers_pod_section)
  set(_cmake_helpers_pod_target "POD")
  set(_cmake_helpers_pod_copy_man_to_source_auto FALSE)
  set(_cmake_helpers_pod_copy_html_to_source_auto FALSE)
  set(_cmake_helpers_pod_copy_md_to_source_auto TRUE)
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_helpers_pod "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # For the eventual copy: automatic git add of README.md
  #
  find_program(GIT git)
  if(GIT)
    set(_cmake_helpers_pod_git ${GIT})
  endif()
  get_filename_component(_cmake_helpers_pod_input_name ${_cmake_helpers_pod_input} NAME)
  get_filename_component(_cmake_helpers_pod_copy_dir ${_cmake_helpers_pod_input} DIRECTORY)
  #
  # Create pod target, eventually
  #
  if(NOT TARGET ${_cmake_helpers_pod_target})
    cmake_helpers_call(add_custom_target ${_cmake_helpers_pod_target} ALL)
  endif()
  #
  # Add input to target
  #
  cmake_helpers_call(target_sources ${_cmake_helpers_pod_target} PRIVATE ${_cmake_helpers_pod_input})
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
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] Creating target to convert ${_cmake_helpers_pod_input} to man")
      endif()
      #
      # pod -> man${section} -> man${section}.gz custom target
      #
      if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/man)
	file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/man)
      endif()
      set(_cmake_helpers_pod_pod2man_output "${_cmake_helpers_pod_name}.${_cmake_helpers_pod_section}")
      string(TOUPPER "${_cmake_helpers_pod_name}" _cmake_helpers_pod_name_toupper)
      set(_cmake_helpers_pod_pod2man_gzip_output "${_cmake_helpers_pod_pod2man_output}.gz")
      if(_cmake_helpers_pod_gzip)
	set(_cmake_helpers_pod_gzip_command ${_cmake_helpers_pod_gzip} ${_cmake_helpers_pod_pod2man_output})
      elseif(_cmake_helpers_pod_7z)
	set(_cmake_helpers_pod_gzip_command ${_cmake_helpers_pod_7z} a -tgzip ${_cmake_helpers_pod_pod2man_gzip_output} ${_cmake_helpers_pod_pod2man_output})
      else()
	message(FATAL_ERROR "No gzip nor 7z")
      endif()
      cmake_helpers_output_to_target(
	${CMAKE_CURRENT_BINARY_DIR}/man                     # workingDirectory
	${_cmake_helpers_pod_pod2man_gzip_output}           # output
	${PROJECT_NAME}DocumentationTargets                 # exportSet
	${CMAKE_HELPERS_INSTALL_MANDIR}                     # destination
	${PROJECT_NAME}ManComponent                         # component
	_cmake_helpers_pod_pod2man_gzip_output_target       # target_outvar
	
	COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod_pod2man_output}
	COMMAND ${_cmake_helpers_pod_pod2man} --section ${_cmake_helpers_pod_section} --center ${PROJECT_NAME} --release ${PROJECT_VERSION} --stderr --name ${_cmake_helpers_pod_name_toupper} ${_cmake_helpers_pod_input} ${_cmake_helpers_pod_pod2man_output}
	COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod_pod2man_gzip_output}
	COMMAND ${_cmake_helpers_pod_gzip_command}
	DEPENDS ${_cmake_helpers_pod_input}
	VERBATIM
	USES_TERMINAL
      )
      #
      # Dependency pod custom target <- man${section}.gz custom target
      #
      cmake_helpers_call(add_dependencies ${_cmake_helpers_pod_target} ${_cmake_helpers_pod_pod2man_gzip_output_target})
      #
      # Remember we have man
      #
      if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
	cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveManComponent TRUE)
      endif()
      #
      # Add the generated files to the clean rule (not all generators support this)
      #
      # cmake_helpers_call(set_property TARGET ${_cmake_helpers_pod_target} APPEND PROPERTY ADDITIONAL_CLEAN_FILES ${_cmake_helpers_pod_pod2man_gzip_output} ${_cmake_helpers_pod_pod2man_output})
      #
      # Eventually copy back in the source
      #
      if(_cmake_helpers_pod_copy_man_to_source_auto AND GIT AND ${_cmake_helpers_pod_input_name} STREQUAL "README.pod")
        set(_cmake_helpers_pod_copy_src ${CMAKE_CURRENT_BINARY_DIR}/man/${_cmake_helpers_pod_pod2man_gzip_output})
        set(_cmake_helpers_pod_copy_dst ${_cmake_helpers_pod_copy_dir}/README.man.gz)
        cmake_helpers_call(add_custom_target ${_cmake_helpers_pod_pod2man_gzip_output_target}_copy
          ALL
          COMMAND ${CMAKE_COMMAND} -E copy ${_cmake_helpers_pod_copy_src} ${_cmake_helpers_pod_copy_dst}
          COMMAND ${GIT} add README.man.gz
          COMMENT "${_cmake_helpers_pod_copy_dst} added to git"
          DEPENDS ${_cmake_helpers_pod_copy_src}
          WORKING_DIRECTORY ${_cmake_helpers_pod_copy_dir} # For git command, put ourself in the git repo
        )
      endif()
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
    # pod -> html custom target
    #
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] Creating target to convert ${_cmake_helpers_pod_input} to html")
    endif()
    if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/html)
      file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html)
    endif()
    set(_cmake_helpers_pod_pod2html_output "${_cmake_helpers_pod_name}.html")
    cmake_helpers_output_to_target(
      ${CMAKE_CURRENT_BINARY_DIR}/html                    # workingDirectory
      ${_cmake_helpers_pod_pod2html_output}               # output
      ${PROJECT_NAME}DocumentationTargets                 # exportSet
      ${CMAKE_HELPERS_INSTALL_HTMLDIR}                    # destination
      ${PROJECT_NAME}HtmlComponent                        # component
      _cmake_helpers_pod_pod2html_output_target           # target_outvar

      COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod_pod2html_output}
      COMMAND ${_cmake_helpers_pod_pod2html} --infile ${_cmake_helpers_pod_input} --outfile ${_cmake_helpers_pod_pod2html_output}
      COMMENT "Generating ${_cmake_helpers_pod_pod2html_output}"
      DEPENDS ${_cmake_helpers_pod_input}
      VERBATIM
      USES_TERMINAL
    )
    #
    # Dependency pod custom target <- html custom target
    #
    cmake_helpers_call(add_dependencies ${_cmake_helpers_pod_target} ${_cmake_helpers_pod_pod2html_output_target})
    #
    # Remember we have html
    #
    if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
      cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveHtmlComponent TRUE)
    endif()
    #
    # Add the generated files to the clean rule (not all generators support this)
    #
    # cmake_helpers_call(set_property TARGET ${_cmake_helpers_pod_target} APPEND PROPERTY ADDITIONAL_CLEAN_FILES ${_cmake_helpers_pod_pod2html_output})
    #
    # Eventually copy back in the source
    #
    if(_cmake_helpers_pod_copy_html_to_source_auto AND GIT AND ${_cmake_helpers_pod_input_name} STREQUAL "README.pod")
      set(_cmake_helpers_pod_copy_src ${CMAKE_CURRENT_BINARY_DIR}/html/${_cmake_helpers_pod_pod2html_output})
      set(_cmake_helpers_pod_copy_dst ${_cmake_helpers_pod_copy_dir}/README.html)
      cmake_helpers_call(add_custom_target ${_cmake_helpers_pod_pod2html_output_target}_copy
        ALL
        COMMAND ${CMAKE_COMMAND} -E copy ${_cmake_helpers_pod_copy_src} ${_cmake_helpers_pod_copy_dst}
        COMMAND ${GIT} add README.html
        COMMENT "${_cmake_helpers_pod_copy_dst} added to git"
        DEPENDS ${_cmake_helpers_pod_copy_src}
        WORKING_DIRECTORY ${_cmake_helpers_pod_copy_dir} # For git command, put ourself in the git repo
      )
    endif()
  endif()
  #
  # ==
  # Md
  # ==
  #
  find_program(POD2MD pod2github) # Well, perl's program is called pod2github and not pod2md
  if(POD2MD)
    set(_cmake_helpers_pod_pod2md ${POD2MD})
  elseif(WIN32)
    #
    # Special case of WIN32
    #
    find_program(POD2MD_BAT pod2github.bat)
    if(POD2MD_BAT)
      set(_cmake_helpers_pod_pod2md ${POD2MD_BAT})
    endif()
  endif()
  if(_cmake_helpers_pod_pod2md)
    #
    # pod -> md custom target
    #
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] Creating target to convert ${_cmake_helpers_pod_input} to md")
    endif()
    if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/md)
      file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/md)
    endif()
    set(_cmake_helpers_pod_pod2md_output "${_cmake_helpers_pod_name}.md")
    cmake_helpers_output_to_target(
      ${CMAKE_CURRENT_BINARY_DIR}/md                      # workingDirectory
      ${_cmake_helpers_pod_pod2md_output}                 # output
      ${PROJECT_NAME}DocumentationTargets                 # exportSet
      ${CMAKE_HELPERS_INSTALL_MDDIR}                      # destination
      ${PROJECT_NAME}MdComponent                          # component
      _cmake_helpers_pod_pod2md_output_target             # target_outvar

      COMMAND ${CMAKE_COMMAND} -E rm -f ${_cmake_helpers_pod_pod2md_output}
      COMMAND ${_cmake_helpers_pod_pod2md} ${_cmake_helpers_pod_input} ${_cmake_helpers_pod_pod2md_output}
      COMMENT "Generating ${_cmake_helpers_pod_pod2md_output}"
      DEPENDS ${_cmake_helpers_pod_input}
      VERBATIM
      USES_TERMINAL
    )
    #
    # Dependency pod custom target <- md custom target
    #
    cmake_helpers_call(add_dependencies ${_cmake_helpers_pod_target} ${_cmake_helpers_pod_pod2md_output_target})
    #
    # Remember we have md
    #
    if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
      cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveMdComponent TRUE)
    endif()
    #
    # Add the generated files to the clean rule (not all generators support this)
    #
    # cmake_helpers_call(set_property TARGET ${_cmake_helpers_pod_target} APPEND PROPERTY ADDITIONAL_CLEAN_FILES ${_cmake_helpers_pod_pod2md_output})
    #
    # Eventually copy back in the source
    #
    if(_cmake_helpers_pod_copy_md_to_source_auto AND GIT AND ${_cmake_helpers_pod_input_name} STREQUAL "README.pod")
      set(_cmake_helpers_pod_copy_src ${CMAKE_CURRENT_BINARY_DIR}/md/${_cmake_helpers_pod_pod2md_output})
      set(_cmake_helpers_pod_copy_dst ${_cmake_helpers_pod_copy_dir}/README.md)
      cmake_helpers_call(add_custom_target ${_cmake_helpers_pod_pod2md_output_target}_copy
        ALL
        COMMAND ${CMAKE_COMMAND} -E copy ${_cmake_helpers_pod_copy_src} ${_cmake_helpers_pod_copy_dst}
        COMMAND ${GIT} add README.md
        COMMENT "${_cmake_helpers_pod_copy_dst} added to git"
        DEPENDS ${_cmake_helpers_pod_copy_src}
        WORKING_DIRECTORY ${_cmake_helpers_pod_copy_dir} # For git command, put ourself in the git repo
      )
    endif()
  endif()
  #
  # Save properties
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ----------------------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Setting directory properties")
    message(STATUS "[${_cmake_helpers_logprefix}] ----------------------------")
  endif()
  foreach(_cmake_helpers_pod_property IN LISTS _cmake_helpers_pod_properties)
    if(cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_pod_property})
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_pod_property} ${cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_pod_property}})
    endif()
  endforeach()
  foreach(_cmake_helpers_pod_array_property IN LISTS _cmake_helpers_pod_array_properties)
    if(cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_pod_array_property})
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} APPEND PROPERTY cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_pod_array_property} ${cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_pod_array_property}})
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
