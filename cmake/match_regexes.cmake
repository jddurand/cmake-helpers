# ====================================================================
# cmake_helpers_match_regexes
# ====================================================================
function(cmake_helpers_match_regexes value regexes default output_var)

  if(regexes)
    set(_matched FALSE)
    foreach(_regex ${regexes})
      message(STATUS "string(REGEX MATCH \"${_regex}\" _output \"${value}\")")
      string(REGEX MATCH ${_regex} _output ${value})
      if(_output)
        set(_matched TRUE)
        break()
      endif()
    endforeach()
  else()
    set(_matched ${default})
  endif()

  set(${output_var} ${_matched} PARENT_SCOPE)
endfunction()
