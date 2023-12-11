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
  # - ${PROJECT_NAME}ConfigComponent
  #
  # These directory properties are generated on ${CMAKE_CURRENT_BINARY_DIR}:
  #
  # - cmake_helpers_property_${PROJECT_NAME}_HaveRuntimeComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}RuntimeComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveLibraryComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}LibraryComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveArchiveComponent         : Boolean indicating presence of COMPONENT ${PROJECT_NAME}ArchiveComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveHeaderComponent          : Boolean indicating presence of COMPONENT ${PROJECT_NAME}HeaderComponent
  # - cmake_helpers_property_${PROJECT_NAME}_HaveConfigComponent          : Boolean indicating presence of COMPONENT ${PROJECT_NAME}ConfigComponent
  # - cmake_helpers_property_${PROJECT_NAME}_PkgConfigHookScript          : Script that generates pkgconfig files after install phase
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
    HaveConfigComponent
    PkgConfigHookScript
  )
  set(_cmake_helpers_library_array_properties
    LibraryTargets
  )
  #
  # CMAKE_COMMAND common parameters in execute_process
  #
  if(CMAKE_GENERATOR)
    set(_cmake_helpers_cmake_command_generator_option "-G" "${CMAKE_GENERATOR}")
  else()
    set(_cmake_helpers_cmake_command_generator_option)
  endif()
  if(CMAKE_GENERATOR_TOOLSET)
    set(_cmake_helpers_cmake_command_generator_toolset_option "-T" "${CMAKE_GENERATOR_TOOLSET}")
  else()
    set(_cmake_helpers_cmake_command_generator_toolset_option)
  endif()
  if(CMAKE_GENERATOR_PLATFORM)
    set(_cmake_helpers_cmake_command_generator_platform_option "-A" "${CMAKE_GENERATOR_PLATFORM}")
  else()
    #
    # Hook only for Visual Studio Win32/Win64. It is strongly advisable to SET the -A option
    # on the command-line.
    #
    if(CMAKE_GENERATOR MATCHES "Visual Studio")
      if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(_cmake_helpers_cmake_command_generator_platform_option "-A" "Win64")
      elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
	set(_cmake_helpers_cmake_command_generator_platform_option "-A" "Win32")
      else()
	set(_cmake_helpers_cmake_command_generator_platform_option)
      endif()
    else()
      set(_cmake_helpers_cmake_command_generator_platform_option)
    endif()
  endif()
  set(_cmake_helpers_cmake_command
    ${CMAKE_COMMAND}
    ${_cmake_helpers_cmake_command_generator_option}
    ${_cmake_helpers_cmake_command_generator_platform_option}
    ${_cmake_helpers_cmake_command_generator_toolset_option}
  )
  #
  # Variables holding directory properties initialization.
  # They will be used at the end of this module.
  #
  foreach(_cmake_helpers_library_property IN LISTS _cmake_helpers_library_properties)
    cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_property} FALSE)
  endforeach()
  foreach(_cmake_helpers_library_array_property IN LISTS _cmake_helpers_library_array_properties)
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
    DEPENDS_EXT
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
  set(_cmake_helpers_library_depends_ext)
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
  # A variable to echo execute_process commands in debug mode
  #
  if(CMAKE_HELPERS_DEBUG)
    set(_cmake_helpers_process_command_echo_stdout "COMMAND_ECHO" "STDOUT")
  else()
    set(_cmake_helpers_process_command_echo_stdout)
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
    foreach(_cmake_helpers_library_find_dependency IN LISTS _cmake_helpers_library_find_dependencies)
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
      # It is STATIC and SHARED
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
  foreach(_cmake_helpers_library_valid_type IN LISTS _cmake_helpers_library_valid_types)
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
  foreach(_cmake_helpers_library_type IN LISTS _cmake_helpers_library_types)
    set(_cmake_helpers_library_target ${_cmake_helpers_library_type_${_cmake_helpers_library_type}_name})
    cmake_helpers_call(add_library ${_cmake_helpers_library_target} ${_cmake_helpers_library_type} ${_cmake_helpers_library_sources})
    list(APPEND cmake_helpers_property_${PROJECT_NAME}_LibraryTargets ${_cmake_helpers_library_target})
  endforeach()
  #
  # FILE_SETs
  # Headers are splitted in two FILE_SETs that share the same base dirs:
  # - Public headers go in the public file set "public_headers"
  # - Private headers go in the private file set "private_headers"
  # This is duplicating base_dirs in include directories, but there is no harm with that.
  #
  foreach(_cmake_helpers_library_target IN LISTS cmake_helpers_property_${PROJECT_NAME}_LibraryTargets)
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
      foreach(_file IN LISTS _cmake_helpers_${_cmake_helpers_header_type}_headers)
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
    foreach(_cmake_helpers_library_pod IN LISTS _cmake_helpers_library_pods)
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
  foreach(_cmake_helpers_library_target IN LISTS cmake_helpers_property_${PROJECT_NAME}_LibraryTargets)
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
    foreach(_cmake_helpers_library_target IN LISTS cmake_helpers_property_${PROJECT_NAME}_LibraryTargets)
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
      foreach(_cmake_helpers_library_install_target IN LISTS _cmake_helpers_library_install_targets)
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
      cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_HaveConfigComponent TRUE)
      #
      # CMake configuration files for import
      #
      set(_export_cmake_config_in ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_HELPERS_INSTALL_CMAKEDIR}/${PROJECT_NAME}Config.cmake.in)
      set(_export_cmake_config_out ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_HELPERS_INSTALL_CMAKEDIR}/${PROJECT_NAME}Config.cmake)
      file(WRITE ${_export_cmake_config_in} "
@PACKAGE_INIT@

include(CMakeFindDependencyMacro)
set(_find_depends \"${_cmake_helpers_library_find_dependencies}\")
foreach(_find_depend IN LISTS _find_depends)
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
  foreach(_comp IN LISTS ${PROJECT_NAME}_FIND_COMPONENTS)
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
  foreach(_comp IN LISTS _${PROJECT_NAME}_supported_components)
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
	COMPONENT ${PROJECT_NAME}ConfigComponent
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
	COMPONENT ${PROJECT_NAME}ConfigComponent
      )
    endif()
    #
    # We create pkgconfighooks if we install cmake configuration files
    #
    if(cmake_helpers_property_${PROJECT_NAME}_HaveConfigComponent)
      # *****************************************************************************************
      # This will do the LAST install() - we generate something that call be called with cmake -P
      cmake_helpers_call(set cmake_helpers_property_${PROJECT_NAME}_PkgConfigHookScript ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig.cmake)
      # *****************************************************************************************
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] ------------------------")
	message(STATUS "[${_cmake_helpers_logprefix}] Creating pkgconfig hooks")
	message(STATUS "[${_cmake_helpers_logprefix}] ------------------------")
      endif()
      #
      # Create a pc.${PROJECT_NAME} directory
      #
      execute_process(
        COMMAND ${CMAKE_COMMAND} -E rm -rf ${CMAKE_CURRENT_BINARY_DIR}/pc.${PROJECT_NAME}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/pc.${PROJECT_NAME}
	${_cmake_helpers_process_command_echo_stdout}
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
Version: $<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_VERSION>
Requires: $<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_REQUIRES>
Requires.private: $<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_REQUIRES_PRIVATE>
Cflags: $<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_CFLAGS>
Cflags.private: $<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_CFLAGS_PRIVATE>
Libs: $<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_LIBS>
Libs.private: $<TARGET_PROPERTY:_CMAKE_HELPERS_LIBRARY_PC_LIBS_PRIVATE>
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

list(APPEND CMAKE_PREFIX_PATH ${CMAKE_HELPERS_CMAKEDIR})
#
# We are going to do a find_package, so we also need to collect the dependencies we
# installed locally.
#
set(_cmake_helpers_install_path "@PROJECT_BINARY_DIR@/cmake_helpers_install")
file(GLOB_RECURSE _cmakes LIST_DIRECTORIES|false ${_cmake_helpers_install_path}/*.cmake)
set(_cmake_helpers_depend_prefix_paths)
foreach(_cmake IN LISTS _cmakes)
  get_filename_component(_dir ${_cmake} DIRECTORY)
  if(NOT _dir IN_LIST _cmake_helpers_depend_prefix_paths)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] Found CMake prefix path: ${_dir}")
    endif()
    list(APPEND _cmake_helpers_depend_prefix_paths ${_dir})
  endif()
endforeach()
list(APPEND CMAKE_PREFIX_PATH ${_cmake_helpers_depend_prefix_paths})
set(CMAKE_FIND_USE_CMAKE_PATH TRUE)
if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[${_cmake_helpers_logprefix}] CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
  message(STATUS "[${_cmake_helpers_logprefix}] find_package(@PROJECT_NAME@ @PROJECT_VERSION@ REQUIRED CONFIG COMPONENTS Development)")
endif()
find_package(@PROJECT_NAME@ @PROJECT_VERSION@ REQUIRED CONFIG COMPONENTS Development)
#
# Helper that transform a filename to a pkgconfig link
#
function(filename_to_pc_lib location pc_lib)
  cmake_path(GET location FILENAME _filename)
  #
  # We guess if the -lxxx is ok - this is not perfect and use CMake conventions
  # Only shared library case is special, any other, include MODULE_LIBRARY, is not
  # handled
  #
  set(_linkname ${_filename})
  if(CMAKE_SHARED_LIBRARY_PREFIX)
    string(REGEX REPLACE "^${CMAKE_SHARED_LIBRARY_PREFIX}" "" _linkname ${_linkname})
  endif()
  set(_can_l_syntax FALSE)
  string(LENGTH ${_linkname} _linkname_length)
  foreach(_suffix ${CMAKE_SHARED_LIBRARY_SUFFIX} ${CMAKE_EXTRA_SHARED_LIBRARY_SUFFIXES})
    string(LENGTH ${_suffix} _suffix_length)
    if(_linkname_length GREATER _suffix_length)
      math(EXPR _expected_indice "${_linkname_length} - ${_suffix_length}")
      string(FIND ${_linkname} ${_suffix} _indice REVERSE)
      if(_indice EQUAL _expected_indice)
	string(SUBSTRING "${_linkname}" 0 ${_indice} _linkname)
	set(_can_l_syntax TRUE)
	break()
      endif()
    endif()
  endforeach()
  if(_can_l_syntax)
    set(_pc_lib ${_linkname})
  else()
    set(_pc_lib "\${libdir}/${_filename}")
  endif()
  set(pc_lib ${_pc_lib} PARENT_SCOPE)
endfunction()

#
# We collect all types in _cmake_helpers_library_target_types
# For each type we have
# _cmake_helpers_library_${_cmake_helpers_library_target_type}_target
# _cmake_helpers_library_${_cmake_helpers_library_target_type}_links
# _cmake_helpers_library_${_cmake_helpers_library_target_type}_defs
# _cmake_helpers_library_${_cmake_helpers_library_target_type}_private_links
# _cmake_helpers_library_${_cmake_helpers_library_target_type}_private_defs
#
foreach(_cmake_helpers_library_install_target @_cmake_helpers_library_install_targets@)
  #
  # Get target name
  #
  set(_cmake_helpers_library_target @PROJECT_NAME@::${_cmake_helpers_library_install_target})
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] Target: ${_cmake_helpers_library_target}")
  endif()
  #
  # Get target type
  #
  get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ... Type: ${_cmake_helpers_library_target_type}")
  endif()
  #
  # Set defs
  #
  get_target_property(_cmake_helpers_library_${_cmake_helpers_library_target_type}_defs ${_cmake_helpers_library_target} INTERFACE_COMPILE_DEFINITIONS)
  if(CMAKE_HELPERS_DEBUG)
    #
    # We do not want to have "xxx-NOTFOUND" printed out
    #
    if(_cmake_helpers_library_${_cmake_helpers_library_target_type}_defs)
      message(STATUS "[${_cmake_helpers_logprefix}] ... INTERFACE_COMPILE_DEFINITIONS: ${_cmake_helpers_library_${_cmake_helpers_library_target_type}_defs}")
    else()
      message(STATUS "[${_cmake_helpers_logprefix}] ... INTERFACE_COMPILE_DEFINITIONS:")
    endif()
  endif()
  #
  # Set links
  #
  get_target_property(_cmake_helpers_library_${_cmake_helpers_library_target_type}_links ${_cmake_helpers_library_target} INTERFACE_LINK_LIBRARIES)
  if(CMAKE_HELPERS_DEBUG)
    #
    # We do not want to have "xxx-NOTFOUND" printed out
    #
    if(_cmake_helpers_library_${_cmake_helpers_library_target_type}_links)
      message(STATUS "[${_cmake_helpers_logprefix}] ... INTERFACE_LINK_LIBRARIES: ${_cmake_helpers_library_${_cmake_helpers_library_target_type}_links}")
    else()
      message(STATUS "[${_cmake_helpers_logprefix}] ... INTERFACE_LINK_LIBRARIES:")
    endif()
  endif()
endforeach()
#
# If there are a static and a shared links, put in shared'd private_links the static's links and remove the duplicates
#
if(_cmake_helpers_library_STATIC_LIBRARY_links AND _cmake_helpers_library_SHARED_LIBRARY_links)
  set(_cmake_helpers_library_SHARED_LIBRARY_private_links ${_cmake_helpers_library_STATIC_LIBRARY_links})
  list(REMOVE_ITEM _cmake_helpers_library_SHARED_LIBRARY_private_links ${_cmake_helpers_library_SHARED_LIBRARY_links})
endif()
#
# If there are a static and a shared defs, put in shared'd private_defs the static's private_links and remove the duplicates
#
if(_cmake_helpers_library_STATIC_LIBRARY_defs AND _cmake_helpers_library_SHARED_LIBRARY_defs)
  set(_cmake_helpers_library_SHARED_LIBRARY_private_defs ${_cmake_helpers_library_STATIC_LIBRARY_defs})
  list(REMOVE_ITEM _cmake_helpers_library_SHARED_LIBRARY_private_defs ${_cmake_helpers_library_SHARED_LIBRARY_defs})
endif()
#
# Loop on all targets and assign target generated properties. Note that we always a string for convenience.
#
foreach(_cmake_helpers_library_install_target @_cmake_helpers_library_install_targets@)
  set(_cmake_helpers_library_target @PROJECT_NAME@::${_cmake_helpers_library_install_target})
  get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)

  set(_cmake_helpers_library_links         ${_cmake_helpers_library_${_cmake_helpers_library_target_type}_links})
  set(_cmake_helpers_library_defs          ${_cmake_helpers_library_${_cmake_helpers_library_target_type}_defs})
  set(_cmake_helpers_library_private_links ${_cmake_helpers_library_${_cmake_helpers_library_target_type}_private_links})
  set(_cmake_helpers_library_private_defs  ${_cmake_helpers_library_${_cmake_helpers_library_target_type}_private_defs})
  #
  # Name: the name of the target
  #
  set(_name ${_cmake_helpers_library_install_target})
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ... Name: ${_name}")
  endif()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_NAME ${_name})
  #
  # Description: custom based on library type
  #
  set(_description)
  if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
    set(_description "@PROJECT_NAME@ headers")
  elseif(_cmake_helpers_library_target_type STREQUAL "SHARED_LIBRARY")
    set(_description "@PROJECT_NAME@ dynamic library")
  elseif(_cmake_helpers_library_target_type STREQUAL "MODULE_LIBRARY")
    set(_description "@PROJECT_NAME@ module library")
  elseif(_cmake_helpers_library_target_type STREQUAL "STATIC_LIBRARY")
    set(_description "@PROJECT_NAME@ static library")
  elseif(_cmake_helpers_library_target_type STREQUAL "OBJECT_LIBRARY")
    set(_description "@PROJECT_NAME@ object library")
  else()
    message(FATAL_ERROR "Unsupported target type ${_cmake_helpers_library_target_type}")
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ... Description: ${_description}")
  endif()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_DESCRIPTION "${_description}")
  #
  # Version: the current project version
  #
  set(_version "@PROJECT_VERSION@")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ... Version: ${_version}")
  endif()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_VERSION "${_version}")
  #
  # Requires: known targets from _cmake_helpers_library_links
  #
  set(_requires)
  foreach(_cmake_helpers_library_link IN LISTS _cmake_helpers_library_links)
    if(TARGET ${_cmake_helpers_library_link})
      string(REGEX REPLACE ".*::" "" _cmake_helpers_library_link ${_cmake_helpers_library_link})
      list(APPEND _requires ${_cmake_helpers_library_link})
    endif()
  endforeach()
  list(JOIN _requires "," _requires)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ... Requires: ${_requires}")
  endif()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_REQUIRES "${_requires}")
  #
  # Requires.private: known targets from _cmake_helpers_library_private_links
  #
  set(_requires_private)
  foreach(_cmake_helpers_library_private_link IN LISTS _cmake_helpers_library_private_links)
    if(TARGET ${_cmake_helpers_library_private_link})
      string(REGEX REPLACE ".*::" "" _cmake_helpers_library_private_link ${_cmake_helpers_library_private_link})
      list(APPEND _requires_private ${_cmake_helpers_library_private_link})
    endif()
  endforeach()
  list(JOIN _requires_private "," _requires_private)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ... Requires.private: ${_requires_private}")
  endif()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_REQUIRES_PRIVATE "${_requires_private}")
  #
  # Cflags: compile definitions
  #
  set(_cflags "-I\${includedir}")
  foreach(_cmake_helpers_library_def IN LISTS _cmake_helpers_library_defs)
    list(APPEND _cflags "-D${_cmake_helpers_library_def}")
  endforeach()
  list(JOIN _cflags " " _cflags)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ... Cflags: ${_cflags}")
  endif()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_CFLAGS "${_cflags}")
  #
  # Cflags.private: private compile definitions
  #
  set(_cflags_private)
  foreach(_cmake_helpers_library_private_def IN LISTS _cmake_helpers_library_private_defs)
    list(APPEND _cflags_private "-D${_cmake_helpers_library_private_def}")
  endforeach()
  list(JOIN _cflags_private " " _cflags_private)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ... Cflags.private: ${_cflags_private}")
  endif()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_CFLAGS_PRIVATE "${_cflags_private_join}")
  #
  # Libs: unknown targets from _cmake_helpers_library_links
  #
  set(_libs)
  foreach(_cmake_helpers_library_link IN LISTS _cmake_helpers_library_links)
    if(NOT (TARGET ${_cmake_helpers_library_link}))
      get_filename_component(_filename ${_cmake_helpers_library_link} NAME)
      filename_to_pc_lib(location _pc_lib)
      list(APPEND _libs ${_pc_lib})
    endif()
  endforeach()
  list(JOIN _libs "," _libs)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ... Libs: ${_libs}")
  endif()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_LIBS "${_libs}")
  #
  # Libs.private: unknown targets from _cmake_helpers_library_private_links
  #
  set(_libs_private)
  foreach(_cmake_helpers_library_private_link IN LISTS _cmake_helpers_library_private_links)
    if(NOT (TARGET ${_cmake_helpers_library_private_link}))
      get_filename_component(_filename ${_cmake_helpers_library_private_link} NAME)
      filename_to_pc_lib(location _pc_lib)
      list(APPEND _libs_private ${_pc_lib})
    endif()
  endforeach()
  list(JOIN _libs_private "," _libs_private)
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ... Libs.private: ${_libs_private}")
  endif()
  set_target_properties(${_cmake_helpers_library_target} PROPERTIES _CMAKE_HELPERS_LIBRARY_PC_LIBS_PRIVATE "${_libs_private}")
  #
  # Generate .pc.in
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
      # Install dummy .pc files that will overwriten during install, c.f. install(CODE ...) below
      #
      foreach(_cmake_helpers_library_install_target IN LISTS _cmake_helpers_library_install_targets)
	set(_cmake_helpers_library_pc ${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_library_install_target}.pc)
	if(CMAKE_HELPERS_DEBUG)
	  message(STATUS "[${_cmake_helpers_logprefix}] Generating dummy ${_cmake_helpers_library_pc}")
	endif()
	file(WRITE ${_cmake_helpers_library_pc} "# Content of this file is overwriten during install or package phases")
	cmake_helpers_call(install
	  FILES ${_cmake_helpers_library_pc}
	  DESTINATION ${CMAKE_HELPERS_INSTALL_PKGCONFIGDIR}
	  COMPONENT ${PROJECT_NAME}ConfigComponent
	)
      endforeach()
      #
      # Generate a cmake file that will process CMAKE_INSTALL_PREFIX to send correct parameters
      # to a generated CMake project, the later will generate the .pc files using the CMake config files
      #
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] Generating pkgconfig.cmake")
      endif()
      file(WRITE ${cmake_helpers_property_${PROJECT_NAME}_PkgConfigHookScript} "  set(_cmake_helpers_logprefix \"cmake_helpers/${PROJECT_NAME}/library/pkgconfig\")
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
    # COMMAND \"${CMAKE_COMMAND}\" -DCMAKE_HELPERS_PKGCONFIGDIR=\${_cmake_helpers_pkgconfigdir} -DCMAKE_HELPERS_CMAKEDIR=\${_cmake_helpers_cmakedir} -DCMAKE_HELPERS_DEBUG=\${CMAKE_HELPERS_DEBUG} -S \"pc.${PROJECT_NAME}\" -B \"pc.${PROJECT_NAME}/build\"
    COMMAND \"${CMAKE_COMMAND}\" ${_cmake_helpers_cmake_command_generator_option} ${_cmake_helpers_cmake_command_generator_platform_option} ${_cmake_helpers_cmake_command_generator_toolset_option} --debug-find -DCMAKE_HELPERS_PKGCONFIGDIR=\${_cmake_helpers_pkgconfigdir} -DCMAKE_HELPERS_CMAKEDIR=\${_cmake_helpers_cmakedir} -DCMAKE_HELPERS_DEBUG=ON -S \"pc.${PROJECT_NAME}\" -B \"pc.${PROJECT_NAME}/build\"
    ${_cmake_helpers_process_command_echo_stdout}
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
    # Install CODE hook for the ConfigComponent
    #
    install(CODE "    message(STATUS \"Executing pkgconfig hooks\")
  set(_cmake_install_prefix \${CMAKE_INSTALL_PREFIX})
  # message(STATUS \"... CMAKE_INSTALL_PREFIX              : \${_cmake_install_prefix}\")\n

  set(_cmake_current_binary_dir \"${CMAKE_CURRENT_BINARY_DIR}\")
  # message(STATUS \"... CMAKE_CURRENT_BINARY_DIR          : \${_cmake_current_binary_dir}\")\n

  set(_cmake_helpers_install_pkgconfigdir \"${CMAKE_HELPERS_INSTALL_PKGCONFIGDIR}\")
  # message(STATUS \"... CMAKE_HELPERS_INSTALL_PKGCONFIGDIR: \${_cmake_helpers_install_pkgconfigdir}\")\n

  set(_cmake_helpers_install_cmakedir \"${CMAKE_HELPERS_INSTALL_CMAKEDIR}\")
  # message(STATUS \"... CMAKE_HELPERS_INSTALL_CMAKEDIR    : \${_cmake_helpers_install_cmakedir}\")\n

  set(_cmake_helpers_debug \"${CMAKE_HELPERS_DEBUG}\")
  # message(STATUS \"... CMAKE_HELPERS_DEBUG               : \${_cmake_helpers_debug}\")\n

  set(_script \"${cmake_helpers_property_${PROJECT_NAME}_PkgConfigHookScript}\")
  execute_process(
    COMMAND \"${CMAKE_COMMAND}\" ${_cmake_helpers_cmake_command_generator_option} ${_cmake_helpers_cmake_command_generator_platform_option} ${_cmake_helpers_cmake_command_generator_toolset_option} -DCMAKE_INSTALL_PREFIX=\${_cmake_install_prefix} -DCMAKE_HELPERS_INSTALL_PKGCONFIGDIR=\${_cmake_helpers_install_pkgconfigdir} -DCMAKE_HELPERS_INSTALL_CMAKEDIR=\${_cmake_helpers_install_cmakedir} -DCMAKE_HELPERS_DEBUG=\${_cmake_helpers_debug} -P \${_script}
    WORKING_DIRECTORY \${_cmake_current_binary_dir}
    ${_cmake_helpers_process_command_echo_stdout}
    COMMAND_ERROR_IS_FATAL ANY
   )
"
      COMPONENT ${PROJECT_NAME}ConfigComponent
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
  #
  # DEPENDS This must be a list of two items at every iteration: scope, lib
  #
  list(LENGTH _cmake_helpers_library_depends _cmake_helpers_library_depends_length)
  math(EXPR _cmake_helpers_library_depends_length_modulo_2 "${_cmake_helpers_library_depends_length} % 2")
  if(NOT(_cmake_helpers_library_depends_length_modulo_2 EQUAL 0))
    message(FATAL_ERROR "DEPENDS option value must be a list of two items: scope, lib")
  endif()
  if(_cmake_helpers_library_depends)
    math(EXPR _cmake_helpers_library_depends_length_i_max "(${_cmake_helpers_library_depends_length} / 2) - 1")
    set(_j -1)
    foreach(_i RANGE 0 ${_cmake_helpers_library_depends_length_i_max})
      math(EXPR _j "${_j} + 1")
      list(GET _cmake_helpers_library_depends ${_j} _cmake_helpers_library_depend_scope)
      math(EXPR _j "${_j} + 1")
      list(GET _cmake_helpers_library_depends ${_j} _cmake_helpers_library_depend_lib)
      foreach(_cmake_helpers_library_target IN LISTS cmake_helpers_property_${PROJECT_NAME}_LibraryTargets)
	get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
	if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
	  #
	  # An interface's target can only have the INTERFACE scope
	  #
	  set(_cmake_helpers_library_depend_scope "INTERFACE")
	endif()
	cmake_helpers_call(target_link_libraries ${_cmake_helpers_library_target} ${_cmake_helpers_library_depend_scope} ${_cmake_helpers_library_depend_lib})
      endforeach()
    endforeach()
  endif()
  #
  # DEPENDS_EXT This must be a list of three items at every iteration: scope, interface, lib
  #
  list(LENGTH _cmake_helpers_library_depends_ext _cmake_helpers_library_depends_ext_length)
  math(EXPR _cmake_helpers_library_depends_ext_length_modulo_3 "${_cmake_helpers_library_depends_ext_length} % 3")
  if(NOT(_cmake_helpers_library_depends_ext_length_modulo_3 EQUAL 0))
    message(FATAL_ERROR "DEPENDS_EXT option value must be a list of three items: scope, interface, lib")
  endif()
  if(_cmake_helpers_library_depends_ext)
    math(EXPR _cmake_helpers_library_depends_ext_length_i_max "(${_cmake_helpers_library_depends_ext_length} / 3) - 1")
    set(_j -1)
    foreach(_i RANGE 0 ${_cmake_helpers_library_depends_ext_length_i_max})
      math(EXPR _j "${_j} + 1")
      list(GET _cmake_helpers_library_depends_ext ${_j} _cmake_helpers_library_depend_scope)
      math(EXPR _j "${_j} + 1")
      list(GET _cmake_helpers_library_depends_ext ${_j} _cmake_helpers_library_depend_interface)
      math(EXPR _j "${_j} + 1")
      list(GET _cmake_helpers_library_depends_ext ${_j} _cmake_helpers_library_depend_lib)
      foreach(_cmake_helpers_library_target IN LISTS cmake_helpers_property_${PROJECT_NAME}_LibraryTargets)
	get_target_property(_cmake_helpers_library_target_type ${_cmake_helpers_library_target} TYPE)
	if(_cmake_helpers_library_target_type STREQUAL "INTERFACE_LIBRARY")
	  #
	  # An interface's target can only have the INTERFACE scope
	  #
	  set(_cmake_helpers_library_depend_scope "INTERFACE")
	endif()
	cmake_helpers_call(target_link_libraries ${_cmake_helpers_library_target} ${_cmake_helpers_library_depend_scope} $<${_cmake_helpers_library_depend_interface}:${_cmake_helpers_library_depend_lib}>)
      endforeach()
    endforeach()
  endif()
  #
  # Save properties
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ----------------------------")
    message(STATUS "[${_cmake_helpers_logprefix}] Setting directory properties")
    message(STATUS "[${_cmake_helpers_logprefix}] ----------------------------")
  endif()
  foreach(_cmake_helpers_library_property IN LISTS _cmake_helpers_library_properties)
    if(cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_property})
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_property} ${cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_property}})
    endif()
  endforeach()
  foreach(_cmake_helpers_library_array_property IN LISTS _cmake_helpers_library_array_properties)
    if(cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_array_property})
      cmake_helpers_call(set_property DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} APPEND PROPERTY cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_array_property} ${cmake_helpers_property_${PROJECT_NAME}_${_cmake_helpers_library_array_property}})
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
  foreach(_base_dir IN LISTS base_dirs)
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
