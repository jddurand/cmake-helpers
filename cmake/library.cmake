function(cmake_helpers_library name)
  if(NOT name)
    message(FATAL_ERROR "name argument is missing")
  endif()
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  #
  set(_options)
  set(_oneValueArgs
    NAMESPACE
    VERSION
    VERSION_MAJOR
    VERSION_MINOR
    VERSION_PATCH
    IFACE_NAME
    SHARED_NAME
    STATIC_NAME
    MODULE_NAME
    SOURCES_AUTO
    PUBLIC_HEADERS_AUTO
    PRIVATE_HEADERS_AUTO
  )
  set(_multiValueArgs
    SOURCES
    SOURCES_AUTO_BASE_DIRS
    SOURCES_AUTO_GLOBS
    SOURCES_AUTO_IFACE_RELPATH_ACCEPT_REGEXES
    SOURCES_AUTO_IFACE_RELPATH_REJECT_REGEXES
    PUBLIC_HEADERS
    PRIVATE_HEADERS
  )
  #
  # Arguments default values
  #
  set(_cmake_helpers_namespace                           ${PROJECT_NAME})
  set(_cmake_helpers_version                             ${PROJECT_VERSION})
  set(_cmake_helpers_version_major                       ${PROJECT_VERSION_MAJOR})
  set(_cmake_helpers_version_minor                       ${PROJECT_VERSION_MINOR})
  set(_cmake_helpers_version_patch                       ${PROJECT_VERSION_PATCH})
  set(_cmake_helpers_iface_name                          ${PROJECT_NAME}_iface)
  set(_cmake_helpers_shared_name                         ${PROJECT_NAME}_shared)
  set(_cmake_helpers_static_name                         ${PROJECT_NAME}_static)
  set(_cmake_helpers_module_name                         ${PROJECT_NAME}_module)
  set(_cmake_helpers_sources_auto                        TRUE)
  set(_cmake_helpers_public_headers_auto                 TRUE)
  set(_cmake_helpers_private_headers_auto                TRUE)
  set(_cmake_helpers_sources)
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
  set(_cmake_helpers_sources_auto_iface_relpath_accept_regexes "\.h$" "\.hh$" "\.hpp$" "\.hxx$")
  set(_cmake_helpers_sources_auto_iface_relpath_reject_regexes "/internal/" "/_")
  set(_cmake_helpers_public_headers)
  set(_cmake_helpers_private_headers)
  #
  # Parse Arguments
  #
  cmake_parse_arguments(CMAKE_HELPERS "" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
  #
  # Set internal variables
  #
  foreach(_option ${_oneValueArgs} ${_multiValueArgs})
    set(_name CMAKE_HELPERS_${_option})
    set(_var _${_name})
    string(TOLOWER "${_var}" _var)
    if(DEFINED CMAKE_HELPERS_${_option})
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[library] Argument CMAKE_HELPERS_${_option}=${CMAKE_HELPERS_${_option}}")
      endif()
      set(${_var} ${CMAKE_HELPERS_${_option}})
    endif()
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[library] Option ${_var}=${${_var}}")
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
  # We always generate an interface library
  #
  cmake_helpers_call(add_library ${_cmake_helpers_iface_name} INTERFACE)
  #
  # If no source and sources_auto is set, auto-discover sources
  #
  if((NOT _cmake_helpers_sources) AND _cmake_helpers_sources_auto)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[library] Auto-discovering sources")
    endif()
    foreach(_base_dir ${_cmake_helpers_sources_auto_base_dirs})
      foreach(_glob ${_cmake_helpers_sources_auto_globs})
	if(CMAKE_HELPERS_DEBUG)
	  message(STATUS "[library] ... ${_base_dir}/${_glob}")
	endif()
	file(GLOB_RECURSE _base_dir_sources LIST_DIRECTORIES false ${_base_dir}/${_glob})
	if(_base_dir_sources)
	  if(CMAKE_HELPERS_DEBUG)
	    foreach(_base_dir_source ${_base_dir_sources})
	      message(STATUS "[library] ... ... ${_base_dir_source}")
	    endforeach()
	  endif()
	  source_group(TREE ${_base_dir} FILES ${_base_dir_sources})
	  list(APPEND _cmake_helpers_sources ${_base_dir_sources})
	endif()
      endforeach()
    endforeach()
  endif()
  if(CMAKE_HELPERS_DEBUG)
    foreach(_cmake_helpers_source ${_cmake_helpers_sources})
      message(STATUS "[library] Source: ${_cmake_helpers_source}")
    endforeach()
  endif()
  #
  # Public headers
  #
  if((NOT _cmake_helpers_public_headers) AND _cmake_helpers_public_headers_auto)
    foreach(_source ${_cmake_helpers_sources})
      cmake_helpers_match_accept_reject_regexes(${_source} "${_cmake_helpers_sources_auto_iface_relpath_accept_regexes}" "${_cmake_helpers_sources_auto_iface_relpath_reject_regexes}" _matched)
      if(_matched)
	list(APPEND _cmake_helpers_public_headers ${_source})
      endif()
    endforeach()
  endif()
  if(_cmake_helpers_public_headers)
    cmake_helpers_call(target_sources ${_cmake_helpers_iface_name}
      PUBLIC
      FILE_SET public_headers
      TYPE HEADERS
      ${_cmake_helpers_public_headers})
    cmake_helpers_call(install
      TARGETS ${_cmake_helpers_iface_name}
      EXPORT ${_cmake_helpers_namespace}-targets
      FILE_SET public_headers
      INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
      COMPONENT HeaderComponent)
  endif()
  #
  # Private headers
  #
  if((NOT _cmake_helpers_private_headers) AND _cmake_helpers_private_headers_auto)
    foreach(_source ${_cmake_helpers_sources})
      cmake_helpers_match_accept_reject_regexes(${_source} "${_cmake_helpers_sources_auto_iface_relpath_accept_regexes}" "${_cmake_helpers_sources_auto_iface_relpath_reject_regexes}" _matched)
      if(NOT _matched)
	list(APPEND _cmake_helpers_private_headers ${_source})
      endif()
    endforeach()
  endif()
  if(_cmake_helpers_private_headers)
    cmake_helpers_call(target_sources ${_cmake_helpers_iface_name}
      PUBLIC
      FILE_SET private_headers
      TYPE HEADERS
      ${_cmake_helpers_public_headers})
  endif()
endfunction()
