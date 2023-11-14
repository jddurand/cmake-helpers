function(cmake_helpers_library name type)
  set(_srcs ${ARGN})
  #
  # Arguments
  #
  set(options
    SOURCES_AUTO
  )
  set(oneValueArgs
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
  # options defaults
  #
  set(_cmake_helpers_sources_auto   TRUE)
  #
  # oneValueArgs defaults - we intentionally recuperate latest project()
  #
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
    ${CMAKE_INSTALL_INCLUDEDIR}/*.h ${CMAKE_INSTALL_INCLUDEDIR}/*.hh ${CMAKE_INSTALL_INCLUDEDIR}/*.hpp ${CMAKE_INSTALL_INCLUDEDIR}/*.hxx
    src/*.c src/*.cpp src/*.cxx
  )
  set(_cmake_helpers_sources_auto_relpath_accept_regexes)
  set(_cmake_helpers_sources_auto_relpath_reject_regexes  "/internal/" "/_")
  #
  # Parse Arguments
  #
  cmake_parse_arguments(CMAKE_HELPERS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  #
  # Recuperate arguments that are set
  #
  foreach(_variable ${options} ${oneValueArgs} ${multiValueArgs})
    if(DEFINED CMAKE_HELPERS_${_variable})
      set(_name CMAKE_HELPERS_${_variable})
      set(_value ${CMAKE_HELPERS_${_variable}})
      string(TOLOWER "${_name}" _name)
      set(_${_name} ${_value})
    endif()
  endforeach()
  #
  # Validation of arguments - only the oneValueArgs must have a value
  #
  foreach(_arg ${oneValueArgs})
    set(_option CMAKE_HELPERS_${_arg})
    if(NOT ${_option})
      message(FATAL_ERROR "${option} is missing")
    endif()
  endforeach()
endfunction()
