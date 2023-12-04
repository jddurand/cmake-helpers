function(cmake_helpers_package)
  # ============================================================================================================
  # This module depend on these ${CMAKE_CURRENT_BINARY_DIR} directory properties:
  #
  # - cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentRuntimeComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveLibraryComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentLibraryComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveArchiveComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentArchiveComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveHeaderComponent          : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentHeaderComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveCMakeConfigComponent     : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentCMakeConfigComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HavePkgConfigComponent       : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentPkgconfigComponent
  # - cmake_helpers_property_${PROJECT_NAME}_CpackPreBuildScript          : Location of a ${PROJECT_NAME} CPack pre-build script
  # - cmake_helpers_property_${PROJECT_NAME}_LibraryTargets               : List of library targets
  # - cmake_helpers_property_${PROJECT_NAME}_HaveManComponent             : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DocumentationManComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveHtmlComponent            : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DocumentationHtmlComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveExeComponent             : Boolean indicating presence of COMPONENT ${PROJECT_NAME}ApplicationExeComponent
  # ============================================================================================================
  #
  # We do not want to package if we install nothing
  #
  if(CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO AND (NOT PROJECT_IS_TOP_LEVEL))
    return()
  endif()
  #
  # Log prefix
  #
  set(_cmake_helpers_logprefix "cmake_helpers/${PROJECT_NAME}/package")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
    message(STATUS "[${_cmake_helpers_logprefix}] Starting")
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
  endif()
  #
  # Directory properties dependencies
  #
  foreach(_cmake_helpers_package_property
      HaveRuntimeComponent
      HaveLibraryComponent
      HaveArchiveComponent
      HaveHeaderComponent
      HaveCMakeConfigComponent
      HavePkgConfigComponent
      CpackPreBuildScript
      LibraryTargets
      HaveManComponent
      HaveHtmlComponent
      HaveExeComponent
    )
    cmake_helpers_call(get_property cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_package_property} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_package_property})
  endforeach()
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  #
  set(_options)
  set(_oneValueArgs
    NAME
    VENDOR
    DESCRIPTION_SUMMARY
    LICENSE
    INSTALL_DIRECTORY
    DEVELOPMENTGROUP_DISPLAY_NAME
    DEVELOPMENTGROUP_DESCRIPTION
    DOCUMENTATIONGROUP_DISPLAY_NAME
    DOCUMENTATIONGROUP_DESCRIPTION
    RUNTIMEGROUP_DISPLAY_NAME
    RUNTIMEGROUP_DESCRIPTION
    LIBRARY_DISPLAY_NAME
    LIBRARY_DESCRIPTION
    HEADER_DISPLAY_NAME
    HEADER_DESCRIPTION
    MAN_DISPLAY_NAME
    MAN_DESCRIPTION
    HTML_DISPLAY_NAME
    HTML_DESCRIPTION
    APPLICATION_DISPLAY_NAME
    APPLICATION_DESCRIPTION
  )
  set(_multiValueArgs
  )
  #
  # Single-value arguments default values
  #
  set(_cmake_helpers_package_name                              ${PROJECT_NAME})
  set(_cmake_helpers_package_vendor                            " ")
  set(_cmake_helpers_package_description_summary               "${_cmake_helpers_package_name}")
  set(_cmake_helpers_package_license                           ${PROJECT_SOURCE_DIR}/LICENSE)
  set(_cmake_helpers_package_install_directory                 "${_cmake_helpers_package_name}")
  set(_cmake_helpers_package_developmentgroup_display_name     "Development")
  set(_cmake_helpers_package_developmentgroup_description      "Development\n\nLibraries, Headers and Configuration files")
  set(_cmake_helpers_package_documentationgroup_display_name   "Documentation")
  set(_cmake_helpers_package_documentationgroup_description    "Documentation\n\nDocumentation in various formats")
  set(_cmake_helpers_package_runtimegroup_display_name         "Runtime")
  set(_cmake_helpers_package_runtimegroup_description          "Runtime\n\nApplications")
  set(_cmake_helpers_package_library_display_name              "Libraries")
  set(_cmake_helpers_package_library_display_names)
  foreach(_target ${cmake_helpers_property_${PROJECT_NAME}_LibraryTargets})
    get_target_property(_type ${_target} TYPE)
    if(_type STREQUAL "INTERFACE_LIBRARY")
      list(APPEND _cmake_helpers_package_library_display_names "Interface")
    elseif(_type STREQUAL "SHARED_LIBRARY")
      list(APPEND _cmake_helpers_package_library_display_names "Shared")
    elseif(_type STREQUAL "STATIC_LIBRARY")
      list(APPEND _cmake_helpers_package_library_display_names "Static")
    elseif(_type STREQUAL "MODULE_LIBRARY")
      list(APPEND _cmake_helpers_package_library_display_names "Module")
    elseif(_type STREQUAL "OBJECT_LIBRARY")
      #
      # And object library installs nothing
      #
    else()
      message(FATAL_ERROR "Unsupported library type: ${_type}")
    endif()
  endforeach()
  list(LENGTH _cmake_helpers_package_library_display_names _cmake_helpers_package_library_display_names_length)
  if(_cmake_helpers_package_library_display_names_length EQUAL 1)
    #
    # Only one library
    #
    set(_cmake_helpers_package_library_description "${_cmake_helpers_package_library_display_names} library")
  elseif(_cmake_helpers_package_library_display_names_length GREATER 1)
    #
    # More than one library
    #
    list(GET _cmake_helpers_package_library_display_names -1 _cmake_helpers_package_library_display_name_last)
    list(REMOVE_AT _cmake_helpers_package_library_display_names -1)
    list(JOIN _cmake_helpers_package_library_display_names ", " _cmake_helpers_package_library_description)
    set(_cmake_helpers_package_library_description "${_cmake_helpers_package_library_description} and ${_cmake_helpers_package_library_display_name_last} libraries")
  else()
    #
    # No library
    #
    set(_cmake_helpers_package_library_description "")
  endif()
  set(_cmake_helpers_package_header_display_name               "Headers")
  set(_cmake_helpers_package_header_description                "C/C++ Header files")
  set(_cmake_helpers_package_man_display_name                  "Man")
  set(_cmake_helpers_package_man_description                   "Documentation in the man format")
  set(_cmake_helpers_package_html_display_name                 "Html")
  set(_cmake_helpers_package_html_description                  "Documentation in the html format")
  set(_cmake_helpers_package_application_display_name          "Applications")
  set(_cmake_helpers_package_application_description           "Runtime executables")
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_helpers_package "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # Set CPack hooks
  #
  if(cmake_helpers_property_${PROJECT_NAME}_CpackPreBuildScript)
    list(APPEND CPACK_PRE_BUILD_SCRIPTS ${cmake_helpers_property_${PROJECT_NAME}_CpackPreBuildScript})
  endif()
  #
  # Set common CPack variables
  #
  set(CPACK_PACKAGE_NAME                ${_cmake_helpers_package_name})
  set(CPACK_PACKAGE_VENDOR              ${_cmake_helpers_package_vendor})
  set(CPACK_PACKAGE_INSTALL_DIRECTORY   ${_cmake_helpers_package_install_directory})
  set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${_cmake_helpers_package_description_summary})
  set(CPACK_PACKAGE_VERSION             ${PROJECT_VERSION})
  if(EXISTS ${_cmake_helpers_package_license})
    configure_file(${_cmake_helpers_package_license} ${CMAKE_CURRENT_BINARY_DIR}/LICENSE.txt)
    set(CPACK_RESOURCE_FILE_LICENSE     ${CMAKE_CURRENT_BINARY_DIR}/LICENSE.txt)
  endif()
  #
  # Get all components in one package
  #
  set(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)
  #
  # And explicit show them
  #
  set(CPACK_MONOLITHIC_INSTALL FALSE)
  #
  # Always enable archive
  #
  set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)
  #
  # We need a way to know if installation is for CPack or not
  #
  set(CPACK_PROJECT_CONFIG_FILE_PATH ${CMAKE_CURRENT_BINARY_DIR}/cpack_project_config_file.cmake)
  file(WRITE ${CPACK_PROJECT_CONFIG_FILE_PATH} "message(STATUS \"Setting ENV{CPACK_IS_RUNNING}\")\n")
  file(APPEND ${CPACK_PROJECT_CONFIG_FILE_PATH} "set(ENV{CPACK_IS_RUNNING} TRUE)\n")
  set(CPACK_PROJECT_CONFIG_FILE ${CPACK_PROJECT_CONFIG_FILE_PATH})
  #
  # Append to CPACK_INSTALL_SCRIPTS that will be executed right before packaging - we use it to generate CPACK_PRE_BUILD_SCRIPT_PC_PATH
  #
  set(FIRE_POST_INSTALL_CMAKE_PATH ${CMAKE_CURRENT_BINARY_DIR}/fire_post_install.cmake)
  set(CPACK_INSTALL_SCRIPT_PATH ${CMAKE_CURRENT_BINARY_DIR}/cpack_install_script_pc.cmake)
  list(APPEND CPACK_INSTALL_SCRIPTS ${CPACK_INSTALL_SCRIPT_PATH})
  file(WRITE  ${CPACK_INSTALL_SCRIPT_PATH} "\n")
  if(cmake_helpers_property_${PROJECT_NAME}_CpackPreBuildScript)
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "SET (CPACK_PRE_BUILD_SCRIPT_PC_PATH \"${cmake_helpers_property_${PROJECT_NAME}_CpackPreBuildScript}\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "message(STATUS \"Generating \${CPACK_PRE_BUILD_SCRIPT_PC_PATH}\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (WRITE  \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(CMAKE_SYSTEM_NAME ${CMAKE_SYSTEM_NAME})\\n\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(CMAKE_SIZEOF_VOID_P ${CMAKE_SIZEOF_VOID_P})\\n\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"include(GNUInstallDirs)\\n\")\n")
    #
    # We use environment variables to propagate CMake options - it is not wrong to hardcode "Library" because this is the name
    # of the component in which we have done file(WRITE ...)
    #
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{DESTDIR} is: \\\\\\\"\\\$ENV{DESTDIR}\\\\\\\"\\\")\\n\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(ENV{CMAKE_INSTALL_PREFIX_ENV} \\\"\${CMAKE_INSTALL_PREFIX}/Library\\\")\\n\")\n")
    FILE(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{CMAKE_INSTALL_PREFIX_ENV} set to: \\\\\\\"\\\$ENV{CMAKE_INSTALL_PREFIX_ENV}\\\\\\\"\\\")\\n\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"cmake_path(SET CMAKE_MODULE_ROOT_PATH_ENV \\\"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/Library/${CMAKE_HELPERS_INSTALL_CMAKEDIR}\\\" NORMALIZE)\\n\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(ENV{CMAKE_MODULE_ROOT_PATH_ENV} \\\"\\\${CMAKE_MODULE_ROOT_PATH_ENV}\\\")\\n\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{CMAKE_MODULE_ROOT_PATH_ENV} set to: \\\\\\\"\\\$ENV{CMAKE_MODULE_ROOT_PATH_ENV}\\\\\\\"\\\")\\n\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"cmake_path(SET CMAKE_PKGCONFIG_ROOT_PATH_ENV \\\"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/Library/${CMAKE_HELPERS_INSTALL_PKGCONFIGDIR}\\\" NORMALIZE)\\n\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV} \\\"\\\${CMAKE_PKGCONFIG_ROOT_PATH_ENV}\\\")\\n\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV} set to: \\\\\\\"\\\$ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV}\\\\\\\"\\\")\\n\")\n")
    file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"execute_process(COMMAND \\\"${CMAKE_COMMAND}\\\" -G \\\"${CMAKE_GENERATOR}\\\" -P \\\"${FIRE_POST_INSTALL_CMAKE_PATH}\\\" WORKING_DIRECTORY \\\$ENV{CMAKE_INSTALL_PREFIX_ENV} COMMAND_ERROR_IS_FATAL ANY COMMAND_ECHO STDOUT)\\n\")\n")
  endif()
  #
  # Components
  #
  set(CPACK_COMPONENTS_ALL)
  foreach(_component
      RuntimeComponent
      LibraryComponent
      ArchiveComponent
      HeaderComponent
      CMakeConfigComponent
      PkgConfigComponent
      ManComponent
      HtmlComponent
    )
    if(cmake_helpers_property_${PROJECT_NAME}_Have${_component})
      list(APPEND CPACK_COMPONENTS_ALL ${PROJECT_NAME}_${_component})
    endif()
  endforeach()
  #
  # Specific to NSIS generator (if any)
  #
  if(WIN32)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
      set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
      set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION} (Win64)")
      set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-win64")
    else()
      set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
      set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION} (Win32)")
      set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-win32")
    endif()
  endif()
  #
  # Include CPack - from now on we will have access to CPACK own macros
  #
  include(CPack)
  #
  # Add Groups
  #
  if(_cmake_helpers_have_library_components OR _cmake_helpers_have_header_components)
    set(_cmake_helpers_package_can_developmentgroup TRUE)
  else()
    set(_cmake_helpers_package_can_developmentgroup FALSE)
  endif()
  if(_cmake_helpers_have_man_components OR _cmake_helpers_have_html_components)
    set(_cmake_helpers_package_can_documentationgroup TRUE)
  else()
    set(_cmake_helpers_package_can_documentationgroup FALSE)
  endif()
  if(_cmake_helpers_have_application_components)
    set(_cmake_helpers_package_can_runtimegroup TRUE)
  else()
    set(_cmake_helpers_package_can_runtimegroup FALSE)
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] Development group  : ${_cmake_helpers_package_can_developmentgroup}")
    message(STATUS "[${_cmake_helpers_logprefix}] Documentation group: ${_cmake_helpers_package_can_documentationgroup}")
    message(STATUS "[${_cmake_helpers_logprefix}] Runtime group      : ${_cmake_helpers_package_can_runtimegroup}")
  endif()
  if(_cmake_helpers_package_can_developmentgroup)
    cmake_helpers_call(cpack_add_component_group DevelopmentGroup
      DISPLAY_NAME ${_cmake_helpers_package_developmentgroup_display_name}
      DESCRIPTION ${_cmake_helpers_package_developmentgroup_description}
      EXPANDED)
  endif()
  if(_cmake_helpers_package_can_documentationgroup)
    cmake_helpers_call(cpack_add_component_group DocumentationGroup
      DISPLAY_NAME ${_cmake_helpers_package_documentationgroup_display_name}
      DESCRIPTION ${_cmake_helpers_package_documentationgroup_description}
      EXPANDED)
  endif()
  if(_cmake_helpers_package_can_runtimegroup)
    cmake_helpers_call(cpack_add_component_group RuntimeGroup
      DISPLAY_NAME ${_cmake_helpers_package_runtimegroup_display_name}
      DESCRIPTION ${_cmake_helpers_package_runtimegroup_description}
      EXPANDED)
  endif()
  #
  # Add Components - it must have the same logic that is setting CPACK_COMPONENTS_ALL
  #
  if(_cmake_helpers_have_library_components)
    foreach(_cmake_helpers_library_component_name ${_cmake_helpers_library_component_names})
      cmake_helpers_call(cpack_add_component ${_cmake_helpers_library_component_name}
	DISPLAY_NAME ${_cmake_helpers_package_library_display_name}
	DESCRIPTION ${_cmake_helpers_package_library_description}
	GROUP DevelopmentGroup
      )
    endforeach()
  endif()
  if(_cmake_helpers_have_header_components)
    foreach(_cmake_helpers_header_component_name ${_cmake_helpers_header_component_names})
      cmake_helpers_call(cpack_add_component ${_cmake_helpers_header_component_name}
	DISPLAY_NAME ${_cmake_helpers_package_header_display_name}
	DESCRIPTION ${_cmake_helpers_package_header_description}
	GROUP DevelopmentGroup
      )
    endforeach()
  endif()
  if(_cmake_helpers_have_man_components)
    foreach(_cmake_helpers_man_component_name ${_cmake_helpers_man_component_names})
      cmake_helpers_call(cpack_add_component ${_cmake_helpers_man_component_name}
	DISPLAY_NAME ${_cmake_helpers_package_man_display_name}
	DESCRIPTION ${_cmake_helpers_package_man_description}
	GROUP DocumentationGroup
      )
    endforeach()
  endif()
  if(_cmake_helpers_have_html_components)
    foreach(_cmake_helpers_html_component_name ${_cmake_helpers_html_component_names})
      cmake_helpers_call(cpack_add_component ${_cmake_helpers_html_component_name}
	DISPLAY_NAME ${_cmake_helpers_package_html_display_name}
	DESCRIPTION ${_cmake_helpers_package_html_description}
	GROUP DocumentationGroup
      )
    endforeach()
  endif()
  if(_cmake_helpers_have_application_components)
    foreach(_cmake_helpers_application_component_name ${_cmake_helpers_application_component_names})
      cmake_helpers_call(cpack_add_component ${_cmake_helpers_application_component_name}
	DISPLAY_NAME ${_cmake_helpers_package_application_display_name}
	DESCRIPTION ${_cmake_helpers_package_application_description}
	GROUP RuntimeGroup
	DEPENDS Library)
    endforeach()
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
