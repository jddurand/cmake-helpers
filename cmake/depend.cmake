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
  )
  set(_multiValueArgs
    EXTERNALPROJECT_ADD_ARGS
    MAKEAVAILABLE_ARGS
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
  #
  # Parse Arguments
  #
  cmake_helpers_parse_arguments(package _cmake_helpers_depend "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
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
  cmake_helpers_call(FetchContent_Declare ${depname}
    ${_cmake_helpers_depend_external_project_args}
    OVERRIDE_FIND_PACKAGE
  )
  FetchContent_MakeAvailable(${_cmake_helpers_depend_makeavailable_args})
  #
  # End
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
    message(STATUS "[${_cmake_helpers_logprefix}] Ending")
    message(STATUS "[${_cmake_helpers_logprefix}] ======")
  endif()
endfunction()
