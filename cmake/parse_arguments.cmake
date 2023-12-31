function(cmake_helpers_parse_arguments scope varprefix options one_value_keywords multi_value_keywords)
  #
  # We always do the following after cmake_parse_arguments():
  # - All values are propated to parent scope using the lowercase'd name ${varprefix}_${_option}
  # - All arguments are added to directory property
  # - All single arguments must have a value
  #
  # Parse Arguments
  #
  cmake_parse_arguments(CMAKE_HELPERS "${options}" "${one_value_keywords}" "${multi_value_keywords}" ${ARGN})
  #
  # Set internal variables
  #
  if(_cmake_helpers_logprefix)
    set(_cmake_helpers_logprefix "${_cmake_helpers_logprefix}/options")
  else()
    set(_cmake_helpers_logprefix "cmake_helpers/${PROJECT_NAME}/${scope}")
  endif()

  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] --------")
    message(STATUS "[${_cmake_helpers_logprefix}] Options:")
    message(STATUS "[${_cmake_helpers_logprefix}] --------")
  endif()
  foreach(_option ${options} ${one_value_keywords} ${multi_value_keywords})
    set(_varname ${varprefix}_${_option})
    string(TOLOWER "${_varname}" _varname)
    if(DEFINED CMAKE_HELPERS_${_option})
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${_cmake_helpers_logprefix}] ... ... Argument ${_option}=${CMAKE_HELPERS_${_option}}")
      endif()
      set(${_varname} ${CMAKE_HELPERS_${_option}})
      set(${_varname} ${CMAKE_HELPERS_${_option}} PARENT_SCOPE)
    endif()
    set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY ${_varname} ${${_varname}})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${_cmake_helpers_logprefix}] ... ${_varname}=${${_varname}}")
    endif()
  endforeach()
  #
  # Validation of arguments - only the oneValueArgs must have a value
  #
  foreach(_option ${one_value_keywords})
    set(_varname ${varprefix}_${_option})
    string(TOLOWER "${_varname}" _varname)
    if(NOT (DEFINED ${_varname}))
      message(FATAL_ERROR "${_varname} is missing")
    endif()
  endforeach()
endfunction()
