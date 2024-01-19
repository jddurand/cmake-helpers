cmake_minimum_required(VERSION 3.26.0 FATAL_ERROR) # We require BUILD_LOCAL_INTERFACE
project(cmake-helpers VERSION 1.0.0 LANGUAGES C CXX)
#
# List of our options
#
set(_cmake_helpers_options
  CMAKE_HELPERS_FETCHCONTENT_BASE_DIR
  CMAKE_HELPERS_BUILDS_PATH
  CMAKE_HELPERS_INSTALL_PATH
  CMAKE_HELPERS_DEBUG
  CMAKE_HELPERS_GENERATE_STDINT_H
  CMAKE_HELPERS_GENERATE_INTTYPES_H
  CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO
)
# Not all options are boolean
#
set(CMAKE_HELPERS_FETCHCONTENT_BASE_DIR         ${CMAKE_BINARY_DIR}/_deps                 CACHE PATH "FetchContent base dir")
set(CMAKE_HELPERS_BUILDS_PATH                   ${CMAKE_BINARY_DIR}/cmake_helpers_builds  CACHE PATH "Common builds path")
set(CMAKE_HELPERS_INSTALL_PATH                  ${CMAKE_BINARY_DIR}/cmake_helpers_install CACHE PATH "Common install path")
set(CMAKE_HELPERS_DEBUG                         OFF                                       CACHE BOOL "CMake Helpers debug")
set(CMAKE_HELPERS_GENERATE_STDINT_H             ON                                        CACHE BOOL "stdint.h generation if not found")
set(CMAKE_HELPERS_GENERATE_INTTYPES_H           ON                                        CACHE BOOL "inttypes.h generation if not found")
set(CMAKE_HELPERS_EXCLUDE_INSTALL_FROM_ALL_AUTO ON                                        CACHE BOOL "Exclude install of sub-projects")
#
# Save options for reuse in cmake_generate_options
#
set(CMAKE_HELPERS_OPTIONS                       "${_cmake_helpers_options}"               CACHE INTERNAL "CMake Helpers options" FORCE)
#
# Dump options
#
if(CMAKE_HELPERS_DEBUG)
  foreach(_cmake_helpers_option IN LISTS _cmake_helpers_options)
    message(STATUS "[cmake_helpers] ${_cmake_helpers_option}: ${${_cmake_helpers_option}}")
  endforeach()
endif()
#
# FETCHCONTENT_BASE_DIR is special
#
if(CMAKE_HELPERS_FETCHCONTENT_BASE_DIR)
  set(FETCHCONTENT_BASE_DIR "FetchContent base dir" CACHE PATH ${CMAKE_HELPERS_FETCHCONTENT_BASE_DIR} FORCE)
endif()
#
# Log that are we being loaded
#
if(CMAKE_HELPERS_DEBUG)
  message(STATUS "[cmake_helpers] Loading version ${PROJECT_VERSION} at ${CMAKE_CURRENT_BINARY_DIR}")
endif()
#
# Load our cmake files
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
