function(cmake_helpers_library name)
  if(NOT name)
    message(FATAL_ERROR "name argument is missing")
  endif()
  #
  # We use GNU standard for installation
  #
  include(GNUInstallDirs)
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  #
  set(_options)
  set(_oneValueArgs
    NAMESPACE
    MODULE
    STATIC_LIBRARY_SUFFIX
    WITH_POSITION_INDEPENDENT_CODE
    WITH_VISIBILITY_PRESET_HIDDEN
    WITH_VISIBILITY_INLINES_HIDDEN
    WITH_MSVC_MINIMAL_HEADERS
    WITH_MSVC_SILENT_CRT_WARNINGS
    WITH_GNU_SOURCE_IF_AVAILABLE
    WITH__NETBSD_SOURCE_IF_AVAILABLE
    WITH__REENTRANT
    WITH__THREAD_SAFE
    VERSION
    VERSION_MAJOR
    VERSION_MINOR
    VERSION_PATCH
    EXPORT_CMAKE_NAME
    PKGCONFIG
    EXPORT_HEADER
    EXPORT_HEADER_BASE_NAME
    EXPORT_HEADER_MACRO_NAME
    EXPORT_HEADER_FILE_NAME
    EXPORT_HEADER_STATIC_DEFINE
    NTRACE
    PACKAGE_VENDOR
    PACKAGE_DESCRIPTION_SUMMARY
    PACKAGE_LICENSE
  )
  set(_multiValueArgs
    CONFIG_ARGS
    SOURCES
    SOURCES_AUTO
    SOURCES_PREFIX
    SOURCES_BASE_DIRS
    SOURCES_GLOBS
    SOURCES_ACCEPT_RELPATH_REGEXES
    SOURCES_REJECT_RELPATH_REGEXES
    HEADERS
    HEADERS_AUTO
    HEADERS_PREFIX
    HEADERS_BASE_DIRS
    HEADERS_GLOBS
    HEADERS_ACCEPT_RELPATH_REGEXES
    HEADERS_REJECT_RELPATH_REGEXES
    PRIVATE_HEADERS_RELPATH_REGEXES
  )
  #
  # Single-value arguments default values
  #
  set(_cmake_helpers_namespace                            ${PROJECT_NAME})
  set(_cmake_helpers_module                               FALSE)
  set(_cmake_helpers_static_library_suffix                _static)
  set(_cmake_helpers_with_position_independent_code       TRUE)
  set(_cmake_helpers_with_visibility_preset_hidden        TRUE)
  set(_cmake_helpers_with_visibility_inlines_hidden       TRUE)
  set(_cmake_helpers_with_msvc_minimal_headers            FALSE)
  set(_cmake_helpers_with_msvc_silent_crt_warnings        TRUE)
  set(_cmake_helpers_with_gnu_source_if_available         TRUE)
  set(_cmake_helpers_with__netbsd_source_if_available     TRUE)
  set(_cmake_helpers_with__reentrant                      TRUE)
  set(_cmake_helpers_with__thread_safe                    TRUE)
  set(_cmake_helpers_version                              ${PROJECT_VERSION})
  set(_cmake_helpers_version_compatibility                SameMajorVersion)
  set(_cmake_helpers_version_major                        ${PROJECT_VERSION_MAJOR})
  set(_cmake_helpers_version_minor                        ${PROJECT_VERSION_MINOR})
  set(_cmake_helpers_version_patch                        ${PROJECT_VERSION_PATCH})
  set(_cmake_helpers_export_cmake_name                    ${PROJECT_NAME}-targets)
  set(_cmake_helpers_pkgconfig                            TRUE)
  set(_cmake_helpers_export_header                        TRUE)
  set(_cmake_helpers_export_header_base_name              ${PROJECT_NAME})
  set(_cmake_helpers_export_header_macro_name             ${PROJECT_NAME}_EXPORT)
  set(_cmake_helpers_export_header_file_name              include/${PROJECT_NAME}/export.h)
  set(_cmake_helpers_export_header_static_define          ${PROJECT_NAME}_STATIC)
  set(_cmake_helpers_ntrace                               TRUE)
  set(_cmake_helpers_package_vendor                       " ")
  set(_cmake_helpers_package_description_summary          "${_cmake_helpers_namespace}")
  set(_cmake_helpers_package_license                      ${PROJECT_SOURCE_DIR}/LICENSE)
  #
  # Multiple-value arguments default values
  #
  set(_cmake_helpers_config_args)
  set(_cmake_helpers_sources)
  set(_cmake_helpers_sources_auto                         TRUE)
  set(_cmake_helpers_sources_prefix                       src)
  get_filename_component(_srcdir "${CMAKE_CURRENT_SOURCE_DIR}" REALPATH)
  get_filename_component(_bindir "${CMAKE_CURRENT_BINARY_DIR}" REALPATH)
  if(_srcdir STREQUAL _bindir)
    set(_cmake_helpers_sources_base_dirs                     ${CMAKE_CURRENT_SOURCE_DIR}/src)
    set(_cmake_helpers_headers_base_dirs                     ${CMAKE_CURRENT_SOURCE_DIR}/include)
  else()
    set(_cmake_helpers_sources_base_dirs                     ${CMAKE_CURRENT_SOURCE_DIR}/src ${CMAKE_CURRENT_BINARY_DIR}/src)
    set(_cmake_helpers_headers_base_dirs                     ${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_CURRENT_BINARY_DIR}/include)
  endif()
  set(_cmake_helpers_sources_globs                        *.c *.cpp *.cxx)
  set(_cmake_helpers_sources_accept_relpath_regexes)
  set(_cmake_helpers_sources_reject_relpath_regexes)
  set(_cmake_helpers_headers)
  set(_cmake_helpers_headers_auto                         TRUE)
  set(_cmake_helpers_headers_prefix                       include)
  set(_cmake_helpers_headers_globs                        *.h *.hh *.hpp *.hxx)
  set(_cmake_helpers_headers_accept_relpath_regexes)
  set(_cmake_helpers_headers_reject_relpath_regexes)
  set(_cmake_helpers_private_headers_relpath_regexes      "/internal" "/_" "^_")
  #
  # Parse Arguments
  #
  cmake_parse_arguments(CMAKE_HELPERS "" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
  #
  # Set internal variables
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${PROJECT_NAME}/library] --------")
    message(STATUS "[${PROJECT_NAME}/library] Options:")
    message(STATUS "[${PROJECT_NAME}/library] --------")
  endif()
  foreach(_option ${_oneValueArgs} ${_multiValueArgs})
    set(_name CMAKE_HELPERS_${_option})
    set(_var _${_name})
    string(TOLOWER "${_var}" _var)
    if(DEFINED CMAKE_HELPERS_${_option})
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${PROJECT_NAME}/library] ... ... Argument CMAKE_HELPERS_${_option}=${CMAKE_HELPERS_${_option}}")
      endif()
      set(${_var} ${CMAKE_HELPERS_${_option}})
    endif()
    cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY ${_var} ${${_var}})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] ... ${_var}=${${_var}}")
    endif()
  endforeach()
  #
  # Validation of arguments - only the oneValueArgs must have a value
  #
  foreach(_oneValueArg ${_oneValueArgs})
    set(_name CMAKE_HELPERS_${_oneValueArg})
    set(_var _${_name})
    string(TOLOWER "${_var}" _var)
    if(NOT (DEFINED ${_var}))
      message(FATAL_ERROR "${_var} is missing")
    endif()
  endforeach()
  #
  # Config
  #
  if(_cmake_helpers_config_args)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] -------------------")
      message(STATUS "[${PROJECT_NAME}/library] Doing configuration")
      message(STATUS "[${PROJECT_NAME}/library] -------------------")
    endif()
    cmake_helpers_call(configure_file ${_cmake_helpers_config_args})
  endif()
  #
  # Sources discovery
  #
  if((NOT _cmake_helpers_sources) AND _cmake_helpers_sources_auto)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] -------------------")
      message(STATUS "[${PROJECT_NAME}/library] Discovering sources")
      message(STATUS "[${PROJECT_NAME}/library] -------------------")
    endif()
    _cmake_helpers_files_find(sources "${_cmake_helpers_sources_base_dirs}" "${_cmake_helpers_sources_prefix}" "${_cmake_helpers_sources_accept_relpath_regexes}" "${_cmake_helpers_sources_reject_relpath_regexes}" _cmake_helpers_sources)
    cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_sources ${_cmake_helpers_sources})
  endif()
  #
  # Decide targets
  #
  if(NOT _cmake_helpers_sources)
    #
    # It can only be INTERFACE
    #
    set(_cmake_helpers_library_types INTERFACE)
  else()
    if(_cmake_helpers_module)
      #
      # MODULE
      #
      set(_cmake_helpers_library_types MODULE)
    else()
      #
      # STATIC and SHARED
      # We INTENTIONALY put STATIC before SHARED because pkgconfig will need STATIC properties
      #
      set(_cmake_helpers_library_types STATIC SHARED)
    endif()
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] Enable library component")
    endif()
    cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_librarycomponent TRUE)
    set(_have_librarycomponent TRUE)
  endif()
  cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_types ${_cmake_helpers_library_types})
  #
  # Create targets
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${PROJECT_NAME}/library] ----------------")
    message(STATUS "[${PROJECT_NAME}/library] Creating targets")
    message(STATUS "[${PROJECT_NAME}/library] ----------------")
  endif()
  set(_cmake_helpers_targets)
  foreach(_library_type ${_cmake_helpers_library_types})
    if(_library_type STREQUAL "STATIC")
      set(_target ${name}${_cmake_helpers_static_library_suffix})
    else()
      set(_target ${name})
    endif()
    cmake_helpers_call(add_library ${_target} ${_library_type} ${_cmake_helpers_sources})
    list(APPEND _cmake_helpers_targets ${_target})
  endforeach()
  cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_targets ${_cmake_helpers_targets})
  #
  # Export
  #
  if(_cmake_helpers_export_header)
    include(GenerateExportHeader)
    #
    # Regardless of user args, we always append the args we know because we need them
    #
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] ------------------------")
      message(STATUS "[${PROJECT_NAME}/library] Generating export header")
      message(STATUS "[${PROJECT_NAME}/library] ------------------------")
    endif()
    cmake_helpers_call(generate_export_header ${name}
      BASE_NAME         ${_cmake_helpers_export_header_base_name}
      EXPORT_MACRO_NAME ${_cmake_helpers_export_header_macro_name}
      EXPORT_FILE_NAME  ${_cmake_helpers_export_header_file_name}
      STATIC_DEFINE     ${_cmake_helpers_export_header_static_define})
  endif()
  #
  # Headers discovery
  #
  if((NOT _cmake_helpers_headers) AND _cmake_helpers_headers_auto)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] -------------------")
      message(STATUS "[${PROJECT_NAME}/library] Discovering headers")
      message(STATUS "[${PROJECT_NAME}/library] -------------------")
    endif()
    _cmake_helpers_files_find(headers "${_cmake_helpers_headers_base_dirs}" "${_cmake_helpers_headers_prefix}" "${_cmake_helpers_headers_accept_relpath_regexes}" "${_cmake_helpers_headers_reject_relpath_regexes}" _cmake_helpers_headers)
    cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_headers ${_cmake_cmake_helpers_headers})
  endif()
  #
  # Get private headers out of header files
  #
  if((NOT _cmake_helpers_public_headers) OR (NOT _cmake_helpers_private_headers))
    if(NOT _cmake_helpers_public_headers)
      set(_cmake_helpers_public_headers_do TRUE)
    else()
      set(_cmake_helpers_public_headers_do FALSE)
    endif()
    if(NOT _cmake_helpers_private_headers)
      set(_cmake_helpers_private_headers_do TRUE)
    else()
      set(_cmake_helpers_private_headers_do FALSE)
    endif()

    foreach(_header ${_cmake_helpers_headers})
      cmake_helpers_match_regexes("${_header}" "${_cmake_helpers_private_headers_relpath_regexes}" FALSE _matched)
      if(_matched)
	if(_cmake_helpers_private_headers_do)
	  list(APPEND _cmake_helpers_private_headers ${_header})
	endif()
      else()
	if(_cmake_helpers_public_headers_do)
	  list(APPEND _cmake_helpers_public_headers ${_header})
	endif()
      endif()
    endforeach()
  endif()
  if(CMAKE_HELPERS_DEBUG)
    foreach(_type public private)
      message(STATUS "[${PROJECT_NAME}/library] ${_type} headers:")
      foreach(_file ${_cmake_helpers_${_type}_headers})
	message(STATUS "[${PROJECT_NAME}/library] ... ${_file}")
      endforeach()
    endforeach()
  endif()
  #
  # Targets specifics
  #
  foreach(_target ${_cmake_helpers_targets})
    get_target_property(_type ${_target} TYPE)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] ----------------------------")
      message(STATUS "[${PROJECT_NAME}/library] Doing ${_type} setting")
      message(STATUS "[${PROJECT_NAME}/library] ----------------------------")
    endif()
    #
    # Assign headers to file sets
    # (INTERFACE case needs a file set to work properly)
    #
    if(_type STREQUAL "INTERFACE_LIBRARY")
      if(_cmake_helpers_public_headers)
	cmake_helpers_call(target_sources ${_target} INTERFACE FILE_SET public_headers BASE_DIRS ${_cmake_helpers_headers_base_dirs} TYPE HEADERS FILES ${_cmake_helpers_public_headers})
      endif()
      if(_cmake_helpers_private_headers)
	cmake_helpers_call(target_sources ${_target} INTERFACE FILE_SET private_headers BASE_DIRS ${_cmake_helpers_headers_base_dirs} TYPE HEADERS FILES ${_cmake_helpers_private_headers})
      endif()
    else()
      if(_cmake_helpers_public_headers)
	cmake_helpers_call(target_sources ${_target} PUBLIC FILE_SET public_headers BASE_DIRS ${_cmake_helpers_headers_base_dirs} TYPE HEADERS FILES ${_cmake_helpers_public_headers})
      endif()
      if(_cmake_helpers_private_headers)
	cmake_helpers_call(target_sources ${_target} PRIVATE FILE_SET private_headers BASE_DIRS ${_cmake_helpers_headers_base_dirs} TYPE HEADERS FILES ${_cmake_helpers_private_headers})
      endif()
    endif()
    #
    # Compile definitions
    #
    if(_type STREQUAL "SHARED_LIBRARY")
      cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -D${PROJECT_NAME}_EXPORTS)
    elseif(_type STREQUAL "STATIC_LIBRARY")
      cmake_helpers_call(target_compile_definitions ${_target} PUBLIC -D${_cmake_helpers_export_header_static_define})
    elseif(_type STREQUAL "MODULE_LIBRARY")
    elseif(_type STREQUAL "INTERFACE_LIBRARY")
    endif()
    string(TOUPPER "${name}" _name_toupper)
    if(_cmake_helpers_ntrace)
      cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -D${_name_toupper}_NTRACE -DNTRACE)
    endif()
    cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -D${_name_toupper}_VERSION_MAJOR=${_cmake_helpers_version_major})
    cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -D${_name_toupper}_VERSION_MINOR=${_cmake_helpers_version_minor})
    cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -D${_name_toupper}_VERSION_PATCH=${_cmake_helpers_version_patch})
    cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -D${_name_toupper}_VERSION="${_cmake_helpers_version}")
    if(WIN32 AND _cmake_helpers_with_msvc_minimal_headers)
      cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -DWIN32_LEAN_AND_MEAN)
    endif()
    if(WIN32 AND _cmake_helpers_with_msvc_silent_crt_warnings)
      cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -DCRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE)
    endif()
    if(_cmake_helpers_with_gnu_source_if_available AND _GNU_SOURCE)
      cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -D_GNU_SOURCE)
    endif()
    if(_cmake_helpers_with__netbsd_source_if_available AND (CMAKE_SYSTEM_NAME MATCHES "NetBSD"))
      #
      # On NetBSD, enable this platform features. This makes sure we always have "long long" btw.
      #
      cmake_helpers_call(target_compile_definitions ${_target} PUBLIC -D_NETBSD_SOURCE=1) # Voluntarily public for global "long long" avaibility
    endif()
    if(_cmake_helpers_with__reentrant)
      cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -D_REENTRANT)
    endif()
    if(_cmake_helpers_with__thread_safe)
      cmake_helpers_call(target_compile_definitions ${_target} PRIVATE -D_THREAD_SAFE)
    endif()
    #
    # Target properties
    #
    if(_type STREQUAL "SHARED_LIBRARY")
      cmake_helpers_call(set_target_properties ${_target} PROPERTIES VERSION ${_cmake_helpers_version} SOVERSION ${_cmake_helpers_version_major})
    endif()
    if(HAVE_C99MODIFIERS)
      cmake_helpers_call(set_target_properties ${_target} PROPERTIES C_STANDARD 99)
    endif()
    if(_cmake_helpers_with_position_independent_code)
      cmake_helpers_call(set_target_properties ${_target} PROPERTIES POSITION_INDEPENDENT_CODE TRUE)
    endif()
    if(_cmake_helpers_with_visibility_preset_hidden)
      cmake_helpers_call(set_target_properties ${_target} PROPERTIES C_VISIBILITY_PRESET hidden CXX_VISIBILITY_PRESET hidden)
    endif()
    if(_cmake_helpers_with_visibility_inlines_hidden)
      cmake_helpers_call(set_target_properties ${_target} PROPERTIES VISIBILITY_INLINES_HIDDEN TRUE)
    endif()
    #
    # Compiler specifics
    #
    if(MSVC)
      # For static library we want to debug information within the lib
      # For shared library we want to install the pdb file if it exists
      if(_type STREQUAL "SHARED_LIBRARY")
	cmake_helpers_call(install FILES $<TARGET_PDB_FILE:${_target}> DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT LibraryComponent OPTIONAL)
      elseif(_type STREQUAL "STATIC_LIBRARY")
	cmake_helpers_call(target_compile_options ${_target} PRIVATE /Z7)
      endif()
    endif()
  endforeach()
  #
  # Include directories
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${PROJECT_NAME}/library] ---------------------------")
    message(STATUS "[${PROJECT_NAME}/library] Setting include directories")
    message(STATUS "[${PROJECT_NAME}/library] ---------------------------")
  endif()
  if("INTERFACE" IN_LIST _cmake_helpers_library_types)
    foreach(_include_dir ${_cmake_helpers_headers_base_dirs})
      cmake_helpers_call(target_include_directories ${name} INTERFACE $<BUILD_LOCAL_INTERFACE:${_include_dir}>)
      cmake_helpers_call(target_include_directories ${name} INTERFACE $<BUILD_INTERFACE:${_include_dir}>)
    endforeach()
    cmake_helpers_call(target_include_directories ${name} INTERFACE $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
  else()
    foreach(_target ${_cmake_helpers_targets})
      foreach(_include_dir ${_cmake_helpers_headers_base_dirs})
	cmake_helpers_call(target_include_directories ${_target} PUBLIC $<BUILD_LOCAL_INTERFACE:${_include_dir}>)
	cmake_helpers_call(target_include_directories ${_target} PUBLIC $<BUILD_INTERFACE:${_include_dir}>)
      endforeach()
      cmake_helpers_call(target_include_directories ${_target} PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
    endforeach()
  endif()
  #
  # Install rules
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${PROJECT_NAME}/library] ---------------------")
    message(STATUS "[${PROJECT_NAME}/library] Setting install rules")
    message(STATUS "[${PROJECT_NAME}/library] ---------------------")
  endif()
  if(_cmake_helpers_public_headers)
    set(_file_set_args FILE_SET public_headers COMPONENT HeaderComponent)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] Enabling header component")
    endif()
    cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_headercomponent TRUE)
    set(_have_headercomponent TRUE)
  endif()

  cmake_helpers_call(install
    TARGETS       ${_cmake_helpers_targets}
    EXPORT        ${_cmake_helpers_export_cmake_name}
    RUNTIME       DESTINATION ${CMAKE_INSTALL_BINDIR}     COMPONENT LibraryComponent
    LIBRARY       DESTINATION ${CMAKE_INSTALL_LIBDIR}     COMPONENT LibraryComponent
    ARCHIVE       DESTINATION ${CMAKE_INSTALL_LIBDIR}     COMPONENT LibraryComponent
    INCLUDES      DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} COMPONENT HeaderComponent
    ${_file_set_args}
  )

    set(_export_cmake_config_in ${CMAKE_CURRENT_BINARY_DIR}/lib/cmake/${_cmake_helpers_namespace}Config.cmake.in)
    set(_export_cmake_config_out ${CMAKE_CURRENT_BINARY_DIR}/lib/cmake/${_cmake_helpers_namespace}Config.cmake)
    file(WRITE ${_export_cmake_config_in} "
@PACKAGE_INIT@

include(\"\${CMAKE_CURRENT_LIST_DIR}/${_cmake_helpers_export_cmake_name}.cmake\"\)
")
    cmake_helpers_call(install
      EXPORT ${_cmake_helpers_export_cmake_name}
      NAMESPACE ${_cmake_helpers_namespace}::
      DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${_cmake_helpers_project}
      COMPONENT LibraryComponent)
    include(CMakePackageConfigHelpers)
    cmake_helpers_call(configure_package_config_file ${_export_cmake_config_in} ${_export_cmake_config_out}
      INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
      NO_SET_AND_CHECK_MACRO
      NO_CHECK_REQUIRED_COMPONENTS_MACRO
    )
    file(REMOVE ${_export_cmake_config_in})

    set(_export_cmake_configversion_out ${CMAKE_CURRENT_BINARY_DIR}/lib/cmake/${_cmake_helpers_namespace}ConfigVersion.cmake)
    cmake_helpers_call(write_basic_package_version_file ${_export_cmake_configversion_out}
      VERSION ${_cmake_helpers_version}
      COMPATIBILITY ${_cmake_helpers_version_compatibility}
    )
    cmake_helpers_call(install
      FILES ${_export_cmake_config_out} ${_export_cmake_configversion_out}
      DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
      COMPONENT LibraryComponent
    )
  #
  # Pkgconfig
  #
  if(_cmake_helpers_pkgconfig)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] ------------------------")
      message(STATUS "[${PROJECT_NAME}/library] Creating pkgconfig hooks")
      message(STATUS "[${PROJECT_NAME}/library] ------------------------")
    endif()
    file(CONFIGURE
      OUTPUT "pc.${_cmake_helpers_namespace}/CMakeLists.txt"
      CONTENT [[
cmake_minimum_required(VERSION 3.16)
project(pc_@_cmake_helpers_namespace@ LANGUAGES C CXX)
include(GNUInstallDirs)

option(CMAKE_HELPERS_DEBUG "CMake Helpers debug" OFF)
if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[pc.@_cmake_helpers_namespace@/build] Starting")
endif()

if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[pc.@_cmake_helpers_namespace@/build] Initializing CMAKE_PREFIX_PATH with: $ENV{CMAKE_MODULE_ROOT_PATH_ENV}")
endif()
set(CMAKE_PREFIX_PATH "$ENV{CMAKE_MODULE_ROOT_PATH_ENV}")

if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[pc.@_cmake_helpers_namespace@/build] Requiring @_cmake_helpers_namespace@")
endif()
find_package(@_cmake_helpers_namespace@ REQUIRED)

#
# It is important to do static before shared, because shared will reuse static properties
#
set(_target_static)
foreach(_subtarget @_cmake_helpers_targets@)
  set(_target @_cmake_helpers_namespace@::${_subtarget})
  get_target_property(_type ${_target} TYPE)
  get_target_property(_interface_link_libraries ${_target} INTERFACE_LINK_LIBRARIES)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[pc.@_cmake_helpers_namespace@/build] ${_target} INTERFACE_LINK_LIBRARIES: ${_interface_link_libraries}")
  endif()
  set(_computed_requires)
  foreach(_interface_link_library ${_interface_link_libraries})
    if(TARGET ${_interface_link_library})
      string(REGEX REPLACE ".*::" "" _computed_require ${_interface_link_library})
      list(APPEND _computed_requires ${_computed_require})
    endif()
  endforeach()
  #
  # iface produce no output file
  # static produces ${_subtarget}@_cmake_helpers_static_library_suffix@
  # shared produces ${_subtarget}
  # module produces ${_subtarget}
  #
  set_target_properties(${_target} PROPERTIES PC_NAME ${_subtarget})
  if(${_type} STREQUAL "INTERFACE_LIBRARY")
    set_target_properties(${_target} PROPERTIES PC_DESCRIPTION "@_cmake_helpers_namespace@ headers")
  elseif(${_type} STREQUAL "SHARED_LIBRARY")
    set_target_properties(${_target} PROPERTIES PC_DESCRIPTION "@_cmake_helpers_namespace@ dynamic library")
  elseif(${_type} STREQUAL "MODULE_LIBRARY")
    set_target_properties(${_target} PROPERTIES PC_DESCRIPTION "@_cmake_helpers_namespace@ module library")
  elseif(${_type} STREQUAL "STATIC_LIBRARY")
    set_target_properties(${_target} PROPERTIES PC_DESCRIPTION "@_cmake_helpers_namespace@ static library")
    set(_target_static ${_target})
  else()
    message(FATAL_ERROR "Unsupported target type ${_type}")
  endif()
  if (_computed_requires)
    list(JOIN _computed_requires "," _pc_requires)
    set_target_properties(${_target} PROPERTIES PC_REQUIRES "${_pc_requires}")
  endif()
  if(_type STREQUAL "SHARED_LIBRARY")
    #
    # By definition the "static" target should already exist
    #
    if(NOT TARGET ${_target_static})
      message(FATAL_ERROR "No static target")
    endif()
    #
    # Requires.private
    #
    get_target_property(_pc_requires_private ${_target_static} PC_REQUIRES)
    if(_pc_requires_private)
      set_target_properties(${_target} PROPERTIES PC_REQUIRES_PRIVATE "${_pc_requires_private}")
    endif()
    #
    # Cflags.private
    #
    get_target_property(_pc_interface_compile_definitions_private ${_target_static} INTERFACE_COMPILE_DEFINITIONS)
    if(_pc_interface_compile_definitions_private)
      set_target_properties(${_target} PROPERTIES PC_INTERFACE_COMPILE_DEFINITIONS_PRIVATE "${_pc_interface_compile_definitions_private}")
    endif()
    #
    # Libs.private
    #
    get_target_property(_pc_libs_private ${_target_static} PC_LIBS)
    if(_pc_libs_private)
      set_target_properties(${_target} PROPERTIES PC_LIBS_PRIVATE "${_pc_libs_private}")
    endif()
  endif()
  set_target_properties(${_target} PROPERTIES PC_VERSION "@_cmake_helpers_version@")

  get_target_property(_location ${_target} LOCATION)
  if(_location)
    cmake_path(GET _location FILENAME _filename)
    if((_type STREQUAL "SHARED_LIBRARY") OR (_type STREQUAL "MODULE_LIBRARY"))
      get_filename_component(_filename_we ${_filename} NAME_WE)
      if(NOT ("x${CMAKE_SHARED_LIBRARY_PREFIX}" STREQUAL "x"))
        string(REGEX REPLACE "^${CMAKE_SHARED_LIBRARY_PREFIX}" "" _filename_we ${_filename_we})
      endif()
      set_target_properties(${_target} PROPERTIES PC_LIBS "-L\${libdir} -l${_filename_we}")
    elseif(_type STREQUAL "STATIC_LIBRARY")
      set_target_properties(${_target} PROPERTIES PC_LIBS "\${libdir}/${_filename}")
    endif()
  endif()
  LIST(APPEND _target_computed_dependencies ${_target_filename_we})
endforeach()

foreach(_subtarget @_cmake_helpers_targets@)
  set(_target @_cmake_helpers_namespace@::${_subtarget})
  set(_file ${_subtarget}.pc)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[pc.@_cmake_helpers_namespace@/build] Generating ${_file}")
  endif()
  file(GENERATE OUTPUT ${_file}
     CONTENT [=[prefix=${pcfiledir}/../..
exec_prefix=${prefix}
bindir=${exec_prefix}/@CMAKE_INSTALL_BINDIR@
includedir=${prefix}/@CMAKE_INSTALL_INCLUDEDIR@
docdir=${prefix}/@CMAKE_INSTALL_DOCDIR@
libdir=${exec_prefix}/@CMAKE_INSTALL_LIBDIR@
mandir=${prefix}/@CMAKE_INSTALL_MANDIR@
man1dir=${prefix}/@CMAKE_INSTALL_MANDIR@1
man2dir=${prefix}/@CMAKE_INSTALL_MANDIR@2

Name: $<TARGET_PROPERTY:PC_NAME>
Description: $<TARGET_PROPERTY:PC_DESCRIPTION>
Version: $<TARGET_PROPERTY:PC_VERSION>
Requires: $<IF:$<BOOL:$<TARGET_PROPERTY:PC_REQUIRES>>,$<TARGET_PROPERTY:PC_REQUIRES>,>
Requires.private: $<IF:$<BOOL:$<TARGET_PROPERTY:PC_REQUIRES_PRIVATE>>,$<TARGET_PROPERTY:PC_REQUIRES_PRIVATE>,>
Cflags: -I${includedir} $<IF:$<BOOL:$<TARGET_PROPERTY:INTERFACE_COMPILE_DEFINITIONS>>,-D$<JOIN:$<TARGET_PROPERTY:INTERFACE_COMPILE_DEFINITIONS>, -D>,>
Cflags.private: $<IF:$<BOOL:$<TARGET_PROPERTY:PC_INTERFACE_COMPILE_DEFINITIONS_PRIVATE>>,-I${includedir} -D$<JOIN:$<TARGET_PROPERTY:PC_INTERFACE_COMPILE_DEFINITIONS_PRIVATE>, -D>,>
Libs: $<IF:$<BOOL:$<TARGET_PROPERTY:PC_LIBS>>,$<TARGET_PROPERTY:PC_LIBS>,>
Libs.private: $<IF:$<BOOL:$<TARGET_PROPERTY:PC_LIBS_PRIVATE>>,$<TARGET_PROPERTY:PC_LIBS_PRIVATE>,>
]=] TARGET ${_target} NEWLINE_STYLE LF)

endforeach()
]] @ONLY NEWLINE_STYLE LF)

    file(CONFIGURE
      OUTPUT "pc.${_cmake_helpers_namespace}/post-install.cmake"
      CONTENT [[
set(proj "@CMAKE_CURRENT_BINARY_DIR@/pc.@_cmake_helpers_namespace@")
if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[pc.@_cmake_helpers_namespace@/post-install.cmake] Building in ${proj}/build")
endif()
execute_process(COMMAND "@CMAKE_COMMAND@" -G "@CMAKE_GENERATOR@" -DCMAKE_HELPERS_DEBUG=@CMAKE_HELPERS_DEBUG@ -S "${proj}" -B "${proj}/build")
]] @ONLY NEWLINE_STYLE LF)

    set(FIRE_POST_INSTALL_CMAKE_PATH ${CMAKE_CURRENT_BINARY_DIR}/fire_post_install.cmake)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] Generating ${FIRE_POST_INSTALL_CMAKE_PATH}")
    endif()
    file(WRITE  ${FIRE_POST_INSTALL_CMAKE_PATH} "if(CMAKE_HELPERS_DEBUG)\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] \\\$ENV{DESTDIR}: \\\"\$ENV{DESTDIR}\\\"\")\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "endif()\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "set(CMAKE_INSTALL_PREFIX \"\$ENV{CMAKE_INSTALL_PREFIX_ENV}\")\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "if(CMAKE_HELPERS_DEBUG)\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] CMAKE_INSTALL_PREFIX: \\\"\${CMAKE_INSTALL_PREFIX}\\\"\")\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "endif()\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "set(CMAKE_INSTALL_LIBDIR \"\$ENV{CMAKE_INSTALL_LIBDIR_ENV}\")\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "if(CMAKE_HELPERS_DEBUG)\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] CMAKE_INSTALL_LIBDIR: \\\"\${CMAKE_INSTALL_LIBDIR}\\\"\")\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "endif()\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "set(CMAKE_MODULE_ROOT_PATH \"\$ENV{CMAKE_MODULE_ROOT_PATH_ENV}\")\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "if(CMAKE_HELPERS_DEBUG)\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] CMAKE_MODULE_ROOT_PATH: \\\"\${CMAKE_MODULE_ROOT_PATH}\\\"\")\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] Including ${CMAKE_CURRENT_BINARY_DIR}/pc.${PROJECT_NAME}/post-install.cmake\")\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "endif()\n")
    file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "include(${CMAKE_CURRENT_BINARY_DIR}/pc.${PROJECT_NAME}/post-install.cmake)\n")
    #
    # We CANNOT use CMAKE_INSTALL_PREFIX variable contrary to what is posted almost everywhere on the net: CPack will
    # will have a CMAKE_INSTALL_PREFIX different, the real and only way to know exactly where we install things is to
    # set the current working directory to ${DESTDIR}${CMAKE_INSTALL_PREFIX}, and use WORKING_DIRECTORY as the full install prefix dir.
    # Now take case: DESTDIR does "work" on Windows is used as is, and CMake has a hook, that we replacate here
    #
    set(_hook [[
    set(_destination "${CMAKE_INSTALL_PREFIX}")
    if(NOT ("x$ENV{DESTDIR}" STREQUAL "x"))
      file(TO_CMAKE_PATH "$ENV{DESTDIR}" _destdir)
      set(_destination "${CMAKE_INSTALL_PREFIX}")
      string(LENGTH "${_destination}" _destination_length)
      if(_destination_length GREATER 1)
	string(SUBSTRING "${_destination}" 0 1 _ch1)
	string(SUBSTRING "${_destination}" 1 1 _ch2)
	set(_ch3 0)
	if(_destination_length GREATER 2)
	  string(SUBSTRING "${_destination}" 2 1 _ch3)
	endif()
	set(_skip 0)
	if(NOT (ch1 STREQUAL "/"))
	  set(_relative 0)
	  if(((("${_ch1}" STRGREATER_EQUAL  "a") AND ("${_ch1}" STRLESS_EQUAL  "z")) OR (("${_ch1}" STRGREATER_EQUAL  "A") AND ("${_ch1}" STRLESS_EQUAL  "Z"))) AND ("${_ch2}" STREQUAL ":"))
	    #
	    # Assume Windows
	    #
	    set(_skip 2)
	    if(NOT ("${_ch3}" STREQUAL "/"))
	      set(_relative 1)
	    endif()
	  else()
	    set(_relative 1)
	  endif()
	  if (_relative)
	    message(FATAL_ERROR "Called with relative DESTINATION. This does not make sense when using DESTDIR. Specify absolute path or remove DESTDIR environment variable.")
	  endif()
	else()
	  if("${_ch2}" STREQUAL "/")
	    #
	    # Looks like a network path
	    #
	    message(FATAL_ERROR "Called with network path DESTINATION. This does not make sense when using DESTDIR. Specify local absolute path or remove DESTDIR environment variable.\nCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}\n")
	  endif()
	endif()
      endif()
      string(SUBSTRING "${_destination}" ${_skip} -1 _destination)
      set(_destination "${_destdir}${_destination}")
    endif()
]])
    install(CODE ${_hook})
    install(CODE "
    set(CPACK_IS_RUNNING \$ENV{CPACK_IS_RUNNING})
    #
    # We do not want to run this when it is CPack
    #
    if (NOT CPACK_IS_RUNNING)
      # We need to re-evaluate GNUInstallDirs to get CMAKE_INSTALL_LIBDIR
      set(CMAKE_SYSTEM_NAME \"${CMAKE_SYSTEM_NAME}\")
      set(CMAKE_SIZEOF_VOID_P \"${CMAKE_SIZEOF_VOID_P}\")
      include(GNUInstallDirs)
      set(ENV{CMAKE_INSTALL_PREFIX_ENV} \"${CMAKE_INSTALL_PREFIX}\") # Variable may be empty
      set(ENV{CMAKE_INSTALL_LIBDIR_ENV} \"${CMAKE_INSTALL_LIBDIR}\") # Variable may be empty
      set(ENV{CMAKE_MODULE_ROOT_PATH_ENV} \"\${_destination}/${CMAKE_INSTALL_LIBDIR}/cmake\")
      execute_process(COMMAND \"${CMAKE_COMMAND}\" -G \"${CMAKE_GENERATOR}\" -DCMAKE_HELPERS_DEBUG=${CMAKE_HELPERS_DEBUG} -P \"${FIRE_POST_INSTALL_CMAKE_PATH}\" WORKING_DIRECTORY \"\${_destination}\")
    endif()
"
      COMPONENT LibraryComponent
    )
    #
    # Generate a file that will be overwriten by the post-install scripts
    #
    foreach(_target ${_cmake_helpers_targets})
      set(FIRE_POST_INSTALL_PKGCONFIG_PATH ${CMAKE_CURRENT_BINARY_DIR}/pc.${_cmake_helpers_namespace}/build/${_target}.pc)
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${PROJECT_NAME}/library] Generating dummy ${FIRE_POST_INSTALL_PKGCONFIG_PATH}")
      endif()
      file(WRITE ${FIRE_POST_INSTALL_PKGCONFIG_PATH} "# Content of this file is overwriten during install or package phases")
      cmake_helpers_call(install FILES ${FIRE_POST_INSTALL_PKGCONFIG_PATH} DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig COMPONENT LibraryComponent)
    endforeach()

    set(_cmake_helpers_cpack_pre_build_script ${CMAKE_CURRENT_BINARY_DIR}/cpack_pre_build_script_pc_${_cmake_helpers_namespace}.cmake)
    file(WRITE ${_cmake_helpers_cpack_pre_build_script} "# Content of this file is overwriten during install or package phase")
    cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_cpack_pre_build_script ${_cmake_helpers_cpack_pre_build_script})
  endif()
endfunction()

function(_cmake_helpers_files_find type base_dirs prefix accept_regexes reject_regexes output_var)
  set(_all_files)
  foreach(_base_dir ${base_dirs})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/library] ... dir ${_base_dir}")
    endif()
    set(_base_dir_files)
    foreach(_glob ${_cmake_helpers_${type}_globs})
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${PROJECT_NAME}/library] ... ... glob ${_base_dir}/${_glob}")
      endif()
      file(GLOB_RECURSE _files LIST_DIRECTORIES false ${_base_dir}/${_glob})
      foreach(_file ${_files})
	cmake_helpers_match_accept_reject_regexes(${_file} "${accept_regexes}" "${reject_regexes}" _matched)
	if(_matched)
	  if(CMAKE_HELPERS_DEBUG)
	    message(STATUS "[${PROJECT_NAME}/library] ... ... ... file ${_file}")
	  endif()
	  list(APPEND _base_dir_files ${_file})
	endif()
      endforeach()
    endforeach()
    if(_base_dir_files)
      cmake_helpers_call(source_group TREE ${_base_dir} PREFIX ${prefix} FILES ${_base_dir_files})
      list(APPEND _all_files ${_base_dir_files})
    endif()
  endforeach()
  set(${output_var} ${_all_files} PARENT_SCOPE)
endfunction()
