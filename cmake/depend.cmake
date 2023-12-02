function(cmake_helpers_depend depname)
  #
  # ==================================================================================
  # Note: any remaining argument is considered as being part of find_package arguments
  # ==================================================================================
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
  )
  set(_multiValueArgs
    EXTERNALPROJECT_ADD_ARGS
    MAKEAVAILABLE_ARGS
    FIND_PACKAGE_ARGS
  )
  #
  # Options default values
  #
  set(_cmake_helpers_depend_file "")
  set(_cmake_helpers_depend_version "")
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
  # We always give it a try using find_package first, forcing the QUIET option
  #
  set(_cmake_helpers_depend_find_package_args_quiet ${_cmake_helpers_depend_find_package_args})
  if(NOT "QUIET" IN_LIST _find_cmake_helpers_depend_package_args_quiet)
    list(APPEND _cmake_helpers_depend_find_package_args_quiet "QUIET")
  endif()
  cmake_helpers_call(find_package ${depname} ${_cmake_helpers_depend_find_package_args_quiet})
  if(${depname}_FOUND)
    return()
  endif()
  #
  # If a file argument is given, use it
  #
  string(TOLOWER "${depname}" _depname_tolower)
  if(_cmake_helpers_depend_file)
    if(NOT (EXISTS ${_cmake_helpers_depend_file}))
      message(WARNING "${_cmake_helpers_depend_file} does not exist")
      set(_cmake_helpers_depend_external_project_args ${_cmake_helpers_depend_externalproject_add_args})
    else()
      set(_cmake_helpers_depend_external_project_args URL ${_cmake_helpers_depend_file})
    endif()
  else()
    set(_cmake_helpers_depend_external_project_args ${_cmake_helpers_depend_externalproject_add_args})
  endif()
  if(_cmake_helpers_depend_external_project_args)
    #
    # FetchContent sequence
    # I do not know why but EXCLUDE_FROM_ALL does not work me. I have to go manually with add_subdirectory
    #
    cmake_helpers_call(include FetchContent)
    cmake_helpers_call(FetchContent_Declare ${depname}
      ${_cmake_helpers_depend_external_project_args}
      OVERRIDE_FIND_PACKAGE
    )
    cmake_helpers_call(FetchContent_GetProperties ${depname})
    string(TOLOWER "${depname}" _depname_tolower)
    if(NOT ${_depname_tolower}_POPULATED)
      cmake_helpers_call(FetchContent_Populate ${depname})
      cmake_helpers_call(add_subdirectory
	${${_depname_tolower}_SOURCE_DIR}
	${${_depname_tolower}_BINARY_DIR}
	EXCLUDE_FROM_ALL
      )
    endif()
    #
    # We voluntarily do not use FetchContent_MakeAvailable : we want to do as if the dependency
    # was already found in the system. So we go into the subdirectory, and will perform a local
    # install.
    #
    set(_cmake_helpers_depend_config $<CONFIG>)
    if(_cmake_helpers_depend_config)
      set(_cmake_helpers_depend_config_args --config "${_cmake_helpers_depend_config}")
    else()
      set(_cmake_helpers_depend_config_args)
    endif()
    execute_process(
      COMMAND ${CMAKE_COMMAND} --build . ${_cmake_helpers_depend_config_args}
      WORKING_DIRECTORY ${${_depname_tolower}_BINARY_DIR}
      COMMAND_ERROR_IS_FATAL ANY
    )
    execute_process(
      COMMAND ${CMAKE_COMMAND} --install . ${_cmake_helpers_depend_config_args} --prefix ${CMAKE_CURRENT_BINARY_DIR}/_install
      WORKING_DIRECTORY ${${_depname_tolower}_BINARY_DIR}
      COMMAND_ERROR_IS_FATAL ANY
    )
    #
    # Re-execute find_package, using original arguments (regardless if they already contain QUIET)
    #
    cmake_helpers_call(find_package ${depname} ${_cmake_helpers_depend_find_package_args})
  endif()
  #
  # If there is no QUIET and dependency is not found, raise a fatal error
  #
  if((NOT ${depname}_FOUND) AND (NOT "QUIET" IN_LIST _find_cmake_helpers_depend_package_arguments))
    message(FATAL_ERROR "Cannot satisfy ${depname} dependency")
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
