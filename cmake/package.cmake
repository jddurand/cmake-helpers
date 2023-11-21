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
      install_libdir)
    get_property(_cmake_helpers_library_${_variable} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_${_variable})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] _cmake_helpers_library_${_variable}: ${_cmake_helpers_library_${_variable}}")
    endif()
  endforeach()
  #
  # Recuperate directory have properties
  #
  foreach(_variable have_library have_documentation have_application)
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
    LIBRARYGROUP_DISPLAY_NAME
    LIBRARYGROUP_DESCRIPTION
    DOCUMENTGROUP_DISPLAY_NAME
    DOCUMENTGROUP_DESCRIPTION
    RUNTIMEGROUP_DISPLAY_NAME
    RUNTIMEGROUP_DESCRIPTION
    LIBRARY_DISPLAY_NAME
    LIBRARY_DESCRIPTION
    DOCUMENTATION_DISPLAY_NAME
    DOCUMENTATION_DESCRIPTION
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
  set(_cmake_helpers_package_librarygroup_display_name         "Libraries")
  set(_cmake_helpers_package_librarygroup_description          "Libraries\n\nLibraries and header files")
  set(_cmake_helpers_package_documentgroup_display_name        "Documents")
  set(_cmake_helpers_package_documentgroup_description         "Documents\n\nDocumentation")
  set(_cmake_helpers_package_runtimegroup_display_name         "Runtime")
  set(_cmake_helpers_package_runtimegroup_description          "Runtime\n\nApplications")
  set(_cmake_helpers_package_library_display_name              "Libraries")
  set(_cmake_helpers_package_library_description               "Libraries and header files")
  set(_cmake_helpers_package_documentation_display_name        "Documentation")
  set(_cmake_helpers_package_documentation_description         "Documentation")
  set(_cmake_helpers_package_application_display_name          "Applications")
  set(_cmake_helpers_package_application_description           "Executables")
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_helpers_package "" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
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
  # We use environment variables to propagate CMake options
  #
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{DESTDIR} is: \\\\\\\"\\\$ENV{DESTDIR}\\\\\\\"\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(ENV{CMAKE_INSTALL_PREFIX_ENV} \\\"\${CMAKE_INSTALL_PREFIX}/Library\\\")\\n\")\n")
  FILE(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{CMAKE_INSTALL_PREFIX_ENV} set to: \\\\\\\"\\\$ENV{CMAKE_INSTALL_PREFIX_ENV}\\\\\\\"\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(ENV{_cmake_helpers_library_install_libdir_ENV} \\\"\${_cmake_helpers_library_install_libdir}\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{_cmake_helpers_library_install_libdir_ENV} set to: \\\\\\\"\\\$ENV{_cmake_helpers_library_install_libdir_ENV}\\\\\\\"\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"cmake_path(SET CMAKE_MODULE_ROOT_PATH_ENV \\\"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/Library/lib/cmake\\\" NORMALIZE)\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(ENV{CMAKE_MODULE_ROOT_PATH_ENV} \\\"\\\${CMAKE_MODULE_ROOT_PATH_ENV}\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{CMAKE_MODULE_ROOT_PATH_ENV} set to: \\\\\\\"\\\$ENV{CMAKE_MODULE_ROOT_PATH_ENV}\\\\\\\"\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"execute_process(COMMAND \\\"${CMAKE_COMMAND}\\\" -G \\\"${CMAKE_GENERATOR}\\\" -P \\\"${FIRE_POST_INSTALL_CMAKE_PATH}\\\" WORKING_DIRECTORY \\\$ENV{CMAKE_INSTALL_PREFIX_ENV})\\n\")\n")
  #
  # Include CPack - from now on we will have access to CPACK own macros
  #
  include(CPack)
  #
  # Groups
  #
  if(_cmake_helpers_have_library)
    set(_cmake_helpers_package_can_librarygroup TRUE)
  else()
    set(_cmake_helpers_package_can_librarygroup FALSE)
  endif()
  if(_cmake_helpers_have_documentation)
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
    message(STATUS "[${_cmake_helpers_logprefix}] Library group     : ${_cmake_helpers_package_can_librarygroup}")
    message(STATUS "[${_cmake_helpers_logprefix}] Document group    : ${_cmake_helpers_package_can_documentgroup}")
    message(STATUS "[${_cmake_helpers_logprefix}] Runtime group     : ${_cmake_helpers_package_can_runtimegroup}")
  endif()
  if(_cmake_helpers_package_can_librarygroup)
    cmake_helpers_call(cpack_add_component_group LibraryGroup
      DISPLAY_NAME ${_cmake_helpers_package_librarygroup_display_name}
      DESCRIPTION ${_cmake_helpers_package_librarygroup_description}
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
  # Components
  #
  set(CPACK_COMPONENTS_ALL)
  if(_cmake_helpers_have_library)
    cmake_helpers_call(cpack_add_component Library
      DISPLAY_NAME ${_cmake_helpers_package_library_display_name}
      DESCRIPTION ${_cmake_helpers_package_library_description}
      GROUP LibraryGroup
    )
    list(APPEND CPACK_COMPONENTS_ALL Library)
  endif()
  if(_cmake_helpers_have_documentation)
    cmake_helpers_call(cpack_add_component Documentation
      DISPLAY_NAME ${_cmake_helpers_package_documentation_display_name}
      DESCRIPTION ${_cmake_helpers_package_documentation_description}
      GROUP DocumentGroup
    )
    list(APPEND CPACK_COMPONENTS_ALL Documentation)
  endif()
  if(_cmake_helpers_have_application)
    cmake_helpers_call(cpack_add_component Application
      DISPLAY_NAME ${_cmake_helpers_package_application_display_name}
      DESCRIPTION ${_cmake_helpers_package_application_description}
      GROUP RuntimeGroup
      DEPENDS Library)
    list(APPEND CPACK_COMPONENTS_ALL Application)
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
