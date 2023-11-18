#
# Intentionaly a macro and not a function
#
macro(cmake_helpers_call command)
  set(_cmake_helpers_call_argn ${ARGN})
  if(CMAKE_HELPERS_DEBUG)
    list(JOIN _cmake_helpers_call_argn " " _cmake_helpers_call_args)
    message(STATUS "${command}(${_cmake_helpers_call_args})")
  endif()
  cmake_language(CALL ${command} ${_cmake_helpers_call_argn})
endmacro()
