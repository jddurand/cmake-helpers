function(cmake_helpers_depend depname)
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
  set(_oneValueArgs FILE)
  set(_multiValueArgs
    EXTERNALPROJECT_ADD_ARGS
    MAKEAVAILABLE_ARGS
  )
  #
  # Options default values
  #
  set(_cmake_helpers_depend_file "")
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
  cmake_helpers_call(include FetchContent)
  string(TOLOWER "${depname}" _depname_tolower)
  if(_cmake_helpers_depend_file)
    if(EXISTS ${_cmake_helpers_depend_file})
      set(_cmake_helpers_depend_external_project_args URL ${_cmake_helpers_depend_file})
    else()
      message(WARNING "${_cmake_helpers_depend_file} does not exist")
      set(_cmake_helpers_depend_external_project_args ${_cmake_helpers_depend_externalproject_add_args})
    endif()
  else()
    set(_cmake_helpers_depend_external_project_args ${_cmake_helpers_depend_externalproject_add_args})
  endif()
  #
  # FetchContent sequence
  # I do not know why but EXCLUDE_FROM_ALL does not work me. I have to go manually with add_subdirectory
  #
  cmake_helpers_call(FetchContent_Declare ${depname}
    ${_cmake_helpers_depend_external_project_args}
    #
    # EXCLUDE_FROM_ALL # C.f. add_subdirectory below
    #
    # We always override find_package (so that our installer will get happy)
    #
    OVERRIDE_FIND_PACKAGE
  )
  cmake_helpers_call(FetchContent_GetProperties ${depname})
  string(TOLOWER "${depname}" _depname_tolower)
  if(NOT ${_depname_tolower}_POPULATED)
    cmake_helpers_call(FetchContent_Populate ${depname})
    cmake_helpers_call(add_subdirectory ${${_depname_tolower}_SOURCE_DIR} ${${_depname_tolower}_BINARY_DIR}
      # EXCLUDE_FROM_ALL
    )
  endif()

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
