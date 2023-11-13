# ====================================================================
# cmake_helpers_match_accept_reject_regexes
# ====================================================================
function(cmake_helpers_match_accept_reject_regexes value accept_regexes reject_regexes output_var)
  cmake_helpers_match_regexes("${value}" "${accept_regexes}" TRUE _accepted)
  cmake_helpers_match_regexes("${value}" "${reject_regexes}" FALSE _rejected )

  if (_accepted AND (NOT _rejected))
    set(_matched TRUE)
  else()
    set(_matched FALSE)
  endif()

  set(${output_var} ${_matched} PARENT_SCOPE)
endfunction()

