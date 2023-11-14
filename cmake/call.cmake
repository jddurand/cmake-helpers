#
# Intentionaly a macro and not a function
#
macro(cmake_helpers_call command)
  set(_argn ${ARGN})
  if(CMAKE_HELPERS_DEBUG)
    list(JOIN _argn " " _args)
    message(STATUS "${command}(${_args})")
  endif()
  cmake_language(CALL ${command} ${_argn})
endmacro()
