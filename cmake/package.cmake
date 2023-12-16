function(cmake_helpers_package)
  # ============================================================================================================
  # This module depend on these ${CMAKE_CURRENT_BINARY_DIR} directory properties:
  #
  # - cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}RuntimeComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveLibraryComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}LibraryComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveArchiveComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}ArchiveComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveHeaderComponent          : Boolean indicating presence of COMPONENT ${PROJECT_NAME}HeaderComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveConfigComponent          : Boolean indicating presence of COMPONENT ${PROJECT_NAME}ConfigComponent
  # - cmake_helpers_property_${PROJECT_NAME}_PkgConfigHookScript          : Script that generates pkgconfig files after install phase
  # - cmake_helpers_property_${PROJECT_NAME}_HaveHtmlComponent            : Boolean indicating presence of COMPONENT ${PROJECT_NAME}HtmlComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveManComponent             : Boolean indicating presence of COMPONENT ${PROJECT_NAME}ManComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveExeComponent             : Boolean indicating presence of COMPONENT ${PROJECT_NAME}ExeComponent
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
    cmake_helpers_property_${PROJECT_NAME}_HaveManComponent
    cmake_helpers_property_${PROJECT_NAME}_HaveHtmlComponent
    cmake_helpers_property_${PROJECT_NAME}_HaveExeComponent
  )
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] -------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Dependencies:")
    message(STATUS "[${_cmake_helpers_logprefix}] -------------")
  endif()
  foreach(_cmake_helpers_package_dependency IN LISTS _cmake_helpers_package_dependencies)
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
    #
    # Component groups
    #
    DEVELOPMENTGROUP_DISPLAY_NAME
    DEVELOPMENTGROUP_DESCRIPTION
    DOCUMENTATIONGROUP_DISPLAY_NAME
    DOCUMENTATIONGROUP_DESCRIPTION
    RUNTIMEGROUP_DISPLAY_NAME
    RUNTIMEGROUP_DESCRIPTION
    #
    # Components
    #
    RUNTIME_DISPLAY_NAME
    RUNTIME_DESCRIPTION
    LIBRARY_DISPLAY_NAME
    LIBRARY_DESCRIPTION
    ARCHIVE_DISPLAY_NAME
    ARCHIVE_DESCRIPTION
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
  set(_cmake_helpers_package_runtime_display_name              "Runtime")
  set(_cmake_helpers_package_runtime_description               "Runtime libraries")
  set(_cmake_helpers_package_library_display_name              "Libraries")
  set(_cmake_helpers_package_library_description               "Shared libraries")
  set(_cmake_helpers_package_archive_display_name              "Archive")
  if(WIN32 OR CYGWIN)
    set(_cmake_helpers_package_archive_description               "Import/export libraries")
  else()
    set(_cmake_helpers_package_archive_description               "Static libraries")
  endif()
  set(_cmake_helpers_package_header_display_name               "Headers")
  set(_cmake_helpers_package_header_description                "C/C++ Header files")
  set(_cmake_helpers_package_config_display_name               "Development configuration")
  set(_cmake_helpers_package_config_description                "CMake and pkgconfig configuration files")
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
  # A variable to echo execute_process commands in debug mode
  #
  if(CMAKE_HELPERS_DEBUG)
    set(_cmake_helpers_package_command_echo_stdout "COMMAND_ECHO" "STDOUT")
  else()
    set(_cmake_helpers_package_command_echo_stdout)
  endif()
  #
  # Set CPack hooks
  #
  #
  # We need a way to know if make install is running under CPACK or not
  #
  set(_cmake_helpers_package_cpack_project_config_file ${CMAKE_CURRENT_BINARY_DIR}/cpack_project_config_file.cmake)
  FILE (WRITE ${_cmake_helpers_package_cpack_project_config_file} "# ${PROJECT_NAME} CPack configuration file\n")
  if(CMAKE_HELPERS_DEBUG)
    FILE (APPEND ${_cmake_helpers_package_cpack_project_config_file} "message(STATUS \"[${_cmake_helpers_logprefix}] Setting ENV{CMAKE_HELPERS_CPACK_IS_RUNNING}\")\n")
  endif()
  FILE (APPEND ${_cmake_helpers_package_cpack_project_config_file} "set(ENV{CMAKE_HELPERS_CPACK_IS_RUNNING} TRUE)\n")
  if(CMAKE_HELPERS_DEBUG)
    FILE (APPEND ${_cmake_helpers_package_cpack_project_config_file} "message(STATUS \"[${_cmake_helpers_logprefix}] CPACK_BUILD_CONFIG: \${CPACK_BUILD_CONFIG}\")\n")
  endif()
  #
  # pkgconfig hooks are running just before CPack installs the components
  #
  if(cmake_helpers_property_${PROJECT_NAME}_HaveConfigComponent AND cmake_helpers_property_${PROJECT_NAME}_PkgConfigHookScript)
    #
    # CPack install things breaked into components. But we want a true install to generate the .pc files.
    # So we install in a local directory, and copy back the .pc files in the CPack's CMAKE_INSTALL_PREFIX/component pkgconfig dir.
    # Unfortunately a true local install will need the current configuratio, and it is not easy to propagate that to CPack.
    #
    # A $<CONFIG> aware CPack script. We keep the logic to be config aware in the case there is no $<CONFIG>, with the technique
    # described in https://cmake.org/pipermail/cmake-developers/2015-April/025082.html .
    # When $<CONFIG> is set, CMake will redo every file(GENERATE ...) call.
    #
    file(APPEND ${_cmake_helpers_package_cpack_project_config_file} "
if(NOT(\"x\${CPACK_BUILD_CONFIG}\" STREQUAL \"x\"))
  list(APPEND CPACK_PRE_BUILD_SCRIPTS \"${CMAKE_CURRENT_BINARY_DIR}/cpack_pre_build_script_${PROJECT_NAME}_\${CPACK_BUILD_CONFIG}.cmake\")
else()
  list(APPEND CPACK_PRE_BUILD_SCRIPTS \"${CMAKE_CURRENT_BINARY_DIR}/cpack_pre_build_script_${PROJECT_NAME}.cmake\")
endif()
"
    )
    #
    # Generate a script for every configuration. This will
    # - do a local install
    # - use this local install to generate correct .pc files
    # - copy these .pc files in the CPack staging area
    #
    # In the pre-build script we want to remember the CMAKE_INSTALL_PREFIX of the local staging area...
    #
    set(_cpack_install_script ${CMAKE_CURRENT_BINARY_DIR}/cpack_install_script.cmake)
    set(_cpack_local_install_prefix_txt ${CMAKE_CURRENT_BINARY_DIR}/cpack_local_install_prefix.txt)
    file(WRITE  ${_cpack_install_script} "message(STATUS \"Remembering local install prefix: \${CMAKE_INSTALL_PREFIX}\")\n")
    file(APPEND ${_cpack_install_script} "file(WRITE \"${_cpack_local_install_prefix_txt}\" \${CMAKE_INSTALL_PREFIX})\n")
    list(APPEND CPACK_INSTALL_SCRIPTS ${_cpack_install_script})
    #
    # We intentionaly use PROJECT_BINARY_DIR and not CMAKE_CURRENT_BINARY_DIR
    #
    set(_cmake_helpers_install_path ${PROJECT_BINARY_DIR}/cmake_helpers_install/${PROJECT_NAME})
    cmake_helpers_call(get_property _cmake_helpers_package_generator_is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
    if(_cmake_helpers_package_generator_is_multi_config)
      set(_cmake_helpers_package_configs ${CMAKE_CONFIGURATION_TYPES})
    elseif(NOT("x${CMAKE_BUILD_TYPE}" STREQUAL "x"))
      set(_cmake_helpers_package_configs ${CMAKE_BUILD_TYPE})
    else()
      set(_cmake_helpers_package_configs)
    endif()
    if(_cmake_helpers_package_configs)
      foreach(_cmake_helpers_package_config IN LISTS _cmake_helpers_package_configs)
        set(_cmake_helpers_package_cpack_pre_build_script ${CMAKE_CURRENT_BINARY_DIR}/cpack_pre_build_script_${PROJECT_NAME}_${_cmake_helpers_package_config}.cmake)
	file(WRITE ${_cmake_helpers_package_cpack_pre_build_script}
	  CONTENT "
#
# Unset environment variable CMAKE_HELPERS_CPACK_IS_RUNNING so that install hooks are running
#
unset(ENV{CMAKE_HELPERS_CPACK_IS_RUNNING})
#
# Do a local install
#
set(_cmake_helpers_install_path \"${_cmake_helpers_install_path}\")
message(STATUS \"******************************************************************************\")
message(STATUS \"Doing a local install of ${PROJECT_NAME} in \${_cmake_helpers_install_path}\")
message(STATUS \"******************************************************************************\")
execute_process(
  COMMAND \"${CMAKE_COMMAND}\" --install \"${CMAKE_CURRENT_BINARY_DIR}\" --config ${_cmake_helpers_package_config} --prefix \"\${_cmake_helpers_install_path}\"
  ${_cmake_helpers_package_command_echo_stdout}
  COMMAND_ERROR_IS_FATAL ANY
)

file(READ \"${_cpack_local_install_prefix_txt}\" _cpack_local_install_prefix_txt)
set(_cmake_helpers_package_configcomponent_path \"\${_cpack_local_install_prefix_txt}/${PROJECT_NAME}ConfigComponent\")
cmake_path(CONVERT \"\${_cmake_helpers_package_configcomponent_path}\" TO_CMAKE_PATH_LIST _cmake_helpers_package_configcomponent_path NORMALIZE)
set(_cmake_helpers_package_pkgconfigdir_path \"\${_cmake_helpers_package_configcomponent_path}/${CMAKE_HELPERS_INSTALL_PKGCONFIGDIR}\")
cmake_path(CONVERT \"\${_cmake_helpers_package_pkgconfigdir_path}\" TO_CMAKE_PATH_LIST _cmake_helpers_package_pkgconfigdir_path NORMALIZE)
message(STATUS \"******************************************************************************\")
message(STATUS \"Copying\")
message(STATUS \"\${_cmake_helpers_install_path}/*${PROJECT_NAME}*.pc\")
message(STATUS \"to pkgconfig local install\")
message(STATUS \"\${_cmake_helpers_package_pkgconfigdir_path}\")
message(STATUS \"******************************************************************************\")
file(GLOB_RECURSE _pcs LIST_DIRECTORIES false \${_cmake_helpers_install_path}/*${PROJECT_NAME}*.pc)
foreach(_pc IN LISTS _pcs)
  message(STATUS \"\${_pc}\")
  get_filename_component(_filename \${_pc} NAME)
  set(_destination \"\${_cmake_helpers_package_pkgconfigdir_path}/\${_filename}\")
  cmake_path(CONVERT \"\${_destination}\" TO_CMAKE_PATH_LIST _destination NORMALIZE)
  file(REMOVE \${_destination})
  file(COPY \${_pc} DESTINATION \${_cmake_helpers_package_pkgconfigdir_path})
endforeach()
"
        )
        if(CMAKE_HELPERS_DEBUG)
          message(STATUS "[${_cmake_helpers_logprefix}] Generated ${_cmake_helpers_package_cpack_pre_build_script}")
          file(READ ${_cmake_helpers_package_cpack_pre_build_script} _cmake_helpers_package_cpack_pre_build_script_content)
          message(STATUS "[${_cmake_helpers_logprefix}] Content:\n${_cmake_helpers_package_cpack_pre_build_script_content}")
        endif()
      endforeach()
    else()
      set(_cmake_helpers_package_cpack_pre_build_script ${CMAKE_CURRENT_BINARY_DIR}/cpack_pre_build_script_${PROJECT_NAME}.cmake)
      file(WRITE ${_cmake_helpers_package_cpack_pre_build_script}
	"
#
# Unset environment variable CMAKE_HELPERS_CPACK_IS_RUNNING so that install hooks are running
#
unset(ENV{CMAKE_HELPERS_CPACK_IS_RUNNING})
#
# Do a local install
#
set(_cmake_helpers_install_path \"${_cmake_helpers_install_path}\")
message(STATUS \"******************************************************************************\")
message(STATUS \"Doing a local install of ${PROJECT_NAME} in \${_cmake_helpers_install_path}\")
message(STATUS \"******************************************************************************\")
execute_process(
  COMMAND \"${CMAKE_COMMAND}\" -E rm -rf \${_cmake_helpers_install_path}
  ${_cmake_helpers_package_command_echo_stdout}
  COMMAND_ERROR_IS_FATAL ANY
)
execute_process(
  COMMAND \"${CMAKE_COMMAND}\" --install \"${CMAKE_CURRENT_BINARY_DIR}\" --prefix \"\${_cmake_helpers_install_path}\"
  ${_cmake_helpers_package_command_echo_stdout}
  COMMAND_ERROR_IS_FATAL ANY
)
file(READ \"${_cpack_local_install_prefix_txt}\" _cpack_local_install_prefix_txt)
set(_cmake_helpers_package_configcomponent_path \"\${_cpack_local_install_prefix_txt}/${PROJECT_NAME}ConfigComponent\")
cmake_path(CONVERT \"\${_cmake_helpers_package_configcomponent_path}\" TO_CMAKE_PATH_LIST _cmake_helpers_package_configcomponent_path NORMALIZE)
set(_cmake_helpers_package_pkgconfigdir_path \"\${_cmake_helpers_package_configcomponent_path}/${CMAKE_HELPERS_INSTALL_PKGCONFIGDIR}\")
cmake_path(CONVERT \"\${_cmake_helpers_package_pkgconfigdir_path}\" TO_CMAKE_PATH_LIST _cmake_helpers_package_pkgconfigdir_path NORMALIZE)
message(STATUS \"******************************************************************************\")
message(STATUS \"Copying\")
message(STATUS \"\${_cmake_helpers_install_path}/*${PROJECT_NAME}*.pc\")
message(STATUS \"to pkgconfig local install\")
message(STATUS \"\${_cmake_helpers_package_pkgconfigdir_path}\")
message(STATUS \"******************************************************************************\")
file(GLOB_RECURSE _pcs LIST_DIRECTORIES false \${_cmake_helpers_install_path}/*${PROJECT_NAME}*.pc)
foreach(_pc IN LISTS _pcs)
  message(STATUS \"\${_pc}\")
  get_filename_component(_filename \${_pc} NAME)
  set(_destination \"\${_cmake_helpers_package_pkgconfigdir_path}/\${_filename}\")
  cmake_path(CONVERT \"\${_destination}\" TO_CMAKE_PATH_LIST _destination NORMALIZE)
  file(REMOVE \${_destination})
  file(COPY \${_pc} DESTINATION \${_cmake_helpers_package_pkgconfigdir_path})
endforeach()
"
      )
      if(CMAKE_HELPERS_DEBUG)
        message(STATUS "[${_cmake_helpers_logprefix}] Generated ${_cmake_helpers_package_cpack_pre_build_script}")
        file(READ ${_cmake_helpers_package_cpack_pre_build_script} _cmake_helpers_package_cpack_pre_build_script_content)
        message(STATUS "[${_cmake_helpers_logprefix}] Content:\n${_cmake_helpers_package_cpack_pre_build_script_content}")
      endif()
    endif()
  endif()
  SET (CPACK_PROJECT_CONFIG_FILE ${_cmake_helpers_package_cpack_project_config_file})
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] Generated ${_cmake_helpers_package_cpack_project_config_file}")
    file(READ ${_cmake_helpers_package_cpack_project_config_file} _cmake_helpers_package_cpack_project_config_file_content)
    message(STATUS "[${_cmake_helpers_logprefix}] Content:\n${_cmake_helpers_package_cpack_project_config_file_content}")
  endif()
  #
  # Set common CPack variables
  #
  cmake_helpers_call(set CPACK_PACKAGE_NAME                ${_cmake_helpers_package_name})
  cmake_helpers_call(set CPACK_PACKAGE_VENDOR              ${_cmake_helpers_package_vendor})
  cmake_helpers_call(set CPACK_PACKAGE_INSTALL_DIRECTORY   ${_cmake_helpers_package_install_directory})
  cmake_helpers_call(set CPACK_PACKAGE_DESCRIPTION_SUMMARY ${_cmake_helpers_package_description_summary})
  cmake_helpers_call(set CPACK_PACKAGE_VERSION             ${PROJECT_VERSION})
  if(EXISTS ${_cmake_helpers_package_license})
    configure_file(${_cmake_helpers_package_license} ${CMAKE_CURRENT_BINARY_DIR}/LICENSE.txt)
    cmake_helpers_call(set CPACK_RESOURCE_FILE_LICENSE     ${CMAKE_CURRENT_BINARY_DIR}/LICENSE.txt)
  endif()
  #
  # Get all components in one package
  #
  cmake_helpers_call(set CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)
  #
  # And explicit show them
  #
  cmake_helpers_call(set CPACK_MONOLITHIC_INSTALL FALSE)
  #
  # Always enable archive
  #
  cmake_helpers_call(set CPACK_ARCHIVE_COMPONENT_INSTALL ON)
  #
  # Components
  #
  cmake_helpers_call(set CPACK_COMPONENTS_ALL)
  foreach(_part
      runtime
      library
      archive
      header
      config
      man
      html
    )
    _cmake_helpers_package_toupper_firstletter("${_part}" _part_toupper_firstletter)
    set(_component "${_part_toupper_firstletter}Component")
    if(cmake_helpers_property_${PROJECT_NAME}_Have${_component})
      list(APPEND CPACK_COMPONENTS_ALL ${PROJECT_NAME}${_component})
    endif()
  endforeach()
  #
  # Specific to NSIS generator (if any)
  #
  if(WIN32)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
      cmake_helpers_call(set CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
      cmake_helpers_call(set CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION} (Win64)")
      cmake_helpers_call(set CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-win64")
    else()
      cmake_helpers_call(set CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
      cmake_helpers_call(set CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION} (Win32)")
      cmake_helpers_call(set CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-win32")
    endif()
  endif()
  #
  # Include CPack - from now on we will have access to CPACK own macros
  #
  include(CPack)
  #
  # Add Groups
  #
  if(cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent OR
     cmake_helpers_property_${PROJECT_NAME}_HaveLibraryComponent OR
     cmake_helpers_property_${PROJECT_NAME}_HaveArchiveComponent OR
     cmake_helpers_property_${PROJECT_NAME}_HaveHeaderComponent OR
     cmake_helpers_property_${PROJECT_NAME}_HaveConfigComponent)
    set(_cmake_helpers_package_can_developmentgroup TRUE)
  else()
    set(_cmake_helpers_package_can_developmentgroup FALSE)
  endif()
  if(cmake_helpers_property_${PROJECT_NAME}_HaveManComponent OR
     cmake_helpers_property_${PROJECT_NAME}_HaveHtmlComponent)
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
  # DevelopmentGroup
  #
  foreach(_part
      runtime
      library
      archive
      header
      config
    )
    _cmake_helpers_package_toupper_firstletter("${_part}" _part_toupper_firstletter)
    set(_component "${_part_toupper_firstletter}Component")
    if(cmake_helpers_property_${PROJECT_NAME}_Have${_component})
      cmake_helpers_call(cpack_add_component ${PROJECT_NAME}${_component}
	DISPLAY_NAME ${_cmake_helpers_package_${_part}_display_name}
	DESCRIPTION ${_cmake_helpers_package_${_part}_description}
	GROUP DevelopmentGroup
      )
    endif()
  endforeach()
  #
  # DocumentationGroup
  #
  foreach(_part
      man
      html
    )
    _cmake_helpers_package_toupper_firstletter("${_part}" _part_toupper_firstletter)
    set(_component "${_part_toupper_firstletter}Component")
    if(cmake_helpers_property_${PROJECT_NAME}_Have${_component})
      cmake_helpers_call(cpack_add_component ${PROJECT_NAME}${_component}
	DISPLAY_NAME ${_cmake_helpers_package_${_part}_display_name}
	DESCRIPTION ${_cmake_helpers_package_${_part}_description}
	GROUP DocumentationGroup
      )
    endif()
  endforeach()
  #
  # RuntimeGroup
  #
  if(cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent)
    set(_cmake_helpers_package_exe_component_depends DEPENDS RuntimeComponent)
  else()
    set(_cmake_helpers_package_exe_component_depends)
  endif()
  foreach(_part
      exe
    )
    _cmake_helpers_package_toupper_firstletter("${_part}" _part_toupper_firstletter)
    set(_component "${_part_toupper_firstletter}Component")
    if(cmake_helpers_property_${PROJECT_NAME}_Have${_component})
      cmake_helpers_call(cpack_add_component ${PROJECT_NAME}${_component}
	DISPLAY_NAME ${_cmake_helpers_package_${_part}_display_name}
	DESCRIPTION ${_cmake_helpers_package_${_part}_description}
	GROUP RuntimeGroup
	${_cmake_helpers_package_exe_component_depends}
      )
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

function(_cmake_helpers_package_toupper_firstletter input outvar)
  string(LENGTH "${input}" _length)
  if(_length GREATER 0)
    string(SUBSTRING "${input}" 0 1 _first)
    if(_length GREATER 1)
      string(SUBSTRING "${input}" 1 -1 _rest)
    else()
      set(_rest "")
    endif()
    string(TOUPPER "${_first}" _first_toupper)
    set(${outvar} "${_first_toupper}${_rest}" PARENT_SCOPE)
  else()
    set(${outvar} "" PARENT_SCOPE)
  endif()
endfunction()
