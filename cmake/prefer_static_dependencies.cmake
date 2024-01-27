function(prefer_static_dependencies outvar depend_lib)
  #
  # Log prefix
  #
  set(_cmake_helpers_logprefix "cmake_helpers/${PROJECT_NAME}/prefer_static_dependencies")
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
    message(STATUS "[${_cmake_helpers_logprefix}] Starting")
    message(STATUS "[${_cmake_helpers_logprefix}] ========")
  endif()
  if($ENV{CMAKE_HELPERS_PREFER_STATIC_DEPENDENCIES})
    get_target_property(_depend_type ${depend_lib} TYPE)
    if(_depend_type STREQUAL "SHARED_LIBRARY")
      #
      # Look for neighbor libraries
      #
      get_target_property(_depend_neighbor_targets ${depend_lib} NEIGHBOR_TARGETS)
      foreach(_depend_neighbor_target IN LISTS _depend_neighbor_targets)
	get_target_property(_depend_neighbor_type ${_depend_neighbor_target} TYPE)
        if(_depend_neighbor_type STREQUAL "STATIC_LIBRARY")
          if(CMAKE_HELPERS_DEBUG)
            message(STATUS "[${_cmake_helpers_logprefix}] Changing depend lib from ${depend_lib} to ${_depend_neighbor_target}")
          endif()
          set(depend_lib ${_depend_neighbor_target})
          break()
        endif()
      endif()
    endif()
  endif()
  set(outvar ${depend_lib} PARENT_SCOPE)
endfunction()
