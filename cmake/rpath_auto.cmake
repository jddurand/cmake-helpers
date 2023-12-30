Function(cmake_helpers_rpath_auto target)
  if(TARGET ${target})
    get_target_property(_cmake_helpers_rpath_auto_target_type ${target} TYPE)
    if(
        (_cmake_helpers_rpath_auto_target_type STREQUAL "MODULE_LIBRARY") OR
        (_cmake_helpers_rpath_auto_target_type STREQUAL "SHARED_LIBRARY") OR
        (_cmake_helpers_rpath_auto_target_type STREQUAL "EXECUTABLE")
      )
      #
      # C.f. https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling
      #
      # Do not skip rpath for the build tree
      #
      cmake_helpers_call(set_target_properties ${target} PROPERTIES SKIP_BUILD_RPATH FALSE)
      #
      # Use $ORIGIN in rpath when building target if supported
      #
      cmake_helpers_call(set_target_properties ${target} PROPERTIES BUILD_RPATH_USE_ORIGIN TRUE)
      #
      # When building, don't use the install RPATH already (but later on when installing)
      #
      cmake_helpers_call(set_target_properties ${target} PROPERTIES BUILD_WITH_INSTALL_RPATH FALSE)
      #
      # Set install rpath on platforms that support this feature
      # C.f. https://gitlab.kitware.com/vtk/vtk/-/blob/master/CMake/vtkModule.cmake
      #
      # On Windows, dlls goes to CMAKE_HELPERS_INSTALL_BINDIR, else they go to CMAKE_HELPERS_INSTALL_LIBDIR
      #
      if(UNIX)
        #
        # UNIX is true also on UNIX-like OSes, e.g. APPLE and CYGWIN
        #
        if(APPLE)
          #
          # Set directory portion of install_name in @rpath.
          # Although this is true by default since CMP0042, set it anyway on macOS or iOS
          #
          cmake_helpers_call(set_target_properties ${target} PROPERTIES MACOSX_RPATH TRUE)
          set(_cmake_helpers_library_rpath_prefix "@rpath:@rpath/../${CMAKE_INSTALL_LIBDIR}")
        else()
          set(_cmake_helpers_library_rpath_prefix "$ORIGIN:$ORIGIN/../${CMAKE_INSTALL_LIBDIR}")
        endif()
        cmake_helpers_call(set_property TARGET ${target} APPEND PROPERTY INSTALL_RPATH ${_cmake_helpers_library_rpath_prefix})
      endif()
    endif()
  endif()
endfunction()
