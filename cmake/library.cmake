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
    HEADERS_AUTO
    PUBLIC_HEADERS_AUTO
    PRIVATE_HEADERS_AUTO
  )
  set(_multiValueArgs
    CONFIG
    SOURCES
    SOURCES_AUTO_BASE_DIRS
    SOURCES_AUTO_GLOBS
    HEADERS
    HEADERS_AUTO_BASE_DIRS
    HEADERS_AUTO_GLOBS
    HEADERS_AUTO_RELPATH_PRIVATE_REGEXES
    PUBLIC_HEADERS
    PRIVATE_HEADERS
  )
  #
  # Single-value arguments default values
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
  set(_cmake_helpers_headers_auto                        TRUE)
  set(_cmake_helpers_public_headers_auto                 TRUE)
  set(_cmake_helpers_private_headers_auto                TRUE)
  #
  # Multiple-value arguments default values
  #
  set(_cmake_helpers_config)
  set(_cmake_helpers_sources)
  set(_cmake_helpers_sources_auto_base_dirs              ${PROJECT_SOURCE_DIR}/src)
  set(_cmake_helpers_sources_auto_globs                  *.c *.cpp *.cxx)
  set(_cmake_helpers_headers)
  set(_cmake_helpers_headers_auto_base_dirs              ${PROJECT_SOURCE_DIR}/include)
  set(_cmake_helpers_headers_auto_globs                  *.h *.hh *.hpp *.hxx)
  set(_cmake_helpers_headers_auto_relpath_private_regexes "/internal/" "^_" "/_")
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
  set(_iface_base_dirs ${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_outputdir}")
  #
  # Config
  #
  if(_cmake_helpers_config)
    list(GET _cmake_helpers_config 0 _cmake_helpers_config_in)
    list(GET _cmake_helpers_config 1 _cmake_helpers_config_out)
    set(_cmake_helpers_config_outdir "${CMAKE_CURRENT_BINARY_DIR}/${_cmake_helpers_outputdir}/${CMAKE_INSTALL_INCLUDEDIR}")
    set(_cmake_helpers_config_out "${_cmake_helpers_config_outdir}/${_cmake_helpers_config_out}")
    cmake_helpers_call(configure_file ${_cmake_helpers_config_in} ${_cmake_helpers_config_out})
    cmake_helpers_call(source_group TREE ${_cmake_helpers_config_outdir} FILES ${_cmake_helpers_config_out})
  else()
    set(_cmake_helpers_config_outdir)
    set(_cmake_helpers_config_out)
  endif()
  #
  # Sources and headers
  #
  foreach(_type sources headers)
    if((NOT _cmake_helpers_${_type}) AND _cmake_helpers_${_type}_auto)
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[library] Auto-discovering ${_type}")
      endif()
      if(_type STREQUAL "sources")
	set(_base_dirs ${_cmake_helpers_${_type}_auto_base_dirs})
      else()
	if(_cmake_helpers_config)
	  set(_base_dirs ${_cmake_helpers_${_type}_auto_base_dirs} ${_cmake_helpers_config_outdir})
	else()
	  set(_base_dirs ${_cmake_helpers_${_type}_auto_base_dirs})
	endif()
      endif()
      foreach(_base_dir ${_base_dirs})
	if(CMAKE_HELPERS_DEBUG)
	  message(STATUS "[library] ... dir ${_base_dir}")
	endif()
	set(_base_dir_files)
	foreach(_glob ${_cmake_helpers_${_type}_auto_globs})
	  if(CMAKE_HELPERS_DEBUG)
	    message(STATUS "[library] ... ... glob ${_base_dir}/${_glob}")
	  endif()
	  file(GLOB_RECURSE _base_dir_${_type} LIST_DIRECTORIES false ${_base_dir}/${_glob})
	  if(_base_dir_${_type})
	    if(CMAKE_HELPERS_DEBUG)
	      foreach(_file ${_base_dir_${_type}})
		message(STATUS "[library] ... ... ... file ${_file}")
	      endforeach()
	    endif()
	    list(APPEND _base_dir_files ${_base_dir_${_type}})
	  endif()
	endforeach()
	cmake_helpers_call(source_group TREE ${_base_dir} FILES ${_base_dir_files})
	list(APPEND _cmake_helpers_${_type} ${_base_dir_files})
      endforeach()
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[library] Discovered ${_type}:")
	foreach(_file ${_cmake_helpers_${_type}})
	  message(STATUS "[library] ... ${_file}")
	endforeach()
      endif()
      if(_type STREQUAL "headers")
	#
	# Include directories
	#
	cmake_helpers_call(target_include_directories ${_cmake_helpers_iface_name} PUBLIC $<BUILD_INTERFACE:${_base_dirs}>)
	cmake_helpers_call(target_include_directories ${_cmake_helpers_iface_name} PUBLIC $<BUILD_LOCAL_INTERFACE:${_base_dirs}>)
	cmake_helpers_call(target_include_directories ${_cmake_helpers_iface_name} PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
      endif()
    endif()
  endforeach()
  #
  # Public headers
  #
  if((NOT _cmake_helpers_public_headers) AND _cmake_helpers_public_headers_auto)
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[library] Auto-discovering public headers")
    endif()
    foreach(_header ${_cmake_helpers_headers})
      cmake_helpers_match_regexes("${_header}" "${_cmake_helpers_headers_auto_relpath_private_regexes}" FALSE _matched)
      if(NOT _matched)
	list(APPEND _cmake_helpers_public_headers ${_header})
      endif()
    endforeach()
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[library] Discovered public headers:")
    foreach(_header ${_cmake_helpers_public_headers})
      message(STATUS "[library] ... ${_header}")
    endforeach()
  endif()
  if(_cmake_helpers_public_headers)
    cmake_helpers_call(target_sources ${_cmake_helpers_iface_name} PUBLIC
      FILE_SET public_headers
      BASE_DIRS ${_iface_base_dirs}
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
    foreach(_header ${_cmake_helpers_headers})
      cmake_helpers_match_regexes("${_header}" "${_cmake_helpers_headers_auto_relpath_private_regexes}" FALSE _matched)
      if(_matched)
	list(APPEND _cmake_helpers_private_headers ${_header})
      endif()
    endforeach()
  endif()
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[library] Discovered private headers:")
    foreach(_header ${_cmake_helpers_private_headers})
      message(STATUS "[library] ... ${_header}")
    endforeach()
  endif()
  if(_cmake_helpers_private_headers)
    cmake_helpers_call(target_sources ${_cmake_helpers_iface_name} PRIVATE
      FILE_SET private_headers
      TYPE HEADERS
      FILES ${_cmake_helpers_private_headers})
  endif()
endfunction()
