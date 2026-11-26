if(CMAKE_VERSION VERSION_LESS 3.13)
  message(FATAL_ERROR "This file relies on consumers using CMake 3.13 or greater.")
endif()
cmake_policy(PUSH)
cmake_policy(VERSION 2.6)

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Protect against multiple inclusion, which would fail when already imported targets are added once more.
set(_targetsDefined)
set(_targetsNotDefined)
set(_expectedTargets)
foreach(_expectedTarget unitree_sdk2)
  list(APPEND _expectedTargets ${_expectedTarget})
  if(NOT TARGET ${_expectedTarget})
    list(APPEND _targetsNotDefined ${_expectedTarget})
  endif()
  if(TARGET ${_expectedTarget})
    list(APPEND _targetsDefined ${_expectedTarget})
  endif()
endforeach()
if("${_targetsDefined}" STREQUAL "${_expectedTargets}")
  unset(_targetsDefined)
  unset(_targetsNotDefined)
  unset(_expectedTargets)
  set(CMAKE_IMPORT_FILE_VERSION)
  cmake_policy(POP)
  return()
endif()
if(NOT "${_targetsDefined}" STREQUAL "")
  message(FATAL_ERROR "Some (but not all) targets in this export set were already defined.\nTargets Defined: ${_targetsDefined}\nTargets not yet defined: ${_targetsNotDefined}\n")
endif()
unset(_targetsDefined)
unset(_targetsNotDefined)
unset(_expectedTargets)


# Compute the installation prefix relative to this file.
get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
if(_IMPORT_PREFIX STREQUAL "/")
  set(_IMPORT_PREFIX "")
endif()

# Create imported targets for the private DDS libraries.
add_library(unitree_ddsc SHARED IMPORTED GLOBAL)
set_target_properties(unitree_ddsc PROPERTIES
    IMPORTED_LOCATION "${_IMPORT_PREFIX}/@UNITREE_SDK_INSTALL_LIBDIR@/libunitree_ddsc.so.0"
    INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/@UNITREE_SDK_INSTALL_INCLUDEDIR@"
    INTERFACE_LINK_LIBRARIES "Threads::Threads"
    IMPORTED_SONAME "libunitree_ddsc.so.0")

add_library(unitree_ddscxx SHARED IMPORTED GLOBAL)
set_target_properties(unitree_ddscxx PROPERTIES
    IMPORTED_LOCATION "${_IMPORT_PREFIX}/@UNITREE_SDK_INSTALL_LIBDIR@/libunitree_ddscxx.so.0"
    INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/@UNITREE_SDK_INSTALL_INCLUDEDIR@;${_IMPORT_PREFIX}/@UNITREE_SDK_INSTALL_INCLUDEDIR@/ddscxx"
    INTERFACE_LINK_LIBRARIES "unitree_ddsc;Threads::Threads"
    IMPORTED_SONAME "libunitree_ddscxx.so.0")

# Create imported target unitree_sdk2
add_library(unitree_sdk2 STATIC IMPORTED GLOBAL)
set_target_properties(unitree_sdk2 PROPERTIES
    IMPORTED_LOCATION "${_IMPORT_PREFIX}/@UNITREE_SDK_INSTALL_LIBDIR@/libunitree_sdk2.a"
    INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/@UNITREE_SDK_INSTALL_INCLUDEDIR@"
    INTERFACE_LINK_LIBRARIES "unitree_ddsc;unitree_ddscxx;Threads::Threads"
    INTERFACE_LINK_OPTIONS "-Wl,-rpath,${_IMPORT_PREFIX}/@UNITREE_SDK_INSTALL_LIBDIR@"
    LINKER_LANGUAGE CXX
)

# Cleanup temporary variables.
set(_IMPORT_PREFIX)

# Loop over all imported files and verify that they actually exist
foreach(target ${_IMPORT_CHECK_TARGETS} )
  foreach(file ${_IMPORT_CHECK_FILES_FOR_${target}} )
    if(NOT EXISTS "${file}" )
      message(FATAL_ERROR "The imported target \"${target}\" references the file
   \"${file}\"
but this file does not exist.  Possible reasons include:
* The file was deleted, renamed, or moved to another location.
* An install or uninstall procedure did not complete successfully.
* The installation package was faulty and contained
   \"${CMAKE_CURRENT_LIST_FILE}\"
but not all the files it references.
")
    endif()
  endforeach()
  unset(_IMPORT_CHECK_FILES_FOR_${target})
endforeach()
unset(_IMPORT_CHECK_TARGETS)

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
cmake_policy(POP)
