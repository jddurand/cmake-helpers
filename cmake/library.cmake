function(cmake_helpers_library name type)
  if((NOT name) OR (NOT type))
    message(FATAL_ERROR "Usage: cmake_helpers_library name type [<src> ...]")
  endif()
  #
  # Get a copy of ARGN
  #
  set(_srcs ${ARGN})
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  # We put our options in oneValueArgs because options are always set when calling
  # cmake_parse_arguments().
  #
  set(oneValueArgs
    SOURCES_AUTO
    NAMESPACE
    VERSION
    VERSION_MAJOR
    VERSION_MINOR
    VERSION_PATCH
  )
  set(multiValueArgs
    SOURCES_AUTO_BASE_DIRS
    SOURCES_AUTO_GLOBS
    SOURCES_AUTO_RELPATH_ACCEPT_REGEXES
    SOURCES_AUTO_RELPATH_REJECT_REGEXES
  )
  #
  # oneValueArgs defaults - we intentionally recuperate latest project()
  #
  set(_cmake_helpers_sources_auto  TRUE)
  set(_cmake_helpers_namespace     ${PROJECT_NAME})
  set(_cmake_helpers_version       ${PROJECT_VERSION})
  set(_cmake_helpers_version_major ${PROJECT_VERSION_MAJOR})
  set(_cmake_helpers_version_minor ${PROJECT_VERSION_MINOR})
  set(_cmake_helpers_version_patch ${PROJECT_VERSION_PATCH})
  #
  # multiValueArgs defaults
  #
  set(_cmake_helpers_sources_auto_base_dirs ${PROJECT_SOURCE_DIR})
  set(_cmake_helpers_sources_auto_globs
    ${CMAKE_INSTALL_INCLUDEDIR}/*.h
    ${CMAKE_INSTALL_INCLUDEDIR}/*.hh
    ${CMAKE_INSTALL_INCLUDEDIR}/*.hpp
    ${CMAKE_INSTALL_INCLUDEDIR}/*.hxx
    src/*.c
    src/*.cpp
    src/*.cxx
  )
  set(_cmake_helpers_sources_auto_relpath_accept_regexes)
  set(_cmake_helpers_sources_auto_relpath_reject_regexes  "/internal/" "/_")
  #
  # Parse Arguments
  #
  cmake_parse_arguments(CMAKE_HELPERS "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  #
  # Set internal variables
  #
  foreach(_option ${options} ${oneValueArgs} ${multiValueArgs})
    set(_name CMAKE_HELPERS_${_option})
    set(_var _${_name})
    string(TOLOWER "${_var}" _var)
    if(DEFINED CMAKE_HELPERS_${_option})
      set(${_var} ${CMAKE_HELPERS_${_option}})
    endif()
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "${_var}=${${_var}}")
    endif()
  endforeach()
  #
  # Validation of arguments - only the oneValueArgs must have a value
  #
  foreach(_option ${oneValueArgs})
    set(_name CMAKE_HELPERS_${_option})
    set(_var _${_name})
    string(TOLOWER "${_var}" _var)
    if(NOT (DEFINED ${_var}))
      message(FATAL_ERROR "${_var} is missing")
    endif()
  endforeach()
endfunction()
