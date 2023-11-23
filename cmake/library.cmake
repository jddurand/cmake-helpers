function(cmake_helpers_library name)
  #
  # Arguments validation
  #
  if(NOT name)
    message(FATAL_ERROR "name argument is missing")
  endif()
  #
  # Log prefix
  #
  set(_cmake_helpers_logprefix "cmake_helpers/${PROJECT_NAME}/library")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
    message(STATUS "[${_cmake_helpers_logprefix}] Starting")
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
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
    STATIC_SUFFIX
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
    EXPORT_HEADER
    EXPORT_HEADER_BASE_NAME
    EXPORT_HEADER_MACRO_NAME
    EXPORT_HEADER_FILE_NAME
    EXPORT_HEADER_STATIC_DEFINE
    NTRACE
    TARGETS_OUTVAR
    INSTALL_BINDIR
    INSTALL_INCLUDEDIR
    INSTALL_DOCDIR
    INSTALL_LIBDIR
    INSTALL_MANDIR
    INSTALL_CMAKEDIR
    INSTALL_PKGCONFIGDIR
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
    PODS
    PODS_AUTO
    PODS_PREFIX
    PODS_BASE_DIRS
    PODS_GLOBS
    PODS_ACCEPT_RELPATH_REGEXES
    PODS_REJECT_RELPATH_REGEXES
  )
  #
  # Single-value arguments default values
  #
  set(_cmake_helpers_library_namespace                            ${PROJECT_NAME})
  set(_cmake_helpers_library_module                               FALSE)
  set(_cmake_helpers_library_static_suffix                        _static)
  set(_cmake_helpers_library_with_position_independent_code       TRUE)
  set(_cmake_helpers_library_with_visibility_preset_hidden        TRUE)
  set(_cmake_helpers_library_with_visibility_inlines_hidden       TRUE)
  set(_cmake_helpers_library_with_msvc_minimal_headers            FALSE)
  set(_cmake_helpers_library_with_msvc_silent_crt_warnings        TRUE)
  set(_cmake_helpers_library_with_gnu_source_if_available         TRUE)
  set(_cmake_helpers_library_with__netbsd_source_if_available     TRUE)
  set(_cmake_helpers_library_with__reentrant                      TRUE)
  set(_cmake_helpers_library_with__thread_safe                    TRUE)
  set(_cmake_helpers_library_version                              ${PROJECT_VERSION})
  set(_cmake_helpers_library_version_compatibility                SameMajorVersion)
  set(_cmake_helpers_library_version_major                        ${PROJECT_VERSION_MAJOR})
  set(_cmake_helpers_library_version_minor                        ${PROJECT_VERSION_MINOR})
  set(_cmake_helpers_library_version_patch                        ${PROJECT_VERSION_PATCH})
  set(_cmake_helpers_library_export_cmake_name                    ${PROJECT_NAME}-targets)
  set(_cmake_helpers_library_export_header                        TRUE)
  set(_cmake_helpers_library_export_header_base_name              ${PROJECT_NAME})
  set(_cmake_helpers_library_export_header_macro_name             ${PROJECT_NAME}_EXPORT)
  set(_cmake_helpers_library_export_header_file_name              include/${PROJECT_NAME}/export.h)
  set(_cmake_helpers_library_export_header_static_define          ${PROJECT_NAME}_STATIC)
  set(_cmake_helpers_library_ntrace                               TRUE)
  set(_cmake_helpers_library_targets_outvar                       cmake_helpers_targets)
  set(_cmake_helpers_library_install_bindir                       ${CMAKE_INSTALL_BINDIR})
  set(_cmake_helpers_library_install_includedir                   ${CMAKE_INSTALL_INCLUDEDIR})
  set(_cmake_helpers_library_install_docdir                       ${CMAKE_INSTALL_DOCDIR})
  set(_cmake_helpers_library_install_libdir                       ${CMAKE_INSTALL_LIBDIR})
  set(_cmake_helpers_library_install_mandir                       ${CMAKE_INSTALL_MANDIR})
  set(_cmake_helpers_library_install_cmakedir                     ${_cmake_helpers_library_install_libdir}/cmake)
  set(_cmake_helpers_library_install_pkgconfigdir                 ${_cmake_helpers_library_install_libdir}/pkgconfig)
  #
  # Multiple-value arguments default values
  #
  get_filename_component(_cmake_helpers_library_srcdir "${CMAKE_CURRENT_SOURCE_DIR}" REALPATH)
  get_filename_component(_cmake_helpers_library_bindir "${CMAKE_CURRENT_BINARY_DIR}" REALPATH)
  set(_cmake_helpers_library_config_args)
  set(_cmake_helpers_library_sources)
  set(_cmake_helpers_library_sources_auto                         TRUE)
  set(_cmake_helpers_library_sources_prefix                       src)
  if(_cmake_helpers_library_srcdir STREQUAL _cmake_helpers_library_bindir)
    set(_cmake_helpers_library_sources_base_dirs                     ${CMAKE_CURRENT_SOURCE_DIR}/src)
    set(_cmake_helpers_library_headers_base_dirs                     ${CMAKE_CURRENT_SOURCE_DIR}/include)
  else()
    set(_cmake_helpers_library_sources_base_dirs                     ${CMAKE_CURRENT_SOURCE_DIR}/src ${CMAKE_CURRENT_BINARY_DIR}/src)
    set(_cmake_helpers_library_headers_base_dirs                     ${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_CURRENT_BINARY_DIR}/include)
  endif()
  set(_cmake_helpers_library_sources_globs                        *.c *.cpp *.cxx)
  set(_cmake_helpers_library_sources_accept_relpath_regexes)
  set(_cmake_helpers_library_sources_reject_relpath_regexes       "/test")

  set(_cmake_helpers_library_headers)
  set(_cmake_helpers_library_headers_auto                         TRUE)
  set(_cmake_helpers_library_headers_prefix                       include)
  set(_cmake_helpers_library_headers_globs                        *.h *.hh *.hpp *.hxx)
  set(_cmake_helpers_library_headers_accept_relpath_regexes)
  set(_cmake_helpers_library_headers_reject_relpath_regexes       "/test")
  set(_cmake_helpers_library_private_headers_relpath_regexes      "/internal" "/_" "^_")
  set(_cmake_helpers_library_pods_base_dirs                       ${CMAKE_CURRENT_SOURCE_DIR})
  set(_cmake_helpers_library_pods)
  set(_cmake_helpers_library_pods_auto                            TRUE)
  set(_cmake_helpers_library_pods_prefix                          pod)
  set(_cmake_helpers_library_pods_globs                           *.pod)
  set(_cmake_helpers_library_pods_accept_relpath_regexes)
  set(_cmake_helpers_library_pods_reject_relpath_regexes          "/test")
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(library _cmake_helpers_library "" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # Config
  #
  if(_cmake_helpers_library_config_args)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] -------------------")
      message(STATUS "[${_cmake_helpers_logprefix}] Doing configuration")
      message(STATUS "[${_cmake_helpers_logprefix}] -------------------")
    endif()
    cmake_helpers_call(configure_file ${_cmake_helpers_library_config_args})
  endif()
  #
  # Sources discovery
  #
  if((NOT _cmake_helpers_library_sources) AND _cmake_helpers_library_sources_auto)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] -------------------")
      message(STATUS "[${_cmake_helpers_logprefix}] Discovering sources")
      message(STATUS "[${_cmake_helpers_logprefix}] -------------------")
    endif()
    _cmake_helpers_files_find(
      sources
      "${_cmake_helpers_library_sources_base_dirs}"
      "${_cmake_helpers_library_sources_globs}"
      "${_cmake_helpers_library_sources_prefix}"
      "${_cmake_helpers_library_sources_accept_relpath_regexes}"
      "${_cmake_helpers_library_sources_reject_relpath_regexes}"
      _cmake_helpers_library_sources)
    set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_sources ${_cmake_helpers_library_sources})
  endif()
  #
  # Decide targets
  #
  set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_interface_library FALSE)
  set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_static_library FALSE)
  set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_dynamic_library FALSE)
  set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_module_library FALSE)
  if(NOT _cmake_helpers_library_sources)
    #
    # It can only be INTERFACE
    #
    set(_cmake_helpers_library_types INTERFACE)
    set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_interface_library TRUE)
  else()
    if(_cmake_helpers_library_module)
      #
      # MODULE
      #
      set(_cmake_helpers_library_types MODULE)
      set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_module_library TRUE)
    else()
      #
      # STATIC and SHARED
      # We INTENTIONALY put STATIC before SHARED because pkgconfig will need STATIC properties
      #
      set(_cmake_helpers_library_types STATIC SHARED)
      set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_static_library TRUE)
      set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_dynamic_library TRUE)
    endif()
  endif()
  #
  # We always produce a library
  #
  set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_library TRUE)
  set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_types ${_cmake_helpers_library_types})
  #
  # Create targets
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ----------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Creating targets")
    message(STATUS "[${_cmake_helpers_logprefix}] ----------------")
  endif()
  set(_cmake_helpers_library_targets)
  foreach(_cmake_helpers_library_type ${_cmake_helpers_library_types})
    if(_cmake_helpers_library_type STREQUAL "STATIC")
      set(_target ${name}${_cmake_helpers_library_static_suffix})
    else()
      set(_target ${name})
    endif()
    cmake_helpers_call(add_library ${_target} ${_cmake_helpers_library_type} ${_cmake_helpers_library_sources})
    list(APPEND _cmake_helpers_library_targets ${_target})
  endforeach()
  set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_targets ${_cmake_helpers_library_targets})
  #
  # Export
  #
  if(_cmake_helpers_library_export_header)
    include(GenerateExportHeader)
    #
    # Regardless of user args, we always append the args we know because we need them
    #
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] ------------------------")
      message(STATUS "[${_cmake_helpers_logprefix}] Generating export header")
      message(STATUS "[${_cmake_helpers_logprefix}] ------------------------")
    endif()
    cmake_helpers_call(generate_export_header ${name}
      BASE_NAME         ${_cmake_helpers_library_export_header_base_name}
      EXPORT_MACRO_NAME ${_cmake_helpers_library_export_header_macro_name}
      EXPORT_FILE_NAME  ${_cmake_helpers_library_export_header_file_name}
      STATIC_DEFINE     ${_cmake_helpers_library_export_header_static_define})
  endif()
  #
  # Headers discovery
  #
  if((NOT _cmake_helpers_library_headers) AND _cmake_helpers_library_headers_auto)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] -------------------")
      message(STATUS "[${_cmake_helpers_logprefix}] Discovering headers")
      message(STATUS "[${_cmake_helpers_logprefix}] -------------------")
    endif()
    _cmake_helpers_files_find(
      headers
      "${_cmake_helpers_library_headers_base_dirs}"
      "${_cmake_helpers_library_headers_globs}"
      "${_cmake_helpers_library_headers_prefix}"
      "${_cmake_helpers_library_headers_accept_relpath_regexes}"
      "${_cmake_helpers_library_headers_reject_relpath_regexes}"
      _cmake_helpers_library_headers)
    set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_headers ${_cmake_cmake_helpers_library_headers})
  endif()
  #
  # Get private headers out of header files
  #
  foreach(_cmake_helpers_library_header ${_cmake_helpers_library_headers})
    cmake_helpers_match_regexes("${_cmake_helpers_library_header}" "${_cmake_helpers_library_private_headers_relpath_regexes}" FALSE _cmake_helpers_library_matched)
    if(_cmake_helpers_library_matched)
      list(APPEND _cmake_helpers_private_headers ${_cmake_helpers_library_header})
    else()
      list(APPEND _cmake_helpers_public_headers ${_cmake_helpers_library_header})
    endif()
  endforeach()
  if(CMAKE_HELPERS_DEBUG)
    foreach(_cmake_helpers_header_type public private)
      message(STATUS "[${_cmake_helpers_logprefix}] ${_cmake_helpers_header_type} headers:")
      foreach(_file ${_cmake_helpers_${_cmake_helpers_header_type}_headers})
	message(STATUS "[${_cmake_helpers_logprefix}] ... ${_file}")
      endforeach()
    endforeach()
  endif()
  #
  # Man pages discovery
  #
  if((NOT _cmake_helpers_library_pods) AND _cmake_helpers_library_pods_auto)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] ----------------")
      message(STATUS "[${_cmake_helpers_logprefix}] Discovering pods")
      message(STATUS "[${_cmake_helpers_logprefix}] ----------------")
    endif()
    _cmake_helpers_files_find(
      pods
      "${_cmake_helpers_library_pods_base_dirs}"
      "${_cmake_helpers_library_pods_globs}"
      "${_cmake_helpers_library_pods_prefix}"
      "${_cmake_helpers_library_pods_accept_relpath_regexes}"
      "${_cmake_helpers_library_pods_reject_relpath_regexes}"
      _cmake_helpers_library_pods)
    set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_pods ${_cmake_cmake_helpers_library_pods})
  endif()
  if(_cmake_helpers_library_pods)
    foreach(_cmake_helpers_library_pod ${_cmake_helpers_library_pods})
      get_filename_component(_filename_we ${_cmake_helpers_library_pod} NAME_WE)
      cmake_helpers_pod(
	INPUT ${_cmake_helpers_library_pod}
	NAME ${_filename_we}
	SECTION 3
	VERSION ${_cmake_helpers_library_version}
      )
    endforeach()
  endif()
  #
  # Targets specifics
  #
  foreach(_cmake_helpers_library_target ${_cmake_helpers_library_targets})
    get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] ----------------------------")
      message(STATUS "[${_cmake_helpers_logprefix}] Doing ${_cmake_helpers_library_target_type} setting")
      message(STATUS "[${_cmake_helpers_logprefix}] ----------------------------")
    endif()
    #
    # Assign headers to file sets
    # (INTERFACE case needs a file set to work properly)
    #
    if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
      if(_cmake_helpers_public_headers)
	cmake_helpers_call(target_sources ${_cmake_helpers_library_target} INTERFACE FILE_SET public_headers BASE_DIRS ${_cmake_helpers_library_headers_base_dirs} TYPE HEADERS FILES ${_cmake_helpers_public_headers})
      endif()
      if(_cmake_helpers_private_headers)
	cmake_helpers_call(target_sources ${_cmake_helpers_library_target} INTERFACE FILE_SET private_headers BASE_DIRS ${_cmake_helpers_library_headers_base_dirs} TYPE HEADERS FILES ${_cmake_helpers_private_headers})
      endif()
    else()
      if(_cmake_helpers_public_headers)
	cmake_helpers_call(target_sources ${_cmake_helpers_library_target} PUBLIC FILE_SET public_headers BASE_DIRS ${_cmake_helpers_library_headers_base_dirs} TYPE HEADERS FILES ${_cmake_helpers_public_headers})
      endif()
      if(_cmake_helpers_private_headers)
	cmake_helpers_call(target_sources ${_cmake_helpers_library_target} PRIVATE FILE_SET private_headers BASE_DIRS ${_cmake_helpers_library_headers_base_dirs} TYPE HEADERS FILES ${_cmake_helpers_private_headers})
      endif()
    endif()
    #
    # Compile definitions
    #
    if(_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY")
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${PROJECT_NAME}_EXPORTS)
    elseif(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PUBLIC -D${_cmake_helpers_library_export_header_static_define})
    elseif(_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY")
    elseif(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
    else()
      message(FATAL_ERROR "Unsupported library type: ${_cmake_helpers_library_target_type}")
    endif()

    string(TOUPPER "${name}" _name_toupper)

    if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${_name_toupper}_VERSION_MAJOR=${_cmake_helpers_library_version_major})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${_name_toupper}_VERSION_MINOR=${_cmake_helpers_library_version_minor})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${_name_toupper}_VERSION_PATCH=${_cmake_helpers_library_version_patch})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${_name_toupper}_VERSION="${_cmake_helpers_library_version}")
    else()
      if(_cmake_helpers_library_ntrace)
	cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_name_toupper}_NTRACE -DNTRACE)
      endif()
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_name_toupper}_VERSION_MAJOR=${_cmake_helpers_library_version_major})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_name_toupper}_VERSION_MINOR=${_cmake_helpers_library_version_minor})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_name_toupper}_VERSION_PATCH=${_cmake_helpers_library_version_patch})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_name_toupper}_VERSION="${_cmake_helpers_library_version}")

      if(WIN32 AND _cmake_helpers_library_with_msvc_minimal_headers)
	cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -DWIN32_LEAN_AND_MEAN)
      endif()
      if(WIN32 AND _cmake_helpers_library_with_msvc_silent_crt_warnings)
	cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -DCRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE)
      endif()
      if(_cmake_helpers_library_with_gnu_source_if_available AND _GNU_SOURCE)
	cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D_GNU_SOURCE)
      endif()
      if(_cmake_helpers_library_with__reentrant)
	cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D_REENTRANT)
      endif()
      if(_cmake_helpers_library_with__thread_safe)
	cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D_THREAD_SAFE)
      endif()
    endif()

    if(_cmake_helpers_library_with__netbsd_source_if_available AND (CMAKE_SYSTEM_NAME MATCHES "NetBSD"))
      #
      # On NetBSD, enable this platform features. This makes sure we always have "long long" btw.
      #
      if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
	cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D_NETBSD_SOURCE=1) # Voluntarily public for global "long long" avaibility
      else()
	cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PUBLIC -D_NETBSD_SOURCE=1) # Voluntarily public for global "long long" avaibility
      endif()
    endif()
    #
    # Target properties
    #
    if(_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY")
      cmake_helpers_call(set_target_properties ${_cmake_helpers_library_target} PROPERTIES VERSION ${_cmake_helpers_library_version} SOVERSION ${_cmake_helpers_library_version_major})
    endif()
    if(HAVE_C99MODIFIERS)
      cmake_helpers_call(set_target_properties ${_cmake_helpers_library_target} PROPERTIES C_STANDARD 99)
    endif()
    if(_cmake_helpers_library_with_position_independent_code)
      cmake_helpers_call(set_target_properties ${_cmake_helpers_library_target} PROPERTIES POSITION_INDEPENDENT_CODE TRUE)
    endif()
    if(_cmake_helpers_library_with_visibility_preset_hidden)
      cmake_helpers_call(set_target_properties ${_cmake_helpers_library_target} PROPERTIES C_VISIBILITY_PRESET hidden CXX_VISIBILITY_PRESET hidden)
    endif()
    if(_cmake_helpers_library_with_visibility_inlines_hidden)
      cmake_helpers_call(set_target_properties ${_cmake_helpers_library_target} PROPERTIES VISIBILITY_INLINES_HIDDEN TRUE)
    endif()
    #
    # Compiler specifics
    #
    if(MSVC)
      # For static library we want to debug information within the lib
      # For shared library we want to install the pdb file if it exists
      if(_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY")
	cmake_helpers_call(install FILES $<TARGET_PDB_FILE:${_cmake_helpers_library_target}> DESTINATION ${_cmake_helpers_library_install_bindir} COMPONENT Library OPTIONAL)
      elseif(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
	cmake_helpers_call(target_compile_options ${_cmake_helpers_library_target} PRIVATE /Z7)
      endif()
    endif()
  endforeach()
  #
  # Include directories
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ---------------------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Setting include directories")
    message(STATUS "[${_cmake_helpers_logprefix}] ---------------------------")
  endif()
  if("INTERFACE" IN_LIST _cmake_helpers_library_types)
    foreach(_cmake_helpers_library_include_dir ${_cmake_helpers_library_headers_base_dirs})
      cmake_helpers_call(target_include_directories ${name} INTERFACE $<BUILD_LOCAL_INTERFACE:${_cmake_helpers_library_include_dir}>)
      cmake_helpers_call(target_include_directories ${name} INTERFACE $<BUILD_INTERFACE:${_cmake_helpers_library_include_dir}>)
    endforeach()
    cmake_helpers_call(target_include_directories ${name} INTERFACE $<INSTALL_INTERFACE:${_cmake_helpers_library_install_includedir}>)
  else()
    foreach(_cmake_helpers_library_target ${_cmake_helpers_library_targets})
      foreach(_cmake_helpers_library_include_dir ${_cmake_helpers_library_headers_base_dirs})
	cmake_helpers_call(target_include_directories ${_cmake_helpers_library_target} PUBLIC $<BUILD_LOCAL_INTERFACE:${_cmake_helpers_library_include_dir}>)
	cmake_helpers_call(target_include_directories ${_cmake_helpers_library_target} PUBLIC $<BUILD_INTERFACE:${_cmake_helpers_library_include_dir}>)
      endforeach()
      cmake_helpers_call(target_include_directories ${_cmake_helpers_library_target} PUBLIC $<INSTALL_INTERFACE:${_cmake_helpers_library_install_includedir}>)
    endforeach()
  endif()
  #
  # Install rules
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ---------------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Setting install rules")
    message(STATUS "[${_cmake_helpers_logprefix}] ---------------------")
  endif()
  if(_cmake_helpers_public_headers)
    set(_file_set_args FILE_SET public_headers DESTINATION ${_cmake_helpers_library_install_includedir} COMPONENT Header)
    set(_cmake_helpers_have_header TRUE)
    set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_header ${_cmake_helpers_have_header})
  else()
    set(_cmake_helpers_have_header FALSE)
  endif()

  cmake_helpers_call(install
    TARGETS       ${_cmake_helpers_library_targets}
    EXPORT        ${_cmake_helpers_library_namespace}DevelopmentTargets
    RUNTIME       DESTINATION ${_cmake_helpers_library_install_bindir} COMPONENT Library
    LIBRARY       DESTINATION ${_cmake_helpers_library_install_libdir} COMPONENT Library
    ARCHIVE       DESTINATION ${_cmake_helpers_library_install_libdir} COMPONENT Library
    ${_file_set_args}
  )

  set(_export_cmake_config_in ${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_library_install_cmakedir}/${_cmake_helpers_library_namespace}Config.cmake.in)
  set(_export_cmake_config_out ${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_library_install_cmakedir}/${_cmake_helpers_library_namespace}Config.cmake)
  file(WRITE ${_export_cmake_config_in} "
@PACKAGE_INIT@

include(CMakeFindDependencyMacro)
# find_dependency(Stats 2.6.4)

set(_${_cmake_helpers_library_namespace}_supported_components Library Header Application Document)

if(${_cmake_helpers_library_namespace}_FIND_COMPONENTS)
  #
  # We provide a virtual component that is Development. If it is set, we remove it and
  # enforce Library plus Header
  #
  list(FIND ${_cmake_helpers_library_namespace}_FIND_COMPONENTS \"Development\" _index)
  if(_index GREATER_EQUAL -1)
    list(REMOVE_ITEM ${_cmake_helpers_library_namespace}_FIND_COMPONENTS \"Development\")
    foreach(_wanted Library Header)
      list(FIND ${_cmake_helpers_library_namespace}_FIND_COMPONENTS \"\${_wanted}\" _index)
      if(_index LESS 0)
        list(APPEND ${_cmake_helpers_library_namespace}_FIND_COMPONENTS \"\${_wanted}\")
      endif()
    endforeach()
  endif()

  foreach(_comp \${${_cmake_helpers_library_namespace}_FIND_COMPONENTS})
    if (NOT _comp IN_LIST _${_cmake_helpers_library_namespace}_supported_components)
      set(${_cmake_helpers_library_namespace}_FOUND False)
      set(${_cmake_helpers_library_namespace}_NOT_FOUND_MESSAGE \"Unsupported component: \${_comp}\")
    endif()
    #
    # Component Library and Header are in the DevelopmentTargets file
    #
    if((\${_comp} STREQUAL \"Library\") OR (\${_comp} STREQUAL \"Header\"))
      set(_targets \"DevelopmentTargets\")
    else()
      set(_targets \"${_comp}Targets\")
    endif()
    set(_include \"\${CMAKE_CURRENT_LIST_DIR}/${_cmake_helpers_library_namespace}/${_cmake_helpers_library_namespace}\${_targets}.cmake\")
    if(EXISTS \${_include})
      include(\${_include})
    else()
      set(${_cmake_helpers_library_namespace}_FOUND False)
      set(${_cmake_helpers_library_namespace}_NOT_FOUND_MESSAGE \"Component not available: \${_comp}\")
    endif()
  endforeach()
else()
  foreach(_comp \${_${_cmake_helpers_library_namespace}_supported_components})
    #
    # Component Library and Header are in the DevelopmentTargets file
    #
    if((\${_comp} STREQUAL \"Library\") OR (\${_comp} STREQUAL \"Header\"))
      set(_targets \"DevelopmentTargets\")
    else()
      set(_targets \"${_comp}Targets\")
    endif()
    set(_include \"\${CMAKE_CURRENT_LIST_DIR}/${_cmake_helpers_library_namespace}/${_cmake_helpers_library_namespace}\${_targets}.cmake\")
    if(EXISTS \${_include})
      include(\${_include})
    else()
      set(${_cmake_helpers_library_namespace}_FOUND False)
      set(${_cmake_helpers_library_namespace}_NOT_FOUND_MESSAGE \"Component not available: \${_comp}\")
    endif()
  endforeach()
endif()
")
  cmake_helpers_call(install
    EXPORT ${_cmake_helpers_library_namespace}DevelopmentTargets
    NAMESPACE ${_cmake_helpers_library_namespace}::
    DESTINATION ${_cmake_helpers_library_install_cmakedir}/${_cmake_helpers_library_namespace}
    COMPONENT Library)
  include(CMakePackageConfigHelpers)
  cmake_helpers_call(configure_package_config_file ${_export_cmake_config_in} ${_export_cmake_config_out}
    INSTALL_DESTINATION ${_cmake_helpers_library_install_cmakedir}
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
  )
  file(REMOVE ${_export_cmake_config_in})

  set(_export_cmake_configversion_out ${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_library_install_cmakedir}/${_cmake_helpers_library_namespace}ConfigVersion.cmake)
  cmake_helpers_call(write_basic_package_version_file ${_export_cmake_configversion_out}
    VERSION ${_cmake_helpers_library_version}
    COMPATIBILITY ${_cmake_helpers_library_version_compatibility}
  )
  cmake_helpers_call(install
    FILES ${_export_cmake_config_out} ${_export_cmake_configversion_out}
    DESTINATION ${_cmake_helpers_library_install_cmakedir}
    COMPONENT Library
  )
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ------------------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Creating pkgconfig hooks")
    message(STATUS "[${_cmake_helpers_logprefix}] ------------------------")
  endif()
  file(CONFIGURE
    OUTPUT "pc.${_cmake_helpers_library_namespace}/CMakeLists.txt"
    CONTENT [[
cmake_minimum_required(VERSION 3.16)
project(pc_@_cmake_helpers_library_namespace@ LANGUAGES C CXX)
include(GNUInstallDirs)

option(CMAKE_HELPERS_DEBUG "CMake Helpers debug" OFF)
if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[pc.@_cmake_helpers_library_namespace@/build] Starting")
endif()

if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[pc.@_cmake_helpers_library_namespace@/build] Initializing CMAKE_PREFIX_PATH with: $ENV{CMAKE_MODULE_ROOT_PATH_ENV}")
endif()
set(CMAKE_PREFIX_PATH "$ENV{CMAKE_MODULE_ROOT_PATH_ENV}")

if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[pc.@_cmake_helpers_library_namespace@/build] Initializing CMAKE_PKGCONFIG_DIR with: $ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV}")
endif()
set(CMAKE_PKGCONFIG_DIR "$ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV}")

if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[pc.@_cmake_helpers_library_namespace@/build] find_package(@_cmake_helpers_library_namespace@ @_cmake_helpers_library_version@ REQUIRED CONFIG COMPONENTS Library)")
endif()
find_package(@_cmake_helpers_library_namespace@ @_cmake_helpers_library_version@ REQUIRED CONFIG COMPONENTS Library)

#
# It is important to do static before shared, because shared will reuse static properties
#
set(_target_static)
foreach(_cmake_helpers_library_subtarget @_cmake_helpers_library_targets@)
  set(_cmake_helpers_library_target @_cmake_helpers_library_namespace@::${_cmake_helpers_library_subtarget})
  get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
  get_target_property(_cmake_helpers_library_interface_link_libraries ${_cmake_helpers_library_target} INTERFACE_LINK_LIBRARIES)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[pc.@_cmake_helpers_library_namespace@/build] ${_cmake_helpers_library_target} INTERFACE_LINK_LIBRARIES: ${_cmake_helpers_library_interface_link_libraries}")
  endif()
  set(_cmake_helpers_library_computed_requires)
  foreach(_cmake_helpers_library_interface_link_library ${_cmake_helpers_library_interface_link_libraries})
    if(TARGET ${_cmake_helpers_library_interface_link_library})
      string(REGEX REPLACE ".*::" "" _cmake_helpers_library_computed_require ${_cmake_helpers_library_interface_link_library})
      list(APPEND _cmake_helpers_library_computed_requires ${_cmake_helpers_library_computed_require})
    endif()
  endforeach()
  #
  # iface produce no output file
  # static produces ${_cmake_helpers_library_subtarget}@_cmake_helpers_library_static_suffix@
  # shared produces ${_cmake_helpers_library_subtarget}
  # module produces ${_cmake_helpers_library_subtarget}
  #
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_NAME ${_cmake_helpers_library_subtarget})
  if(${_cmake_helpers_library_target_type} STREQUAL "INTERFACE_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@_cmake_helpers_library_namespace@ headers")
  elseif(${_cmake_helpers_library_target_type} STREQUAL "SHARED_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@_cmake_helpers_library_namespace@ dynamic library")
  elseif(${_cmake_helpers_library_target_type} STREQUAL "MODULE_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@_cmake_helpers_library_namespace@ module library")
  elseif(${_cmake_helpers_library_target_type} STREQUAL "STATIC_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@_cmake_helpers_library_namespace@ static library")
    set(_target_static ${_cmake_helpers_library_target})
  else()
    message(FATAL_ERROR "Unsupported target type ${_cmake_helpers_library_target_type}")
  endif()
  if (_cmake_helpers_library_computed_requires)
    list(JOIN _cmake_helpers_library_computed_requires "," _cmake_helpers_library_pc_requires)
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_REQUIRES "${_cmake_helpers_library_pc_requires}")
  endif()
  if(_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY")
    #
    # By definition the "static" target should already exist
    #
    if(NOT TARGET ${_target_static})
      message(FATAL_ERROR "No static target")
    endif()
    #
    # Requires.private
    #
    get_target_property(_cmake_helpers_library_pc_requires_private ${_target_static} _CMAKE_HELPERS_LIBRARY_PC_REQUIRES)
    if(_cmake_helpers_library_pc_requires_private)
      set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_REQUIRES_PRIVATE "${_cmake_helpers_library_pc_requires_private}")
    endif()
    #
    # Cflags.private
    #
    get_target_property(_pc_interface_compile_definitions_private ${_target_static} INTERFACE_COMPILE_DEFINITIONS)
    if(_pc_interface_compile_definitions_private)
      set_target_properties(${_cmake_helpers_library_target} PROPERTIES PC_INTERFACE_COMPILE_DEFINITIONS_PRIVATE "${_pc_interface_compile_definitions_private}")
    endif()
    #
    # Libs.private
    #
    get_target_property(_pc_libs_private ${_target_static} _CMAKE_HELPERS_LIBRARY_PC_LIBS)
    if(_pc_libs_private)
      set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_LIBS_PRIVATE "${_pc_libs_private}")
    endif()
  endif()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES PC_VERSION "@_cmake_helpers_library_version@")

  get_target_property(_location ${_cmake_helpers_library_target} LOCATION)
  if(_location)
    cmake_path(GET _location FILENAME _filename)
    if((_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY") OR (_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY"))
      get_filename_component(_filename_we ${_filename} NAME_WE)
      if(NOT ("x${CMAKE_SHARED_LIBRARY_PREFIX}" STREQUAL "x"))
        string(REGEX REPLACE "^${CMAKE_SHARED_LIBRARY_PREFIX}" "" _filename_we ${_filename_we})
      endif()
      set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_LIBS "-L\${libdir} -l${_filename_we}")
    elseif(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
      set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_LIBS "\${libdir}/${_filename}")
    endif()
  endif()
  LIST(APPEND _target_computed_dependencies ${_target_filename_we})
endforeach()

foreach(_cmake_helpers_library_subtarget @_cmake_helpers_library_targets@)
  set(_cmake_helpers_library_target @_cmake_helpers_library_namespace@::${_cmake_helpers_library_subtarget})
  set(_file "${CMAKE_PKGCONFIG_DIR}/${_cmake_helpers_library_subtarget}.pc")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[pc.@_cmake_helpers_library_namespace@/build] Generating ${_file}")
  endif()
  file(GENERATE OUTPUT ${_file}
     CONTENT [=[prefix=${pcfiledir}/../..
exec_prefix=${prefix}
bindir=${exec_prefix}/@_cmake_helpers_library_install_bindir@
includedir=${prefix}/@_cmake_helpers_library_install_includedir@
docdir=${prefix}/@_cmake_helpers_library_install_docdir@
libdir=${exec_prefix}/@_cmake_helpers_library_install_libdir@
mandir=${prefix}/@_cmake_helpers_library_install_mandir@
man1dir=${prefix}/@_cmake_helpers_library_install_mandir@1
man2dir=${prefix}/@_cmake_helpers_library_install_mandir@2

Name: $<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_NAME>
Description: $<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION>
Version: $<TARGET_PROPERTY:PC_VERSION>
Requires: $<IF:$<BOOL:$<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_REQUIRES>>,$<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_REQUIRES>,>
Requires.private: $<IF:$<BOOL:$<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_REQUIRES_PRIVATE>>,$<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_REQUIRES_PRIVATE>,>
Cflags: -I${includedir} $<IF:$<BOOL:$<TARGET_PROPERTY:INTERFACE_COMPILE_DEFINITIONS>>,-D$<JOIN:$<TARGET_PROPERTY:INTERFACE_COMPILE_DEFINITIONS>, -D>,>
Cflags.private: $<IF:$<BOOL:$<TARGET_PROPERTY:PC_INTERFACE_COMPILE_DEFINITIONS_PRIVATE>>,-I${includedir} -D$<JOIN:$<TARGET_PROPERTY:PC_INTERFACE_COMPILE_DEFINITIONS_PRIVATE>, -D>,>
Libs: $<IF:$<BOOL:$<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_LIBS>>,$<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_LIBS>,>
Libs.private: $<IF:$<BOOL:$<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_LIBS_PRIVATE>>,$<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_LIBS_PRIVATE>,>
]=] TARGET ${_cmake_helpers_library_target} NEWLINE_STYLE LF)

endforeach()
]] @ONLY NEWLINE_STYLE LF)

  file(CONFIGURE
    OUTPUT "pc.${_cmake_helpers_library_namespace}/post-install.cmake"
    CONTENT [[
set(proj "@CMAKE_CURRENT_BINARY_DIR@/pc.@_cmake_helpers_library_namespace@")
if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[pc.@_cmake_helpers_library_namespace@/post-install.cmake] Building in ${proj}/build")
endif()
execute_process(COMMAND "@CMAKE_COMMAND@" -G "@CMAKE_GENERATOR@" -DCMAKE_HELPERS_DEBUG=@CMAKE_HELPERS_DEBUG@ -S "${proj}" -B "${proj}/build")
]] @ONLY NEWLINE_STYLE LF)

  set(FIRE_POST_INSTALL_CMAKE_PATH ${CMAKE_CURRENT_BINARY_DIR}/fire_post_install.cmake)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] Generating ${FIRE_POST_INSTALL_CMAKE_PATH}")
  endif()
  file(WRITE  ${FIRE_POST_INSTALL_CMAKE_PATH} "if(CMAKE_HELPERS_DEBUG)\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] \\\$ENV{DESTDIR}: \\\"\$ENV{DESTDIR}\\\"\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "endif()\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "set(CMAKE_INSTALL_PREFIX \"\$ENV{CMAKE_INSTALL_PREFIX_ENV}\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "if(CMAKE_HELPERS_DEBUG)\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] CMAKE_INSTALL_PREFIX: \\\"\${CMAKE_INSTALL_PREFIX}\\\"\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "endif()\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "set(_cmake_helpers_library_install_libdir \"\$ENV{_cmake_helpers_library_install_libdir_ENV}\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "if(CMAKE_HELPERS_DEBUG)\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] _cmake_helpers_library_install_libdir: \\\"\${_cmake_helpers_library_install_libdir}\\\"\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "endif()\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "set(CMAKE_MODULE_ROOT_PATH \"\$ENV{CMAKE_MODULE_ROOT_PATH_ENV}\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "set(CMAKE_PKGCONFIG_ROOT_PATH \"\$ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV}\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "if(CMAKE_HELPERS_DEBUG)\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] CMAKE_MODULE_ROOT_PATH: \\\"\${CMAKE_MODULE_ROOT_PATH}\\\"\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] CMAKE_PKGCONFIG_ROOT_PATH: \\\"\${CMAKE_PKGCONFIG_ROOT_PATH}\\\"\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] Including ${CMAKE_CURRENT_BINARY_DIR}/pc.${PROJECT_NAME}/post-install.cmake\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "endif()\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "include(${CMAKE_CURRENT_BINARY_DIR}/pc.${PROJECT_NAME}/post-install.cmake)\n")
  #
  # We CANNOT use CMAKE_INSTALL_PREFIX variable contrary to what is posted almost everywhere on the net: CPack will
  # will have a CMAKE_INSTALL_PREFIX different, the real and only way to know exactly where we install things is to
  # set the current working directory to ${DESTDIR}${CMAKE_INSTALL_PREFIX}, and use WORKING_DIRECTORY as the full install prefix dir.
  # Now take care: DESTDIR does not "work" on Windows if used as is, and CMake has a hook, that we replacate here
  #
  set(_hook [[
    set(_destination "${CMAKE_INSTALL_PREFIX}")
    if(NOT ("x$ENV{DESTDIR}" STREQUAL "x"))
      file(TO_CMAKE_PATH "$ENV{DESTDIR}" _destdir)
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
  install(CODE ${_hook} COMPONENT Library)
  install(CODE "
    set(CPACK_IS_RUNNING \$ENV{CPACK_IS_RUNNING})
    #
    # We do not want to run this when it is CPack
    #
    if (NOT CPACK_IS_RUNNING)
      # We need to re-evaluate GNUInstallDirs to get _cmake_helpers_library_install_libdir
      set(CMAKE_SYSTEM_NAME \"${CMAKE_SYSTEM_NAME}\")
      set(CMAKE_SIZEOF_VOID_P \"${CMAKE_SIZEOF_VOID_P}\")
      include(GNUInstallDirs)
      set(ENV{CMAKE_INSTALL_PREFIX_ENV} \"${CMAKE_INSTALL_PREFIX}\") # Variable may be empty
      set(ENV{_cmake_helpers_library_install_libdir_ENV} \"${_cmake_helpers_library_install_libdir}\") # Variable may be empty
      set(ENV{CMAKE_MODULE_ROOT_PATH_ENV} \"\${_destination}/${_cmake_helpers_library_install_cmakedir}\")
      set(ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV} \"\${_destination}/${_cmake_helpers_library_install_pkgconfigdir}\")
      execute_process(COMMAND \"${CMAKE_COMMAND}\" -G \"${CMAKE_GENERATOR}\" -DCMAKE_HELPERS_DEBUG=${CMAKE_HELPERS_DEBUG} -P \"${FIRE_POST_INSTALL_CMAKE_PATH}\" WORKING_DIRECTORY \"\${_destination}\")
    endif()
"
    COMPONENT Library
  )
  #
  # Generate a file that will be overwriten by the post-install scripts
  #
  foreach(_cmake_helpers_library_target ${_cmake_helpers_library_targets})
    set(FIRE_POST_INSTALL_PKGCONFIG_PATH ${CMAKE_CURRENT_BINARY_DIR}/pc.${_cmake_helpers_library_namespace}/build/${_cmake_helpers_library_target}.pc)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] Generating dummy ${FIRE_POST_INSTALL_PKGCONFIG_PATH}")
    endif()
    file(WRITE ${FIRE_POST_INSTALL_PKGCONFIG_PATH} "# Content of this file is overwriten during install or package phases")
    cmake_helpers_call(install FILES ${FIRE_POST_INSTALL_PKGCONFIG_PATH} DESTINATION ${_cmake_helpers_library_install_pkgconfigdir} COMPONENT Library)
  endforeach()

  set(_cmake_helpers_library_cpack_pre_build_script ${CMAKE_CURRENT_BINARY_DIR}/cpack_pre_build_script_pc_${_cmake_helpers_library_namespace}.cmake)
  file(WRITE ${_cmake_helpers_library_cpack_pre_build_script} "# Content of this file is overwriten during install or package phase")
  set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_library_cpack_pre_build_script ${_cmake_helpers_library_cpack_pre_build_script})
  #
  # Send-out the targets
  #
  if(_cmake_helpers_library_targets_outvar)
    set(${_cmake_helpers_library_targets_outvar} ${_cmake_helpers_library_targets} PARENT_SCOPE)
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

function(_cmake_helpers_files_find type base_dirs globs prefix accept_regexes reject_regexes output_var)
  set(_cmake_helpers_library_all_files)
  foreach(_base_dir ${base_dirs})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] ... base dir ${_base_dir}")
    endif()
    set(_base_dir_files)
    foreach(_glob ${globs})
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] ... ... glob ${_base_dir}/${_glob}")
      endif()
      file(GLOB_RECURSE _files LIST_DIRECTORIES false ${_base_dir}/${_glob})
      foreach(_file ${_files})
	cmake_helpers_match_accept_reject_regexes(${_file} "${accept_regexes}" "${reject_regexes}" _cmake_helpers_library_matched)
	if(_cmake_helpers_library_matched)
	  if(CMAKE_HELPERS_DEBUG)
	    message(STATUS "[${_cmake_helpers_logprefix}] ... ... ... file ${_file}")
	  endif()
	  list(APPEND _base_dir_files ${_file})
	endif()
      endforeach()
    endforeach()
    if(_base_dir_files)
      cmake_helpers_call(source_group TREE ${_base_dir} PREFIX ${prefix} FILES ${_base_dir_files})
      list(APPEND _cmake_helpers_library_all_files ${_base_dir_files})
    endif()
  endforeach()
  set(${output_var} ${_cmake_helpers_library_all_files} PARENT_SCOPE)
endfunction()
