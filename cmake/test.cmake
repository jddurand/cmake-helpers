function(cmake_helpers_test name)
  if(NOT name)
    message(FATAL_ERROR "name argument is missing")
  endif()
  set(_argn ${ARGN})
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${PROJECT_NAME}/test] ${name} ${_argn}")
  endif()
  #
  # Include CTest
  #
  include(CTest)
  #
  # Recuperate directory properties
  #
  foreach(_variable targets static_library_suffix)
    get_property(_cmake_helpers_${_variable} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_${_variable})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/test] _cmake_helpers_${_variable}: ${_cmake_helpers_${_variable}}")
    endif()
  endforeach()
  #
  # Add a test using all library targets
  #
  foreach(_library_target ${_cmake_helpers_targets})
    get_target_property(_type ${_library_target} TYPE)
    if(_type STREQUAL "STATIC_LIBRARY")
      set(_output_name "${name}${_cmake_helpers_static_library_suffix}")
    else()
      set(_output_name "${name}")
    endif()
    set(_target "${_output_name}_test")
    cmake_helpers_call(add_executable ${_target} ${_argn})
    cmake_helpers_call(set_target_properties ${_target} PROPERTIES OUTPUT_NAME ${_output_name})
    cmake_helpers_call(target_link_libraries ${_target} ${_library_target})
    cmake_helpers_call(add_test NAME ${_target} COMMAND ${_target})
  endforeach()
endfunction()
