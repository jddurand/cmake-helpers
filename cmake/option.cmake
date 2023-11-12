function(cmake_helpers_option name default description)
  set(${name} ${default} CACHE STRING ${description})
  set_property(CACHE ${name} PROPERTY STRINGS ${${name}})
endfunction()
