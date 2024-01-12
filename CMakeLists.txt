cmake_minimum_required(VERSION 3.26.0 FATAL_ERROR) # We require BUILD_LOCAL_INTERFACE
#
# General local install path, intentionaly under PROJECT_BINARY_DIR and not CMAKE_CURRENT_BINARY_DIR
# Intentionaly done before project definition to recuperate parent's PROJECT_BINARY_DIR.
#
if(DEFINED PROJECT_BINARY_DIR)
  set(CMAKE_HELPERS_INSTALL_PATH ${PROJECT_BINARY_DIR}/cmake_helpers_install CACHE PATH "Local installation directory" FORCE)
else()
  unset(CMAKE_HELPERS_INSTALL_PATH)
endif()
project(cmake-helpers VERSION 1.0.0 LANGUAGES C CXX)
if(NOT DEFINED CMAKE_HELPERS_INSTALL_PATH)
  # No project() in the parent
  set(CMAKE_HELPERS_INSTALL_PATH ${CMAKE_CURRENT_BINARY_DIR}/cmake_helpers_install CACHE PATH "Local installation directory" FORCE)
endif()
#
# If this is not a multi-generator config, then CMAKE_BUILD_TYPE should always be set
#
get_property(_cmake_helpers_generator_is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT _cmake_helpers_generator_is_multi_config)
  if(NOT "${CMAKE_BUILD_TYPE}")
    message(WARNING "Generator is not multi config and there is no CMAKE_BUILD_TYPE - Enforcing RelWithDebInfo")
    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "RelWithDebInfo" FORCE)
  endif()
endif()
#
# Load our includes, once
#
if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[cmake_helpers] Loading version ${PROJECT_VERSION}")
endif()
#
# Load all cmake file
#
file(GLOB _files ${PROJECT_SOURCE_DIR}/cmake/*.cmake)
foreach (_file ${_files})
  if(CMAKE_HELPERS_DEBUG)
    message(STATUS "[cmake_helpers] include(${_file})")
  endif()
  include(${_file})
endforeach()
#
# Initialize
#
cmake_helpers_init()
#
# Set the options
#
option(CMAKE_HELPERS_DEBUG "CMake Helpers debug" OFF)
option(CMAKE_HELPERS_GENERATE_STDINT_H "CMake Helpers stdint.h generation if not found" ON)
option(CMAKE_HELPERS_GENERATE_INTTYPES_H "CMake Helpers inttypes.h generation if not found" ON)
option(CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO "Exclude install of sub-projects" ON)
#
# ... Standard include dirs
#
if(NOT CMAKE_INSTALL_BINDIR)
  set(CMAKE_INSTALL_BINDIR bin)
endif()
if(NOT CMAKE_INSTALL_INCLUDEDIR)
  set(CMAKE_INSTALL_INCLUDEDIR include)
endif()
if(NOT CMAKE_INSTALL_DOCDIR)
  set(CMAKE_INSTALL_DOCDIR doc)
endif()
if(NOT CMAKE_INSTALL_LIBDIR)
  set(CMAKE_INSTALL_LIBDIR lib)
endif()
if(NOT CMAKE_INSTALL_MANDIR)
  set(CMAKE_INSTALL_MANDIR man)
endif()
if(NOT CMAKE_INSTALL_DATAROOTDIR)
  set(CMAKE_INSTALL_DATAROOTDIR share)
endif()
if(NOT CMAKE_INSTALL_JAVADIR)
  set(CMAKE_INSTALL_JAVADIR ${CMAKE_INSTALL_DATAROOTDIR}/java)
endif()
if(NOT CMAKE_INSTALL_JAVADOCDIR)
  set(CMAKE_INSTALL_JAVADOCDIR ${CMAKE_INSTALL_DATAROOTDIR}/javadoc)
endif()
foreach(_cmake_helpers_type bin include doc lib man dataroot java javadoc)
  string(TOUPPER "${_cmake_helpers_type}" _cmake_helpers_type_toupper)
  set(CMAKE_HELPERS_INSTALL_${_cmake_helpers_type_toupper}DIR ${CMAKE_INSTALL_${_cmake_helpers_type_toupper}DIR} CACHE PATH "${_cmake_helpers_type} install directory" FORCE)
endforeach()
#
# ... Our interpretation of where should be html, cmake and pkgconfig files
#
set(_cmake_helpers_install_htmldir_default      ${CMAKE_INSTALL_DOCDIR}/html)
set(_cmake_helpers_install_cmakedir_default     ${CMAKE_INSTALL_LIBDIR}/cmake)
set(_cmake_helpers_install_pkgconfigdir_default ${CMAKE_INSTALL_LIBDIR}/pkgconfig)
foreach(_cmake_helpers_type html cmake pkgconfig)
  string(TOUPPER "${_cmake_helpers_type}" _cmake_helpers_type_toupper)
  set(CMAKE_HELPERS_INSTALL_${_cmake_helpers_type_toupper}DIR ${_cmake_helpers_install_${_cmake_helpers_type}dir_default} CACHE PATH "${_cmake_helpers_type} install directory" FORCE)
endforeach()
