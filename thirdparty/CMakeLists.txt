find_package(Threads REQUIRED)
find_program(PATCHELF_EXECUTABLE patchelf)
if(NOT PATCHELF_EXECUTABLE)
    message(FATAL_ERROR "patchelf is required to isolate the bundled DDS libraries")
endif()

# Patch build-tree copies; keep the upstream binaries unchanged.
foreach(library ddsc ddscxx)
    set(soname "libunitree_${library}.so.0")
    set(output "${CMAKE_CURRENT_BINARY_DIR}/${soname}")
    configure_file("lib/${CMAKE_SYSTEM_PROCESSOR}/lib${library}.so" "${output}" COPYONLY)
    set(patch_args --set-soname "${soname}" --set-rpath "$ORIGIN")
    if(library STREQUAL "ddscxx")
        list(APPEND patch_args --replace-needed libddsc.so.0 libunitree_ddsc.so.0)
    endif()
    execute_process(COMMAND "${PATCHELF_EXECUTABLE}" ${patch_args} "${output}"
        RESULT_VARIABLE patch_result)
    if(NOT patch_result EQUAL 0)
        message(FATAL_ERROR "Failed to isolate ${library}: ${patch_result}")
    endif()

    add_library(unitree_${library} SHARED IMPORTED GLOBAL)
    set_target_properties(unitree_${library} PROPERTIES
        IMPORTED_LOCATION "${output}"
        IMPORTED_SONAME "${soname}")
    target_link_libraries(unitree_${library} INTERFACE Threads::Threads)
    target_include_directories(unitree_${library} INTERFACE
        "${CMAKE_CURRENT_SOURCE_DIR}/include")
    install(FILES "${output}" DESTINATION ${UNITREE_SDK_INSTALL_LIBDIR})
endforeach()

target_link_libraries(unitree_ddscxx INTERFACE unitree_ddsc)
target_include_directories(unitree_ddscxx INTERFACE
    "${CMAKE_CURRENT_SOURCE_DIR}/include/ddscxx")

install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/"
    DESTINATION ${UNITREE_SDK_INSTALL_INCLUDEDIR})
