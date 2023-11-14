function(cmake_helpers_library name type)
  if((NOT name) OR (NOT type))
    message(FATAL_ERROR "Usage: cmake_helpers_library name type [<src> ...]")
  endif()
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  #
  set(_options
    SOURCES_AUTO
  )
  set(_oneValueArgs
    NAMESPACE
    VERSION
    VERSION_MAJOR
    VERSION_MINOR
    VERSION_PATCH
  )
  set(_multiValueArgs
    SOURCES
    SOURCES_AUTO_BASE_DIRS
    SOURCES_AUTO_GLOBS
    SOURCES_AUTO_RELPATH_ACCEPT_REGEXES
    SOURCES_AUTO_RELPATH_REJECT_REGEXES
  )
  #
  # Arguments default values
  #
  set(_cmake_helpers_sources_auto                        TRUE)
  set(_cmake_helpers_sources)
  set(_cmake_helpers_namespace                           ${PROJECT_NAME})
  set(_cmake_helpers_version                             ${PROJECT_VERSION})
  set(_cmake_helpers_version_major                       ${PROJECT_VERSION_MAJOR})
  set(_cmake_helpers_version_minor                       ${PROJECT_VERSION_MINOR})
  set(_cmake_helpers_version_patch                       ${PROJECT_VERSION_PATCH})
  set(_cmake_helpers_sources_auto_base_dirs              ${PROJECT_SOURCE_DIR})
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
  set(_cmake_helpers_sources_auto_relpath_reject_regexes "/internal/" "/_")
  #
  # Parse Arguments
  #
  cmake_parse_arguments(CMAKE_HELPERS "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
  #
  # Set internal variables
  #
  foreach(_option ${_options} ${_oneValueArgs} ${_multiValueArgs})
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
  foreach(_oneValueArg ${_oneValueArgs})
    set(_name CMAKE_HELPERS_${_oneValueArg})
    set(_var _${_name})
    string(TOLOWER "${_var}" _var)
    if(NOT (DEFINED ${_var}))
      message(FATAL_ERROR "${_var} is missing")
    endif()
  endforeach()
  #
  # If no source and sources_auto is set, auto-discover sources
  #
  if((NOT _cmake_helpers_sources) AND _cmake_helpers_sources_auto)
    foreach(_base_dir ${_cmake_helpers_sources_auto_base_dirs})
      foreach(_glob ${_cmake_helpers_sources_auto_globs})
	file(GLOB_RECURSE _base_dir_sources LIST_DIRECTORIES false CONFIGURE_DEPENDS ${_base_dir}/${_glob})
	list(APPEND _cmake_helpers_sources ${_base_dir_sources})
      endforeach()
    endforeach()
  endif()
endfunction()
