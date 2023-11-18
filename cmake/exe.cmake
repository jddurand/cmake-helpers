function(cmake_helpers_exe name)
  if(NOT name)
    message(FATAL_ERROR "name argument is missing")
  endif()
  set(_argn ${ARGN})
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${PROJECT_NAME}/exe] ${name} ${_argn}")
  endif()
  #
  # Recuperate directory properties
  #
  foreach(_variable targets static_library_suffix export_cmake_name)
    get_property(_cmake_helpers_${_variable} DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_${_variable})
    if(CMAKE_HELPERS_DEBUG)
      message(STATUS "[${PROJECT_NAME}/exe] _cmake_helpers_${_variable}: ${_cmake_helpers_${_variable}}")
    endif()
  endforeach()
  #
  # Add an executable using all library targets
  #
  foreach(_library_target ${_cmake_helpers_targets})
    get_target_property(_type ${_library_target} TYPE)
    if(_type STREQUAL "STATIC_LIBRARY")
      set(_target "${name}${_cmake_helpers_static_library_suffix}_exe")
    else()
      set(_target "${name}_exe")
    endif()
    cmake_helpers_call(add_executable ${_target} ${_argn})
    cmake_helpers_call(target_link_libraries ${_target} ${_library_target})
    cmake_helpers_call(install
      TARGETS ${_target}
      EXPORT ${_cmake_helpers_export_cmake_name}
      RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
      COMPONENT ApplicationComponent
    )
    set_property(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} PROPERTY _cmake_helpers_have_applicationcomponent TRUE)
  endforeach()
endfunction()
