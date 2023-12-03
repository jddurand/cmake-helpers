function(cmake_helpers_depend depname)
  #
  # A tiny wrapper around FetchContent that gives precedence to a local file if it exist
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
    EXCLUDE_FROM_ALL
    SYSTEM
  )
  set(_multiValueArgs
    EXTERNALPROJECT_ADD_ARGS
    MAKEAVAILABLE_ARGS
    FIND_PACKAGE_ARGS
  )
  #
  # Options default values
  #
  set(_cmake_helpers_depend_file             "")
  set(_cmake_helpers_depend_version          "")
  set(_cmake_helpers_depend_exclude_from_all TRUE)
  set(_cmake_helpers_depend_system           FALSE)
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
  # Check with find_package first
  # -----------------------------
  set(_cmake_helpers_depend_find_package_args_quiet ${_cmake_helpers_depend_find_package_args})
  if(NOT "QUIET" IN_LIST _cmake_helpers_depend_find_package_args_quiet)
    list(APPEND _cmake_helpers_depend_find_package_args_quiet "QUIET")
  endif()
  cmake_helpers_call(find_package ${depname} ${_cmake_helpers_depend_find_package_args_quiet})
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] find_package status on ${depname}: ${${depname}_FOUND}")
  endif()
  if(${depname}_FOUND)
    return()
  endif()
  #
  # Not found with find_package: switch to FetchContent
  # ---------------------------------------------------
  #
  # If a file argument is given, use it
  #
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
  #
  # FetchContent sequence
  #
  cmake_helpers_call(include FetchContent)
  set(_cmake_helpers_depend_fetchcontent_declare_exclude_from_all)
  if(_cmake_helpers_depend_exclude_from_all)
    set(_cmake_helpers_depend_fetchcontent_declare_exclude_from_all "EXCLUDE_FROM_ALL")
  endif()
  set(_cmake_helpers_depend_fetchcontent_declare_system)
  if(_cmake_helpers_depend_system)
    set(_cmake_helpers_depend_fetchcontent_declare_system "SYSTEM")
  endif()
  cmake_helpers_call(FetchContent_Declare ${depname}
    ${_cmake_helpers_depend_external_project_args}
    ${_cmake_helpers_depend_fetchcontent_declare_exclude_from_all}
    ${_cmake_helpers_depend_fetchcontent_declare_system}
    FIND_PACKAGE_ARGS ${_cmake_helpers_depend_find_package_args}
  )
  cmake_helpers_call(FetchContent_MakeAvailable ${_cmake_helpers_depend_makeavailable_args})
  #
  # End
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
    message(STATUS "[${_cmake_helpers_logprefix}] Ending")
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
  endif()
endfunction()
