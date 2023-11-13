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
    SOURCES_AUTO_EXTENSIONS
    SOURCES_AUTO_RELPATH_ACCEPT_REGEXES
    SOURCES_AUTO_RELPATH_REJECT_REGEXES
  )
  #
  # options defaults
  #
  set(_cmake_helpers_sources_auto   TRUE)
  #
  # oneValueArgs defaults
  #
  set(_cmake_helpers_namespace     ${PARENT_PROJECT_NAME})
  set(_cmake_helpers_version       ${PARENT_PROJECT_VERSION})
  set(_cmake_helpers_version_major ${PARENT_PROJECT_VERSION_MAJOR})
  set(_cmake_helpers_version_minor ${PARENT_PROJECT_VERSION_MINOR})
  set(_cmake_helpers_version_patch ${PARENT_PROJECT_VERSION_PATH})
  #
  # multiValueArgs defaults
  #
  set(_cmake_helpers_sources_auto_base_dirs ${CMAKE_CURRENT_SOURCE_DIR}/${CMAKE_INSTALL_INCLUDEDIR})
  set(_cmake_helpers_sources_auto_extensions *.h *.hpp *.hxx)
  set(_cmake_helpers_sources_auto_relpath_accept_regexes "/internal/")
  set(_cmake_helpers_sources_auto_relpath_reject_regexes)
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
endfunction()
