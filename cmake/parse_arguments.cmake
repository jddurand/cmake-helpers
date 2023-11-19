function(cmake_helpers_parse_arguments scope options one_value_keywords multi_value_keywords)
  #
  # We always do the following after cmake_parse_arguments():
  # - All arguments are added to directory property
  # - All single arguments must have a value
  # - All value are propated to parent scope using the name _cmake_helpers_${scope}_${_option}
  #
  # Parse Arguments
  #
  cmake_parse_arguments(CMAKE_HELPERS "${options}" "${one_value_keywords}" "${multi_value_keywords}" "${ARGN}")
  #
  # Set internal variables
  #
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${PROJECT_NAME}/${scope}] --------")
    message(STATUS "[${PROJECT_NAME}/${scope}] Options:")
    message(STATUS "[${PROJECT_NAME}/${scope}] --------")
  endif()
  foreach(_option ${options} ${one_value_keywords} ${multi_value_keywords})
    set(_name CMAKE_HELPERS_${_option})
    set(_var _${_name}_${scope})
    string(TOLOWER "${_var}" _var)
    if(DEFINED CMAKE_HELPERS_${_option})
      if(CMAKE_HELPERS_DEBUG)
	message(STATUS "[${PROJECT_NAME}/${scope}] ... ... Argument CMAKE_HELPERS_${_option}=${CMAKE_HELPERS_${_option}}")
      endif()
      set(${_var} ${CMAKE_HELPERS_${_option}} PARENT_SCOPE)
    endif()
    set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY ${_var} ${${_var}})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/${scope}] ... ${_var}=${${_var}}")
    endif()
  endforeach()
  #
  # Validation of arguments - only the oneValueArgs must have a value
  #
  foreach(_one_value_keyword ${one_value_keywords})
    set(_name CMAKE_HELPERS_${_one_value_keyword})
    set(_var _${_name}_${scope})
    string(TOLOWER "${_var}" _var)
    if(NOT (DEFINED ${_var}))
      message(FATAL_ERROR "${_var} is missing")
    endif()
  endforeach()
endfunction()
