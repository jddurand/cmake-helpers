function(cmake_helpers_library name)
  if(NOT name)
    message(FATAL_ERROR "name argument is missing")
  endif()
  #
  # Arguments definitions: options, one value arguments, multivalue arguments.
  #
  set(_options)
  set(_oneValueArgs
    OUTPUTDIR
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
    CONFIG
    SOURCES
    SOURCES_AUTO_BASE_DIRS
    SOURCES_AUTO_GLOBS
    SOURCES_AUTO_IFACE_RELPATH_ACCEPT_REGEXES
    SOURCES_AUTO_IFACE_RELPATH_PRIVATE_REGEXES
    PUBLIC_HEADERS
    PRIVATE_HEADERS
  )
  #
  # Arguments default values
  #
  set(_cmake_helpers_outputdir                           output)
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
  set(_cmake_helpers_config)
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
  set(_cmake_helpers_sources_auto_iface_relpath_private_regexes "/internal/" "^_" "/_")
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
  # If CONFIG is set, it must have two arguments, where the second one is not an absolute path
  #
  if(_cmake_helpers_config)
    list(LENGTH _cmake_helpers_config _cmake_helpers_config_length)
    if(NOT (_cmake_helpers_config_length EQUAL 2))
      message(FATAL_ERROR "CONFIG must have two elements when it is set")
    endif()
    list(GET _cmake_helpers_config 1 _config_out)
    cmake_path(IS_ABSOLUTE _config_out _config_out_is_absolute)
    if(_config_out_is_absolute)
      message(FATAL_ERROR "${_config_out} must be relative")
    endif()
  endif()
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
	  cmake_helpers_call(source_group TREE ${_base_dir} FILES ${_base_dir_sources})
	  list(APPEND _cmake_helpers_sources ${_base_dir_sources})
	endif()
      endforeach()
    endforeach()
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[library] Discovered sources:")
    foreach(_cmake_helpers_source ${_cmake_helpers_sources})
      message(STATUS "[library] ... ${_cmake_helpers_source}")
    endforeach()
  endif()
  #
  # Config
  #
  if(_cmake_helpers_config)
    list(GET _cmake_helpers_config 0 _cmake_helpers_config_in)
    list(GET _cmake_helpers_config 1 _cmake_helpers_config_out)
    set(_cmake_helpers_config_outdir "${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_outputdir}")
    set(_cmake_helpers_config_out "${_cmake_helpers_config_outdir}/${_cmake_helpers_config_out}")
    cmake_helpers_call(configure_file ${_cmake_helpers_config_in} ${_cmake_helpers_config_out})
    cmake_helpers_call(source_group TREE ${_cmake_helpers_config_outdir} FILES ${_cmake_helpers_config_out})
  else()
    set(_cmake_helpers_config_out)
  endif()
  #
  # Public headers
  #
  if((NOT _cmake_helpers_public_headers) AND _cmake_helpers_public_headers_auto)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[library] Auto-discovering public headers")
    endif()
    foreach(_source ${_cmake_helpers_sources} ${_cmake_helpers_config_out})
      cmake_helpers_match_accept_reject_regexes("${_source}" "${_cmake_helpers_sources_auto_iface_relpath_accept_regexes}" "${_cmake_helpers_sources_auto_iface_relpath_private_regexes}" _matched)
      if(_matched)
	list(APPEND _cmake_helpers_public_headers ${_source})
      endif()
    endforeach()
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[library] Discovered public headers:")
    foreach(_cmake_helpers_public_header ${_cmake_helpers_public_headers})
      message(STATUS "[library] ... ${_cmake_helpers_public_header}")
    endforeach()
  endif()
  if(_cmake_helpers_public_headers)
    cmake_helpers_call(target_sources ${_cmake_helpers_iface_name} PUBLIC
      FILE_SET public_headers
      BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_outputdir}"
      TYPE HEADERS
      FILES ${_cmake_helpers_public_headers})
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
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[library] Auto-discovering private headers")
    endif()
    foreach(_source ${_cmake_helpers_sources} ${_cmake_helpers_config_out})
      cmake_helpers_match_regexes("${_source}" "${_cmake_helpers_sources_auto_iface_relpath_accept_regexes}" TRUE _accept_matched)
      if (_accept_matched)
	if(CMAKE_HELPERS_DEBUG)
	  message(STATUS "[library] ${_source} matches accept regexes: ${_cmake_helpers_sources_auto_iface_relpath_accept_regexes}")
	endif()
	cmake_helpers_match_regexes("${_source}" "${_cmake_helpers_sources_auto_iface_relpath_private_regexes}" FALSE _private_matched)
	if(_private_matched)
	  if(CMAKE_HELPERS_DEBUG)
	    message(STATUS "[library] ${_source} matches private regexes: ${_cmake_helpers_sources_auto_iface_relpath_private_regexes}")
	  endif()
	  list(APPEND _cmake_helpers_private_headers ${_source})
	else()
	  if(CMAKE_HELPERS_DEBUG)
	    message(STATUS "[library] ${_source} do not match private regexes: ${_cmake_helpers_sources_auto_iface_relpath_private_regexes}")
	  endif()
	endif()
	else()
	  if(CMAKE_HELPERS_DEBUG)
	    message(STATUS "[library] ${_source} do not match accept regexes: ${_cmake_helpers_sources_auto_iface_relpath_accept_regexes}")
	  endif()
      endif()
    endforeach()
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[library] Discovered private headers:")
    foreach(_cmake_helpers_private_header ${_cmake_helpers_private_headers})
      message(STATUS "[library] ... ${_cmake_helpers_private_header}")
    endforeach()
  endif()
  if(_cmake_helpers_private_headers)
    cmake_helpers_call(target_sources ${_cmake_helpers_iface_name} PRIVATE
      FILE_SET private_headers
      TYPE HEADERS
      FILES ${_cmake_helpers_private_headers})
  endif()
  #
  # If there is a config file, determine the scope of the include directory
  #
  if(_cmake_helpers_config)
    if(_cmake_helpers_config_out IN_LIST _cmake_helpers_public_headers)
      target_include_directories(${_cmake_helpers_iface_name} PUBLIC ${_cmake_helpers_config_outdir})
    elseif(_cmake_helpers_config_out IN_LIST _cmake_helpers_private_headers)
      target_include_directories(${_cmake_helpers_iface_name} PRIVATE ${_cmake_helpers_config_outdir}>)
    else()
      message(WARNING "Cannot determine if ${_cmake_helpers_config_out} is public or private")
    endif()
  endif()
endfunction()
