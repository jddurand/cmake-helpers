function(cmake_helpers_depend depname)
  #
  # This method ensure that the dependency is always available using find_package.
  # If it is provided via FetchContent(), it is then explicitly installed into
  # ${PROJECT_BINARY_DIR}/cmake_helpers_install, and find_package is done on the later.
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
    VERSION
    EXCLUDE_FROM_ALL
    SYSTEM
    CONFIG
  )
  set(_multiValueArgs
    EXTERNALPROJECT_ADD_ARGS
    FIND_PACKAGE_ARGS
  )
  #
  # Options default values
  #
  set(_cmake_helpers_depend_file                            "")
  set(_cmake_helpers_depend_version                         "")
  set(_cmake_helpers_depend_exclude_from_all                TRUE)
  set(_cmake_helpers_depend_system                          FALSE)
  #
  # In the case we are doing a local installation, we want to know the configuration type.
  # We always end up with a find_package, so we also want to specify import configuration mapping.
  #
  cmake_helpers_call(get_property _cmake_helpers_depend_generator_is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
  set(_cmake_helpers_depend_config_default                  RelWithDebInfo)
  if(_cmake_helpers_depend_generator_is_multi_config)
    #
    # Multi-generator. config is not know until build/install steps.
    #
    set(_cmake_helpers_depend_config                          ${_cmake_helpers_depend_config_default})
    set(_cmake_helpers_depend_configure_step_config_option)
    set(_cmake_helpers_depend_build_step_config_option        "--config" ${_cmake_helpers_depend_config})
    set(_cmake_helpers_depend_install_step_config_option      "--config" ${_cmake_helpers_depend_config})
  else()
    #
    # Single generator.
    #
    if(NOT("x${CMAKE_BUILD_TYPE}" STREQUAL "x"))
      #
      # If caller did set CMAKE_BUILD_TYPE, use it in the configure step.
      #
      set(_cmake_helpers_depend_config                          "${CMAKE_BUILD_TYPE}")
    else()
      #
      # Force our default.
      #
      set(_cmake_helpers_depend_config                          ${_cmake_helpers_depend_config_default})
    endif()
    set(_cmake_helpers_depend_configure_step_config_option    "--config" ${_cmake_helpers_depend_config})
    set(_cmake_helpers_depend_build_step_config_option)
    set(_cmake_helpers_depend_install_step_config_option)
  endif()
  #
  # CMake generate options
  #
  cmake_generate_options(_cmake_helpers_depend_cmake_generate_options)
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
  # Multi-value options default values
  #
  set(_cmake_helpers_depend_externalproject_add_args)
  set(_cmake_helpers_depend_find_package_args)
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_helpers_depend "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  #
  # Disable FILE option if it does not exist
  #
  if(_cmake_helpers_depend_file AND (NOT EXISTS ${_cmake_helpers_depend_file}))
    message(STATUS "[${_cmake_helpers_logprefix}] ${_cmake_helpers_depend_file} does not exist")
    set(_cmake_helpers_depend_file "")
  endif()
  #
  # We intentionaly use PROJECT_BINARY_DIR and not CMAKE_CURRENT_BINARY_DIR
  #
  set(_cmake_helpers_install_path ${PROJECT_BINARY_DIR}/cmake_helpers_install/${depname})
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
  #
  # Check with find_package first
  # -----------------------------
  #
  # If there are FILE or EXTERNALPROJECT_ADD_ARGS options, we make sure there is a QUIET option and no REQUIRED option.
  #
  if(_cmake_helpers_depend_file OR _cmake_helpers_depend_externalproject_add_args)
    set(_cmake_helpers_depend_find_package_have_alternatives TRUE)
  else()
    set(_cmake_helpers_depend_find_package_have_alternatives FALSE)
  endif()
  set(_cmake_helpers_depend_find_package_args_tmp ${_cmake_helpers_depend_find_package_args}) 
  set(_cmake_helpers_depend_find_package_args_tmp ${_cmake_helpers_depend_find_package_args})
  if(NOT "QUIET" IN_LIST _cmake_helpers_depend_find_package_args_tmp)
    set(_cmake_helpers_depend_have_quiet TRUE)
    if(_cmake_helpers_depend_find_package_have_alternatives)
      list(APPEND _cmake_helpers_depend_find_package_args_tmp "QUIET")
      list(REMOVE_ITEM _cmake_helpers_depend_find_package_args_tmp "REQUIRED")
      set(_cmake_helper_depend_find_package_must_succeed FALSE)
    else()
      set(_cmake_helper_depend_find_package_must_succeed TRUE)
    endif()
  else()
    set(_cmake_helpers_depend_have_quiet FALSE)
    set(_cmake_helper_depend_find_package_must_succeed FALSE)
  endif()
  #
  # Since we install locally ourself, check if this is already done
  #
  if(_cmake_helpers_depend_prefix_paths)
    cmake_helpers_call(list APPEND CMAKE_PREFIX_PATH ${_cmake_helpers_depend_prefix_paths})
    cmake_helpers_call(list REMOVE_ITEM _cmake_helpers_depend_find_package_args_tmp "NO_CMAKE_PATH")
    cmake_helpers_call(set CMAKE_FIND_USE_CMAKE_PATH TRUE)
  endif()
  cmake_helpers_call(find_package ${depname} ${_cmake_helpers_depend_find_package_args_tmp})
  if(${depname}_FOUND)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] ${depname} found")
    endif()
    return()
  endif()
  #
  # Check if we raise a fatal error or not when it is not found
  #
  if((NOT ${depname}_FOUND) AND _cmake_helper_depend_find_package_must_succeed)
    message(FATAL_ERROR "[${_cmake_helpers_logprefix}] ${depname} is not found - use the FILE or EXTERNALPROJECT_ADD_ARGS options to continue")
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
    elseif(_cmake_helpers_depend_alternative STREQUAL "externalproject_add_args")
      #
      # EXTERNALPROJECT_ADD_ARGS generic alternative
      #
      set(_cmake_helpers_depend_content_options ${_cmake_helpers_depend_externalproject_add_args})
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
    cmake_helpers_call(FetchContent_Populate ${depname})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] ${_depname_tolower}_POPULATED: ${${_depname_tolower}_POPULATED}")
    endif()
    if(${_depname_tolower}_POPULATED)
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] ${_depname_tolower}_SOURCE_DIR: ${${_depname_tolower}_SOURCE_DIR}")
	message(STATUS "[${_cmake_helpers_logprefix}] ${_depname_tolower}_BINARY_DIR: ${${_depname_tolower}_BINARY_DIR}")
      endif()
      break()
    endif()
  endforeach()
  #
  # If not populated and not QUIET, this is an error
  #
  if((NOT ${_depname_tolower}_POPULATED) AND (NOT _cmake_helpers_depend_have_quiet))
    message(FATAL_ERROR "[${_cmake_helpers_logprefix}] ${depname} cannot be populated")
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
  if(NOT _cmake_helpers_depend_have_quiet)
    set(_cmake_helpers_process_command_error_is_fatal "COMMAND_ERROR_IS_FATAL" "ANY")
  else()
    set(_cmake_helpers_process_command_error_is_fatal)
  endif()
  execute_process(
    COMMAND ${CMAKE_COMMAND}
      -DCMAKE_HELPERS_DEBUG=${CMAKE_HELPERS_DEBUG}
      ${_cmake_helpers_depend_cmake_generate_options}
      -S ${${_depname_tolower}_SOURCE_DIR}
      -B ${${_depname_tolower}_BINARY_DIR}
      ${_cmake_helpers_depend_configure_step_config_option}
    RESULT_VARIABLE _result_variable
    ${_cmake_helpers_process_command_echo_stdout}
    ${_cmake_helpers_process_command_error_is_fatal}
  )
  if((NOT _result_variable) OR (_result_variable EQUAL 0))
    execute_process(
      COMMAND ${CMAKE_COMMAND}
        --build ${${_depname_tolower}_BINARY_DIR}
        ${_cmake_helpers_depend_build_step_config_option}
        ${_cmake_helpers_process_command_echo_stdout}
        ${_cmake_helpers_process_command_error_is_fatal}
    )
  endif()
  if((NOT _result_variable) OR (_result_variable EQUAL 0))
    execute_process(
      COMMAND ${CMAKE_COMMAND}
        --install ${${_depname_tolower}_BINARY_DIR}
	--prefix ${_cmake_helpers_install_path}
        ${_cmake_helpers_depend_install_step_config_option}
        ${_cmake_helpers_process_command_echo_stdout}
        ${_cmake_helpers_process_command_error_is_fatal}
    )
  endif()
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
  #
  # Redo a find_package.
  #
  if((NOT _result_variable) OR (_result_variable EQUAL 0))
    cmake_helpers_call(list APPEND CMAKE_PREFIX_PATH ${_cmake_helpers_depend_prefix_paths})
    cmake_helpers_call(list REMOVE_ITEM _cmake_helpers_depend_find_package_args "NO_CMAKE_PATH")
    cmake_helpers_call(set CMAKE_FIND_USE_CMAKE_PATH TRUE)
    cmake_helpers_call(find_package ${depname} ${_cmake_helpers_depend_find_package_args})
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
