function(cmake_helpers_library)
  # ============================================================================================================
  # This module generates two components:
  #
  # - ${namespace}Library, dynamic directory properties giving details are:
  #
  # - ${namespace}Header
  #
  # Additional dynamic directory properties generated:
  #
  # - cmake_helpers_namespaces                                 : List of all namespaces
  # - cmake_helpers_have_${namespace}_interface_library        : Boolean indicating presence of an ${namespace} INTERFACE_LIBRARY
  # - cmake_helpers_have_${namespace}_static_library           : Boolean indicating presence of a  ${namespace} STATIC_LIBRARY
  # - cmake_helpers_have_${namespace}_shared_library           : Boolean indicating presence of a  ${namespace} SHARED_LIBRARY
  # - cmake_helpers_have_${namespace}_module_library           : Boolean indicating presence of a  ${namespace} MODULE_LIBRARY
  # - cmake_helpers_have_${namespace}_object_library           : Boolean indicating presence of an ${namespace} OBJECT_LIBRARY
  # - cmake_helpers_have_interface_libraries                   : Boolean indicating presence of any INTERFACE_LIBRARY
  # - cmake_helpers_have_static_libraries                      : Boolean indicating presence of any STATIC_LIBRARY
  # - cmake_helpers_have_shared_libraries                      : Boolean indicating presence of any SHARED_LIBRARY
  # - cmake_helpers_have_module_libraries                      : Boolean indicating presence of any MODULE_LIBRARY
  # - cmake_helpers_have_object_libraries                      : Boolean indicating presence of any OBJECT_LIBRARY
  # - cmake_helpers_library_${namespace}_targets               : List of ${namespace} library targets
  # - cmake_helpers_library_targets                            : List of all library targets
  # - cmake_helpers_cpack_${namespace}_pre_build_script        : Location of a CPack pre-build script
  # - cmake_helpers_cpack_pre_build_scripts                    : List of all CPack pre-build scripts
  # - cmake_helpers_have_${namespace}_library_component        : Boolean indicating presence of a ${namespace} Library COMPONENT
  # - cmake_helpers_have_${namespace}_header_component         : Boolean indicating presence of a ${namespace} Header COMPONENT
  # - cmake_helpers_have_library_components                    : Boolean indicating presence of any Library COMPONENT
  # - cmake_helpers_have_header_components                     : Boolean indicating presence of any Header COMPONENT
  # - cmake_helpers_library_${namespace}_component_name        : Name of the ${namespace} Library COMPONENT if installed
  # - cmake_helpers_library_component_names                    : List of all installed Library COMPONENTs
  # - cmake_helpers_header_${namespace}_component_name         : Name of the ${namespace} Header COMPONENT if installed
  # - cmake_helpers_header_component_names                     : List of all installed Header COMPONENTs
  #
  # Note that:
  # - Library component exist only if there are binaries, i.e. only for STATIC, SHARED, and MODULE
  # - Header component exist only if there are public headers
  # - An OBJECT library installs nothing
  #
  # This module generates one export set:
  #
  # - ${namespace}DevelopmentTargets
  # ============================================================================================================
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
    TYPE_AUTO
    TYPE_INTERFACE
    TYPE_SHARED
    TYPE_STATIC
    TYPE_MODULE
    TYPE_OBJECT
    TARGET_NAME_AUTO
    TARGET_NAME_INTERFACE
    TARGET_NAME_SHARED
    TARGET_NAME_STATIC
    TARGET_NAME_MODULE
    TARGET_NAME_OBJECT
    WITH_POSITION_INDEPENDENT_CODE
    WITH_VISIBILITY_PRESET_HIDDEN
    WITH_VISIBILITY_INLINES_HIDDEN
    WITH_MSVC_MINIMAL_HEADERS
    WITH_MSVC_SILENT_CRT_WARNINGS
    WITH_GNU_SOURCE_IF_AVAILABLE
    WITH__NETBSD_SOURCE_IF_AVAILABLE
    WITH__REENTRANT
    WITH__THREAD_SAFE
    COMPATIBILITY
    EXPORT_HEADER
    EXPORT_HEADER_TARGET_AUTO
    EXPORT_HEADER_TARGET
    EXPORT_HEADER_BASE_NAME
    EXPORT_HEADER_MACRO_NAME
    EXPORT_HEADER_FILE_NAME
    EXPORT_HEADER_STATIC_DEFINE
    NTRACE
    TARGETS_OUTVAR
  )
  set(_multiValueArgs
    FIND_DEPENDENCIES
    DEPENDS
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
    PODS_RENAME_README_TO_NAMESPACE
  )
  #
  # Single-value arguments default values
  #
  set(_cmake_helpers_library_namespace                            ${PROJECT_NAME})
  set(_cmake_helpers_library_type_auto                            TRUE)
  set(_cmake_helpers_library_type_interface                       FALSE)
  set(_cmake_helpers_library_type_shared                          FALSE)
  set(_cmake_helpers_library_type_static                          FALSE)
  set(_cmake_helpers_library_type_module                          FALSE)
  set(_cmake_helpers_library_type_object                          FALSE)
  set(_cmake_helpers_library_target_name_auto                     TRUE)
  set(_cmake_helpers_library_target_name_interface                ${_cmake_helpers_library_namespace}_iface)
  set(_cmake_helpers_library_target_name_shared                   ${_cmake_helpers_library_namespace}_shared)
  set(_cmake_helpers_library_target_name_static                   ${_cmake_helpers_library_namespace}_static)
  set(_cmake_helpers_library_target_name_module                   ${_cmake_helpers_library_namespace}_module)
  set(_cmake_helpers_library_target_name_object                   ${_cmake_helpers_library_namespace}_objs)
  set(_cmake_helpers_library_with_position_independent_code       TRUE)
  set(_cmake_helpers_library_with_visibility_preset_hidden        TRUE)
  set(_cmake_helpers_library_with_visibility_inlines_hidden       TRUE)
  set(_cmake_helpers_library_with_msvc_minimal_headers            FALSE)
  set(_cmake_helpers_library_with_msvc_silent_crt_warnings        TRUE)
  set(_cmake_helpers_library_with_gnu_source_if_available         TRUE)
  set(_cmake_helpers_library_with__netbsd_source_if_available     TRUE)
  set(_cmake_helpers_library_with__reentrant                      TRUE)
  set(_cmake_helpers_library_with__thread_safe                    TRUE)
  set(_cmake_helpers_library_compatibility                        SameMajorVersion)
  set(_cmake_helpers_library_export_header                        TRUE)
  set(_cmake_helpers_library_export_header_target_auto            TRUE)
  set(_cmake_helpers_library_export_header_target                 FALSE)
  set(_cmake_helpers_library_export_header_base_name              ${_cmake_helpers_library_namespace})
  set(_cmake_helpers_library_export_header_macro_name             ${_cmake_helpers_library_namespace}_EXPORT)
  set(_cmake_helpers_library_export_header_file_name              include/${_cmake_helpers_library_namespace}/export.h)
  set(_cmake_helpers_library_export_header_static_define          ${_cmake_helpers_library_namespace}_STATIC)
  set(_cmake_helpers_library_ntrace                               TRUE)
  set(_cmake_helpers_library_targets_outvar                       cmake_helpers_targets)
  #
  # Multiple-value arguments default values
  #
  get_filename_component(_cmake_helpers_library_srcdir "${CMAKE_CURRENT_SOURCE_DIR}" REALPATH)
  get_filename_component(_cmake_helpers_library_bindir "${CMAKE_CURRENT_BINARY_DIR}" REALPATH)
  set(_cmake_helpers_library_find_dependencies)
  set(_cmake_helpers_library_depends)
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
  set(_cmake_helpers_library_sources_reject_relpath_regexes       "/test/" "/3rdparty/" "^test/" "^3rdparty/")

  set(_cmake_helpers_library_headers)
  set(_cmake_helpers_library_headers_auto                         TRUE)
  set(_cmake_helpers_library_headers_prefix                       include)
  set(_cmake_helpers_library_headers_globs                        *.h *.hh *.hpp *.hxx)
  set(_cmake_helpers_library_headers_accept_relpath_regexes)
  set(_cmake_helpers_library_headers_reject_relpath_regexes       "/test/" "/3rdparty/" "^test/" "^3rdparty/")
  set(_cmake_helpers_library_private_headers_relpath_regexes      "/internal/" "/_" "^internal/" "^_")
  set(_cmake_helpers_library_pods_base_dirs                       ${CMAKE_CURRENT_SOURCE_DIR})
  set(_cmake_helpers_library_pods)
  set(_cmake_helpers_library_pods_auto                            TRUE)
  set(_cmake_helpers_library_pods_prefix                          pod)
  set(_cmake_helpers_library_pods_globs                           *.pod)
  set(_cmake_helpers_library_pods_accept_relpath_regexes)
  set(_cmake_helpers_library_pods_reject_relpath_regexes          "/test/" "/3rdparty/" "^test/" "^3rdparty/")
  set(_cmake_helpers_library_pods_rename_readme_to_namespace      TRUE)
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(library _cmake_helpers_library "" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # Constants
  #
  set(_cmake_helpers_library_library_component_name               ${_cmake_helpers_library_namespace}${CMAKE_HELPERS_LIBRARY_COMPONENT_NAME_SUFFIX})
  set(_cmake_helpers_library_header_component_name                ${_cmake_helpers_library_namespace}${CMAKE_HELPERS_HEADER_COMPONENT_NAME_SUFFIX})
  set(_cmake_helpers_library_development_export_set_name          ${_cmake_helpers_library_namespace}${CMAKE_HELPERS_DEVELOPMENT_EXPORT_SET_NAME_SUFFIX})
  set(_cmake_helpers_library_generator_platform                   ${CMAKE_GENERATOR_PLATFORM})
  if(_cmake_helpers_library_generator_platform)
    set(_cmake_helpers_library_generator_platform_args "-A" "${_cmake_helpers_library_generator_platform}")
  else()
    set(_cmake_helpers_library_generator_platform_args)
  endif()
  set(_cmake_helpers_library_generator_toolset                   ${CMAKE_GENERATOR_TOOLSET})
  if(_cmake_helpers_library_generator_toolset)
    set(_cmake_helpers_library_generator_toolset_args "-T" "${_cmake_helpers_library_generator_toolset}")
  else()
    set(_cmake_helpers_library_generator_toolset_args)
  endif()
  #
  # Check find dependencies
  #
  if(_cmake_helpers_library_find_dependencies)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] --------------------")
      message(STATUS "[${_cmake_helpers_logprefix}] Finding dependencies")
      message(STATUS "[${_cmake_helpers_logprefix}] --------------------")
    endif()
    include(CMakeFindDependencyMacro)
    foreach(_cmake_helpers_library_find_dependency "${_cmake_helpers_library_find_dependencies}")
      if("x${_cmake_helpers_library_find_dependency}" STREQUAL "x")
	continue()
      endif()
      #
      # _find_depend is splitted using the space
      #
      separate_arguments(_args UNIX_COMMAND "${_cmake_helpers_library_find_dependency}")
      cmake_helpers_call(find_package ${_args})
    endforeach()
  endif()
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
      _cmake_helpers_library_sources
      _cmake_helpers_library_relpath_sources)
  endif()
  #
  # Decide targets
  #
  set(_cmake_helpers_have_${_cmake_helpers_library_namespace}_interface_library FALSE)
  set(_cmake_helpers_have_${_cmake_helpers_library_namespace}_static_library FALSE)
  set(_cmake_helpers_have_${_cmake_helpers_library_namespace}_shared_library FALSE)
  set(_cmake_helpers_have_${_cmake_helpers_library_namespace}_module_library FALSE)
  set(_cmake_helpers_have_${_cmake_helpers_library_namespace}_object_library FALSE)
  set(_cmake_helpers_library_valid_types)
  set(_cmake_helpers_library_export_header_target_from_type)
  if(_cmake_helpers_library_type_auto)
    #
    # In auto mode, only INTERFACE, or STATIC plus SHARED libraries can be triggered
    #
    if(NOT _cmake_helpers_library_sources)
      list(APPEND _cmake_helpers_library_valid_types interface)
      if(_cmake_helpers_library_target_name_auto)
        set(_cmake_helpers_library_target_name_interface ${_cmake_helpers_library_namespace})
      endif()
    else()
      #
      # It is STATIC then SHARED - order is important, c.f. pkgconfig hooks
      #
      list(APPEND _cmake_helpers_library_valid_types static)
      if(_cmake_helpers_library_target_name_auto)
        set(_cmake_helpers_library_target_name_static ${_cmake_helpers_library_namespace}_static)
      endif()
      list(APPEND _cmake_helpers_library_valid_types shared)
      if(_cmake_helpers_library_target_name_auto)
        set(_cmake_helpers_library_target_name_shared ${_cmake_helpers_library_namespace})
      endif()
      if((NOT _cmake_helpers_library_export_header_target) AND _cmake_helpers_library_export_header_target_auto)
        set(_cmake_helpers_library_export_target_from_type SHARED)
      endif()
    endif()
  else()
    if(NOT _cmake_helpers_library_sources)
      #
      # It can only be INTERFACE
      #
      if((NOT _cmake_helpers_library_type_interface) OR
          _cmake_helpers_library_type_shared OR
          _cmake_helpers_library_type_static OR
          _cmake_helpers_library_type_module OR
          _cmake_helpers_library_type_object)
        message(FATAL_ERROR "No source: library can only be of type INTERFACE - option TYPE_INTERFACE TRUE should be used and only this option")
      endif()
      list(APPEND _cmake_helpers_library_valid_types interface)
    else()
      #
      # It cannot be INTERFACE
      #
      if(_cmake_helpers_library_type_interface)
        message(FATAL_ERROR "Sources are present: option TYPE_INTERFACE FALSE should be used, and at least one of TYPE_SHARED, TYPE_STATIC, TYPE_MODULKE, TYPE_OBJECT set to TRUE")
      endif()
      foreach(_cmake_helpers_library_type module object iface static shared)
        if(_cmake_helpers_library_type_${_cmake_helpers_library_type})
          list(APPEND _cmake_helpers_library_valid_types ${_cmake_helpers_library_type})
        endif()
      endforeach()
      if((NOT _cmake_helpers_library_export_header_target) AND _cmake_helpers_library_export_header_target_auto)
        set(_cmake_helpers_library_export_target_from_type SHARED)
      endif()
    endif()
  endif()
  #
  # Collect all validated library types
  #
  set(_cmake_helpers_library_types)
  foreach(_cmake_helpers_library_valid_type ${_cmake_helpers_library_valid_types})
    string(TOUPPER "${_cmake_helpers_library_valid_type}" _cmake_helpers_library_valid_type_toupper)
    list(APPEND _cmake_helpers_library_types ${_cmake_helpers_library_valid_type_toupper})
    set(_cmake_helpers_have_${_cmake_helpers_library_namespace}_${_cmake_helpers_library_valid_type}_library TRUE)
    set(_cmake_helpers_library_type_${_cmake_helpers_library_valid_type_toupper}_name ${_cmake_helpers_library_target_name_${_cmake_helpers_library_valid_type}})
  endforeach()
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
    set(_cmake_helpers_library_target ${_cmake_helpers_library_type_${_cmake_helpers_library_type}_name})
    cmake_helpers_call(add_library ${_cmake_helpers_library_target} ${_cmake_helpers_library_type} ${_cmake_helpers_library_sources})
    list(APPEND _cmake_helpers_library_targets ${_cmake_helpers_library_target})
  endforeach()
  #
  # FILE_SETs
  # Headers are splitted in two FILE_SETs that share the same base dirs:
  # - Public headers go in the public file set "public_headers"
  # - Private headers go in the private file set "private_headers"
  # This is duplicating base_dirs in include directories, but there is no harm with that.
  #
  foreach(_cmake_helpers_library_target ${_cmake_helpers_library_targets})
    cmake_helpers_call(target_sources ${_cmake_helpers_library_target} PUBLIC FILE_SET public_headers BASE_DIRS ${_cmake_helpers_library_headers_base_dirs} TYPE HEADERS)
    cmake_helpers_call(target_sources ${_cmake_helpers_library_target} PRIVATE FILE_SET private_headers BASE_DIRS ${_cmake_helpers_library_headers_base_dirs} TYPE HEADERS)
  endforeach()
  #
  # Export header: invalid if this is an INTERFACE only library
  #
  if(_cmake_helpers_library_export_header)
    include(GenerateExportHeader)
    #
    # Get the target used for the export header
    #
    if((NOT _cmake_helpers_library_export_header_target) AND _cmake_helpers_library_export_target_from_type)
      set(_cmake_helpers_library_export_header_target ${_cmake_helpers_library_type_${_cmake_helpers_library_export_target_from_type}_name})
      #
      # Regardless of user args, we always append the args we know because we need them
      #
      if(CMAKE_HELPERS_DEBUG)
        message(STATUS "[${_cmake_helpers_logprefix}] ------------------------------------------------------------------------")
        message(STATUS "[${_cmake_helpers_logprefix}] Generating export header using target ${_cmake_helpers_library_export_header_target}")
        message(STATUS "[${_cmake_helpers_logprefix}] ------------------------------------------------------------------------")
      endif()
      cmake_helpers_call(generate_export_header ${_cmake_helpers_library_export_header_target}
        BASE_NAME         ${_cmake_helpers_library_export_header_base_name}
        EXPORT_MACRO_NAME ${_cmake_helpers_library_export_header_macro_name}
        EXPORT_FILE_NAME  ${_cmake_helpers_library_export_header_file_name}
        STATIC_DEFINE     ${_cmake_helpers_library_export_header_static_define})
    endif()
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
      _cmake_helpers_library_headers
      _cmake_helpers_library_relpath_headers)
  endif()
  #
  # Get private headers out of header files
  #
  set(_cmake_helpers_private_headers)
  set(_cmake_helpers_public_headers)
  list(LENGTH _cmake_helpers_library_headers _cmake_helpers_library_headers_length)
  if(_cmake_helpers_library_headers_length GREATER 0)
    math(EXPR _cmake_helpers_library_headers_i_max "${_cmake_helpers_library_headers_length} - 1")
    foreach(_i RANGE 0 ${_cmake_helpers_library_headers_i_max})
      list(GET _cmake_helpers_library_headers ${_i} _cmake_helpers_library_header)
      list(GET _cmake_helpers_library_relpath_headers ${_i} _cmake_helpers_library_relpath_header)
      cmake_helpers_match_regexes("${_cmake_helpers_library_relpath_header}" "${_cmake_helpers_library_private_headers_relpath_regexes}" FALSE _cmake_helpers_library_matched)
      if(_cmake_helpers_library_matched)
	list(APPEND _cmake_helpers_private_headers ${_cmake_helpers_library_header})
      else()
	list(APPEND _cmake_helpers_public_headers ${_cmake_helpers_library_header})
      endif()
    endforeach()
  endif()
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
      _cmake_helpers_library_pods
      _cmake_helpers_library_relpath_pods)
  endif()
  if(_cmake_helpers_library_pods)
    foreach(_cmake_helpers_library_pod ${_cmake_helpers_library_pods})
      get_filename_component(_filename_we ${_cmake_helpers_library_pod} NAME_WE)
      if(_cmake_helpers_library_pods_rename_readme_to_namespace AND (_filename_we STREQUAL "README"))
	#
	# We do not want README to be produced as README.3.gz
	#
	cmake_helpers_pod(
	  INPUT ${_cmake_helpers_library_pod}
	  NAME ${_cmake_helpers_library_namespace}
	  SECTION 3
	  VERSION ${PROJECT_VERSION}
	  MAN_PREPEND FALSE
	)
      else()
	cmake_helpers_pod(
	  INPUT ${_cmake_helpers_library_pod}
	  NAME ${_filename_we}
	  SECTION 3
	  VERSION ${PROJECT_VERSION}
	  MAN_PREPEND FALSE
	)
      endif()
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
    # Populate headers file sets
    #
    if(_cmake_helpers_public_headers)
      cmake_helpers_call(target_sources ${_cmake_helpers_library_target} PUBLIC FILE_SET public_headers FILES ${_cmake_helpers_public_headers})
    endif()
    if(_cmake_helpers_private_headers)
      cmake_helpers_call(target_sources ${_cmake_helpers_library_target} PRIVATE FILE_SET private_headers FILES ${_cmake_helpers_private_headers})
    endif()
    #
    # Compile definitions
    #
    if(_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY")
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_cmake_helpers_library_namespace}_EXPORTS)
    elseif(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PUBLIC -D${_cmake_helpers_library_export_header_static_define})
    elseif(_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY")
    elseif(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
    elseif(_cmake_helpers_library_target_type STREQUAL "OBJECT_LIBRARY")
    else()
      message(FATAL_ERROR "Unsupported library type: ${_cmake_helpers_library_target_type}")
    endif()

    string(TOUPPER "${_cmake_helpers_library_namespace}" _namespace_toupper)

    if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${_namespace_toupper}_VERSION_MAJOR=${PROJECT_VERSION_MAJOR})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${_namespace_toupper}_VERSION_MINOR=${PROJECT_VERSION_MINOR})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${_namespace_toupper}_VERSION_PATCH=${PROJECT_VERSION_PATCH})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${_namespace_toupper}_VERSION="${PROJECT_VERSION}")
    else()
      if(_cmake_helpers_library_ntrace)
	cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_namespace_toupper}_NTRACE -DNTRACE)
      endif()
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_namespace_toupper}_VERSION_MAJOR=${PROJECT_VERSION_MAJOR})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_namespace_toupper}_VERSION_MINOR=${PROJECT_VERSION_MINOR})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_namespace_toupper}_VERSION_PATCH=${PROJECT_VERSION_PATCH})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${_namespace_toupper}_VERSION="${PROJECT_VERSION}")

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
    if((_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY") OR (_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY"))
      cmake_helpers_call(set_target_properties ${_cmake_helpers_library_target} PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
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
      # For the others we want to install the pdb file if it exists
      if(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
	cmake_helpers_call(target_compile_options ${_cmake_helpers_library_target} PRIVATE /Z7)
      elseif((_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY") OR (_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY"))
        set(_cmake_helpers_library_target_pdb_file $<TARGET_PDB_FILE:${_cmake_helpers_library_target}>)
        if(_cmake_helpers_library_target_pdb_file)
	  if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
	    install(FILES ${_cmake_helpers_library_target_pdb_file} DESTINATION ${CMAKE_HELPERS_INSTALL_BINDIR} COMPONENT ${_cmake_helpers_library_library_component_name} OPTIONAL)
	  endif()
        endif()
      else()
        #
        # Nothing special for the other types
        #
      endif()
    endif()
  endforeach()
  #
  # Install rules
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ---------------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Setting install rules")
    message(STATUS "[${_cmake_helpers_logprefix}] ---------------------")
  endif()
  #
  # We select the targets to install.
  # Take in the library components we means only components that have RUNTIME, LIBRARY or ARCHIVE files
  #
  set(_cmake_helpers_library_install_targets)
  foreach(_cmake_helpers_library_target ${_cmake_helpers_library_targets})
    get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
    if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
      list(APPEND _cmake_helpers_library_install_targets ${_cmake_helpers_library_target})
    elseif(_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY")
      list(APPEND _cmake_helpers_library_install_targets ${_cmake_helpers_library_target})
    elseif(_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY")
      list(APPEND _cmake_helpers_library_install_targets ${_cmake_helpers_library_target})
    elseif(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
      list(APPEND _cmake_helpers_library_install_targets ${_cmake_helpers_library_target})
    elseif(_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY")
      list(APPEND _cmake_helpers_library_install_targets ${_cmake_helpers_library_target})
    elseif(_cmake_helpers_library_target_type STREQUAL "OBJECT_LIBRARY")
      #
      # An OBJECT library is not installable
      #
    else()
      message(FATAL_ERROR "Unsupported library type: ${_cmake_helpers_library_target_type}")
    endif()
  endforeach()
  #
  # Install rule
  #
  set(_cmake_helpers_have_${_cmake_helpers_library_namespace}_library_component FALSE)
  set(_cmake_helpers_have_${_cmake_helpers_library_namespace}_header_component FALSE)
  if(_cmake_helpers_library_install_targets)
    #
    # Install and export in ${_cmake_helpers_library_development_export_set_name}
    #
    if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
      #
      # Remember we have a Library component
      #
      set(_cmake_helpers_have_${_cmake_helpers_library_namespace}_library_component TRUE)
      #
      # Remember if we have a Header component
      #
      if(_cmake_helpers_public_headers)
	set(_cmake_helpers_have_${_cmake_helpers_library_namespace}_header_component TRUE)
      endif()
      #
      # Install components
      #
      install(
	TARGETS                 ${_cmake_helpers_library_install_targets}
	EXPORT                  ${_cmake_helpers_library_development_export_set_name}
	RUNTIME                 DESTINATION ${CMAKE_HELPERS_INSTALL_BINDIR}     COMPONENT ${_cmake_helpers_library_library_component_name}
	LIBRARY                 DESTINATION ${CMAKE_HELPERS_INSTALL_LIBDIR}     COMPONENT ${_cmake_helpers_library_library_component_name}
	ARCHIVE                 DESTINATION ${CMAKE_HELPERS_INSTALL_LIBDIR}     COMPONENT ${_cmake_helpers_library_library_component_name}
	FILE_SET public_headers DESTINATION ${CMAKE_HELPERS_INSTALL_INCLUDEDIR} COMPONENT ${_cmake_helpers_library_header_component_name}
      )
    endif()
  endif()
  #
  # CMake configuratin files for import
  #
  set(_export_cmake_config_in ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_HELPERS_INSTALL_CMAKEDIR}/${_cmake_helpers_library_namespace}Config.cmake.in)
  set(_export_cmake_config_out ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_HELPERS_INSTALL_CMAKEDIR}/${_cmake_helpers_library_namespace}Config.cmake)
  file(WRITE ${_export_cmake_config_in} "
@PACKAGE_INIT@

include(CMakeFindDependencyMacro)
foreach(_find_depend \"${_cmake_helpers_library_find_dependencies}\")
  if(\"x\${_find_depend}\" STREQUAL \"x\")
    continue()
  endif()
  #
  # _find_depend is splitted using the space
  #
  separate_arguments(_args UNIX_COMMAND \"\${_find_depend}\")
  find_dependency(\${_args})
endforeach()

#
# Take care, when find_package requires a component, this is an export set from packager point of view
#
set(_${_cmake_helpers_library_namespace}_supported_components Development Application Documentation)

if(${_cmake_helpers_library_namespace}_FIND_COMPONENTS)
  foreach(_comp \${${_cmake_helpers_library_namespace}_FIND_COMPONENTS})
    if (NOT _comp IN_LIST _${_cmake_helpers_library_namespace}_supported_components)
      set(${_cmake_helpers_library_namespace}_FOUND False)
      set(${_cmake_helpers_library_namespace}_NOT_FOUND_MESSAGE \"Unsupported component: \${_comp}\")
    endif()
    set(_include \"\${CMAKE_CURRENT_LIST_DIR}/${_cmake_helpers_library_namespace}\${_comp}Targets.cmake\")
    if(EXISTS \${_include})
      include(\${_include})
    else()
      set(${_cmake_helpers_library_namespace}_FOUND False)
      set(${_cmake_helpers_library_namespace}_NOT_FOUND_MESSAGE \"Component not available: \${_comp}\")
      break()
    endif()
  endforeach()
else()
  foreach(_comp \${_${_cmake_helpers_library_namespace}_supported_components})
    set(_include \"\${CMAKE_CURRENT_LIST_DIR}/${_cmake_helpers_library_namespace}\${_comp}Targets.cmake\")
    if(EXISTS \${_include})
      include(\${_include})
    endif()
  endforeach()
endif()
")
  if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
    install(
      EXPORT ${_cmake_helpers_library_development_export_set_name}
      NAMESPACE ${_cmake_helpers_library_namespace}::
      DESTINATION ${CMAKE_HELPERS_INSTALL_CMAKEDIR}
      COMPONENT ${_cmake_helpers_library_library_component_name})
  endif()
  include(CMakePackageConfigHelpers)
  cmake_helpers_call(configure_package_config_file ${_export_cmake_config_in} ${_export_cmake_config_out}
    INSTALL_DESTINATION ${CMAKE_HELPERS_INSTALL_CMAKEDIR}
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
  )
  file(REMOVE ${_export_cmake_config_in})

  set(_export_cmake_configversion_out ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_HELPERS_INSTALL_CMAKEDIR}/${_cmake_helpers_library_namespace}ConfigVersion.cmake)
  cmake_helpers_call(write_basic_package_version_file ${_export_cmake_configversion_out}
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY ${_cmake_helpers_library_compatibility}
  )
  if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
    install(
      FILES ${_export_cmake_config_out} ${_export_cmake_configversion_out}
      DESTINATION ${CMAKE_HELPERS_INSTALL_CMAKEDIR}
      COMPONENT ${_cmake_helpers_library_library_component_name}
    )
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ------------------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Creating pkgconfig hooks")
    message(STATUS "[${_cmake_helpers_logprefix}] ------------------------")
  endif()
  #
  # Generate a file that will be overwriten by the post-install scripts
  #
  foreach(_cmake_helpers_library_install_target ${_cmake_helpers_library_install_targets})
    set(FIRE_POST_INSTALL_PKGCONFIG_PATH ${CMAKE_CURRENT_BINARY_DIR}/pc.${_cmake_helpers_library_namespace}/build/${_cmake_helpers_library_install_target}.pc)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] Generating dummy ${FIRE_POST_INSTALL_PKGCONFIG_PATH}")
    endif()
    file(WRITE ${FIRE_POST_INSTALL_PKGCONFIG_PATH} "# Content of this file is overwriten during install or package phases")
    if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
      install(FILES ${FIRE_POST_INSTALL_PKGCONFIG_PATH} DESTINATION ${CMAKE_HELPERS_INSTALL_PKGCONFIGDIR} COMPONENT ${_cmake_helpers_library_library_component_name})
    endif()
  endforeach()
  #
  # It is important to intall the pkgconfig hooks after the install rule, because withing a directory
  # install rules are executed in order
  #
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
  message(STATUS "[pc.@_cmake_helpers_library_namespace@/build] find_package(@_cmake_helpers_library_namespace@ @PROJECT_VERSION@ REQUIRED CONFIG COMPONENTS Development)")
endif()
find_package(@_cmake_helpers_library_namespace@ @PROJECT_VERSION@ REQUIRED CONFIG COMPONENTS Development)

#
# It is important to do static before shared, because shared will reuse static properties
#
set(_target_static)
foreach(_cmake_helpers_library_install_target @_cmake_helpers_library_install_targets@)
  set(_cmake_helpers_library_target @_cmake_helpers_library_namespace@::${_cmake_helpers_library_install_target})
  get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
  get_target_property(_cmake_helpers_library_interface_link_libraries ${_cmake_helpers_library_target} INTERFACE_LINK_LIBRARIES)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[pc.@_cmake_helpers_library_namespace@/build] ${_cmake_helpers_library_target} INTERFACE_LINK_LIBRARIES: ${_cmake_helpers_library_interface_link_libraries}")
  endif()
  set(_cmake_helpers_library_computed_requires)
  set(_cmake_helpers_library_computed_extra_libs)
  foreach(_cmake_helpers_library_interface_link_library ${_cmake_helpers_library_interface_link_libraries})
    if(TARGET ${_cmake_helpers_library_interface_link_library})
      #
      # Pkgconfig does not understand namespace::target - we keep target only
      #
      string(REGEX REPLACE ".*::" "" _cmake_helpers_library_computed_require ${_cmake_helpers_library_interface_link_library})
      list(APPEND _cmake_helpers_library_computed_requires ${_cmake_helpers_library_computed_require})
    else()
      #
      # This is not a known target : we will put that in the Libs section
      #
      get_filename_component(_filename_we ${_cmake_helpers_library_interface_link_library} NAME_WE)
      #
      # If the filename without extension is equal to the dependency, we assume it is candidate for the generic -lxxx syntax,
      # else we put the dependency as is.
      #
      if(_filename_we STREQUAL _cmake_helpers_library_interface_link_library)
        list(APPEND _cmake_helpers_library_computed_extra_libs "-l${_cmake_helpers_library_interface_link_library}")
      else()
        list(APPEND _cmake_helpers_library_computed_extra_libs "${_cmake_helpers_library_interface_link_library}")
      endif()
    endif()
  endforeach()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_NAME ${_cmake_helpers_library_install_target})
  if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@_cmake_helpers_library_namespace@ headers")
  elseif(_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@_cmake_helpers_library_namespace@ dynamic library")
  elseif(_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@_cmake_helpers_library_namespace@ module library")
  elseif(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@_cmake_helpers_library_namespace@ static library")
    set(_target_static ${_cmake_helpers_library_target})
  elseif(_cmake_helpers_library_target_type STREQUAL "OBJECT_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@_cmake_helpers_library_namespace@ object library")
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
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES PC_VERSION "@PROJECT_VERSION@")

  get_target_property(_location ${_cmake_helpers_library_target} LOCATION)
  set(_pc_libs)
  if(_location)
    cmake_path(GET _location FILENAME _filename)
    if((_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY") OR (_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY"))
      get_filename_component(_filename_we ${_filename} NAME_WE)
      if(NOT ("x${CMAKE_SHARED_LIBRARY_PREFIX}" STREQUAL "x"))
        string(REGEX REPLACE "^${CMAKE_SHARED_LIBRARY_PREFIX}" "" _filename_we ${_filename_we})
      endif()
      list(APPEND _pc_libs "-L\${libdir} -l${_filename_we}")
    elseif(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
      list(APPEND _pc_libs "\${libdir}/${_filename}")
    endif()
  else()
    #
    # This is not really a problem
    #
    # message(WARNING "Target ${_cmake_helpers_library_target} has no LOCATION property")
  endif()
  #
  # Append eventual extra libs
  #
  list(APPEND _pc_libs ${_cmake_helpers_library_computed_extra_libs})
  if(_pc_libs)
    list(JOIN _pc_libs " " _pc_libs_string)
    #
    # Append extra libs to the dependencies
    #
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_LIBS "${_pc_libs_string}")
  endif()
endforeach()

foreach(_cmake_helpers_library_install_target @_cmake_helpers_library_install_targets@)
  set(_cmake_helpers_library_target @_cmake_helpers_library_namespace@::${_cmake_helpers_library_install_target})
  set(_file "${CMAKE_PKGCONFIG_DIR}/${_cmake_helpers_library_install_target}.pc")
  message(STATUS "[pc.@_cmake_helpers_library_namespace@/build] Generating ${_file}")
  file(GENERATE OUTPUT ${_file}
     CONTENT [=[prefix=${pcfiledir}/../..
exec_prefix=${prefix}
bindir=${exec_prefix}/@CMAKE_HELPERS_INSTALL_BINDIR@
includedir=${prefix}/@CMAKE_HELPERS_INSTALL_INCLUDEDIR@
docdir=${prefix}/@CMAKE_HELPERS_INSTALL_DOCDIR@
libdir=${exec_prefix}/@CMAKE_HELPERS_INSTALL_LIBDIR@
mandir=${prefix}/@CMAKE_HELPERS_INSTALL_MANDIR@
man1dir=${prefix}/@CMAKE_HELPERS_INSTALL_MANDIR@1
man2dir=${prefix}/@CMAKE_HELPERS_INSTALL_MANDIR@2

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
execute_process(COMMAND "@CMAKE_COMMAND@" -G "@CMAKE_GENERATOR@" @_cmake_helpers_library_generator_platform_args@ @_cmake_helpers_library_generator_toolset_args@ -DCMAKE_HELPERS_DEBUG=@CMAKE_HELPERS_DEBUG@ -S "${proj}" -B "${proj}/build" COMMAND_ERROR_IS_FATAL ANY COMMAND_ECHO STDOUT)
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
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "set(CMAKE_MODULE_ROOT_PATH \"\$ENV{CMAKE_MODULE_ROOT_PATH_ENV}\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "set(CMAKE_PKGCONFIG_ROOT_PATH \"\$ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV}\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "if(CMAKE_HELPERS_DEBUG)\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] CMAKE_MODULE_ROOT_PATH: \\\"\${CMAKE_MODULE_ROOT_PATH}\\\"\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "  message(STATUS \"[fire_post_install.cmake] CMAKE_PKGCONFIG_ROOT_PATH: \\\"\${CMAKE_PKGCONFIG_ROOT_PATH}\\\"\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "endif()\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "message(STATUS \"[fire_post_install.cmake] include(${CMAKE_CURRENT_BINARY_DIR}/pc.${_cmake_helpers_library_namespace}/post-install.cmake)\")\n")
  file(APPEND ${FIRE_POST_INSTALL_CMAKE_PATH} "include(${CMAKE_CURRENT_BINARY_DIR}/pc.${_cmake_helpers_library_namespace}/post-install.cmake)\n")
  #
  # We CANNOT use CMAKE_INSTALL_PREFIX variable contrary to what is posted almost everywhere on the net: CPack will
  # will have a CMAKE_INSTALL_PREFIX different, the real and only way to know exactly where we install things is to
  # set the current working directory to ${DESTDIR}${CMAKE_INSTALL_PREFIX}, and use WORKING_DIRECTORY as the full install prefix dir.
  # Now take care: DESTDIR does not "work" on Windows if used as is, and CMake has a hook, that we replacate here
  #
  set(_hook [[

    set(_destination "${CMAKE_INSTALL_PREFIX}")
    cmake_path(CONVERT ${_destination} TO_CMAKE_PATH_LIST _destination NORMALIZE)
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
    cmake_path(IS_ABSOLUTE _destination _destination_is_absolute)
    if(NOT _destination_is_absolute)
      cmake_path(ABSOLUTE_PATH _destination NORMALIZE OUTPUT_VARIABLE _destination_absolute)
      message(STATUS "Destination changed from ${_destination} to ${_destination_absolute}")
      set(_destination "${_destination_absolute}")
    endif()
]])
  if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
    install(CODE ${_hook} COMPONENT ${_cmake_helpers_library_library_component_name})
    install(CODE "

    set(CPACK_IS_RUNNING \$ENV{CPACK_IS_RUNNING})
    #
    # We do not want to run this when it is CPack
    #
    if (NOT CPACK_IS_RUNNING)
      set(ENV{CMAKE_INSTALL_PREFIX_ENV} \"${CMAKE_INSTALL_PREFIX}\") # Variable may be empty
      set(ENV{CMAKE_MODULE_ROOT_PATH_ENV} \"\${_destination}/${CMAKE_HELPERS_INSTALL_CMAKEDIR}\")
      set(ENV{CMAKE_PKGCONFIG_ROOT_PATH_ENV} \"\${_destination}/${CMAKE_HELPERS_INSTALL_PKGCONFIGDIR}\")
      execute_process(COMMAND \"${CMAKE_COMMAND}\" -G \"${CMAKE_GENERATOR}\" -DCMAKE_HELPERS_DEBUG=${CMAKE_HELPERS_DEBUG} -P \"${FIRE_POST_INSTALL_CMAKE_PATH}\" WORKING_DIRECTORY \"\${_destination}\" COMMAND_ERROR_IS_FATAL ANY COMMAND_ECHO STDOUT)
    endif()
"
    COMPONENT ${_cmake_helpers_library_library_component_name}
    )
  endif()
  #
  # CPack specific pre-build script
  #
  set(_cmake_helpers_library_cpack_pre_build_script ${CMAKE_CURRENT_BINARY_DIR}/cpack_pre_build_script_pc_${_cmake_helpers_library_namespace}.cmake)
  file(WRITE ${_cmake_helpers_library_cpack_pre_build_script} "# Content of this file is overwriten during install or package phase")
  #
  # Apply dependencies
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ---------------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Applying dependencies")
    message(STATUS "[${_cmake_helpers_logprefix}] ---------------------")
  endif()
  if(_cmake_helpers_library_depends)
    #
    # We always use BUILD_LOCAL_INTERFACE to prevent the dependencies to appear in our export set
    #
    foreach(_cmake_helpers_library_target ${_cmake_helpers_library_targets})
      get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
      if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
	cmake_helpers_call(target_link_libraries ${_cmake_helpers_library_target} INTERFACE $<BUILD_LOCAL_INTERFACE:${_cmake_helpers_library_depends}>)
      else()
	cmake_helpers_call(target_link_libraries ${_cmake_helpers_library_target} PUBLIC $<BUILD_LOCAL_INTERFACE:${_cmake_helpers_library_depends}>)
      endif()
    endforeach()
  endif()
  #
  # Save additional dynamic directory properties
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ============================")
    message(STATUS "[${_cmake_helpers_logprefix}] Setting directory properties")
    message(STATUS "[${_cmake_helpers_logprefix}] ============================")
  endif()
  get_property(_cmake_helpers_namespaces DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_namespaces)
  if(NOT ${_cmake_helpers_library_namespace} IN_LIST _cmake_helpers_namespaces)
    cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} APPEND PROPERTY cmake_helpers_namespaces ${_cmake_helpers_library_namespace})
  endif()
  foreach(_cmake_helpers_have_type interface static shared module object)
    cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_have_${_cmake_helpers_library_namespace}_${_cmake_helpers_have_type}_library ${_cmake_helpers_have_${_cmake_helpers_library_namespace}_${_cmake_helpers_have_type}_library})
    get_property(_cmake_helpers_have_${_cmake_helpers_have_type}_libraries DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_have_${_cmake_helpers_have_type}_libraries)
    if((NOT _cmake_helpers_have_${_cmake_helpers_have_type}_libraries) AND _cmake_helpers_have_${_cmake_helpers_library_namespace}_${_cmake_helpers_have_type}_library)
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_have_${_cmake_helpers_have_type}_libraries TRUE)
    else()
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_have_${_cmake_helpers_have_type}_libraries FALSE)
    endif()
  endforeach()

  cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_library_${_cmake_helpers_library_namespace}_targets ${_cmake_helpers_library_targets})
  cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} APPEND PROPERTY cmake_helpers_library_targets ${_cmake_helpers_library_targets})

  cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_cpack_${_cmake_helpers_library_namespace}_cpack_pre_build_script ${_cmake_helpers_library_cpack_pre_build_script})
  cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} APPEND PROPERTY cmake_helpers_cpack_pre_build_scripts ${_cmake_helpers_library_cpack_pre_build_script})

  foreach(_cmake_helpers_component_type library header)
    cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_have_${_cmake_helpers_library_namespace}_${_cmake_helpers_component_type}_component ${_cmake_helpers_have_${_cmake_helpers_library_namespace}_${_cmake_helpers_component_type}_component})
    get_property(_cmake_helpers_have_${_cmake_helpers_component_type}_components DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_have_${_cmake_helpers_component_type}_components)
    if((NOT _cmake_helpers_have_${_cmake_helpers_component_type}_components) AND _cmake_helpers_have_${_cmake_helpers_library_namespace}_${_cmake_helpers_component_type}_component)
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_have_${_cmake_helpers_component_type}_components TRUE)
    else()
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_have_${_cmake_helpers_component_type}_components FALSE)
    endif()
    if(${_cmake_helpers_have_${_cmake_helpers_library_namespace}_${_cmake_helpers_component_type}_component})
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_library_${_cmake_helpers_library_namespace}_component_name ${_cmake_helpers_library_${_cmake_helpers_component_type}_component_name})
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} APPEND PROPERTY cmake_helpers_${_cmake_helpers_component_type}_component_names ${_cmake_helpers_library_${_cmake_helpers_component_type}_component_name})
    endif()
  endforeach()
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

function(_cmake_helpers_files_find type base_dirs globs prefix accept_relpath_regexes reject_relpath_regexes output_var relpath_output_var)
  set(_cmake_helpers_library_all_files)
  set(_cmake_helpers_library_all_relfiles)
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
	cmake_path(RELATIVE_PATH _file BASE_DIRECTORY ${_base_dir} OUTPUT_VARIABLE _relfile)
	cmake_helpers_match_accept_reject_regexes(${_relfile} "${accept_relpath_regexes}" "${reject_relpath_regexes}" _cmake_helpers_library_matched)
	if(_cmake_helpers_library_matched)
	  if(CMAKE_HELPERS_DEBUG)
	    message(STATUS "[${_cmake_helpers_logprefix}] ... ... ... relfile ${_relfile}")
	  endif()
	  list(APPEND _base_dir_files ${_file})
	  list(APPEND _cmake_helpers_library_all_relfiles ${_relfile})
	endif()
      endforeach()
    endforeach()
    if(_base_dir_files)
      cmake_helpers_call(source_group TREE ${_base_dir} PREFIX ${prefix} FILES ${_base_dir_files})
      list(APPEND _cmake_helpers_library_all_files ${_base_dir_files})
    endif()
  endforeach()
  set(${output_var} ${_cmake_helpers_library_all_files} PARENT_SCOPE)
  set(${relpath_output_var} ${_cmake_helpers_library_all_relfiles} PARENT_SCOPE)
endfunction()
