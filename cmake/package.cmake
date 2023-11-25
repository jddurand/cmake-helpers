function(cmake_helpers_package)
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
  # Recuperate directory library properties
  #
  foreach(_variable
      namespace
      version
      cpack_pre_build_script
      install_libdir
      install_cmakedir
      install_pkgconfigdir)
    get_property(_cmake_helpers_library_${_variable} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_${_variable})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] _cmake_helpers_library_${_variable}: ${_cmake_helpers_library_${_variable}}")
    endif()
  endforeach()
  #
  # Recuperate directory have properties
  #
  foreach(_variable
      have_library
      have_interface_library
      have_static_library
      have_dynamic_library
      have_module_library
      have_header
      have_man
      have_html
      have_application)
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
    VENDOR
    DESCRIPTION_SUMMARY
    LICENSE
    INSTALL_DIRECTORY
    DEVELOPMENTGROUP_DISPLAY_NAME
    DEVELOPMENTGROUP_DESCRIPTION
    DOCUMENTGROUP_DISPLAY_NAME
    DOCUMENTGROUP_DESCRIPTION
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
  set(_multiValueArgs)
  #
  # Single-value arguments default values
  #
  set(_cmake_helpers_package_vendor                            " ")
  set(_cmake_helpers_package_description_summary               "${_cmake_helpers_library_namespace}")
  set(_cmake_helpers_package_license                           ${PROJECT_SOURCE_DIR}/LICENSE)
  set(_cmake_helpers_package_install_directory                 "${_cmake_helpers_library_namespace}")
  set(_cmake_helpers_package_developmentgroup_display_name     "Development")
  set(_cmake_helpers_package_developmentgroup_description      "Development\n\nLibraries and Headers components")
  set(_cmake_helpers_package_documentgroup_display_name        "Documents")
  set(_cmake_helpers_package_documentgroup_description         "Documents\n\nDocumentation in various formats")
  set(_cmake_helpers_package_runtimegroup_display_name         "Runtime")
  set(_cmake_helpers_package_runtimegroup_description          "Runtime\n\nApplications")
  set(_cmake_helpers_package_library_display_name              "Libraries")
  if(_cmake_helpers_have_interface_library)
    set(_cmake_helpers_package_library_description             "Library interface")
  elseif(_cmake_helpers_have_module_library)
    set(_cmake_helpers_package_library_description             "Module plugin")
  elseif(_cmake_helpers_have_static_library OR _cmake_helpers_have_dynamic_library)
    #
    # When static is produced, shared is always produced
    #
    set(_cmake_helpers_package_library_description             "Dynamic and static libraries")
  else()
    message(FATAL_ERROR "Unsupported configuration: no library is produced")
  endif()
  set(_cmake_helpers_package_header_display_name               "Headers")
  set(_cmake_helpers_package_header_description                "Header files")
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
  if(_cmake_helpers_library_cpack_pre_build_script)
    list(APPEND CPACK_PRE_BUILD_SCRIPTS ${_cmake_helpers_library_cpack_pre_build_script})
  endif()
  #
  # Set common CPack variables
  #
  set(CPACK_PACKAGE_NAME                ${_cmake_helpers_library_namespace})
  set(CPACK_PACKAGE_VENDOR              ${_cmake_helpers_package_vendor})
  set(CPACK_PACKAGE_INSTALL_DIRECTORY   ${_cmake_helpers_package_install_directory})
  set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${_cmake_helpers_package_description_summary})
  set(CPACK_PACKAGE_VERSION             ${_cmake_helpers_library_version})
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
  # We need a way to know if make install is running under CPACK or not
  #
  set(CPACK_PROJECT_CONFIG_FILE_PATH ${CMAKE_CURRENT_BINARY_DIR}/cpack_project_config_file.cmake)
  file(WRITE ${CPACK_PROJECT_CONFIG_FILE_PATH} "message(STATUS \"Setting ENV{CPACK_IS_RUNNING}\")\n")
  file(APPEND ${CPACK_PROJECT_CONFIG_FILE_PATH} "set(ENV{CPACK_IS_RUNNING} TRUE)\n")
  set(CPACK_PROJECT_CONFIG_FILE ${CPACK_PROJECT_CONFIG_FILE_PATH})
  #
  # Append to CPACK_INSTALL_SCRIPTS that will be executed right before packaging - we use it to generate CPACK_PRE_BUILD_SCRIPT_PC_PATH
  #
  set(FIRE_POST_INSTALL_CMAKE_PATH ${CMAKE_BINARY_DIR}/fire_post_install.cmake)
  set(CPACK_INSTALL_SCRIPT_PATH ${CMAKE_CURRENT_BINARY_DIR}/cpack_install_script_pc.cmake)
  list(APPEND CPACK_INSTALL_SCRIPTS ${CPACK_INSTALL_SCRIPT_PATH})
  file(WRITE  ${CPACK_INSTALL_SCRIPT_PATH} "SET (CPACK_PRE_BUILD_SCRIPT_PC_PATH \"${CMAKE_CURRENT_BINARY_DIR}/cpack_pre_build_script_pc_${PROJECT_NAME}.cmake\")\n")
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
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"cmake_path(SET CMAKE_MODULE_ROOT_PATH_ENV \\\"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/Library/${_cmake_helpers_library_install_cmakedir}\\\" NORMALIZE)\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(ENV{CMAKE_MODULE_ROOT_PATH_ENV} \\\"\\\${CMAKE_MODULE_ROOT_PATH_ENV}\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{CMAKE_MODULE_ROOT_PATH_ENV} set to: \\\\\\\"\\\$ENV{CMAKE_MODULE_ROOT_PATH_ENV}\\\\\\\"\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"cmake_path(SET CMAKE_PKGCONFIG_ROOT_PATH_ENV \\\"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/Library/${_cmake_helpers_library_install_pkgconfigdir}\\\" NORMALIZE)\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV} \\\"\\\${CMAKE_PKGCONFIG_ROOT_PATH_ENV}\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV} set to: \\\\\\\"\\\$ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV}\\\\\\\"\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"execute_process(COMMAND \\\"${CMAKE_COMMAND}\\\" -G \\\"${CMAKE_GENERATOR}\\\" -P \\\"${FIRE_POST_INSTALL_CMAKE_PATH}\\\" WORKING_DIRECTORY \\\$ENV{CMAKE_INSTALL_PREFIX_ENV})\\n\")\n")
  #
  # Components
  #
  set(CPACK_COMPONENTS_ALL)
  if(_cmake_helpers_have_library)
    list(APPEND CPACK_COMPONENTS_ALL Library)
  endif()
  if(_cmake_helpers_have_header)
    list(APPEND CPACK_COMPONENTS_ALL Header)
  endif()
  if(_cmake_helpers_have_man)
    list(APPEND CPACK_COMPONENTS_ALL Man)
  endif()
  if(_cmake_helpers_have_html)
    list(APPEND CPACK_COMPONENTS_ALL Html)
  endif()
  if(_cmake_helpers_have_application)
    list(APPEND CPACK_COMPONENTS_ALL Application)
  endif()
  #
  # Specific to NSIS generator (if any)
  #
  if(WIN32)
    if(MSVC)
      if(CMAKE_CL_64)
	set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
	set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION} (Win64)")
      else()
	set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
	set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")
      endif()
    endif()
  endif()
  #
  # Include CPack - from now on we will have access to CPACK own macros
  #
  include(CPack)
  #
  # Add Groups
  #
  if(_cmake_helpers_have_library OR _cmake_helpers_have_header)
    set(_cmake_helpers_package_can_developmentgroup TRUE)
  else()
    set(_cmake_helpers_package_can_developmentgroup FALSE)
  endif()
  if(_cmake_helpers_have_man OR _cmake_helpers_have_html)
    set(_cmake_helpers_package_can_documentgroup TRUE)
  else()
    set(_cmake_helpers_package_can_documentgroup FALSE)
  endif()
  if(_cmake_helpers_have_application)
    set(_cmake_helpers_package_can_runtimegroup TRUE)
  else()
    set(_cmake_helpers_package_can_runtimegroup FALSE)
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] Development group : ${_cmake_helpers_package_can_developmentgroup}")
    message(STATUS "[${_cmake_helpers_logprefix}] Document group    : ${_cmake_helpers_package_can_documentgroup}")
    message(STATUS "[${_cmake_helpers_logprefix}] Runtime group     : ${_cmake_helpers_package_can_runtimegroup}")
  endif()
  if(_cmake_helpers_package_can_developmentgroup)
    cmake_helpers_call(cpack_add_component_group DevelopmentGroup
      DISPLAY_NAME ${_cmake_helpers_package_developmentgroup_display_name}
      DESCRIPTION ${_cmake_helpers_package_developmentgroup_description}
      EXPANDED)
  endif()
  if(_cmake_helpers_package_can_documentgroup)
    cmake_helpers_call(cpack_add_component_group DocumentGroup
      DISPLAY_NAME ${_cmake_helpers_package_documentgroup_display_name}
      DESCRIPTION ${_cmake_helpers_package_documentgroup_description}
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
  if(_cmake_helpers_have_library)
    cmake_helpers_call(cpack_add_component Library
      DISPLAY_NAME ${_cmake_helpers_package_library_display_name}
      DESCRIPTION ${_cmake_helpers_package_library_description}
      GROUP DevelopmentGroup
    )
  endif()
  if(_cmake_helpers_have_header)
    cmake_helpers_call(cpack_add_component Header
      DISPLAY_NAME ${_cmake_helpers_package_header_display_name}
      DESCRIPTION ${_cmake_helpers_package_header_description}
      GROUP DevelopmentGroup
    )
  endif()
  if(_cmake_helpers_have_man)
    cmake_helpers_call(cpack_add_component Man
      DISPLAY_NAME ${_cmake_helpers_package_man_display_name}
      DESCRIPTION ${_cmake_helpers_package_man_description}
      GROUP DocumentGroup
    )
  endif()
  if(_cmake_helpers_have_html)
    cmake_helpers_call(cpack_add_component Html
      DISPLAY_NAME ${_cmake_helpers_package_html_display_name}
      DESCRIPTION ${_cmake_helpers_package_html_description}
      GROUP DocumentGroup
    )
  endif()
  if(_cmake_helpers_have_application)
    cmake_helpers_call(cpack_add_component Application
      DISPLAY_NAME ${_cmake_helpers_package_application_display_name}
      DESCRIPTION ${_cmake_helpers_package_application_description}
      GROUP RuntimeGroup
      DEPENDS Library)
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
