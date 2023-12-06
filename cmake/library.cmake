function(cmake_helpers_library)
  # ============================================================================================================
  # This module can generate one export set:
  #
  # - ${PROJECT_NAME}DevelopmentTargets
  #
  # This module can install six components:
  #
  # - ${PROJECT_NAME}RuntimeComponent
  # - ${PROJECT_NAME}LibraryComponent
  # - ${PROJECT_NAME}ArchiveComponent
  # - ${PROJECT_NAME}HeaderComponent
  # - ${PROJECT_NAME}CMakeConfigComponent
  # - ${PROJECT_NAME}PkgConfigComponent
  #
  # These directory properties are generated on ${CMAKE_CURRENT_BINARY_DIR}:
  #
  # - cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}RuntimeComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveLibraryComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}LibraryComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveArchiveComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}ArchiveComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveHeaderComponent          : Boolean indicating presence of COMPONENT ${PROJECT_NAME}HeaderComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveCMakeConfigComponent     : Boolean indicating presence of COMPONENT ${PROJECT_NAME}CMakeConfigComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HavePkgConfigComponent       : Boolean indicating presence of COMPONENT ${PROJECT_NAME}PkgConfigComponent
  # - cmake_helpers_property_${PROJECT_NAME}_LibraryTargets               : List of library targets
  #
  # Note that:
  # - An OBJECT library installs nothing
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
  # Constants
  #
  set(_cmake_helpers_library_properties
    HaveRuntimeComponent
    HaveLibraryComponent
    HaveArchiveComponent
    HaveHeaderComponent
    HaveCMakeConfigComponent
    HavePkgConfigComponent
  )
  set(_cmake_helpers_library_array_properties
    LibraryTargets
  )
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
  # Variables holding directory properties initialization.
  # They will be used at the end of this module.
  #
  foreach(_cmake_helpers_library_property ${_cmake_helpers_library_properties})
    cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_property} FALSE)
  endforeach()
  foreach(_cmake_helpers_library_array_property ${_cmake_helpers_library_array_properties})
    cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_array_property})
  endforeach()
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  #
  set(_options)
  set(_oneValueArgs
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
  set(_cmake_helpers_library_type_auto                            TRUE)
  set(_cmake_helpers_library_type_interface                       FALSE)
  set(_cmake_helpers_library_type_shared                          FALSE)
  set(_cmake_helpers_library_type_static                          FALSE)
  set(_cmake_helpers_library_type_module                          FALSE)
  set(_cmake_helpers_library_type_object                          FALSE)
  set(_cmake_helpers_library_target_name_auto                     TRUE)
  set(_cmake_helpers_library_target_name_interface                ${PROJECT_NAME}_iface)
  set(_cmake_helpers_library_target_name_shared                   ${PROJECT_NAME}_shared)
  set(_cmake_helpers_library_target_name_static                   ${PROJECT_NAME}_static)
  set(_cmake_helpers_library_target_name_module                   ${PROJECT_NAME}_module)
  set(_cmake_helpers_library_target_name_object                   ${PROJECT_NAME}_objs)
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
  set(_cmake_helpers_library_export_header_base_name              ${PROJECT_NAME})
  set(_cmake_helpers_library_export_header_macro_name             ${PROJECT_NAME}_EXPORT)
  set(_cmake_helpers_library_export_header_file_name              include/${PROJECT_NAME}/export.h)
  set(_cmake_helpers_library_export_header_static_define          ${PROJECT_NAME}_STATIC)
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
  set(_cmake_helpers_have_interface_library FALSE)
  set(_cmake_helpers_have_static_library FALSE)
  set(_cmake_helpers_have_shared_library FALSE)
  set(_cmake_helpers_have_module_library FALSE)
  set(_cmake_helpers_have_object_library FALSE)
  set(_cmake_helpers_library_valid_types)
  set(_cmake_helpers_library_export_header_target_from_type)
  if(_cmake_helpers_library_type_auto)
    #
    # In auto mode, only INTERFACE, or STATIC plus SHARED libraries can be triggered
    #
    if(NOT _cmake_helpers_library_sources)
      list(APPEND _cmake_helpers_library_valid_types interface)
      if(_cmake_helpers_library_target_name_auto)
        set(_cmake_helpers_library_target_name_interface ${PROJECT_NAME})
      endif()
    else()
      #
      # It is STATIC then SHARED - order is important, c.f. pkgconfig hooks
      #
      list(APPEND _cmake_helpers_library_valid_types static)
      if(_cmake_helpers_library_target_name_auto)
        set(_cmake_helpers_library_target_name_static ${PROJECT_NAME}_static)
      endif()
      list(APPEND _cmake_helpers_library_valid_types shared)
      if(_cmake_helpers_library_target_name_auto)
        set(_cmake_helpers_library_target_name_shared ${PROJECT_NAME})
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
    set(_cmake_helpers_have_${_cmake_helpers_library_valid_type}_library TRUE)
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
  foreach(_cmake_helpers_library_type ${_cmake_helpers_library_types})
    set(_cmake_helpers_library_target ${_cmake_helpers_library_type_${_cmake_helpers_library_type}_name})
    cmake_helpers_call(add_library ${_cmake_helpers_library_target} ${_cmake_helpers_library_type} ${_cmake_helpers_library_sources})
    list(APPEND cmake_helpers_property_${PROJECT_NAME}_LibraryTargets ${_cmake_helpers_library_target})
    message(STATUS "JDD : cmake_helpers_property_${PROJECT_NAME}_LibraryTargets = ${cmake_helpers_property_${PROJECT_NAME}_LibraryTargets}")
  endforeach()
  #
  # FILE_SETs
  # Headers are splitted in two FILE_SETs that share the same base dirs:
  # - Public headers go in the public file set "public_headers"
  # - Private headers go in the private file set "private_headers"
  # This is duplicating base_dirs in include directories, but there is no harm with that.
  #
  foreach(_cmake_helpers_library_target ${cmake_helpers_property_${PROJECT_NAME}_LibraryTargets})
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
	  NAME ${PROJECT_NAME}
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
  foreach(_cmake_helpers_library_target ${cmake_helpers_property_${PROJECT_NAME}_LibraryTargets})
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
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${PROJECT_NAME}_EXPORTS)
    elseif(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PUBLIC -D${_cmake_helpers_library_export_header_static_define})
    elseif(_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY")
    elseif(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
    elseif(_cmake_helpers_library_target_type STREQUAL "OBJECT_LIBRARY")
    else()
      message(FATAL_ERROR "Unsupported library type: ${_cmake_helpers_library_target_type}")
    endif()

    string(TOUPPER "${PROJECT_NAME}" PROJECT_NAME_toupper)

    if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${PROJECT_NAME_toupper}_VERSION_MAJOR=${PROJECT_VERSION_MAJOR})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${PROJECT_NAME_toupper}_VERSION_MINOR=${PROJECT_VERSION_MINOR})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${PROJECT_NAME_toupper}_VERSION_PATCH=${PROJECT_VERSION_PATCH})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} INTERFACE -D${PROJECT_NAME_toupper}_VERSION="${PROJECT_VERSION}")
    else()
      if(_cmake_helpers_library_ntrace)
	cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PRIVATE -D${PROJECT_NAME_toupper}_NTRACE -DNTRACE)
      endif()
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PUBLIC -D${PROJECT_NAME_toupper}_VERSION_MAJOR=${PROJECT_VERSION_MAJOR})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PUBLIC -D${PROJECT_NAME_toupper}_VERSION_MINOR=${PROJECT_VERSION_MINOR})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PUBLIC -D${PROJECT_NAME_toupper}_VERSION_PATCH=${PROJECT_VERSION_PATCH})
      cmake_helpers_call(target_compile_definitions ${_cmake_helpers_library_target} PUBLIC -D${PROJECT_NAME_toupper}_VERSION="${PROJECT_VERSION}")

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
	    cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent TRUE)
	    cmake_helpers_call(install
	      FILES ${_cmake_helpers_library_target_pdb_file}
	      DESTINATION ${CMAKE_HELPERS_INSTALL_BINDIR}
	      COMPONENT ${PROJECT_NAME}RuntimeComponent
	      OPTIONAL)
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
  # Install rules. Only for the top-level project unless CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO is FALSE.
  #
  if((NOT CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO) OR PROJECT_IS_TOP_LEVEL)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] ---------------------")
      message(STATUS "[${_cmake_helpers_logprefix}] Setting install rules")
      message(STATUS "[${_cmake_helpers_logprefix}] ---------------------")
    endif()
    #
    # We select the targets to install
    #
    set(_cmake_helpers_library_install_targets)
    foreach(_cmake_helpers_library_target ${cmake_helpers_property_${PROJECT_NAME}_LibraryTargets})
      get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
      if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
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
    if(_cmake_helpers_library_install_targets)
      foreach(_cmake_helpers_library_install_target ${_cmake_helpers_library_install_targets})
	get_target_property(_cmake_helpers_library_install_target_type ${_cmake_helpers_library_install_target} TYPE)
	if(_cmake_helpers_library_install_target_type STREQUAL "INTERFACE_LIBRARY")
	  #
	  # No binary data - c.f. the check below for public headers
	  #
	elseif(_cmake_helpers_library_install_target_type STREQUAL "MODULE_LIBRARY")
	  #
	  # Module libraries are always treated as library targets
	  #
	  cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveLibraryComponent TRUE)
	elseif(_cmake_helpers_library_install_target_type STREQUAL "STATIC_LIBRARY")
	  #
	  # Static libraries are always treated as archive targets
	  #
	  cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveArchiveComponent TRUE)
	elseif(_cmake_helpers_library_install_target_type STREQUAL "SHARED_LIBRARY")
	  #
	  # All Windows-based systems including Cygwin are DLL platforms
	  #
	  if(WIN32 OR CYGWIN)
	    #
	    # For DLL platforms the DLL part of a shared library is treated as a runtime target
	    # and the corresponding import library is treated as an archive target
	    #
	    cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent TRUE)
	    cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveArchiveComponent TRUE)
	  else()
	    #
	    # For non-DLL platforms shared libraries are treated as library targets
	    #
	    cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveLibraryComponent TRUE)
	  endif()
	elseif(_cmake_helpers_library_install_target_type STREQUAL "OBJECT_LIBRARY")
	  #
	  # An OBJECT library is not installable
	  #
	else()
	  message(FATAL_ERROR "Unsupported library type: ${_cmake_helpers_library_target_type}")
	endif()
      endforeach()
      #
      # Public headers
      #
      if(_cmake_helpers_public_headers)
	cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveHeaderComponent TRUE)
	cmake_helpers_call(set _cmake_helpers_install_files_set_public_header_args FILE_SET public_headers DESTINATION ${CMAKE_HELPERS_INSTALL_INCLUDEDIR} COMPONENT ${PROJECT_NAME}HeaderComponent)
      endif()
      cmake_helpers_call(install
	TARGETS                 ${_cmake_helpers_library_install_targets}
	EXPORT                  ${PROJECT_NAME}DevelopmentTargets
	RUNTIME                 DESTINATION ${CMAKE_HELPERS_INSTALL_BINDIR}     COMPONENT ${PROJECT_NAME}RuntimeComponent
	LIBRARY                 DESTINATION ${CMAKE_HELPERS_INSTALL_LIBDIR}     COMPONENT ${PROJECT_NAME}LibraryComponent
	ARCHIVE                 DESTINATION ${CMAKE_HELPERS_INSTALL_LIBDIR}     COMPONENT ${PROJECT_NAME}ArchiveComponent
	${_cmake_helpers_install_files_set_public_header_args}
      )

      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] ----------------------------------")
	message(STATUS "[${_cmake_helpers_logprefix}] Creating CMake configuration files")
	message(STATUS "[${_cmake_helpers_logprefix}] ----------------------------------")
      endif()
      cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveCMakeConfigComponent TRUE)
      #
      # CMake configuration files for import
      #
      set(_export_cmake_config_in ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_HELPERS_INSTALL_CMAKEDIR}/${PROJECT_NAME}Config.cmake.in)
      set(_export_cmake_config_out ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_HELPERS_INSTALL_CMAKEDIR}/${PROJECT_NAME}Config.cmake)
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
set(_${PROJECT_NAME}_supported_components Development Application Documentation)

