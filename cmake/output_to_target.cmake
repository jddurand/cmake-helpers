function(cmake_helpers_output_to_target output target_outvar)
  #
  # Save argn
  #
  set(_argn ${ARGN})
  #
  # Custom command
  #
  cmake_helpers_call(add_custom_command OUTPUT ${output} ${_argn})
  #
  # Custom target
  #
  set(_target ${output})
  string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" _target ${_target})
  cmake_helpers_call(add_custom_target ${_target} SOURCES ${output})
  #
  # Return target in output_var
  #
  set(${target_outvar} ${_target} PARENT_SCOPE)
endfunction()
