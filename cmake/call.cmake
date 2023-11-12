function(cmake_helpers_call command)
  set(_argn ${ARGN})
  if(CMAKE_HELPER_DEBUG)
    message(STATUS "${command}(${_argn})")
  endif()
  cmake_language(CALL ${command} ${_argn})
endfunction()