if(${PROJECT_NAME}_FIND_COMPONENTS)
  foreach(_comp \${${PROJECT_NAME}_FIND_COMPONENTS})
    if (NOT _comp IN_LIST _${PROJECT_NAME}_supported_components)
      set(${PROJECT_NAME}_FOUND False)
      set(${PROJECT_NAME}_NOT_FOUND_MESSAGE \"Unsupported component: \${_comp}\")
    endif()
    set(_include \"\${CMAKE_CURRENT_LIST_DIR}/${PROJECT_NAME}\${_comp}Targets.cmake\")
    if(EXISTS \${_include})
      include(\${_include})
    else()
      set(${PROJECT_NAME}_FOUND False)
      set(${PROJECT_NAME}_NOT_FOUND_MESSAGE \"Component not available: \${_comp}\")
      break()
    endif()
  endforeach()
else()
  foreach(_comp \${_${PROJECT_NAME}_supported_components})
    set(_include \"\${CMAKE_CURRENT_LIST_DIR}/${PROJECT_NAME}\${_comp}Targets.cmake\")
    if(EXISTS \${_include})
      include(\${_include})
    endif()
  endforeach()
endif()
")
      install(
	EXPORT ${PROJECT_NAME}DevelopmentTargets
	NAMESPACE ${PROJECT_NAME}::
	DESTINATION ${CMAKE_HELPERS_INSTALL_CMAKEDIR}
	COMPONENT ${PROJECT_NAME}CMakeConfigComponent
      )

      include(CMakePackageConfigHelpers)
      cmake_helpers_call(configure_package_config_file ${_export_cmake_config_in} ${_export_cmake_config_out}
	INSTALL_DESTINATION ${CMAKE_HELPERS_INSTALL_CMAKEDIR}
	NO_SET_AND_CHECK_MACRO
	NO_CHECK_REQUIRED_COMPONENTS_MACRO
      )
      file(REMOVE ${_export_cmake_config_in})

      set(_export_cmake_configversion_out ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_HELPERS_INSTALL_CMAKEDIR}/${PROJECT_NAME}ConfigVersion.cmake)
      cmake_helpers_call(write_basic_package_version_file ${_export_cmake_configversion_out}
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY ${_cmake_helpers_library_compatibility}
      )
      cmake_helpers_call(install
	FILES ${_export_cmake_config_out} ${_export_cmake_configversion_out}
	DESTINATION ${CMAKE_HELPERS_INSTALL_CMAKEDIR}
	COMPONENT ${PROJECT_NAME}CMakeConfigComponent
      )
    endif()
    #
    # We create pkgconfighooks if we install cmake configuration files
    #
    if(cmake_helpers_property_${PROJECT_NAME}_HaveCMakeConfigComponent)
      # *****************************************************************************************
      # This will do the LAST install() - we generate something that call be called with cmake -P
      set(_cmake_helpers_library_pkgconfig_cmake_path ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig.cmake)
      # *****************************************************************************************
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] ------------------------")
	message(STATUS "[${_cmake_helpers_logprefix}] Creating pkgconfig hooks")
	message(STATUS "[${_cmake_helpers_logprefix}] ------------------------")
      endif()
      cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HavePkgConfigComponent TRUE)
      #
      # Create a pc.${PROJECT_NAME} directory
      #
      execute_process(
        COMMAND ${CMAKE_COMMAND} -E rm -rf ${CMAKE_CURRENT_BINARY_DIR}/pc.${PROJECT_NAME}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/pc.${PROJECT_NAME}
        COMMAND_ECHO STDOUT
        COMMAND_ERROR_IS_FATAL ANY
      )
      #
      # Generate a pc.in template that will be configured for every library
      # Note that it is difficult to tell CMake to generate a file that contains
      # generator expressions. The [[xxx]] syntax still evaluates them.
      # So we have to break the syntax inserting dummy things.
      #
      set(_cmake_helpers_library_pc_in ${CMAKE_CURRENT_BINARY_DIR}/pc.${PROJECT_NAME}/pc.in)
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] Generating ${_cmake_helpers_library_pc_in}")
      endif()
      file(CONFIGURE
      OUTPUT ${_cmake_helpers_library_pc_in}
      CONTENT [[prefix=${pcfiledir}/../..
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
]]
        @ONLY
        NEWLINE_STYLE LF
      )

      set(_cmake_helpers_library_CMakeLists ${CMAKE_CURRENT_BINARY_DIR}/pc.${PROJECT_NAME}/CMakeLists.txt)
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] Generating ${_cmake_helpers_library_CMakeLists}")
      endif()
      file(CONFIGURE
	OUTPUT ${_cmake_helpers_library_CMakeLists}
	CONTENT [[
cmake_minimum_required(VERSION 3.16)
project(pc_@PROJECT_NAME@)

option(CMAKE_HELPERS_DEBUG "CMake Helpers debug" OFF)
set(_cmake_helpers_logprefix "cmake_helpers/@PROJECT_NAME@/library/pc.@PROJECT_NAME@/build")
if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[${_cmake_helpers_logprefix}] ========")
  message(STATUS "[${_cmake_helpers_logprefix}] Starting")
  message(STATUS "[${_cmake_helpers_logprefix}] ========")
  message(STATUS "[${_cmake_helpers_logprefix}] CMAKE_HELPERS_PKGCONFIGDIR: ${CMAKE_HELPERS_PKGCONFIGDIR}")
  message(STATUS "[${_cmake_helpers_logprefix}] CMAKE_HELPERS_CMAKEDIR    : ${CMAKE_HELPERS_CMAKEDIR}")
endif()

if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[${_cmake_helpers_logprefix}] find_package(@PROJECT_NAME@ @PROJECT_VERSION@ REQUIRED CONFIG COMPONENTS Development)")
endif()
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_HELPERS_CMAKEDIR})
find_package(@PROJECT_NAME@ @PROJECT_VERSION@ REQUIRED CONFIG COMPONENTS Development)
#
# It is important to do static before shared, because shared will reuse static properties
#
set(_target_static)
foreach(_cmake_helpers_library_install_target @_cmake_helpers_library_install_targets@)
  set(_cmake_helpers_library_target @PROJECT_NAME@::${_cmake_helpers_library_install_target})
  get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
  get_target_property(_cmake_helpers_library_interface_link_libraries ${_cmake_helpers_library_target} INTERFACE_LINK_LIBRARIES)
  if(CMAKE_HELPERS_DEBUG)
    if(${_cmake_helpers_library_interface_link_libraries})
      message(STATUS "[${_cmake_helpers_logprefix}] ${_cmake_helpers_library_target} INTERFACE_LINK_LIBRARIES: ${_cmake_helpers_library_interface_link_libraries}")
    else()
      #
      # We prefer no string instead of _cmake_helpers_library_interface_link_libraries-NOTFOUND
      #
      message(STATUS "[${_cmake_helpers_logprefix}] ${_cmake_helpers_library_target} INTERFACE_LINK_LIBRARIES:")
    endif()
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
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@PROJECT_NAME@ headers")
  elseif(_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@PROJECT_NAME@ dynamic library")
  elseif(_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@PROJECT_NAME@ module library")
  elseif(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@PROJECT_NAME@ static library")
    set(_target_static ${_cmake_helpers_library_target})
  elseif(_cmake_helpers_library_target_type STREQUAL "OBJECT_LIBRARY")
    set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "@PROJECT_NAME@ object library")
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
  set(_cmake_helpers_library_target @PROJECT_NAME@::${_cmake_helpers_library_install_target})
  set(_file "${CMAKE_HELPERS_PKGCONFIGDIR}/${_cmake_helpers_library_install_target}.pc")
  message(STATUS "[${_cmake_helpers_logprefix}] Generating ${_file}")
  file(GENERATE OUTPUT ${_file}
    INPUT ${CMAKE_CURRENT_SOURCE_DIR}/pc.in
    TARGET ${_cmake_helpers_library_target}
    NEWLINE_STYLE LF
  )
endforeach()

if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[${_cmake_helpers_logprefix}] ======")
  message(STATUS "[${_cmake_helpers_logprefix}] Ending")
  message(STATUS "[${_cmake_helpers_logprefix}] ======")
endif()
]]
        @ONLY
        NEWLINE_STYLE LF
      )
      #
      # Register a file for install that will be overwriten by the very last install(CODE ...) script - see just after this foreach() loop
      #
      foreach(_cmake_helpers_library_install_target ${_cmake_helpers_library_install_targets})
	set(_cmake_helpers_library_pc ${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_library_install_target}.pc)
	if(CMAKE_HELPERS_DEBUG)
	  message(STATUS "[${_cmake_helpers_logprefix}] Generating dummy ${_cmake_helpers_library_pc}")
	endif()
	file(WRITE ${_cmake_helpers_library_pc} "# Content of this file is overwriten during install or package phases")
	cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HavePkgConfigComponent TRUE)
	cmake_helpers_call(install
	  FILES ${_cmake_helpers_library_pc}
	  DESTINATION ${CMAKE_HELPERS_INSTALL_PKGCONFIGDIR}
	  COMPONENT ${PROJECT_NAME}PkgConfigComponent
	)
      endforeach()
      #
      # It is important to intall the pkgconfig hooks as the LAST install rule, because withing a directory
      # install rules are executed in order
      #
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] Generating pkgconfig.cmake")
      endif()
      file(WRITE ${_cmake_helpers_library_pkgconfig_cmake_path} "  set(_cmake_helpers_logprefix \"cmake_helpers/${PROJECT_NAME}/library/pkgconfig\")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS \"[\${_cmake_helpers_logprefix}] ========\")
    message(STATUS \"[\${_cmake_helpers_logprefix}] Starting\")
    message(STATUS \"[\${_cmake_helpers_logprefix}] ========\")
  endif()
  set(_destination \${CMAKE_INSTALL_PREFIX})
  cmake_path(CONVERT \"\${_destination}\" TO_CMAKE_PATH_LIST _destination NORMALIZE)
  if(\$ENV{DESTDIR})
    cmake_path(CONVERT \"\$ENV{DESTDIR}\" TO_CMAKE_PATH_LIST _destdir NORMALIZE)
    string(LENGTH \${_destination} _destination_length)
    if(_destination_length GREATER 1)
      string(SUBSTRING \"\${_destination}\" 0 1 _ch1)
      string(SUBSTRING \"\${_destination}\" 1 1 _ch2)
      set(_ch3 0)
      if(_destination_length GREATER 2)
        string(SUBSTRING \"\${_destination}\" 2 1 _ch3)
      endif()
      set(_skip 0)
      if(NOT (ch1 STREQUAL \"/\"))
        set(_relative 0)
        if((((_ch1 STRGREATER_EQUAL \"a\") AND (_ch1 STRLESS_EQUAL \"z\")) OR ((_ch1 STRGREATER_EQUAL \"A\") AND (_ch1 STRLESS_EQUAL \"Z\"))) AND (_ch2 STREQUAL \":\"))
          #
          # Assume Windows
          #
          set(_skip 2)
          if(NOT (_ch3 STREQUAL \"/\"))
            set(_relative 1)
          endif()
        else()
          set(_relative 1)
        endif()
        if (_relative)
          message(FATAL_ERROR \"Called with relative DESTINATION. This does not make sense when using DESTDIR. Specify absolute path or remove DESTDIR environment variable.\")
        endif()
      else()
        if(_ch2 STREQUAL \"/\")
          #
          # Looks like a network path
          #
          message(FATAL_ERROR \"Called with network path DESTINATION. This does not make sense when using DESTDIR. Specify local absolute path or remove DESTDIR environment variable.\nCMAKE_INSTALL_PREFIX=\${CMAKE_INSTALL_PREFIX}\n\")
        endif()
      endif()
    endif()
    string(SUBSTRING \"\${_destination}\" \${_skip} -1 _destination)
    #
    # Make sure that _destdir ends with a \"/\"
    #
    string(REGEX MATCH [[/\$]] _destdir_match \${_destdir})
    if(_destdir_match)
      set(_destination \"\${_destdir}\${_destination}\")
    else()
      set(_destination \"\${_destdir}/\${_destination}\")
    endif()
  endif()
  cmake_path(IS_ABSOLUTE _destination _destination_is_absolute)
  if(NOT _destination_is_absolute)
    cmake_path(ABSOLUTE_PATH _destination NORMALIZE OUTPUT_VARIABLE _destination_absolute)
    set(_destination \${_destination_absolute})
  endif()
  set(_cmake_helpers_pkgconfigdir \${_destination}/${CMAKE_HELPERS_INSTALL_PKGCONFIGDIR})
  set(_cmake_helpers_cmakedir \${_destination}/${CMAKE_HELPERS_INSTALL_CMAKEDIR})
  #
  # CMake config files for the project has already beeing installed prior to this CODE hook
  #
  # set(ENV{${PROJECT_NAME}_DIR} \"\${_destination}/${CMAKE_HELPERS_INSTALL_CMAKEDIR}\")
  execute_process(
    COMMAND \"${CMAKE_COMMAND}\" -DCMAKE_HELPERS_PKGCONFIGDIR=\${_cmake_helpers_pkgconfigdir} -DCMAKE_HELPERS_CMAKEDIR=\${_cmake_helpers_cmakedir} -DCMAKE_HELPERS_DEBUG=\${CMAKE_HELPERS_DEBUG} -S \"pc.${PROJECT_NAME}\" -B \"pc.${PROJECT_NAME}/build\"
    COMMAND_ECHO STDOUT
    COMMAND_ERROR_IS_FATAL ANY
  )
"
    )
    endif()
    install(CODE "  set(_cmake_helpers_library_pkgconfig_cmake_path \"${_cmake_helpers_library_pkgconfig_cmake_path}\")
  message(STATUS \"Executing \${_cmake_helpers_library_pkgconfig_cmake_path}\")\n
  set(_cmake_install_prefix \${CMAKE_INSTALL_PREFIX})
  set(_cmake_helpers_install_pkgconfigdir \"${CMAKE_HELPERS_INSTALL_PKGCONFIGDIR}\")
  set(_cmake_helpers_install_cmakedir \"${CMAKE_HELPERS_INSTALL_CMAKEDIR}\")
  set(_cmake_helpers_debug \"${CMAKE_HELPERS_DEBUG}\")
  set(_cmake_helpers_library_pkgconfig_cmake_path \"${_cmake_helpers_library_pkgconfig_cmake_path}\")
  set(_cmake_current_binary_dir \"${CMAKE_CURRENT_BINARY_DIR}\")
  execute_process(
    COMMAND \"${CMAKE_COMMAND}\" -DCMAKE_INSTALL_PREFIX=\${_cmake_install_prefix} -DCMAKE_HELPERS_INSTALL_PKGCONFIGDIR=\${_cmake_helpers_install_pkgconfigdir} -DCMAKE_HELPERS_INSTALL_CMAKEDIR=\${_cmake_helpers_install_cmakedir} -DCMAKE_HELPERS_DEBUG=\${_cmake_helpers_debug} -P \${_cmake_helpers_library_pkgconfig_cmake_path}
    WORKING_DIRECTORY \${_cmake_current_binary_dir}
    COMMAND_ECHO STDOUT
    COMMAND_ERROR_IS_FATAL ANY
   )
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS \"[\${_cmake_helpers_logprefix}] ======\")
    message(STATUS \"[\${_cmake_helpers_logprefix}] Ending\")
    message(STATUS \"[\${_cmake_helpers_logprefix}] ======\")
  endif()
"
    )
  endif()
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
    foreach(_cmake_helpers_library_target ${cmake_helpers_property_${PROJECT_NAME}_LibraryTargets})
      get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
      if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
	cmake_helpers_call(target_link_libraries ${_cmake_helpers_library_target} INTERFACE $<BUILD_LOCAL_INTERFACE:${_cmake_helpers_library_depends}>)
      else()
	cmake_helpers_call(target_link_libraries ${_cmake_helpers_library_target} PUBLIC $<BUILD_LOCAL_INTERFACE:${_cmake_helpers_library_depends}>)
      endif()
    endforeach()
  endif()
  #
  # Save properties
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ============================")
    message(STATUS "[${_cmake_helpers_logprefix}] Setting directory properties")
    message(STATUS "[${_cmake_helpers_logprefix}] ============================")
  endif()
  foreach(_cmake_helpers_library_property ${_cmake_helpers_library_properties})
    if(cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_property})
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_BINARY_DIR} PROPERTY cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_property} ${cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_property}})
    endif()
  endforeach()
  foreach(_cmake_helpers_library_array_property ${_cmake_helpers_library_array_properties})
    if(cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_array_property})
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_BINARY_DIR} APPEND PROPERTY cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_array_property} ${cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_array_property}})
    endif()
  endforeach()
  #
  # Send-out the targets
  #
  set(${_cmake_helpers_library_targets_outvar} "${cmake_helpers_property_${PROJECT_NAME}_LibraryTargets}" PARENT_SCOPE)
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
