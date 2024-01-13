function(cmake_helpers_depend depname)
  #
  # This method ensure that the dependency is always available using find_package.
  # If it is provided via FetchContent(), it is then explicitly installed into
  # ${CMAKE_HELPERS_INSTALL_PATH}, and find_package is done on the later.
  # We use FetchContent facility just to have the sources at configure step.
  #
  # =========================================================================================
  # Note: any remaining argument is considered as being part of ExternalProject_Add arguments
  # =========================================================================================
  #
  # Log prefix
  #
  set(_cmake_helpers_logprefix "cmake_helpers/${PROJECT_NAME}/depend")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
    message(STATUS "[${_cmake_helpers_logprefix}] Starting")
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
  endif()
  #
  # Check dependency name
  #
  if(NOT depname)
    message(FATAL_ERROR "depname argument is missing")
  endif()
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  #
  set(_options)
  set(_oneValueArgs
    FILE
    EXCLUDE_FROM_ALL
    SYSTEM
    FIND
    SOURCE_DIR_OUTVAR
    BINARY_DIR_OUTVAR
    CONFIGURE
    BUILD
    INSTALL
    FIND_PACKAGE_NAME
    MAKEAVAILABLE                   # Note that MAKEAVAILABLE has precedence, if set, over the configure/build/install phases
    GENERATOR_CONFIG
    BUILD_DIR_SUFFIX                # We do not want to mix to the build/config/install steps with the add_subdirectory
    ADD_SUBDIRECTORY_PROTECTION
  )
  set(_multiValueArgs
    EXTERNALPROJECT_ADD_ARGS
    CMAKE_ARGS
    FIND_PACKAGE_ARGS
  )
  #
  # Default values
  #
  set(_env_cmake_helpers_win32_packaging $ENV{CMAKE_HELPERS_WIN32_PACKAGING})
  set(_cmake_helpers_depend_file                            "")
  if(_env_cmake_helpers_win32_packaging)
    set(_cmake_helpers_depend_exclude_from_all              FALSE)
  else()
    set(_cmake_helpers_depend_exclude_from_all              TRUE)
  endif()
  set(_cmake_helpers_depend_system                          FALSE)
  set(_cmake_helpers_depend_find                            TRUE)
  set(_cmake_helpers_depend_source_dir_outvar               cmake_helpers_exe_source_dir)
  set(_cmake_helpers_depend_binary_dir_outvar               cmake_helpers_exe_binary_dir)
  set(_cmake_helpers_depend_configure                       TRUE)
  set(_cmake_helpers_depend_build                           TRUE)
  set(_cmake_helpers_depend_install                         TRUE)
  set(_cmake_helpers_depend_find_package_name               ${depname})
  if(_env_cmake_helpers_win32_packaging)
    set(_cmake_helpers_depend_makeavailable                 TRUE)
  else()
    set(_cmake_helpers_depend_makeavailable                 FALSE)
  endif()
  #
  # In the case we are doing a local installation, we want to know the configuration type.
  # We always end up with a find_package, so we also want to specify import configuration mapping.
  #
  cmake_helpers_call(get_property _cmake_helpers_depend_generator_is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
  set(_cmake_helpers_depend_generator_config_default        RelWithDebInfo)
  if(_cmake_helpers_depend_generator_is_multi_config)
    #
    # Multi-generator. config is not know until build/install steps.
    #
    set(_cmake_helpers_depend_generator_config              ${_cmake_helpers_depend_generator_config_default})
  else()
    #
    # Single generator.
    #
    if(NOT("x${CMAKE_BUILD_TYPE}" STREQUAL "x"))
      #
      # If caller did set CMAKE_BUILD_TYPE, use it in the configure step.
      #
      set(_cmake_helpers_depend_generator_config            "${CMAKE_BUILD_TYPE}")
    else()
      #
      # Force our default.
      #
      set(_cmake_helpers_depend_generator_config            ${_cmake_helpers_depend_generator_config_default})
    endif()
  endif()
  set(_cmake_helpers_depend_build_dir_suffix                "-cmh")
  set(_cmake_helpers_depend_add_subdirectory_protection     TRUE)
  #
  # Multi-value options default values
  #
  set(_cmake_helpers_depend_externalproject_add_args)
  set(_cmake_helpers_depend_cmake_args)
  set(_cmake_helpers_depend_find_package_args)
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_helpers_depend "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # If we install we must build
  #
  if(_cmake_helpers_depend_install)
    if(NOT _cmake_helpers_depend_build)
      message(STATUS "[${_cmake_helpers_logprefix}] Install option is true: enforcing build option to true")
      set(_cmake_helpers_depend_build ON)
    endif()
  endif()
  #
  # If we build we must configure
  #
  if(_cmake_helpers_depend_build)
    if(NOT _cmake_helpers_depend_configure)
      message(STATUS "[${_cmake_helpers_logprefix}] Build option is true: enforcing configure option to true")
      set(_cmake_helpers_depend_configure ON)
    endif()
  endif()
  #
  # For recursive calls, make sure we always fetch in the same directory
  #
  if("x$ENV{CMAKE_HELPERS_FETCHCONTENT_BASE_DIR}" STREQUAL "x")
    set(_cmake_helpers_fetchcontent_base_dir ${PROJECT_BINARY_DIR}/_deps)
    set(ENV{CMAKE_HELPERS_FETCHCONTENT_BASE_DIR} ${_cmake_helpers_fetchcontent_base_dir})
  else()
    set(_cmake_helpers_fetchcontent_base_dir $ENV{CMAKE_HELPERS_FETCHCONTENT_BASE_DIR})
  endif()
  set(FETCHCONTENT_BASE_DIR ${_cmake_helpers_fetchcontent_base_dir} CACHE PATH "FetchContent base dir" FORCE)
  #
  # CMake generate options
  #
  cmake_generate_options(_cmake_helpers_depend_cmake_generate_options)
  if(_cmake_helpers_depend_generator_is_multi_config)
    #
    # Multi-generator. config is not know until build/install steps.
    #
    set(_cmake_helpers_depend_configure_step_config_option    ${_cmake_helpers_depend_cmake_args})
    set(_cmake_helpers_depend_build_step_config_option        "--config" ${_cmake_helpers_depend_generator_config})
    set(_cmake_helpers_depend_install_step_config_option      "--config" ${_cmake_helpers_depend_generator_config})
  else()
    #
    # Single generator.
    #
    set(_cmake_helpers_depend_configure_step_config_option    ${_cmake_helpers_depend_cmake_args} "-DCMAKE_BUILD_TYPE=${_cmake_helpers_depend_generator_config}")
    set(_cmake_helpers_depend_build_step_config_option)
    set(_cmake_helpers_depend_install_step_config_option)
  endif()
  #
  # Import mapping. We always want to fallback to:
  # - our default (case we build/install locally)
  # - "sane" default, including the noconfig case
  #
  if(_cmake_helpers_depend_generator_is_multi_config)
    set(_cmake_helpers_depend_configuration_types ${CMAKE_CONFIGURATION_TYPES})
  elseif(NOT("x${CMAKE_BUILD_TYPE}" STREQUAL "x"))
    set(_cmake_helpers_depend_configuration_types ${CMAKE_BUILD_TYPE})
  else()
    set(_cmake_helpers_depend_configuration_types)
  endif()
  #
  # Make sure the known CMake default are present.
  #
  foreach(_cmake_helpers_depend_configuration_default "Debug" "Release" "RelWithDebInfo" "MinSizeRel")
    if(NOT(${_cmake_helpers_depend_configuration_default} IN_LIST _cmake_helpers_depend_configuration_types))
      list(APPEND _cmake_helpers_depend_configuration_types ${_cmake_helpers_depend_configuration_default})
    endif()
  endforeach()
  #
  # Make sure the "noconfig" version is present
  #
  if(NOT("" IN_LIST _cmake_helpers_depend_configuration_types))
    list(APPEND _cmake_helpers_depend_configuration_types "")
  endif()
  #
  # Put "Debug;" at the very end
  #
  foreach(_cmake_helpers_depend_configuration_default "Debug" "")
    list(REMOVE_ITEM _cmake_helpers_depend_configuration_types "${_cmake_helpers_depend_configuration_default}")
    list(APPEND _cmake_helpers_depend_configuration_types "${_cmake_helpers_depend_configuration_default}")
  endforeach()
  #
  # Define the import fallbacks
  #
  foreach(_cmake_helpers_depend_configuration_type IN LISTS _cmake_helpers_depend_configuration_types)
    if(NOT("x${_cmake_helpers_depend_configuration_type}" STREQUAL "x"))
      string(TOUPPER "${_cmake_helpers_depend_configuration_type}" _cmake_helpers_depend_configuration_type_toupper)
      if(NOT(DEFINED CMAKE_MAP_IMPORTED_CONFIG_${_cmake_helpers_depend_configuration_type_toupper}))
        set(_cmake_helpers_depend_configuration_type_maps ${_cmake_helpers_depend_configuration_types})
        list(REMOVE_ITEM _cmake_helpers_depend_configuration_type_maps ${_cmake_helpers_depend_configuration_type})
        list(INSERT _cmake_helpers_depend_configuration_type_maps 0 ${_cmake_helpers_depend_configuration_type})
        set(CMAKE_MAP_IMPORTED_CONFIG_${_cmake_helpers_depend_configuration_type_toupper} ${_cmake_helpers_depend_configuration_type_maps})
        #
        # Well, CMake has trouble with empty element
        #
        list(GET CMAKE_MAP_IMPORTED_CONFIG_${_cmake_helpers_depend_configuration_type_toupper} -1 _last)
        if(NOT("x${_last}" STREQUAL "x"))
          list(APPEND CMAKE_MAP_IMPORTED_CONFIG_${_cmake_helpers_depend_configuration_type_toupper} "")
        endif()
        if(CMAKE_HELPERS_DEBUG)
	  message(STATUS "[${_cmake_helpers_logprefix}] CMAKE_MAP_IMPORTED_CONFIG_${_cmake_helpers_depend_configuration_type_toupper}: ${CMAKE_MAP_IMPORTED_CONFIG_${_cmake_helpers_depend_configuration_type_toupper}}")
        endif()
      endif()
    endif()
  endforeach()
  #
  # Disable FILE option if it does not exist
  #
  if(_cmake_helpers_depend_file AND (NOT EXISTS ${_cmake_helpers_depend_file}))
    message(STATUS "[${_cmake_helpers_logprefix}] ${_cmake_helpers_depend_file} does not exist")
    set(_cmake_helpers_depend_file "")
  endif()
  #
  # We intentionaly use PROJECT_BINARY_DIR and not CMAKE_CURRENT_BINARY_DIR. In case of a
  # recursive call via an external project, this path is recuperated via an environment
  # variable.
  #
  if("x$ENV{CMAKE_HELPERS_INSTALL_PATH}" STREQUAL "x")
    set(_cmake_helpers_install_path ${CMAKE_HELPERS_INSTALL_PATH})
    set(ENV{CMAKE_HELPERS_INSTALL_PATH} ${_cmake_helpers_install_path})
  else()
    set(_cmake_helpers_install_path $ENV{CMAKE_HELPERS_INSTALL_PATH})
  endif()
  #
  # Prepare already installed dependencies for find_package
  #
  file(GLOB_RECURSE _cmakes LIST_DIRECTORIES false ${_cmake_helpers_install_path}/*.cmake)
  set(_cmake_helpers_depend_prefix_paths ${_cmake_helpers_install_path})
  foreach(_cmake IN LISTS _cmakes)
    get_filename_component(_dir ${_cmake} DIRECTORY)
    if(NOT _dir IN_LIST _cmake_helpers_depend_prefix_paths)
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] Found CMake prefix path: ${_dir}")
      endif()
      list(APPEND _cmake_helpers_depend_prefix_paths ${_dir})
    endif()
  endforeach()
  #
  # Check with find_package first
  #
  # If there are FILE or EXTERNALPROJECT_ADD_ARGS options, we make sure there is a QUIET option and no REQUIRED option.
  #
  if(_cmake_helpers_depend_file OR _cmake_helpers_depend_externalproject_add_args)
    set(_cmake_helpers_depend_find_package_have_alternatives TRUE)
  else()
    set(_cmake_helpers_depend_find_package_have_alternatives FALSE)
  endif()
  #
  # Look the original QUIET and REQUIRED options
  #
  if("QUIET" IN_LIST _cmake_helpers_depend_find_package_args)
    set(_cmake_helpers_depend_have_quiet TRUE)
  else()
    set(_cmake_helpers_depend_have_quiet FALSE)
  endif()
  if("REQUIRED" IN_LIST _cmake_helpers_depend_find_package_args)
    set(_cmake_helpers_depend_have_required TRUE)
  else()
    set(_cmake_helpers_depend_have_required FALSE)
  endif()
  set(_cmake_helpers_depend_find_package_args_tmp ${_cmake_helpers_depend_find_package_args}) 
  if(_cmake_helpers_depend_have_required)
    if(_cmake_helpers_depend_find_package_have_alternatives)
      #
      # There are two alternatives. Make sure the first one is QUIET and not REQUIRED
      #
      if(NOT _cmake_helpers_depend_have_quiet)
	list(APPEND _cmake_helpers_depend_find_package_args_tmp "QUIET")
      endif()
      list(REMOVE_ITEM _cmake_helpers_depend_find_package_args_tmp "REQUIRED")
      set(_cmake_helper_depend_find_package_must_succeed FALSE)
    else()
      set(_cmake_helper_depend_find_package_must_succeed TRUE)
    endif()
  else()
    set(_cmake_helper_depend_find_package_must_succeed FALSE)
  endif()
  #
  # Since we install locally ourself, check if this is already done
  #
  if(_cmake_helpers_depend_prefix_paths)
    cmake_helpers_call(list PREPEND CMAKE_PREFIX_PATH ${_cmake_helpers_depend_prefix_paths})
    cmake_helpers_call(list REMOVE_ITEM _cmake_helpers_depend_find_package_args_tmp "NO_CMAKE_PATH")
    cmake_helpers_call(set CMAKE_FIND_USE_CMAKE_PATH TRUE)
  endif()
  if(_cmake_helpers_depend_find)
    cmake_helpers_call(find_package ${_cmake_helpers_depend_find_package_name} ${_cmake_helpers_depend_find_package_args_tmp})
    if(${_cmake_helpers_depend_find_package_name}_FOUND)
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] ${depname} found")
      endif()
      if(NOT _cmake_helpers_depend_makeavailable)
	#
	# We return if the caller do not want some targets in its build process
	#
	return()
      else()
	if(CMAKE_HELPERS_DEBUG)
	  message(STATUS "[${_cmake_helpers_logprefix}] Continuing up to the makeavailable step")
	endif()
      endif()
    else()
      #
      # Check if we raise a fatal error or not when it is not found
      #
      if(_cmake_helper_depend_find_package_must_succeed)
	message(FATAL_ERROR "[${_cmake_helpers_logprefix}] ${depname} is not found - use the FILE or EXTERNALPROJECT_ADD_ARGS options to continue")
      endif()
    endif()
  endif()
  #
  # Prepare the FetchContent_Declare EXCLUDE_FROM_ALL and SYSTEM options
  #
  cmake_helpers_call(include FetchContent)
  set(_cmake_helpers_depend_fetchcontent_declare_exclude_from_all)
  if(_cmake_helpers_depend_exclude_from_all)
    set(_cmake_helpers_depend_fetchcontent_declare_exclude_from_all "EXCLUDE_FROM_ALL")
  else()
    set(_cmake_helpers_depend_fetchcontent_declare_exclude_from_all)
  endif()
  set(_cmake_helpers_depend_fetchcontent_declare_system)
  if(_cmake_helpers_depend_system)
    set(_cmake_helpers_depend_fetchcontent_declare_system "SYSTEM")
  else()
    set(_cmake_helpers_depend_fetchcontent_declare_system)
  endif()
  #
  # We will need the lowercase version of depname
  #
  string(TOLOWER "${depname}" _depname_tolower)
  #
  # Loop on the alternatives
  #
  foreach(_cmake_helpers_depend_alternative "file" "externalproject_add_args")
    if(NOT _cmake_helpers_depend_${_cmake_helpers_depend_alternative})
      continue()
    endif()
    if(_cmake_helpers_depend_alternative STREQUAL "file")
      #
      # FILE alternative - we can check if if exiss
      #
      set(_cmake_helpers_depend_content_options URL ${_cmake_helpers_depend_file})
      message(STATUS "[${_cmake_helpers_logprefix}] Fetching ${depname} using ${_cmake_helpers_depend_file}")
    elseif(_cmake_helpers_depend_alternative STREQUAL "externalproject_add_args")
      #
      # EXTERNALPROJECT_ADD_ARGS generic alternative
      #
      set(_cmake_helpers_depend_content_options ${_cmake_helpers_depend_externalproject_add_args})
      message(STATUS "[${_cmake_helpers_logprefix}] Fetching ${depname}")
    else()
      message(FATAL_ERROR "[${_cmake_helpers_logprefix}] Unknown alternative ${_cmake_helpers_depend_alternative}")
    endif()
    #
    # FetchContent_Declare()
    #
    cmake_helpers_call(FetchContent_Declare ${depname}
      ${_cmake_helpers_depend_content_options}
      ${_cmake_helpers_depend_fetchcontent_declare_exclude_from_all}
      ${_cmake_helpers_depend_fetchcontent_declare_system}
      OVERRIDE_FIND_PACKAGE
    )
    #
    # FetchContent_Populate()
    #
    if(NOT ${_depname_tolower}_POPULATED)
      message(STATUS "[${_cmake_helpers_logprefix}] Populating ${depname}")
      cmake_helpers_call(FetchContent_Populate ${depname})
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] ${_depname_tolower}_POPULATED: ${${_depname_tolower}_POPULATED}")
      endif()
    else()
      message(STATUS "[${_cmake_helpers_logprefix}] ${depname} already populated")
    endif()
    if(${_depname_tolower}_POPULATED)
      message(STATUS "[${_cmake_helpers_logprefix}] Populated ${depname}")
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] ${_depname_tolower}_SOURCE_DIR: ${${_depname_tolower}_SOURCE_DIR}")
	message(STATUS "[${_cmake_helpers_logprefix}] ${_depname_tolower}_BINARY_DIR: ${${_depname_tolower}_BINARY_DIR}")
      endif()
      break()
    endif()
  endforeach()
  #
  # If not populated and not REQUIRED, this is an error
  #
  if(NOT ${_depname_tolower}_POPULATED)
    if(_cmake_helpers_depend_have_required)
      message(FATAL_ERROR "[${_cmake_helpers_logprefix}] ${depname} cannot be populated")
    else()
      return()
    endif()
  endif()
  #
  # We do a local installation, and do not mind about $<CONFIG>: we want the default from this package
  # as per FetchContent_Declare content options.
  #
  if(CMAKE_HELPERS_DEBUG)
    set(_cmake_helpers_process_command_echo_stdout "COMMAND_ECHO" "STDOUT")
  else()
    set(_cmake_helpers_process_command_echo_stdout)
  endif()
  if(_cmake_helpers_depend_configure OR _cmake_helpers_depend_build OR _cmake_helpers_depend_install)
    if(_cmake_helpers_depend_have_required)
      set(_cmake_helpers_process_command_error_is_fatal "COMMAND_ERROR_IS_FATAL" "ANY")
    else()
      set(_cmake_helpers_process_command_error_is_fatal)
    endif()
    if(_cmake_helpers_depend_configure)
      #
      # Configure
      #
      message(STATUS "[${_cmake_helpers_logprefix}] Configuring ${depname} in ${${_depname_tolower}_BINARY_DIR}")
      execute_process(
	COMMAND ${CMAKE_COMMAND}
          -DCMAKE_HELPERS_DEBUG=${CMAKE_HELPERS_DEBUG}
          ${_cmake_helpers_depend_cmake_generate_options}
          -S "${${_depname_tolower}_SOURCE_DIR}"
          -B "${${_depname_tolower}_BINARY_DIR}${_cmake_helpers_depend_build_dir_suffix}"
          ${_cmake_helpers_depend_configure_step_config_option}
        RESULT_VARIABLE _result_variable
	${_cmake_helpers_process_command_echo_stdout}
	${_cmake_helpers_process_command_error_is_fatal}
      )
      if(_cmake_helpers_depend_build AND ((NOT _result_variable) OR (_result_variable EQUAL 0)))
	#
	# Build
	#
	message(STATUS "[${_cmake_helpers_logprefix}] Building ${depname} in ${${_depname_tolower}_BINARY_DIR}")
	execute_process(
          COMMAND ${CMAKE_COMMAND}
            --build "${${_depname_tolower}_BINARY_DIR}${_cmake_helpers_depend_build_dir_suffix}"
            ${_cmake_helpers_depend_build_step_config_option}
          RESULT_VARIABLE _result_variable
          ${_cmake_helpers_process_command_echo_stdout}
          ${_cmake_helpers_process_command_error_is_fatal}
	)
	if(_cmake_helpers_depend_install AND ((NOT _result_variable) OR (_result_variable EQUAL 0)))
          message(STATUS "[${_cmake_helpers_logprefix}] Installing ${depname} in ${_cmake_helpers_install_path}")
          execute_process(
            COMMAND ${CMAKE_COMMAND}
              --install "${${_depname_tolower}_BINARY_DIR}${_cmake_helpers_depend_build_dir_suffix}"
	      --prefix "${_cmake_helpers_install_path}"
              ${_cmake_helpers_depend_install_step_config_option}
            RESULT_VARIABLE _result_variable
            ${_cmake_helpers_process_command_echo_stdout}
            ${_cmake_helpers_process_command_error_is_fatal}
          )
	  if(_cmake_helpers_depend_find AND ((NOT _result_variable) OR (_result_variable EQUAL 0)))
	    #
	    # Re-do a find_package
	    #
	    #
	    # We look for all *.cmake in ${_cmake_helpers_install_path}, collect the directories in CMAKE_PREFIX_PATH,
	    # Make sure that NO_CMAKE_PATH is not in find_package arguments nor that CMAKE_FIND_USE_CMAKE_PATH is FALSE.
	    #
	    cmake_helpers_call(file GLOB_RECURSE _cmakes LIST_DIRECTORIES|false ${_cmake_helpers_install_path}/*.cmake)
	    set(_cmake_helpers_depend_prefix_paths)
	    foreach(_cmake IN LISTS _cmakes)
	      get_filename_component(_dir ${_cmake} DIRECTORY)
	      if(NOT _dir IN_LIST _cmake_helpers_depend_prefix_paths)
		if(CMAKE_HELPERS_DEBUG)
		  message(STATUS "[${_cmake_helpers_logprefix}] CMake prefix path: ${_dir}")
		endif()
		list(APPEND _cmake_helpers_depend_prefix_paths ${_dir})
	      endif()
	    endforeach()
	    cmake_helpers_call(list PREPEND CMAKE_PREFIX_PATH ${_cmake_helpers_depend_prefix_paths})
	    cmake_helpers_call(list REMOVE_ITEM _cmake_helpers_depend_find_package_args "NO_CMAKE_PATH")
	    cmake_helpers_call(set CMAKE_FIND_USE_CMAKE_PATH TRUE)
	    cmake_helpers_call(find_package ${_cmake_helpers_depend_find_package_name} ${_cmake_helpers_depend_find_package_args})
	  endif()
	endif()
      endif()
    endif()
  endif()
  #
  # Caller wants to have access to some development targets.
  # Source and binary directories are meaningful only when it is made available.
  #
  if(NOT _cmake_helpers_depend_makeavailable)
    set(_cmake_helpers_depend_depname_source_dir)
    set(_cmake_helpers_depend_depname_binary_dir)
  else()
    set(_cmake_helpers_depend_depname_source_dir "${${_depname_tolower}_SOURCE_DIR}")
    set(_cmake_helpers_depend_depname_binary_dir "${${_depname_tolower}_BINARY_DIR}-for-${PROJECT_NAME}")
    #
    # We prevent the case of a failure if the source directory does not contain CMakeLists.txt
    #
    if(EXISTS "${${_depname_tolower}_SOURCE_DIR}/CMakeLists.txt")
      message(STATUS "[${_cmake_helpers_logprefix}] Making ${depname} available")
      #
      # Internally FetchContent_MakeAvailable will do nothing else but an add_subdirectory. So do we.
      #
      if(NOT _cmake_helpers_depend_exclude_from_all)
	#
	# If the sub-library is using our framework, disable the automatic skip of install rules
	# when current project is not the top-level project
	#
	set(CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO FALSE)
      else()
	set(CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO TRUE)
      endif()
      cmake_helpers_call(add_subdirectory
	${${_depname_tolower}_SOURCE_DIR}
	${_cmake_helpers_depend_depname_binary_dir}
	${_cmake_helpers_depend_fetchcontent_declare_exclude_from_all}
	${_cmake_helpers_depend_fetchcontent_declare_system}
      )
    else()
      if(_cmake_helpers_depend_add_subdirectory_protection)
	message(WARNING "[${_cmake_helpers_logprefix}] ${${_depname_tolower}_SOURCE_DIR}/CMakeLists.txt is missing: add_subdirectory is skipped")
      else()
	message(FATAL_ERROR "[${_cmake_helpers_logprefix}] ${${_depname_tolower}_SOURCE_DIR}/CMakeLists.txt is missing: add_subdirectory is skipped")
      endif()
    endif()
  endif()
  #
  # Send-out variables
  #
  set(${_cmake_helpers_depend_source_dir_outvar} "${_cmake_helpers_depend_depname_source_dir}" PARENT_SCOPE)
  set(${_cmake_helpers_depend_binary_dir_outvar} "${_cmake_helpers_depend_depname_binary_dir}" PARENT_SCOPE)
  #
  # End
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
    message(STATUS "[${_cmake_helpers_logprefix}] Ending")
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
  endif()
endfunction()
