function(cmake_helpers_package)
  # ============================================================================================================
  # This module depend on these ${CMAKE_CURRENT_BINARY_DIR} directory properties:
  #
  # - cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentRuntimeComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveLibraryComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentLibraryComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveArchiveComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentArchiveComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveHeaderComponent          : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentHeaderComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveConfigComponent          : Boolean indicating presence of COMPONENT ${PROJECT_NAME}DevelopmentConfigComponent
  # - cmake_helpers_property_${PROJECT_NAME}_PkgConfigHookScript          : Location of a ${PROJECT_NAME} CPack pre-build script
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
  set(_cmake_helpers_package_dependencies
    cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent
    cmake_helpers_property_${PROJECT_NAME}_HaveLibraryComponent
    cmake_helpers_property_${PROJECT_NAME}_HaveArchiveComponent
    cmake_helpers_property_${PROJECT_NAME}_HaveHeaderComponent
    cmake_helpers_property_${PROJECT_NAME}_HaveConfigComponent
    cmake_helpers_property_${PROJECT_NAME}_PkgConfigHookScript
    cmake_helpers_property_${PROJECT_NAME}_LibraryTargets
    cmake_helpers_property_${PROJECT_NAME}_HaveManComponent
    cmake_helpers_property_${PROJECT_NAME}_HaveHtmlComponent
    cmake_helpers_property_${PROJECT_NAME}_HaveExeComponent
  )
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] -------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Dependencies:")
    message(STATUS "[${_cmake_helpers_logprefix}] -------------")
  endif()
  foreach(_cmake_helpers_package_dependency ${_cmake_helpers_package_dependencies})
    get_property(${_cmake_helpers_package_dependency} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY ${_cmake_helpers_package_dependency})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] ... ${_cmake_helpers_package_dependency}: ${${_cmake_helpers_package_dependency}}")
    endif()
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
  if(cmake_helpers_property_${PROJECT_NAME}_PkgConfigHookScript)
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
  # Components
  #
  set(CPACK_COMPONENTS_ALL)
  foreach(_component
      RuntimeComponent
      LibraryComponent
      ArchiveComponent
      HeaderComponent
      ConfigComponent
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
  if(cmake_helpers_property_${PROJECT_NAME}_LibraryTargets)
    set(_cmake_helpers_package_can_developmentgroup TRUE)
  else()
    set(_cmake_helpers_package_can_developmentgroup FALSE)
  endif()
  if(cmake_helpers_property_${PROJECT_NAME}_HaveManComponent OR cmake_helpers_property_${PROJECT_NAME}_HaveHtmlComponent)
    set(_cmake_helpers_package_can_documentationgroup TRUE)
  else()
    set(_cmake_helpers_package_can_documentationgroup FALSE)
  endif()
  if(cmake_helpers_property_${PROJECT_NAME}_HaveExeComponent)
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
  if(cmake_helpers_property_${PROJECT_NAME}_LibraryTargets)
    foreach(_cmake_helpers_package_component
	RuntimeComponent
	LibraryComponent
	ArchiveComponent
	HeaderComponent
	ConfigComponent
      )
      if(cmake_helpers_property_${PROJECT_NAME}_Have${_cmake_helpers_package_component})
	cmake_helpers_call(cpack_add_component ${PROJECT_NAME}${_cmake_helpers_package_component}
	  DISPLAY_NAME ${_cmake_helpers_package_library_display_name}
	  DESCRIPTION ${_cmake_helpers_package_library_description}
	  GROUP DevelopmentGroup
	)
      endif()
    endforeach()
  endif()
  if(cmake_helpers_property_${PROJECT_NAME}_HaveManComponent OR cmake_helpers_property_${PROJECT_NAME}_HaveHtmlComponent)
    foreach(_cmake_helpers_package_component
	ManComponent
	HtmlComponent
      )
      cmake_helpers_call(cpack_add_component ${PROJECT_NAME}${_cmake_helpers_package_component}
	DISPLAY_NAME ${_cmake_helpers_package_man_display_name}
	DESCRIPTION ${_cmake_helpers_package_man_description}
	GROUP DocumentationGroup
      )
    endforeach()
  endif()
  if(cmake_helpers_property_${PROJECT_NAME}_HaveExeComponent)
    if(cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent)
      set(_cmake_helpers_component_depends DEPENDS RuntimeComponent)
    else()
      set(_cmake_helpers_component_depends)
    endif()
    foreach(_cmake_helpers_package_component
	ExeComponent
      )
      cmake_helpers_call(cpack_add_component ${PROJECT_NAME}${_cmake_helpers_package_component}
	DISPLAY_NAME ${_cmake_helpers_package_application_display_name}
	DESCRIPTION ${_cmake_helpers_package_application_description}
	GROUP RuntimeGroup
	${_cmake_helpers_component_depends}
      )
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
