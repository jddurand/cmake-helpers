function(cmake_helpers_init)
  #
  # We always create an interface library
  #
  cmake_helpers_call(add_library ${CMAKE_PROJECT_NAME}-iface)
  cmake_helpers_call(include GNUInstallDirs)
  cmake_helpers_call(include CheckSymbolExists)
  cmake_helpers_call(check_symbol_exists __GNU_LIBRARY__ "features.h" _GNU_SOURCE)
endfunction()
