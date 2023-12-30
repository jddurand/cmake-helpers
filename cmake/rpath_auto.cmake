Function(cmake_helpers_rpath_auto target)
  if(TARGET ${target})
    get_target_property(_cmake_helpers_rpath_auto_target_type ${target} TYPE)
    if(
        (_cmake_helpers_rpath_auto_target_type STREQUAL "STATIC_LIBRARY") OR
        (_cmake_helpers_rpath_auto_target_type STREQUAL "MODULE_LIBRARY") OR
        (_cmake_helpers_rpath_auto_target_type STREQUAL "SHARED_LIBRARY") OR
        (_cmake_helpers_rpath_auto_target_type STREQUAL "EXECUTABLE")
      )       
      #
      # C.f. https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling
      #
      # Do not skip rpath for the build tree
      #
      cmake_helpers_call(set_target_properties ${_cmake_helpers_exe_target} PROPERTIES SKIP_BUILD_RPATH FALSE)
      #
      # Use $ORIGIN in rpath when building target if supported
      #
      cmake_helpers_call(set_target_properties ${_cmake_helpers_exe_target} PROPERTIES BUILD_RPATH_USE_ORIGIN TRUE)
      #
      # When building, don't use the install RPATH already (but later on when installing)
      #
      cmake_helpers_call(set_target_properties ${_cmake_helpers_exe_target} PROPERTIES BUILD_WITH_INSTALL_RPATH FALSE)
      #
      # Set install rpath on platforms that support this feature
      # C.f. https://gitlab.kitware.com/vtk/vtk/-/blob/master/CMake/vtkModule.cmake
      #
      if(UNIX)
        if(APPLE)
          set(_cmake_helpers_library_rpath_prefix "@loader_path")
        else()
          set(_cmake_helpers_library_rpath_prefix "$ORIGIN")
        endif()
        cmake_helpers_call(set_property TARGET ${_cmake_helpers_exe_target} APPEND PROPERTY INSTALL_RPATH ${_cmake_helpers_library_rpath_prefix})
      endif()
    endif()
  endif()
endfunction()
