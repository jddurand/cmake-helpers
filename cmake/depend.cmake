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
    BUILD_AND_INSTALL_CONFIGURATION
  )
  set(_multiValueArgs
    EXTERNALPROJECT_ADD_ARGS
    MAKEAVAILABLE_ARGS
    FIND_PACKAGE_ARGS
  )
  #
  # Options default values
  #
  set(_cmake_helpers_depend_file                            "")
  set(_cmake_helpers_depend_version                         "")
  set(_cmake_helpers_depend_exclude_from_all                TRUE)
  set(_cmake_helpers_depend_system                          FALSE)
  set(_cmake_helpers_depend_build_and_install_configuration Release)
  #
  # Multi-value options default values
  #
  set(_cmake_helpers_depend_externalproject_add_args)
  set(_cmake_helpers_depend_makeavailable_args)
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
	message(STATUS "[${_cmake_helpers_logprefix}] CMake prefix path: ${_dir}")
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
  message(STATUS "[${_cmake_helpers_logprefix}] Installing ${depname} in ${_cmake_helpers_install_path}, configuration ${_cmake_helpers_depend_build_and_install_configuration}")
  execute_process(
    COMMAND ${CMAKE_COMMAND}
      -DCMAKE_HELPERS_DEBUG=${CMAKE_HELPERS_DEBUG}
      -S ${${_depname_tolower}_SOURCE_DIR}
      -B ${${_depname_tolower}_BINARY_DIR}
    RESULT_VARIABLE _result_variable
    ${_cmake_helpers_process_command_echo_stdout}
    ${_cmake_helpers_process_command_error_is_fatal}
  )
  if((NOT _result_variable) OR (_result_variable EQUAL 0))
    execute_process(
      COMMAND ${CMAKE_COMMAND}
        --build ${${_depname_tolower}_BINARY_DIR}
	--config ${_cmake_helpers_depend_build_and_install_configuration}
      ${_cmake_helpers_process_command_echo_stdout}
      ${_cmake_helpers_process_command_error_is_fatal}
    )
  endif()
  if((NOT _result_variable) OR (_result_variable EQUAL 0))
    execute_process(
      COMMAND ${CMAKE_COMMAND}
        --install ${${_depname_tolower}_BINARY_DIR}
	--config ${_cmake_helpers_depend_build_and_install_configuration}
	--prefix ${_cmake_helpers_install_path}
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
