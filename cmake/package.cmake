function(cmake_helpers_package)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${PROJECT_NAME}/package] -------------------------")
    message(STATUS "[${PROJECT_NAME}/package] Doing CPack configuration")
    message(STATUS "[${PROJECT_NAME}/package] -------------------------")
  endif()
  #
  # Recuperate directory properties
  #
  foreach(_variable
      namespace
      version
      package_vendor package_description_summary package_license
      have_headercomponent have_librarycomponent have_manpagecomponent have_applicationcomponent
      cpack_pre_build_script)
    get_property(_cmake_helpers_${_variable} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_${_variable})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/package] _cmake_helpers_${_variable}: ${_cmake_helpers_${_variable}}")
    endif()
  endforeach()
  #
  # Set CPack hooks
  #
  if(_cmake_helpers_cpack_pre_build_script)
    list(APPEND CPACK_PRE_BUILD_SCRIPTS ${_cmake_helpers_cpack_pre_build_script})
  endif()
  #
  # Set common CPack variables
  #
  set(CPACK_PACKAGE_NAME                ${_cmake_helpers_namespace})
  set(CPACK_PACKAGE_VENDOR              ${_cmake_helpers_package_vendor})
  set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${_cmake_helpers_package_description_summary})
  set(CPACK_PACKAGE_VERSION             ${_cmake_helpers_version})
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
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(ENV{CMAKE_INSTALL_PREFIX_ENV} \\\"\${CMAKE_INSTALL_PREFIX}/LibraryComponent\\\")\\n\")\n")
  FILE(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{CMAKE_INSTALL_PREFIX_ENV} set to: \\\\\\\"\\\$ENV{CMAKE_INSTALL_PREFIX_ENV}\\\\\\\"\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"set(ENV{CMAKE_INSTALL_LIBDIR_ENV} \\\"\${CMAKE_INSTALL_LIBDIR}\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"message(STATUS \\\"[cpack_pre_build_script_pc_${PROJECT_NAME}.cmake] \\\\\\\$ENV{CMAKE_INSTALL_LIBDIR_ENV} set to: \\\\\\\"\\\$ENV{CMAKE_INSTALL_LIBDIR_ENV}\\\\\\\"\\\")\\n\")\n")
  file(APPEND ${CPACK_INSTALL_SCRIPT_PATH} "FILE (APPEND \${CPACK_PRE_BUILD_SCRIPT_PC_PATH} \"cmake_path(SET CMAKE_MODULE_ROOT_PATH_ENV \\\"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/LibraryComponent/lib/cmake\\\" NORMALIZE)\\n\")\n")
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
  if(_cmake_helpers_have_headercomponent)
    set(_cmake_helpers_can_developmentgroup TRUE)
  else()
    set(_cmake_helpers_can_developmentgroup FALSE)
  endif()
  if(_cmake_helpers_have_librarycomponent)
    set(_cmake_helpers_can_librarygroup TRUE)
  else()
    set(_cmake_helpers_can_librarygroup FALSE)
  endif()
  if(_cmake_helpers_have_manpagecomponent)
    set(_cmake_helpers_can_documentgroup TRUE)
  else()
    set(_cmake_helpers_can_documentgroup FALSE)
  endif()
  if(_cmake_helpers_have_applicationcomponent)
    set(_cmake_helpers_can_runtimegroup TRUE)
  else()
    set(_cmake_helpers_can_runtimegroup FALSE)
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${PROJECT_NAME}/package] Development group : ${_cmake_helpers_can_developmentgroup}")
    message(STATUS "[${PROJECT_NAME}/package] Library group     : ${_cmake_helpers_can_librarygroup}")
    message(STATUS "[${PROJECT_NAME}/package] Document group    : ${_cmake_helpers_can_documentgroup}")
    message(STATUS "[${PROJECT_NAME}/package] Runtime group     : ${_cmake_helpers_can_runtimegroup}")
  endif()
  if(_cmake_helpers_can_developmentgroup)
    cmake_helpers_call(cpack_add_component_group DevelopmentGroup
      DISPLAY_NAME "Development"
      DESCRIPTION "Development\n\nContains header and CMake components"
      EXPANDED)
  endif()
  if(_cmake_helpers_can_librarygroup)
    cmake_helpers_call(cpack_add_component_group LibraryGroup
      DISPLAY_NAME "Libraries"
      DESCRIPTION "Libraries\n\nContains dynamic and static components"
      EXPANDED)
  endif()
  if(_cmake_helpers_can_documentgroup)
    cmake_helpers_call(cpack_add_component_group DocumentGroup
      DISPLAY_NAME "Documents"
      DESCRIPTION "Documents\n\nContains manpages component"
      EXPANDED)
  endif()
  if(_cmake_helpers_can_runtimegroup)
    cmake_helpers_call(cpack_add_component_group RuntimeGroup
      DISPLAY_NAME "Runtime"
      DESCRIPTION "Runtime\n\nContains application component"
      EXPANDED)
  endif()
  #
  # Components
  #
  set(CPACK_COMPONENTS_ALL)
  if(_cmake_helpers_have_headercomponent)
    cmake_helpers_call(cpack_add_component HeaderComponent
      DISPLAY_NAME "Headers"
      DESCRIPTION "C/C++ Headers"
      GROUP DevelopmentGroup
    )
    list(APPEND CPACK_COMPONENTS_ALL HeaderComponent)
  endif()
  if(_cmake_helpers_have_librarycomponent)
    cmake_helpers_call(cpack_add_component LibraryComponent
      DISPLAY_NAME "Libraries"
      DESCRIPTION "Dynamic and Static Libraries"
      GROUP LibraryGroup
    )
    list(APPEND CPACK_COMPONENTS_ALL LibraryComponent)
  endif()
  if(_cmake_helpers_have_manpagecomponent)
    cmake_helpers_call(cpack_add_component ManpageComponent
      DISPLAY_NAME "Man pages"
      DESCRIPTION "Documentation in the man format"
      GROUP DocumentGroup
    )
    list(APPEND CPACK_COMPONENTS_ALL ManpageComponent)
  endif()
  if(_cmake_helpers_have_applicationcomponent)
    cmake_helpers_call(cpack_add_component ApplicationComponent
      DISPLAY_NAME "Applications"
      DESCRIPTION "Executables"
      GROUP RuntimeGroup
      DEPENDS LibraryComponent)
    list(APPEND CPACK_COMPONENTS_ALL ApplicationComponent)
  endif()
endfunction()
